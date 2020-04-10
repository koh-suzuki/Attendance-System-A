module AttendancesHelper
 
  def attendance_state(attendance)
    if Date.current == attendance.worked_on
      return "出社" if attendance.started_at.nil?
      return "退社" if attendance.started_at.present? && attendance.finished_at.nil?
    end
    false
  end
  
  def working_time(start, finish, day)
    if day.tommorow_index == true
      format("%.2f", (((finish - start) / 60) / 60.0) + 24)
    else
      format("%.2f", (((finish - start) / 60) / 60.0))
    end
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
  
  # 勤怠編集のバリデーション
  def attendances_updated_invalid?
      attendances = true
      attendances_params.each do |id, item|
        if item[:updated_started_at].blank? && item[:updated_finished_at].blank?
          next
        elsif item[:updated_started_at].blank? || item[:updated_finished_at].blank?
          attendances = false
          break
        elsif item[:tommorow_index] == "false" && item[:updated_started_at] > item[:updated_finished_at]
          attendances = false
          break
        end
      end
      return attendances
  end
  
  # ###
  
  def overtime_params_updated_invalid?
    if @attendance.updated_finished_at.present? || @attendance.finished_at.present?
      if (params[:attendance]["endtime_at(4i)"].to_i > @worktime.hour) ||
          params[:attendance][:tommorow_index] == "true"
        return true
      else
        return false
      end
    else
     return false
    end
  end

  # 残業申請のお知らせモーダルの更新バリデーション
  def overtime_notice_updated_invalid?
    items = []
    notice_overtime_params.each do |id, item|
      # attendance = Attendance.find(id)
      items << item[:overtime_check]
    end
    if  items.all?{|i| i == "false"}
      return false
    else
      return true
    end
  end

  # 勤怠変更申請のお知らせモーダルの更新バリデーション
  def change_attendance_updated_invalid?
    items = []
    change_attendance_params.each do |id, item|
    # attendance = Attendance.find(id)
      items << item[:attendance_change_check]
    end
    if  items.all?{|i| i == "false"}
      return false
    else
      return true
    end
  end

  def users(notice_users)
    notice_users.each do |user|
      @notice_overtimes = Attendance.where(user_id: user.id).where.not(endtime_at: nil).where(overtime_check: false)
      @notice_overtimes.each do |att_notice|
        @att_notice = att_notice
      end
    end
  end
end
