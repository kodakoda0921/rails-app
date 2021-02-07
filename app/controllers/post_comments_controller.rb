class PostCommentsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :current_user, only: [:destroy]

  def create
    if params[:post_comment][:content].empty?
      params[:post_comment][:image].nil? ? flash.now[:info] = "空のデータは送信できません。" : flash.now[:info] = "画像のみの投稿はできません。"
      ActionCable.server.broadcast("flash_channel", { flash: flash, user_id: current_user.id })
    else
      @post_comment = PostComment.new(post_comment_params)
      @post_comment.user_id = current_user.id
      if @post_comment.save
        flash.now[:success] = "投稿に成功しました！"
        ActionCable.server.broadcast("post_comment_channel", { post_comment: @post_comment.html_template, post_comment_count: @post_comment.html_template_count, micropost_id: @post_comment.micropost_id })
        ActionCable.server.broadcast("flash_channel", { flash: flash, user_id: current_user.id })
        return
      else
        if @post_comment.errors.any?
          flash.now[:danger] = @post_comment.errors.full_messages.to_s.gsub(",", "<br>").gsub("[", "").gsub("]", "").gsub('"', "")
          ActionCable.server.broadcast("flash_channel", { flash: flash, user_id: current_user.id })
          return
        else
          flash.now[:danger] = "不明なエラー"
          ActionCable.server.broadcast("flash_channel", { flash: flash, user_id: current_user.id })
          return
        end
      end

    end
  end

  private

  def post_comment_params
    params.require(:post_comment).permit(:content, :image, :micropost_id)
  end
end