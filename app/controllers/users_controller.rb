class UsersController < ApplicationController
  before_action :set_q, :if_not_admin, only: [:index]

  def index
    @users = User.where(delete_at: nil)
  end

  def show
    @user = current_user
  end

  #   def edit
  #     @user = current_user
  #   end

  #   def update
  #     @user = current_user
  #     @user.update(user_params)
  #     redirect_to videos_path
  #   end
end

private

def if_not_admin
  redirect_to root_path unless current_user.admin?
end
