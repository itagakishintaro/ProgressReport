require 'rails_helper'

describe Comment do
	describe 'private' do
		before :each do
      (1..4).each do |i|
        FactoryGirl.create(:user, id: i)
        FactoryGirl.create(:report, user_id: i)
      end
      FactoryGirl.create(:comment, report_id: 1, user_id: 4, updated_at: 6.days.ago)
      FactoryGirl.create(:comment, report_id: 1, user_id: 3)
      FactoryGirl.create(:comment, report_id: 2, user_id: 2)
      FactoryGirl.create(:comment, report_id: 3, user_id: 1)
      FactoryGirl.create(:comment, report_id: 1, user_id: 1, updated_at: 8.days.ago)
    end

    describe 'self.for_user' do
      it 'returns comment for a user' do
        expect(Comment.for_user(1).size).to eq 2
        expect(Comment.for_user(1)[0].user_id).to eq 3
        expect(Comment.for_user(1)[1].user_id).to eq 4
      end
    end

		describe 'self.back_for_user' do
      it 'returns others comments to commented reports for a user' do
        expect(Comment.back_for_user(4).length).to eq 1
        expect(Comment.back_for_user(4)[0].report_id).to eq 1
        expect(Comment.back_for_user(4)[0].updated_at.strftime('%Y-%m-%d')).to eq 0.days.ago.strftime('%Y-%m-%d')
				expect(Comment.back_for_user(1).length).to eq 0
				expect(Comment.back_for_user(2).length).to eq 0
				expect(Comment.back_for_user(3).length).to eq 0
      end
    end
	end
end
