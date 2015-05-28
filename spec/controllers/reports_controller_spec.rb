require 'rails_helper'

describe ReportsController do
  let(:user) { FactoryGirl.create(:user) }
  before do
    sign_in user
  end

  describe 'GET #download' do
    it 'sends attachment file' do
      attachment = FactoryGirl.create(:attachment)
      get :download, id: attachment
      expect(assigns(:attachment)).to eq attachment
    end
  end

  describe 'GET #index' do
    before do
      @report_6_days_ago = FactoryGirl.create(:report, updated_at: 6.day.ago)
      @report_7_days_ago = FactoryGirl.create(:report, updated_at: 7.day.ago, id: 2)
      @report_8_days_ago = FactoryGirl.create(:report, updated_at: 8.day.ago)
      FactoryGirl.create(:progress, report_id: 2)
      get :index
    end

    it 'has reports in default order' do
      expect(assigns(:reports)).to eq( [@report_7_days_ago, @report_6_days_ago] )
    end
    it 'does not have a report 8 which created at 8 days ago' do
      expect(assigns(:reports)).not_to match_array([@report_8_days_ago])
    end
  end

  # TODO 添付が登録されたか確認したい
  describe 'POST #create' do
    it 'saves the new report with attachment' do
      expect{
        report = FactoryGirl.attributes_for(:report)
        report[:attachment] = FactoryGirl.attributes_for(:attachment)
        post :create, report: report
      }.to change(Report, :count).by(1)
    end
  end

  describe 'Author or not' do
    before :each do
      @report_1 = FactoryGirl.create(:report, { id: 1, title: 'original', user_id: 1 })
      @attachment_1 = FactoryGirl.create(:attachment, report_id: 1)
      @report_9 = FactoryGirl.create(:report, { id: 9, title: 'original', user_id: 9 })
      @attachment_9 = FactoryGirl.create(:attachment, report_id: 9)
    end

    describe 'PATCH #update' do
      before :each do
        @report = FactoryGirl.attributes_for(:report, title: 'updated')
        @report[:attachment] = FactoryGirl.attributes_for(:attachment)
      end

      it 'can not be updated by anybody but author' do
        patch :update, id: @report_9, report: @report
        @report_9.reload
        expect(@report_9.title).not_to eq('updated')
        expect(@report_9.title).to eq('original')
      end
      # TODO 添付が登録されたか確認したい
      it 'updates the report with attachment by author' do
        patch :update, id: @report_1, report: @report
        @report_1.reload
        expect(@report_1.title).to eq('updated')
        expect(@report_1.title).not_to eq('original')
      end
    end

    describe 'DELETE #destroy' do
      it 'can not be deleted by anybody but author' do
        expect{
          delete :destroy, id: @report_9
        }.to change(Report, :count).by(0)
      end
      # TODO 添付が削除されたか確認したい
      it 'deletes the report with attachment by author' do
        expect{
          delete :destroy, id: @report_1
        }.to change(Report, :count).by(-1)
        # expect(@attachment_1).to eq(nil)
      end
    end
  end
end