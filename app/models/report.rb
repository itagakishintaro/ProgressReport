class Report < ActiveRecord::Base
	belongs_to :user
	has_many :progresses, dependent: :destroy
	has_many :comments, dependent: :destroy
	has_many :attachments, dependent: :destroy

	validates :title,
	  presence: true
	validates :content,
	  presence: true

  def self.with_progress_points_and_comment_num
    joins('left outer join (SELECT SUM(point) AS progress_points, report_id FROM PROGRESSES GROUP BY report_id) AS p on reports.id = p.report_id')
    .joins('left outer join (SELECT COUNT(*) AS comment_num, report_id FROM COMMENTS GROUP BY report_id) AS c on reports.id = c.report_id')
    .select('reports.*, progress_points, comment_num')
  end

  def self.index_default_order
    # 基本は、1:成長ポイント降順, 2:コメント数降順, 3:更新日付降順 でソート
    order('progress_points desc').order('comment_num desc').order('updated_at desc')
  end

  def self.progress_points_by_user_this_month
    select('users.name AS user_name, SUM(progresses.point) AS progress_points')
    .joins(:progresses)
    .joins(:user)
    .where('progresses.updated_at': Time.now.beginning_of_month...Time.now.end_of_month)
    .group('users.id')
    .order('progress_points desc')
  end
end
