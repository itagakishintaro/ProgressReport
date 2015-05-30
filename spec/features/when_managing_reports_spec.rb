require 'rails_helper'
require 'pages/users'
include UsersSignIn
require 'pages/reports'
include ReportsIndex, ReportsShow, ReportsEdit

feature 'レポートを管理する' do
  let(:author) { FactoryGirl.create(:user, { id: 1 }) }
  let(:other) { FactoryGirl.create(:user, { id: 9 }) }
  let(:title) { 'タイトル' + SecureRandom.uuid }
  before do
    visit root_path
    UsersSignIn.login({email: author.email, password: author.password})
    expect(page).to have_content 'Signed in successfully.'
  end

  context '自分のレポートを操作するとき' do
    scenario 'レポートを画像あり、添付なしで登録して、検索してヒットする' do
      ReportsIndex.go_to_new_report_page
      ReportsEdit.fill_report({tag: 'タグ', title: title, content: '内容'})
      ReportsEdit.insert_img("#{Rails.root}/spec/factories/progress.jpeg")
      # TODO 画像が貼れたか確認したい
      # expect(page).to have_selector '#content-view img'
      ReportsEdit.save_report
      ReportsIndex.search_report({title: title})
      expect(page).to have_link title
    end

    scenario 'レポートをタイトルなしで登録してエラーになって、内容なしで登録してエラーになって、タグなし添付なしで登録して、間違った検索をしてヒットしなくて、正しい検索をしてヒットする' do
      ReportsIndex.go_to_new_report_page
      ReportsEdit.fill_report({content: '内容'})
      ReportsEdit.save_report
      expect(page).to have_content "Title can't be blank"
      ReportsEdit.fill_report({title: 'タイトル', content: ''})
      ReportsEdit.save_report
      expect(page).to have_content "Content can't be blank"
      ReportsEdit.fill_report({title: title, content: '内容'})
      ReportsEdit.save_report
      ReportsIndex.search_report({title: 'NO_HIT'})
      expect(page).not_to have_link title 
      ReportsIndex.search_report({title: title})
      expect(page).to have_link title 
    end

    scenario '自分のレポートを検索して、削除する' do
      FactoryGirl.create(:report, {title: title, user_id: author.id})

      ReportsIndex.search_report({title: title})
      expect(page).to have_link title 
      ReportsIndex.go_to_show_report_page(title)
      ReportsShow.delete_report
      expect(page).to have_content "Report was successfully destroyed."
    end

    scenario 'レポートを添付2つで登録して、検索して、更新で1つ添付を削除して、別の添付を追加する' do
      ReportsIndex.go_to_new_report_page
      ReportsEdit.fill_report({title: title, content: '内容'})
      ReportsEdit.attach( [ "#{Rails.root}/spec/factories/progress.jpeg", "#{Rails.root}/spec/factories/report.jpeg" ] )
      ReportsEdit.save_report
      expect(page).to have_content 'progress.jpeg'
      expect(page).to have_content 'report.jpeg'
      ReportsIndex.go_to_show_report_page(title)
      ReportsShow.go_to_edit_report_page
      ReportsEdit.delete_attach(0)
      ReportsEdit.attach("#{Rails.root}/spec/factories/brokiga.jpeg")
      ReportsEdit.save_report
      expect(page).to have_content 'progress.jpeg'
      expect(page).not_to have_content 'report.jpeg'
      expect(page).to have_content 'brokiga.jpeg'
    end

    scenario 'レポートを登録するときにタグがサジェストされる'
    scenario 'タグを日報、日付を今日から今日で検索すると、今日の日報が検索されて、ユーザーでソート、更新日時でソートする'
  end

  context '他人のレポートを操作するとき' do
    before do
      FactoryGirl.create(:report, {title: title, user_id: other.id})
      visit root_path
      ReportsIndex.go_to_show_report_page(title)
    end

    scenario '他人のレポートでも成長したねボタンは表示される' do
      expect(page).to have_content title
      expect(page).to have_link '成長したね'
    end

    scenario '他人のレポートは更新ボタンがでない' do
      expect(page).not_to have_link '更新'
    end

    scenario '他人のレポートは削除ボタンがでない' do
      expect(page).not_to have_link '削除'
    end
  end
end