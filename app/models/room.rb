class Room < ApplicationRecord
  belongs_to :hostel
  has_many :bookings, dependent: :destroy

  validates :room_number, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :capacity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validate :check_room_number

  scope :available, -> { where(is_occupied: false) }

  def as_json(options = {})
    super(options.merge(include: { hostel: { only: [:id, :name, :address, :phone] } }))
  end

  def check_room_number
    if room_number_changed? && Room.where(room_number: room_number, hostel_id: hostel_id).where.not(id: id).exists?
      errors.add(:room_number, "already exists in this hostel")
    end
  end
end
