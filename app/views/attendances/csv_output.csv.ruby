require 'csv'
CSV.generate do |csv|
  csv_column_names = ["日付","出社時間","退社時間"]
  csv << csv_column_names
  @attendance.each do |product|
    csv_column_values = [
      product.worked_on.strftime("%m/%d"),
      product.updated_started_at.present? && product.confirm == "承認" ? product.updated_started_at.strftime("%I:%M") : nil,
      product.updated_finished_at.present? && product.confirm == "承認" ? product.updated_finished_at.strftime("%I:%M") : nil
    ]
    csv << csv_column_values
  end
end