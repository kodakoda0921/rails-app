class ApplicationController < ActionController::Base
  include UsersHelper
  include ApplicationHelper
  protect_from_forgery with: :null_session
  private

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "ログインしてください"
      redirect_to login_url
    end
  end
end
