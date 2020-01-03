class AddEndTimetoAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :endtime_at, :datetime
  end
end
