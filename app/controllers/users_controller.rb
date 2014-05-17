class UsersController < ApplicationController
  def search
    render :index, :layout => false
  end
end
