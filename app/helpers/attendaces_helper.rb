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
  
  # 時間外時間の計算
  def work_end_time(attendance)
    if attendance.tommorow_index == true
      format("%.2f", (((attendance.endtime_at - attendance.finished_at) / 60) / 60.0) + 24)
    else
      format("%.2f", (((attendance.endtime_at - attendance.finished_at) / 60) / 60.0))
    end
  end
  
  def css_class(wo)
    case $days_of_the_week[wo.wday]
    when '土'
      'text-primary'
    when '日'
      'text-danger'
    end
  end
  
   # 不正な値があるか確認する
  def attendances_invalid?
    attendances = true
    attendances_params.each do |id, item|
      if item[:started_at].blank? && item[:finished_at].blank?
        next
      elsif item[:started_at].blank? || item[:finished_at].blank?
        attendances = false
        break
      elsif item[:started_at] > item[:finished_at]
        attendances = false
        break
      end
    end
    return attendances
  end
end
