class Api::UsersController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => [:create, :update]

  def index
  end

  def show
    @user = User.find(id_params[:id])
  end

  def search
    @users = User.where('name LIKE(?)', "%#{params[:name]}%")
  end

  def create
    @user = User.new(create_params)
    @error_message = []
    unless @user.save
      @error_message = [@user.errors.full_messages].compact
    end
  end

  def update
    @user = User.find(id_params[:id])
    @user.update(update_params)
    binding.pry
  end


  def fetch_current_user
    @user = User.by_auth_token(auth_token_params[:authToken])
  end

  def add_bagImage
    User.create(add_bag_image)
  end

  def follow
    # user = User.find
  end

  private
  def create_params
    params.permit(:name, :email, :password)
  end

  def id_params
    params.permit(:id)
  end

  def update_params
    params.permit(:name, :message, :avatar, :id, :bagImage)
  end

  def auth_token_params
    params.permit(:auth_token)
  end

  def add_bag_image
    params.permit(:bagImage)
  end
end
