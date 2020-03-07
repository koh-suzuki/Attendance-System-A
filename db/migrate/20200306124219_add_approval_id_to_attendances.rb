class AddApprovalIdToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :approval_id, :integer
  end
end
