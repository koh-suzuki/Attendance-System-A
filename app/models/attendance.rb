class Attendance < ApplicationRecord
  belongs_to :user
  require 'csv'
  
  validates :worked_on, presence: true
  validates :note, length: { maximum: 50 }
  
  # 出勤時間が存在しない場合、退勤時間は無効
  validate :finished_at_is_invalid_without_a_started_at
  validate :started_at_than_finished_at_fast_if_invalid
  # validate :updated_finished_at_is_invalid_without_a_updated_started_at
  # # validate :updated_finished_at_or_updated_started_at_invalid
  # validate :updated_started_at_than_updated_finished_at_fast_if_invalid
  validate :name_invalid

  def finished_at_is_invalid_without_a_started_at
    errors.add(:started_at, "が必要です") if started_at.blank? && finished_at.present?
  end
  
  def started_at_than_finished_at_fast_if_invalid
    if started_at.present? && finished_at.present?
      errors.add(:started_at, "より早い退勤時間は無効です") if started_at > finished_at
    end
  end
  
  # def updated_finished_at_is_invalid_without_a_updated_started_at
  #   errors.add(:updated_started_at, "が必要です") if updated_started_at.blank? && updated_finished_at.present?
  # end

  # # def updated_finished_at_or_updated_started_at_invalid
  # #   errors.add(:updated_started_at, "が必要です") if updated_started_at.blank? || updated_finished_at.blank?
  # # end

  # def updated_started_at_than_updated_finished_at_fast_if_invalid
  #   if updated_started_at.present? && updated_finished_at.present?
  #     errors.add(:updated_started_at, "より早い退勤時間は無効です") if updated_started_at > updated_finished_at
  #   end
  # end
  
  def name_invalid
    # errors.add(:name, "が必要です") if name.blank? && (updated_started_at.present? || updated_finished_at.present?)
  end
  
  enum confirm: { "申請中" => 1, "承認" => 2, "否認" => 3 }

end
