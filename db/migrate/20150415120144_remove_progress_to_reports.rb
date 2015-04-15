class RemoveProgressToReports < ActiveRecord::Migration
  def change
    remove_column :reports, :progress, :string
  end
end
