module UsersHelper
  def format_basic_info(time)
    format("%.2f", ((time.hour * 60) + time.min)/60.0)
  end
  
  # 時間外時間の計算
  def over_time(endtime, designated_work_end_time, day)
    if day.tommorow_index == true
      format("%.2f", (((Time.parse(endtime) - Time.parse(designated_work_end_time)) / 60) / 60.0) + 24)
    else
      format("%.2f", (((Time.parse(endtime) - Time.parse(designated_work_end_time)) / 60) / 60.0))
    end
  end
end
