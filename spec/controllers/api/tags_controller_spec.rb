require 'rails_helper'

describe 'TagsController', type: :request do
  it 'sends tags distinct' do
    FactoryGirl.create(:report, {tag: 'foo'})
    FactoryGirl.create(:report, {tag: 'foo'})
    FactoryGirl.create(:report, {tag: 'bar'})
    get '/api/tags'
    expect(response).to have_http_status(:success)
    json = JSON.parse(response.body)
    expect(json.size).to eq 2
    expect(json[0]['tag']).to eq 'foo'
    expect(json[1]['tag']).to eq 'bar'
  end
end