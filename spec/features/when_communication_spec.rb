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

	scenario 'レポートをみる' do
		ReportsIndex.go_to_new_report_page
		ReportsEdit.fill_report({tag: 'タグ', title: title, content: '内容'})
		ReportsEdit.insert_img("#{Rails.root}/spec/factories/progress.jpeg")
		ReportsEdit.save_report
		ReportsIndex.search_report({title: title})
		ReportsIndex.go_to_show_report_page(title)
		expect(page).to have_content title 
	end

	scenario 'コメントをする' do
		ReportsIndex.go_to_new_report_page
		ReportsEdit.fill_report({tag: 'タグ', title: title, content: '内容'})
		ReportsEdit.insert_img("#{Rails.root}/spec/factories/progress.jpeg")
		ReportsEdit.save_report
		ReportsIndex.search_report({title: title})
		ReportsIndex.go_to_show_report_page(title)
		ReportsComment.add_new_comment({comment: 'momonga'})
		expect(page).to have_content 'momonga'
	end

	scenario '成長したねする' do
		ReportsIndex.go_to_new_report_page
		ReportsEdit.fill_report({tag: 'タグ', title: title, content: '内容'})
		ReportsEdit.insert_img("#{Rails.root}/spec/factories/progress.jpeg")
		ReportsEdit.save_report
		ReportsIndex.search_report({title: title})
		ReportsIndex.go_to_show_report_page(title)
		ReportsComment.add_new_comment({comment: 'momonga'})
		ReportsComment.click_grew_button
		ReportsComment.click_grew_button
		expect(page).to have_css("div.arrow_box", text: "2")
	end

	scenario 'レポートをみて、コメントして、成長したねして、成長グラフをみる' do
		ReportsIndex.go_to_new_report_page
		ReportsEdit.fill_report({tag: 'タグ', title: title, content: '内容'})
		ReportsEdit.insert_img("#{Rails.root}/spec/factories/progress.jpeg")
		ReportsEdit.save_report
		ReportsIndex.search_report({title: title})
		ReportsIndex.go_to_show_report_page(title)
		ReportsComment.add_new_comment({comment: 'momonga'})
		ReportsComment.click_grew_button
		visit '/progresses'
		expect(page).to have_css("a.btn", text: "戻る")
		expect(find('svg')).to have_css("svg")
		#expect(page).to have_css("div.c3-tooltip-container")
	end
end
