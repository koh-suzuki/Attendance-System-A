class Approval < ApplicationRecord
  belongs_to :user
  
  enum confirm: { "申請中" => 1, "承認" => 2, "否認" => 3 }
end
