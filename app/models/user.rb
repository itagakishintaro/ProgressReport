class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :comments
  has_many :progresses
  has_many :images

  def self.with_progress_points
    select('users.id, users.name, progresses.point, progresses.updated_at')
    .joins(:progresses)
    .order('users.id, progresses.updated_at')
  end
end
