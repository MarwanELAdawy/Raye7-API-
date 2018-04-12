# Class Group for Users's groups
class GroupsController < ApplicationController
  def index
    @groups = Group.all
    render json: @groups
  end

  def create
    @group = Group.new group_params
    if @group.save
      render json: @group
    else
      render json: @group.errors.full_messages, status: :bad_request
    end
  end

  def show
    group = Group.find params[:id]
    render json: group
  end

  private

  def group_params
    params.require(:group).permit(:name)
  end
end