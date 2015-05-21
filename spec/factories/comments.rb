FactoryGirl.define do
	factory :comment do
    	comment { 'comment' }
    	report_id { 1 }
    	user_id { 1 }
	end
end