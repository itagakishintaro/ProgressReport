class Report < ActiveRecord::Base
	belongs_to :user
	has_many :progresses
	has_many :comments
	has_many :attachments

	validates :title,
	  presence: true
	validates :content,
	  presence: true

  def self.with_progress_points
    joins('left outer join progresses on reports.id = progresses.report_id')
    .select('reports.*, sum("progresses"."point") AS progress_points')
    .group('reports.id')
  end

  def self.index_default_order
    # 基本は、1:成長ポイント降順, 2:更新日付降順 でソート
    order('progress_points desc').order('updated_at desc')
  end
end
