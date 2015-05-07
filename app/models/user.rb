class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :comments
  has_many :progresses

  def self.progress_points
    select('users.name AS user_name, SUM(progresses.point) AS progress_points')
    .joins(:progresses)
    .where('progresses.updated_at': Time.now.beginning_of_month...Time.now.end_of_month)
    .group('users.id')
    .order('progress_points desc')
  end
end
