require './spec/rails_helper'

RSpec.describe PlacesController, type: :controller do
  context 'listing' do
    it 'should return all Places in the database' do
      place1 = create(:place)
      get :index, format: :json
      expect(response.body).to eql([place1].to_json)
    end

    it 'should return a single place given an id' do
      place = create(:place)

      get :show, params: { id: place.id }, format: :json

      expect(response.body).to eql(place.to_json)
    end
  end
  context 'creation' do
    it 'should create a new place and return created object in json' do
      post :create, params: { place: attributes_for(:place) }, format: :json

      expect(Place.count).to eql 1

      place = Place.first
      expect(response.body).to eql(place.to_json)
    end

    it 'should return bad request and the errors if validation fails' do
      post :create, params: { place: attributes_for(:invalid_place) }, format: :json
      place = build(:invalid_place)
      place.valid?

      expect(response).to have_http_status(400)
      expect(response.body).to eql(place.errors.full_messages.to_json)
    end

    it { should route(:get, '/places').to(action: :index) }
    it { should route(:get, '/places/1').to(action: :show, id: 1) }
    it { should route(:post, '/places').to(action: :create) }
  end
end