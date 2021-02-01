class User < ApplicationRecord
  has_many(:microposts, dependent: :destroy)
  has_one(:profiles, dependent: :destroy, class_name: "Profile")
  accepts_nested_attributes_for :profiles
  has_one_attached :image
  has_one_attached :back_ground
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

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # パスワード再設定の期限が切れている場合はtrueを返す
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  def display_image
    image.variant(resize_to_limit: [500, 500])
  end

  def display_background_image
    back_ground.variant(resize_to_limit: [300, 300]).processed
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
