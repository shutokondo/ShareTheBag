class Api::UsersController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => [:create, :update, :follow, :followers]

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
  end


  def fetch_current_user
    @user = User.by_auth_token(auth_token_params[:authToken])
  end

  def add_bagImage
    User.create(add_bag_image)
  end

  def follow
    currentUser = User.find(id_params[:id])
    followUser = User.find_by(name: follow_params[:name])
    if currentUser.following?(followUser)
      currentUser.stop_following(followUser)
    else
      currentUser.follow(followUser)
    end
    @follow = Follow.find_by(followable_id: followUser.id, follower_id: currentUser.id)
  end

  def get_followers
    user = User.find_by(auth_token: auth_token_params[:auth_token])
    users = user.followers
    @follower = []
      users.each do |user|
        id = user.follower_id
        follower = User.find(id)
        @follower << follower
      end
  end

  def get_follows
    user = User.find_by(auth_token: auth_token_params[:auth_token])
    users = user.follows
    @follow_users = []
      users.each do |user|
        id = user.followable_id
        follow_user = User.find(id)
        @follow_users << follow_user
      end
  end

  def profile_info
    @user = User.find(id_params[:id])
  end

  private
  def create_params
    params.permit(:name, :email, :password)
  end

  def id_params
    params.permit(:id)
  end

  def update_params
    params.permit(:name, :message, :avatar, :id, :bagImage, :bagName)
  end

  def auth_token_params
    params.permit(:auth_token)
  end

  def add_bag_image
    params.permit(:bagImage)
  end

  def follow_params
    params.permit(:name)
  end
end
