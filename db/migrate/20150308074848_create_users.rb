class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name, :unique=>true
      t.string :email
      t.string :password
      t.datetime :created_at
      t.datetime :updated_at

      t.timestamps null: false
    end
  end
end
