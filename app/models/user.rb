class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, #:registerable
         :recoverable, :rememberable, :trackable, :validatable
  has_many :comments
  has_many :progresses
  has_many :images

  def self.with_progress_points
    select('users.id, users.name, p.point, p.updated_at')
    .joins('left outer join (SELECT reports.user_id, progresses.point, progresses.updated_at FROM REPORTS left outer join PROGRESSES on reports.id = progresses.report_id) AS p on users.id = p.user_id')
    .order('users.id, p.updated_at')
  end
end
