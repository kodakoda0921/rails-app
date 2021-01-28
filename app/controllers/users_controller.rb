class UsersController < ApplicationController
  def new
  end

  def home
    session[:user_id] = 1
    @current_user = current_user
  end

  def index
  end
end
