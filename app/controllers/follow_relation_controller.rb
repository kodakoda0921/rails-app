class FollowRelationController < ApplicationController
  # フォロー処理
  def create
    @other_user = User.find(params[:following_id])
    current_user.follow(@other_user)
  end

  # フォロー解除処理
  def destroy
    @other_user = FollowRelation.find_by(id: params[:id]).following
    current_user.unfollow(@other_user)
  end

  #一覧表示
  def index
    if logged_in?
      @current_user = current_user
      user = User.find_by(id: params[:id])
      @following_user_all = user.following.paginate(page: params[:page])
      @followers_user_all = user.follower.paginate(page: params[:page])
      @index = params[:index]
    else
      redirect_to new_session_path
    end
  end
end

