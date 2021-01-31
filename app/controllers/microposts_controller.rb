class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :current_user2, only: [:destroy]

  def create
    if params[:micropost][:content].empty?
      params[:image].nil? ? flash[:info] = "空のデータは送信できません。" : flash[:info] = "画像のみの投稿はできません。"
      redirect_to root_path
    else
      @micropost = current_user.microposts.build(micropost_params)
      @micropost.image.attach(params[:image])
      if @micropost.save
        flash[:success] = "投稿に成功しました！"
        redirect_to root_path and return
      else
        if @micropost.errors.any?
          flash[:danger] = @micropost.errors.full_messages.to_s.gsub(",", "<br>").gsub("[", "").gsub("]", "").gsub('"', "").html_safe
          redirect_to root_path and return
        end
      end
      flash[:danger] = "不明なエラー"
      redirect_to root_path
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
