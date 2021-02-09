class PostComment < ApplicationRecord
  belongs_to :micropost
  belongs_to :user
  has_one_attached :image
  default_scope -> { order(created_at: :asc) }
  validates :micropost_id, presence: true
  validates :content, presence: true, length: { minimum: 1, maximum: 140 }
  validates :image, content_type: { in: %w[image/jpeg image/gif image/png],
                                    message: "must be a valid image format" },
            size: { less_than: 5.megabytes, message: "should be less than 5MB" }

  def display_image
    image.variant(resize_to_limit: [500, 500])
  end

  # 投稿されたコメントをコメント用の部分テンプレートでHTMLに変換
  def html_template(current_user)
    ApplicationController.renderer.render partial: "post_comments/post_comment_container", locals: { comment: self, current_user: current_user }
  end

  def html_template_count
    ApplicationController.renderer.render partial: "post_comments/post_comment_count_container", locals: { micropost: self.micropost }
  end

end
