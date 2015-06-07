class CreateNotices < ActiveRecord::Migration
  def change
    create_table :notices do |t|
      t.integer :user_id
      t.datetime :watched_at

      t.timestamps null: false
    end
  end
end
