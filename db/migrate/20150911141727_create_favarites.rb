class CreateFavarites < ActiveRecord::Migration
  def change
    create_table :favarites do |t|
      t.integer :user_id
      t.integer :report_id

      t.timestamps null: false

      t.index [:user_id, :report_id], :unique => true
    end
  end
end
