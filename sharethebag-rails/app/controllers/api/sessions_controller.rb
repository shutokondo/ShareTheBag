class Api::SessionsController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => :create

  def create
    @user = login(params[:email], params[:password])
    if @user
      @error_message = []
    else
      @error_message = ["Email or password was invalid."]
    end
  end
end
