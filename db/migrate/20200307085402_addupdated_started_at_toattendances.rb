class AddupdatedStartedAtToattendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :updated_started_at, :datetime
    add_column :attendances, :updated_finished_at, :datetime
  end
end
