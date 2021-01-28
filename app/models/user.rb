class User < ApplicationRecord
  validates(:name, presence: true, length: { maximum: 50 })
  validates(:email, presence: true, length: { maximum: 255 })
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates(:email, format: { with: VALID_EMAIL_REGEX }, uniqueness: true)
  has_secure_password
  validates(:password, presence: true, length: { minimum: 6 }, allow_nil: true)
  before_save :downcase_email

  # 渡された文字列のハッシュ値を返す
  def digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
             BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # ランダムなトークンを返す
  def new_token
    SecureRandom.urlsafe_base64
  end

  # 認証済かどうか確認する
  def authenticated?(token)
    return false if activated.nil?
  end

  # リメンバーを破棄
  def forget
    update_attribute(:remember_digest, nil)
  end

  private

  # メールアドレスをすべて小文字にする
  def downcase_email
    self.email = email.downcase
  end
end
