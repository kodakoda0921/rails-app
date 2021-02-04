class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :current_user2, only: [:destroy]

  def create
    if params[:micropost][:content].empty?
      params[:image].nil? ? flash.now[:info] = "空のデータは送信できません。" : flash.now[:info] = "画像のみの投稿はできません。"
      ActionCable.server.broadcast("flash_channel", { flash: flash_template(flash), user_id: current_user.id.to_s })
    else
      @micropost = current_user.microposts.build(micropost_params)
      @micropost.image.attach(params[:image])
      if @micropost.save
        flash.now[:success] = "投稿に成功しました！"
        ActionCable.server.broadcast("home_channel", { micropost: @micropost.html_template })
        ActionCable.server.broadcast("flash_channel", { flash: flash_template(flash), user_id: @micropost.user.id.to_s })
        return
      else
        if @micropost.errors.any?
          flash.now[:danger] = @micropost.errors.full_messages.to_s.gsub(",", "<br>").gsub("[", "").gsub("]", "").gsub('"', "").html_safe
          ActionCable.server.broadcast("flash_channel", { flash: flash_template(flash), user_id: current_user.id.to_s })
          return
        else
          flash.now[:danger] = "不明なエラー"
          ActionCable.server.broadcast("flash_channel", { flash: flash_template(flash), user_id: current_user.id.to_s })
          return
        end
      end
    end
  end
end

def destroy
  @micropost.destroy
  flash[:success] = "削除完了しました！"
  redirect_to request.referer || root_path
end

private

def micropost_params
  params.require(:micropost).permit(:content, :image)
end

def current_user2
  @micropost = current_user.microposts.find_by(id: params[:id])
  redirect_to root_path if @micropost.nil?
end
