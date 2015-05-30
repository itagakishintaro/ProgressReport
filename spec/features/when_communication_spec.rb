require 'rails_helper'
require 'pages/users'
include UsersSignIn
require 'pages/reports'
include ReportsIndex, ReportsShow

feature 'レポートにコメント、成長したねする' do
  scenario 'レポートをみて、コメントして、成長したねして、成長グラフをみる'
end