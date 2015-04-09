class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.string :title
      t.string :tag
      t.string :content
      t.integer :user_id
      t.integer :progress, default: 0
      t.datetime :created_at
      t.datetime :updated_at

      t.timestamps null: false
    end
  end
end
