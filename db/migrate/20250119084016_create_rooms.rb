class CreateRooms < ActiveRecord::Migration[7.1]
  def change
    create_table :rooms do |t|
      t.references :hostel, null: false, foreign_key: true
      t.string :room_number, null: false
      t.integer :capacity, null: false
      t.boolean :is_occupied, default: false
      t.timestamps
    end
  end
end
