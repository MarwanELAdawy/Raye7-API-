require './spec/rails_helper'

RSpec.describe GroupsController, type: :controller do
  context 'listing' do
    it 'should return all groups in the database' do
      group1 = create(:group)
      get :index, format: :json
      expect(response.body).to eql([group1].to_json)
    end

    it 'should return a single group given an id' do
      group = create(:group)

      get :show, params: { id: group.id }, format: :json

      expect(response.body).to eql(group.to_json)
    end
  end
  context 'creation' do
    it 'should create a new group and return created object in json' do
      post :create, params: { group: attributes_for(:group) }, format: :json

      expect(Group.count).to eql 1

      group = Group.first
      expect(response.body).to eql(group.to_json)
    end

    it 'should return bad request and the errors if validation fails' do
      post :create, params: { group: attributes_for(:invalid_group) }, format: :json
      group = build(:invalid_group)
      group.valid?

      expect(response).to have_http_status(400)
      expect(response.body).to eql(group.errors.full_messages.to_json)
    end

    it { should route(:get, '/groups').to(action: :index) }
    it { should route(:get, '/groups/1').to(action: :show, id: 1) }
    it { should route(:post, '/groups').to(action: :create) }
  end
end