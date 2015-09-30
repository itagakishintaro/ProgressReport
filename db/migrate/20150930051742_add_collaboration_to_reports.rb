class AddCollaborationToReports < ActiveRecord::Migration
  def change
    add_column :reports, :collaboration, :integer, null: false, default: 0
  end
end
