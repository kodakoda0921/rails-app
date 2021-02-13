class User < ApplicationRecord
  has_many :microposts, dependent: :destroy
  has_one(:profiles, dependent: :destroy, class_name: "Profile")
  accepts_nested_attributes_for :profiles
  # active_relation(follower_id)を持つユーザは、それを通して、さらにfollowing_idを持っている。
  has_many :active_relation, class_name: "FollowRelation", foreign_key: :follower_id, dependent: :destroy
  has_many :following, through: :active_relation, source: :following
  # passive_relation(following_id)を持つユーザは、それを通して、さらにfollower_idを持っている。
  has_many :passive_relation, class_name: "FollowRelation", foreign_key: :following_id, dependent: :destroy
  has_many :follower, through: :passive_relation, source: :follower
  # 画像のアタッチ
  has_one_attached :image
  has_one_attached :back_ground
  has_one_attached :image_preview
  has_one_attached :back_ground_preview
  validates(:name, presence: true, length: { maximum: 50 })
  validates(:email, presence: true, length: { maximum: 255 })
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates(:email, format: { with: VALID_EMAIL_REGEX }, uniqueness: true)
  has_secure_password
  validates(:password, presence: true, length: { minimum: 6 }, allow_nil: true)
  before_create :default_image, :default_back_ground_image, :create_activation_digest
  before_save :downcase_email
  attr_accessor :remember_token, :activation_token, :reset_token
  validates :image, content_type: { in: %w[image/jpeg image/gif image/png],
                                    message: "must be a valid image format" },
            size: { less_than: 5.megabytes, message: "should be less than 5MB" }
  validates :back_ground, content_type: { in: %w[image/jpeg image/gif image/png],
                                          message: "must be a valid image format" },
            size: { less_than: 5.megabytes, message: "should be less than 5MB" }
  validates :image_preview, content_type: { in: %w[image/jpeg image/gif image/png],
                                            message: "must be a valid image format" },
            size: { less_than: 5.megabytes, message: "should be less than 5MB" }
  validates :back_ground_preview, content_type: { in: %w[image/jpeg image/gif image/png],
                                                  message: "must be a valid image format" },
            size: { less_than: 5.megabytes, message: "should be less than 5MB" }

  # 渡された文字列のハッシュ値を返す
  def digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
             BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # ランダムなトークンを返す
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # 認証済かどうか確認する
  def authenticated?(attribute, token)
    digest = self.send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # ランダムな文字列（トークン）を作成し、それをハッシュ化し、DBのremember_digestに保存
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, digest(self.remember_token))
  end

  # DBのremember_digestを破棄
  def forget
    update_attribute(:remember_digest, nil)
  end

  def activate
    update_attribute(:activated, true)
    update_attribute(:activated_at, Time.zone.now)
  end

  # 有効化用のメールを送信する
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest, digest(self.reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  # パスワード再設定のメールを送る
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # パスワード再設定の期限が切れている場合はtrueを返す
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  # ユーザプロフィールイメージを圧縮する
  def display_image()
    image.variant(gravity: :center, resize: "640x640^", crop: "640x640+0+0") if self.image.attached?
  end

  # ユーザプロフィールイメージを圧縮する
  def display_background_image()
    back_ground.variant(gravity: :center, resize: "280x180^", crop: "300x140+0+0") if self.back_ground.attached?
  end

  # プレビューイメージを圧縮する
  def preview_image()

    image_preview.variant(gravity: :center, resize: "640x640^", crop: "640x640+0+0") if self.image.attached?
  end

  # プレビューイメージを圧縮する
  def preview_background_image()
    back_ground_preview.variant(gravity: :center, resize: "310x180^", crop: "300x140+0+0") if self.back_ground.attached?
  end

  # channelを使用したリアルタイム表示の際に差し替えるhtmlテンプレートを生成する
  def user_widget_html
    ApplicationController.renderer.render partial: "users/user_widget", locals: { preview: false, user: self, current_user: self }
  end

  # other_userのフォローを行う
  def follow(other_user)
    self.following << other_user
  end

  # active_relation(follower_id)を通してfollowing_idがあるか探し、あったら削除
  def unfollow(other_user)
    self.active_relation.find_by(following_id: other_user.id).destroy
  end

  # other_userをフォローしているかを確認しbooleanを返す
  def following?(other_user)
    self.following.include?(other_user)
  end

  # フォローされているユーザ（リスナー）の一覧を取得
  def followed_list_id
    self.passive_relation.map { |i| i["follower_id"] }
  end

  # 投稿の一覧を取得する
  def micropost_index
    # userがフォローしているユーザ達の一覧(following_id)を取得する
    following_id_list = "SELECT following_id FROM follow_relations
                     WHERE follower_id = :user_id"
    # 上記で取得したuser達のfollowing_idとMicropost.user_idが一致する投稿IDを全て抜き出す。さらに、user自身の投稿も抜き出す
    Micropost.where("user_id IN (#{following_id_list})
                     OR user_id = :user_id", user_id: self.id)
  end

  # 名前に特定の文字を含むユーザとユーザプロフィールのnotesに特定の文字を含むユーザの一覧を取得する
  def all_user_include_params_name_and_notes(value)
    # notesにvalueの値を含むuser_idの一覧を取得
    notes_sql = "SELECT user_id FROM profiles
                     WHERE (notes like '%#{value}%')"
    User.where("id IN (#{notes_sql})
                     OR name like ?", "%#{value}%")
    # User.joins(:profiles).where('notes like ?', "%#{value}%")
  end

  private

  # メールアドレスをすべて小文字にする
  def downcase_email
    self.email = email.downcase
  end

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = digest(activation_token)
  end

  def default_image
    if !self.image.attached?
      self.image.attach(io: File.open(Rails.root.join('app', 'assets', 'images', 'user_default.png')), filename: 'user_default.png', content_type: 'image/png')
    end
  end

  def default_back_ground_image
    if !self.back_ground.attached?
      self.back_ground.attach(io: File.open(Rails.root.join('app', 'assets', 'images', 'photo4.jpg')), filename: 'photo4.jpg', content_type: 'image/jpg')
    end
  end
end
