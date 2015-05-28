FactoryGirl.define do
	factory :attachment do
    name { Faker::Name.name }
    file { }
    report_id { 1 }
	end
end