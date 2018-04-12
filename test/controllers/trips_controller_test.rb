require './spec/rails_helper'

RSpec.describe TripsController, type: :controller do
  context 'listing' do
    before(:each) do
      @group = FactoryGirl.create(:group2)
      @place = FactoryGirl.create(:place3)
      @place1 = FactoryGirl.create(:place4)
      @user = FactoryGirl.create(:user1)
    end

    it 'should return all Trips avalilbe for user in the database' do
      trip = create(:trip)
      get :index, params: { user_id: @user.id }, format: :json

      expect(response.body).to eql(@group.trips.to_json)
    end

    it 'should return a single trip given an id' do
      trip = create(:trip)
      get :show, params: { id: trip.id }, format: :json
      expect(response.body).to eql(trip.to_json(include: :users))
    end
  end
  context 'creation' do
    before(:each) do
      @group = FactoryGirl.create(:group2)
      @place = FactoryGirl.create(:place3)
      @place1 = FactoryGirl.create(:place4)
      @user = FactoryGirl.create(:user1)
    end

    it 'should create a new trip and return created object in json' do
      post :create, params: { trip: attributes_for(:trip) }, format: :json

      expect(Trip.count).to eql 1

      trip = Trip.first
      expect(response.body).to eql(trip.to_json)
    end

    it 'should return bad request and the errors if validation fails' do
      post :create, params: { trip: attributes_for(:invalid_trip) }, format: :json
      trip = build(:invalid_trip)
      trip.valid?

      expect(response).to have_http_status(400)
      expect(response.body).to eql(trip.errors.full_messages.to_json)
    end
  end
  context 'join/leave' do
    before(:each) do
      @group = FactoryGirl.create(:group2)
      @group1 = FactoryGirl.create(:group3)

      @place = FactoryGirl.create(:place3)
      @place1 = FactoryGirl.create(:place4)

      @user = FactoryGirl.create(:user1)
      @user1 = FactoryGirl.create(:user2)
      @user2 = FactoryGirl.create(:user3)
      @user3 = FactoryGirl.create(:user4)

      @trip = create(:trip)
    end

    it 'should add guest when user join trip' do
      post :join, params: { id: @trip.id, user_id: @user1.id }, format: :json
      @guest = Guest.first

      expect(Guest.count).to eql 1
      expect(response.body).to eql(@guest.to_json)
    end

    it "should return error message when user not in the same trip's group" do
      post :join, params: { id: @trip.id, user_id: @user2.id }, format: :json
      expect(Guest.count).to eql 0
      expect(response.body).to eql("You are not in the same Trip's Group")
    end

    it 'should return seats are full when seats are full for trip' do
      post :join, params: { id: @trip.id, user_id: @user1.id }, format: :json
      post :join, params: { id: @trip.id, user_id: @user3.id }, format: :json

      expect(response.body).to eql('Seats are full for this trip')
    end

    it 'should return error message if user leave a trip not joined' do
      post :leave, params: { id: @trip.id, user_id: @user3.id }, format: :json
      expect(response.body).to eql('Sorry, you are not joined this trip before')
    end

    it 'should delete guest for a trip when user leave a trip' do
      post :join, params: { id: @trip.id, user_id: @user1.id }, format: :json
      @guest = Guest.first
      expect(Guest.count).to eql 1
      # leaving
      post :leave, params: { id: @trip.id, user_id: @user1.id }, format: :json
      expect(Guest.count).to eql 0
    end
  end

  context 'deletion' do
    before(:each) do
      @group = FactoryGirl.create(:group2)
      @place = FactoryGirl.create(:place3)
      @place1 = FactoryGirl.create(:place4)
      @user = FactoryGirl.create(:user1)
      @user2 = FactoryGirl.create(:user4)
      @trip = create(:trip)
    end

    it 'should delete the given trip and return confirmation message' do
      expect(Trip.count).to eql 1
      delete :destroy, params: { id: @trip.id }, format: :json
      expect(Trip.count).to eql 0
      expect(response.body).to eql('Trip deleted!')
    end

    it 'should delete all guests related to the trip' do
      post :join, params: { id: @trip.id, user_id: @user2.id }, format: :json
      expect(Guest.count).to eql 1
      delete :destroy, params: { id: @trip.id }, format: :json
      expect(Guest.count).to eql 0
    end

    it { should route(:get, '/trips').to(action: :index) }
    it { should route(:get, '/trips/1').to(action: :show, id: 1) }
    it { should route(:post, '/trips').to(action: :create) }
    it { should route(:post, '/trips/1/join').to(action: :join, id: 1) }
    it { should route(:post, '/trips/1/leave').to(action: :leave, id: 1) }
    it { should route(:delete, '/trips/1').to(action: :destroy, id: 1) }
  end
end