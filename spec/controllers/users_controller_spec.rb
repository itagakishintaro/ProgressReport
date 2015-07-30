require 'rails_helper'

describe UsersController do
  let(:user) { FactoryGirl.create(:user) }
  before do
    sign_in user
  end

  describe 'with_progresses' do
    it 'sends users with progresses' do
      FactoryGirl.create(:user, {id: 2})
      FactoryGirl.create(:user, {id: 3})
      FactoryGirl.create(:report, {id: 1, user_id: 1})
      FactoryGirl.create(:report, {id: 2, user_id: 2})
      FactoryGirl.create(:report, {id: 3, user_id: 3})
      FactoryGirl.create(:progress, {report_id: 1})
      FactoryGirl.create(:progress, {report_id: 2})
      FactoryGirl.create(:progress, {report_id: 2})
      FactoryGirl.create(:progress, {report_id: 2})
      get :with_progresses
      expect(response).to have_http_status(:success)
      json = JSON.parse(response.body)
      expect(json.size).to eq 5
      expect(json[0]['id']).to eq 1
      expect(json[0]['point']).to eq 1
      expect(json[1]['id']).to eq 2
      expect(json[1]['point']).to eq 1
      expect(json[4]['id']).to eq 3
      expect(json[4]['point']).to eq nil
    end
  end
end
