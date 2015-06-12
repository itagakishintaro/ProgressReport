require 'rails_helper'
require 'pages/users'
include UsersSignIn
require 'pages/reports'
include ReportsIndex, ReportsShow, ReportsEdit, ReportsComment

feature 'レポートにコメント、成長したねする' do
  let(:author) { FactoryGirl.create(:user, { id: 1 }) }
  let(:other) { FactoryGirl.create(:user, { id: 9 }) }
  let(:title) { 'タイトル' + SecureRandom.uuid }
  before do
    visit root_path
    UsersSignIn.login({email: author.email, password: author.password})
    expect(page).to have_content 'Signed in successfully.'
  end

	scenario 'レポートをみて、コメントして、成長したねして、成長グラフをみる' do
		ReportsIndex.go_to_new_report_page
		ReportsEdit.fill_report({tag: 'タグ', title: title, content: '内容'})
		ReportsEdit.insert_img("#{Rails.root}/spec/factories/progress.jpeg")
		ReportsEdit.save_report
		ReportsIndex.search_report({title: title})
		expect(page).to have_link title
		ReportsIndex.go_to_show_report_page(title)
		expect(page).to have_content 'Progress Report'
		ReportsComment.add_new_comment({comment: 'momonga'})
		expect(page).to have_content 'momonga'
	end

end
