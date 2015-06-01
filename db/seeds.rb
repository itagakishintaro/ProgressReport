# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

100.times do |i|
  User.create!({
    id: i,
    name: "name#{i}",
    email: "email#{i}@example.com",
    password: "password"
  })
end

100.times do |i|
  Report.create!({
    tag: "タグ#{i}",
    title: "タイトル#{i}",
    content: "内容#{i}",
    user_id: i
  })
end