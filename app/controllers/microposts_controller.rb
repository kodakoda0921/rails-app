class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :current_user2, only: [:destroy]

  def create
    @micropost = current_user.microposts.build(micropost_params)
    @micropost.image.attach(params[:micropost][:image])
    if @micropost.save
      flash[:success] = "投稿に成功しました！"
      redirect_to root_path
    else
      @feed_items = current_user.microposts.paginate(page: params[:page])
      render "users/home"
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
end
