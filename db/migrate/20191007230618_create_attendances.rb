class CreateAttendances < ActiveRecord::Migration[5.1]
  def change
    create_table :attendances do |t|
      t.date :worked_on
      t.datetime :started_on
      t.datetime :finished_on
      t.string :note
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
