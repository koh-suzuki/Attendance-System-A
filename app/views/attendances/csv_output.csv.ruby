require 'csv'
CSV.generate do |csv|
  csv_column_names = ["worked_on","started_at","finished_at"]
  csv << csv_column_names
  @attendance.each do |product|
    csv_column_values = [
      product.worked_on,
      product.started_at,
      product.finished_at,
    ]
    csv << csv_column_values
  end
end