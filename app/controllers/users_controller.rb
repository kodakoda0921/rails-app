class UsersController < ApplicationController
  def new
  end

  def home
    if logged_in?
      @current_user = current_user
    else
      redirect_to new_session_path
    end
  end

  def index
  end
end
