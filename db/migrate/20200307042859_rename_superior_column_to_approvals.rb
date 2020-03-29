class RenameSuperiorColumnToApprovals < ActiveRecord::Migration[5.1]
  def change
    rename_column :approvals, :superior, :superior_id
  end
end
