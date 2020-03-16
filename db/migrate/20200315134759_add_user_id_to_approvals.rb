class AddUserIdToApprovals < ActiveRecord::Migration[5.1]
  def change
    add_column :approvals, :month_at, :date
    add_column :approvals, :approval_flag, :boolean
    add_reference :approvals, :user, foreign_key: true
  end
end
