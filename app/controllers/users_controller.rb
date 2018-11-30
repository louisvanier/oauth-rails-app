class UsersController < ApplicationController
  before_action :authenticate_user!, except: :login
  def login
    render :login, layout: 'layouts/login'
  end

  def index
  end
end
