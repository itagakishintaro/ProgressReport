class AddFieldToImages < ActiveRecord::Migration
  def change
    add_column :images, :content_type, :string
  end
end
