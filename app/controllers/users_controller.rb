class UsersController < ApplicationController
  before_action :authenticate_user!, except: :login
  def login
  	@user = current_user
    render :login, layout: 'layouts/login'
  end

  def index
  end
end
