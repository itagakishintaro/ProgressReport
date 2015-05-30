require 'rails_helper'
require 'pages/users'
include Header, UsersSignIn, UsersSignUp, UsersEdit

feature 'ユーザー情報を管理する' do
  let(:user) { FactoryGirl.build(:user, password: 'password') }
  let(:new_name) { Faker::Name.name }
  let(:new_email) { Faker::Internet.email }
  let(:new_password) { Faker::Internet.password }
  before do
    visit root_path
  end

  scenario 'サインアップして、名前とメアドとパスワードを変更して、ログアウトして、古い情報でログインできないが、新しい情報でログインできる' do
    UsersSignIn.go_to_signup_page
    UsersSignUp.signup({email: user.email, password: user.password, confirmation: user.password})
    expect(page).to have_content 'Welcome! You have signed up successfully.'
    Header.go_to_edit_user_page
    UsersEdit.update_user({name: new_name, email: new_email,password: new_password, confirmation: new_password, current: 'password'})
    expect(page).to have_content 'Your account has been updated successfully.'
    Header.logout
    UsersSignIn.login({email: user.email, password: user.password})
    expect(page).to have_content 'Invalid email or password.'
    UsersSignIn.login({email: new_email, password: new_password})
    expect(page).to have_content 'Signed in successfully.'
  end

  scenario 'アカウントを削除すると、そのアカウントでログインできない' do
    UsersSignIn.go_to_signup_page
    UsersSignUp.signup({email: user.email, password: user.password, confirmation: user.password})
    expect(page).to have_content 'Welcome! You have signed up successfully.'
    Header.go_to_edit_user_page
    UsersEdit.delete_user
    UsersSignIn.login({email: user.email, password: user.password})
    expect(page).to have_content 'Invalid email or password.'
  end
end