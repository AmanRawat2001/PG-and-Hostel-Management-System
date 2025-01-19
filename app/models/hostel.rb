class Hostel < ApplicationRecord
  has_many :rooms, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :address, presence: true
  validates :phone, presence: true

  def as_json(options = {})
    super(options.merge(include: {rooms:{only: [:id, :room_number, :capacity] }}))
  end
end
