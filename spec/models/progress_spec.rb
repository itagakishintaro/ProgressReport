require 'rails_helper'

describe Progress do
	describe 'private' do
		before :each do
      (1..4).each do |i|
        FactoryGirl.create(:user, id: i)
        FactoryGirl.create(:report, user_id: i)
      end
      FactoryGirl.create(:progress, report_id: 1, user_id: 4, updated_at: 6.days.ago)
      FactoryGirl.create(:progress, report_id: 1, user_id: 3)
      FactoryGirl.create(:progress, report_id: 2, user_id: 2)
      FactoryGirl.create(:progress, report_id: 3, user_id: 1)
      FactoryGirl.create(:progress, report_id: 1, user_id: 1, updated_at: 8.days.ago)
    end

    describe 'self.for_user' do
      it 'returns progress for a user' do
        expect(Progress.for_user(1).size).to eq 2
        expect(Progress.for_user(1)[0].user_id).to eq 3
        expect(Progress.for_user(1)[1].user_id).to eq 4
      end
    end
	end
end