class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :destroy_id_get, only: [:destroy]

  def create
    if params[:micropost][:content].empty?
      params[:image].nil? ? flash.now[:info] = "空のデータは送信できません。" : flash.now[:info] = "画像のみの投稿はできません。"
      ActionCable.server.broadcast("flash_channel", { flash: flash, user_id: current_user.id })
    else
      @micropost = current_user.microposts.build(micropost_params)
      @micropost.image.attach(params[:image])
      if @micropost.save
        flash.now[:success] = "投稿に成功しました！"
        ActionCable.server.broadcast("home_channel", { micropost: @micropost.html_template, user_id: current_user.id, method: "create" })
        ActionCable.server.broadcast("flash_channel", { flash: flash, user_id: current_user.id })
        return
      else
        if @micropost.errors.any?
          flash.now[:danger] = @micropost.errors.full_messages.to_s.gsub(",", "<br>").gsub("[", "").gsub("]", "").gsub('"', "").html_safe
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

  def destroy
    if @micropost.destroy
      flash.now[:success] = "削除完了しました！"
      ActionCable.server.broadcast("home_channel", { user_id: current_user.id, micropost_id: @micropost.id.to_s, method: "destroy" })
    else
      flash.now[:warn] = "削除に失敗しました"
    end
    ActionCable.server.broadcast("flash_channel", { flash: flash, user_id: current_user.id })
  end

  private

  def micropost_params
    params.require(:micropost).permit(:id, :content, :image,
                                      post_comments_attributes: [:id, :content, :image])
  end

  def destroy_id_get
    @micropost = current_user.microposts.find_by(id: params[:id])
    if @micropost.nil?
      flash.now[:warn] = "投稿が存在しません！"
      ActionCable.server.broadcast("flash_channel", { flash: flash, user_id: current_user.id })
    end
  end
end

