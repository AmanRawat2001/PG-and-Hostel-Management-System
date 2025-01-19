class CreateHostels < ActiveRecord::Migration[7.1]
  def change
    create_table :hostels do |t|
      t.string :name, null: false
      t.string :address , null: false
      t.string :phone, null: false
  
      t.timestamps
    end
  end
end
