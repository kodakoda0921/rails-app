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
end

