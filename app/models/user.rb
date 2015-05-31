class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :comments
  has_many :progresses
  has_many :images

  def self.with_progress_points
    select('users.id, progresses.id')
    # select('users.id, users.name, SUM(progresses.point) AS progress_points, progresses.updated_at')
    .joins(:progresses)
    # .group('users.id')
    # .order('progress_points desc')
  end
end
