module AttendancesHelper
 
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
  def over_time(endtime, designated_work_end_time, day)
    if day.tommorow_index == true
      format("%.2f", (((Time.parse(endtime) - Time.parse(designated_work_end_time)) / 60) / 60.0) + 24)
    else
      format("%.2f", (((Time.parse(endtime) - Time.parse(designated_work_end_time)) / 60) / 60.0))
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
  
  
  def attendances_updated_invalid?
    attendances = true
    attendances_params.each do |id, item|
      if item[:name].present?
        if item[:updated_started_at].blank? && item[:updated_finished_at].blank?
          next
        elsif item[:updated_started_at].blank? || item[:updated_finished_at].blank?
          attendances = false
          break
        elsif item[:updated_started_at] > item[:updated_finished_at]
          attendances = false
          break
        end
        return attendances
      else
        attendances = false
        break
      end
    end
  end
  
  def users(notice_users)
    notice_users.each do |user|
      @u = user
      @attendance_notices = Attendance.where(user_id: user.id).where.not(endtime_at: nil).where(change: false)
      @attendance_notices.each do |att_notice|
        @att_notice = att_notice
      end
    end
  end

end
