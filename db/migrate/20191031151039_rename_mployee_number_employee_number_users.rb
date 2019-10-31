class RenameMployeeNumberEmployeeNumberUsers < ActiveRecord::Migration[5.1]
  def change
    rename_column :users, :mployee_number, :employee_number
  end
end
