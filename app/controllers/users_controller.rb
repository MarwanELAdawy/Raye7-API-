# Class Users
class UsersController < ApplicationController
  def index
    @users = User.all
    render json: @users
  end

  def create
    @user = User.new user_params
    if @user.save
      render json: @user
    else
      render json: @user.errors.full_messages, status: :bad_request
    end
  end

  private

  def user_params
    params.require(:user).permit(
      :name, :first_name,
      :last_name, :phone_number,
      :group_id, :home_place_id, :work_place_id
    )
  end
end