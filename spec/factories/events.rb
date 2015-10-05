# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :event do
    title "MyString"
    start "2015-10-05 19:34:02"
    self.end "2015-10-05 19:34:02"
    color "MyString"
    allDay false
  end
end
