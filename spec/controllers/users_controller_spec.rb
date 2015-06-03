require 'rails_helper'

describe 'UsersController' do
  let(:user) { FactoryGirl.create(:user) }
  before do
    sign_in user
  end

  it 'sends users with progresses' do
    FactoryGirl.create(:user, {id: 2})
    FactoryGirl.create(:user, {id: 3})
    FactoryGirl.create(:progress, {user_id: 1})
    FactoryGirl.create(:progress, {user_id: 2})
    FactoryGirl.create(:progress, {user_id: 2})
    FactoryGirl.create(:progress, {user_id: 2})
    get '/users/with_progresses'
    expect(response).to have_http_status(:success)
    json = JSON.parse(response.body)
    expect(json.size).to eq 4
    expect(json[0]['id']).to eq 1
    expect(json[0]['point']).to eq 1
    expect(json[3]['id']).to eq 2
    expect(json[3]['point']).to eq 1
  end
end