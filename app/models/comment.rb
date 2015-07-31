class Comment < ActiveRecord::Base
	belongs_to :report
	belongs_to :user

  def self.for_user(user_id)
    select('reports.id AS report_id, comments.id AS comment_id, comments.updated_at, users.id AS user_id, users.name AS user_name')
    .joins(:user)
    .joins(:report)
    .where('comments.updated_at >= ?', 7.days.ago)
    .where("reports.user_id = #{user_id}")
    .order('comments.updated_at desc')
  end

	# 自分がコメントしたレポートのうち、誰かがコメントしたレポートのIDとコメントの更新日付の最大値を取得
	def self.back_for_user(user_id)
		select('comments.report_id AS report_id, max(comments.updated_at) AS updated_at')
		.joins(:report)
		.joins("INNER JOIN (SELECT report_id, updated_at FROM comments WHERE user_id = #{user_id}) AS SELF ON SELF.report_id = comments.report_id AND SELF.updated_at < comments.updated_at")
		.where("comments.user_id != #{user_id}")
		.where("reports.user_id != #{user_id}")
		.group('comments.report_id, comments.updated_at')
	end
end
