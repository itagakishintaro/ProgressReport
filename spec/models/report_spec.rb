require 'rails_helper'

describe Report do
  describe 'validation' do
    before :each do
      @report_without_title = FactoryGirl.build(:report, title: '')
      @report_without_content = FactoryGirl.build(:report, content: '')
    end

    it 'is invalid without a title' do
      @report_without_title.valid?
      expect(@report_without_title.errors[:title]).to include("can't be blank")
    end

    it 'is invalid without a content' do
      @report_without_content.valid?
      expect(@report_without_content.errors[:content]).to include("can't be blank")
    end
  end

  describe 'private' do
    before :each do
      (1..4).each do |i|
        FactoryGirl.create(:user, id: i)
        FactoryGirl.create(:report, user_id: i)
      end
      FactoryGirl.create(:progress, report_id: 3)
      FactoryGirl.create(:progress, report_id: 4)

      (1..4).each do |i|
        FactoryGirl.create(:progress, report_id: 1)
        FactoryGirl.create(:comment, report_id: 1)
      end
      FactoryGirl.create(:comment, report_id: 2)
      FactoryGirl.create(:comment, report_id: 2)
      FactoryGirl.create(:comment, report_id: 3)
    end

    describe 'self.with_progress_points_and_number_of_comments' do
      it 'returns reports with progress points' do
        expect(Report.with_progress_points_and_number_of_comments[0].progress_points).to eq 4
        expect(Report.with_progress_points_and_number_of_comments[1].progress_points).to eq nil
        expect(Report.with_progress_points_and_number_of_comments[2].progress_points).to eq 1
        expect(Report.with_progress_points_and_number_of_comments[3].progress_points).to eq 1
      end

      it 'returns reports with number of comments' do
        expect(Report.with_progress_points_and_number_of_comments[0].number_of_comments).to eq 4
        expect(Report.with_progress_points_and_number_of_comments[1].number_of_comments).to eq 2
        expect(Report.with_progress_points_and_number_of_comments[2].number_of_comments).to eq 1
        expect(Report.with_progress_points_and_number_of_comments[3].number_of_comments).to eq nil
      end
    end
    
    describe 'self.index_default_order' do
      it 'returns reports with progress points' do
        expect(Report.with_progress_points_and_number_of_comments.index_default_order[0].id).to eq 1
        expect(Report.with_progress_points_and_number_of_comments.index_default_order[1].id).to eq 3
        expect(Report.with_progress_points_and_number_of_comments.index_default_order[2].id).to eq 4
        expect(Report.with_progress_points_and_number_of_comments.index_default_order[3].id).to eq 2
      end
    end

    describe 'self.progress_points_by_user_this_month' do
      it 'returns reports with progress points' do
        expect(Report.progress_points_by_user_this_month[0].progress_points).to eq 4
        expect(Report.progress_points_by_user_this_month[1].progress_points).to eq 1
        expect(Report.progress_points_by_user_this_month[2].progress_points).to eq 1
        expect(Report.progress_points_by_user_this_month[3]).to eq nil
      end
    end
  end
end