class Comment < ActiveRecord::Base
	belongs_to :report
	belongs_to :user

  def self.for_user(user_id)
    select('reports.id AS report_id, comments.id AS comment_id, comments.updated_at, users.id AS user_id, users.name AS user_name')
    .joins(:user)
    .joins(:report)
    .where('comments.updated_at >= ?', 7.days.ago)
    .where("reports.user_id == #{user_id}")
    .order('comments.updated_at desc')
  end
end
