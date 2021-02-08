class FrameController < ApplicationController
  def show
    if logged_in?
      @current_user = current_user
      @microposts = current_user.microposts
      @profiles = current_user.profiles
      @post_comment = PostComment.new
    else
      redirect_to new_session_path
    end
  end
end
