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

  private
  def create_params
    params.permit(:title, :store, :description, :avatar)
  end
end
