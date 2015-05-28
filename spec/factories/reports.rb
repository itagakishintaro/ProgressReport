FactoryGirl.define do
	factory :report do
		tag { 'tag' }
		title { 'title' }
    content { 'content' }
    user_id { 1 }
	end
end