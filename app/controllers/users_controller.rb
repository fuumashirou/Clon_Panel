class UsersController < ApplicationController
  before_action :is_admin?

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to users_url, notice: 'User was successfully destroyed.'
  end

private
  def user_params
    params.require(:user).permit(:username, :password, :token, :verified, :verified_at)
  end
end
