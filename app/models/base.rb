class Base < ApplicationRecord
  # 数字が0以上であるか
  validates :base_number, :numericality => { :greater_than_or_equal_to => 0 }  
  validates :base_name, presence: true
end
