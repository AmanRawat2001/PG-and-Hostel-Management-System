class Booking < ApplicationRecord
  belongs_to :room
  belongs_to :user

  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :user_id, presence: true
  validates :room_id, presence: true
  
  
  validate :start_date_and_end_date_check
  before_create :set_status
  after_save :update_room_status
  after_update :update_room_status, if: :saved_change_to_status?
  
  enum status: { pending: 1, approved: 2, rejected: 3 }

  def start_date_and_end_date_check
    if start_date.present? && start_date < Date.today
      errors.add(:start_date, "can't be in the past")
    end
    if end_date.present? && end_date < Date.today
      errors.add(:end_date, "can't be in the past")
    end
    if start_date.present? && end_date.present? && start_date > end_date
      errors.add(:end_date, "can't be before the start date")
    end
  end

  def set_status
    self.status = :pending
  end

  def update_room_status
    capacity = room.capacity
    booking_counts = room.bookings.where(status: [:approved, :pending]).count
    if booking_counts >= capacity
      room.update(is_occupied: true)
    else
      room.update(is_occupied: false)
    end
  end
end
