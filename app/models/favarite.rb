class Favarite < ActiveRecord::Base
  validates :user_id,
  uniqueness: {
    message: "user_id、report_idが同じ組み合わせのレコードが既に存在します。",
    scope: [:report_id]
  }
end
