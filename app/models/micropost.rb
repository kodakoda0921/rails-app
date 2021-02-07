class Micropost < ApplicationRecord
  include UsersHelper
  belongs_to :user
  has_many :post_comment, dependent: :destroy
  has_one_attached :image
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :content, presence: true, length: { minimum: 1, maximum: 140 }
  validates :image, content_type: { in: %w[image/jpeg image/gif image/png],
                                    message: "must be a valid image format" },
            size: { less_than: 5.megabytes, message: "should be less than 5MB" }

  def display_image
    image.variant(resize_to_limit: [500, 500])
  end

  # 投稿されたメッセージをメッセージ用の部分テンプレートでHTMLに変換
  def html_template
    ApplicationController.renderer.render partial: "microposts/microposts_create", locals: { micropost: self, post_comment: PostComment.new }
  end

end
