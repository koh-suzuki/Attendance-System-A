module AttendacesHelper
 
  def attendance_state(attendance)
    if Date.current == attendance.worked_on
      return "出社" if attendance.started_at.nil?
      return "退社" if attendance.started_at.present? && attendance.finished_at.nil?
    end
    false
  end
  
  def working_time(start, finish)
    format("%.2f", (((finish - start) / 60) / 60.0))
  end
  
  def css_class(wo)
    case $days_of_the_week[wo.wday]
    when '土'
      'text-primary'
    when '日'
      'text-danger'
    end
  end
end
