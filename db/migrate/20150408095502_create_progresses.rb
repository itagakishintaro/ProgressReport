class CreateProgresses < ActiveRecord::Migration
  def change
    create_table :progresses do |t|
      t.integer :report_id
      t.integer :point

      t.timestamps null: false
    end
  end
end
