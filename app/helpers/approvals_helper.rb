module ApprovalsHelper
  # 1ヶ月分の勤怠申請のお知らせモーダル更新バリデーション
  def approval_invalid?
    items = []
    approval_params.each do |id, item|
      items << item[:approval_flag]
    end
    if items.all?{|i| i == "false"}
      return false
    else
      return true
    end
  end
end
