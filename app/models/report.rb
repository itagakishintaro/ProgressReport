class Report < ActiveRecord::Base
	belongs_to :user
	has_many :progresses, dependent: :destroy
	has_many :comments, dependent: :destroy
	has_many :attachments, dependent: :destroy

	validates :title,
	  presence: true
	validates :content,
	  presence: true

  def self.with_progress_points_and_number_of_comments
    joins('left outer join (SELECT SUM(point) AS progress_points, report_id FROM PROGRESSES GROUP BY report_id) AS p on reports.id = p.report_id')
    .joins('left outer join (SELECT COUNT(*) AS number_of_comments, report_id FROM COMMENTS GROUP BY report_id) AS c on reports.id = c.report_id')
    .select('reports.*, COALESCE(progress_points, 0) AS progress_points, COALESCE(number_of_comments, 0) AS number_of_comments')
  end

  def self.index_default_order
    # 基本は、1:更新日付降順、2:成長ポイント降順, 3:コメント数降順, 4:更新日時降順 でソート（※日付と日時の違いに注意）
    order("substr(updated_at, 0, 10) desc").order('progress_points desc').order('number_of_comments desc').order("updated_at desc")
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
