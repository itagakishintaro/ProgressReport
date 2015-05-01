class Report < ActiveRecord::Base
	belongs_to :user
	has_many :progresses
	has_many :comments
	has_many :attachments

	validates :title,
	  presence: true
	validates :content,
	  presence: true
end
