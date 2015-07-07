class Api::UsersController < ApplicationController
  def create
    User.create(create_params)
    unless item.save
      @error_message = item.errors.full_message
    end
  end


  private
  def create_params
    params.permit(:name, :password)
  end
end
