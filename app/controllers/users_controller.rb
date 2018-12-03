class UsersController < ApplicationController
  before_action :authenticate_user!, except: :login
  def login
    @user = User.find_by(id: session[:user_id]) if session[:user_id]
    render :login, layout: 'layouts/login'
  end

  def index
  end
end
