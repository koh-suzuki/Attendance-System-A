class AddConfirmToApprovals < ActiveRecord::Migration[5.1]
  def change
    add_column :approvals, :confirm, :integer, null: false, default: 0
  end
end
