# Class Trip for Trips created by users for one group
class TripsController < ApplicationController
  def index
    @user = User.find params[:user_id]
    @group = @user.group
    render json: @group.trips.to_json(include: %i[source destination])
  end

  def show
    @trip = Trip.find params[:id]
    render json: @trip.to_json(include: [:users])
  end

  def create
    @trip = Trip.new trip_params
    @user = User.find(@trip.driver_id)

    @trip.group_id = @user.group_id
    @user.trip_id = @trip.id

    if @trip.save
      @user.save!
      render json: @trip
    else
      render json: @trip.errors.full_messages, status: :bad_request
    end
  end

  def join
    @trip = Trip.find params[:id]
    @user = User.find params[:user_id]
    if @trip.driver.group_id == @user.group_id
      if @trip.seats > 0
        @trip.seats -= 1
        @trip.save!
        @user.trip_id = @trip.id
        @user.save!
        @guest = Guest.new(user_id: @user.id.to_s, trip_id: @trip.id.to_s)
        @guest.save!
        render json: @guest
      else
        render json: 'Seats are full for this trip'
      end
    else
      render json: "You are not in the same Trip's Group"
    end
  end

  def leave
    @trip = Trip.find params[:id]
    @user = User.find params[:user_id]
    @guest = Guest.where(user_id: @user, trip_id: @trip)
    if @guest.empty?
      render json: 'Sorry, you are not joined this trip before'
    else
      render json: @guest
      Guest.destroy(@guest.ids)
      @trip.seats += 1
      @trip.save
    end
  end

  def destroy
    @trip = Trip.where(driver_id: params[:id])
    @guests = Guest.where(trip_id: params[:id]).delete_all

    # Set trip_id = Nil to all users
    @users = User.where(trip_id: @trip)

    # set the Relation user.trip_id to nil for users related to this trip
    @users.each do |user|
      user.trip_id = nil
      user.save!
    end
    Trip.destroy(@trip.ids)
    render json: 'Trip deleted!'
  end

  private

  def trip_params
    params.require(:trip).permit(
      :name, :departure_time,
      :seats, :driver_id,
      :source_id, :destination_id
    )
  end
end