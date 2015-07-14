class Api::ItemsController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: :create

  def index
    @items = Item.all
  end

  def create
    @item = Item.new(create_params)
    unless @item.save
      @error_message = item.errors.full_message
    end
  end

  def fetch_current_user_items
    user = User.by_auth_token(auth_token_params[:authToken])
    @items = user.items
  end

  private
  def create_params
    params.permit(:title, :store, :description, :avatar, :user_id)
  end

  def auth_token_params
    params.permit(:authToken)
  end
end
