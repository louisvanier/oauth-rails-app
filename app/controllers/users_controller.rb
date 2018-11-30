class UsersController < ApplicationController
  before_action :authenticate_user!, except: :login
  def login
  end

  def index
  end
end
