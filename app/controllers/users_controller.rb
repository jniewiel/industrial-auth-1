# app/controllers/users_controller.rb

class UsersController < ApplicationController
  before_action :set_user, only: %i[ show liked feed followers following discover ]
  before_action :authorize_user, except: %i[ index new create ]

  def index
    @users = policy_scope(User)
  end

  def feed
  end

  def show
  end

  def new
    @user = User.new
    authorize(@user)
  end

  def edit
  end

  def create
    @user = User.new(user_params)
    authorize(@user)
  end

  def update
    if @user.update(user_params)
      redirect_to(@user, { :notice => "User was successfully updated." })
    else
      render({ :template => "users/edit", :status => :unprocessable_entity })
    end
  end

  def destroy
    @user.destroy
    
    redirect_back({ :fallback_location => root_url, :notice => "User was successfully destroyed." })
  end

  private

  def set_user
    if params[:username]
      @user = User.find_by!({ :username => params.fetch("username") })
    else
      @user = current_user
    end
  end

  def authorize_user
    authorize(@user)
  end

  def user_params
    params.require("user").permit("username", "name", "email", "private", "bio", "website", "avatar_image")
  end
end
