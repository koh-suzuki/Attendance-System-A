class AddChangeToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :overtime_check, :boolean, null: false, default: false
    add_column :attendances, :attendance_change_check, :boolean, null: false, default: false
  end
end
