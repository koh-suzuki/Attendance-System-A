class AddConfirmToApprovals < ActiveRecord::Migration[5.1]
  def change
    add_column :approvals, :confirm, :integer, default: 0
  end
end
