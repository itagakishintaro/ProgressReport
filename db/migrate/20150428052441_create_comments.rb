class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :comment
      t.integer :report_id
      t.integer :user_id
      t.datetime :created_at
      t.datetime :updated_at
      
      t.timestamps null: false
    end
  end
end
