include Capybara::DSL

module Header
  def go_to_edit_user_page
    click_on 'プロフィール変更'
  end
  def logout
    click_on 'ログアウト'
  end
end

module UsersSignIn
  def login(user)
    fill_in 'Email', with: user[:email]
    fill_in 'Password', with: user[:password]
    click_button 'ログイン'
  end
  def go_to_signup_page
    first('.container a').click
  end
end

module UsersSignUp
  def signup(d)
    if d[:name] then fill_in 'Name', with: d[:name] end
    if d[:email] then fill_in 'Email', with: d[:email] end
    if d[:password] then fill_in 'Password', with: d[:password] end
    if d[:confirmation] then fill_in 'Password confirmation', with: d[:confirmation] end
    click_button 'サインアップ'
  end
end

module UsersEdit
  def update_user(d)
    if d[:name] then fill_in 'Name', with: d[:name] end
    if d[:email] then fill_in 'Email', with: d[:email] end
    if d[:password] then fill_in 'Password', with: d[:password] end
    if d[:confirmation] then fill_in 'Password confirmation', with: d[:confirmation] end
    if d[:current] then fill_in 'Current password', with: d[:current] end
    click_on '更新する'
  end

  def delete_user
    click_on 'アカウントを削除する'
  end
end