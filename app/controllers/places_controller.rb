# Class Place examples( Maadi - New-Cairo)
class PlacesController < ApplicationController
  def index
    @places = Place.all
    render json: @places
  end

  def create
    @place = Place.new place_params
    if @place.save
      render json: @place
    else
      render json: @place.errors.full_messages, status: :bad_request
    end
  end

  def show
    place = Place.find params[:id]
    render json: place
  end

  private

  def place_params
    params.require(:place).permit(:name, :longitude, :latitude)
  end
end