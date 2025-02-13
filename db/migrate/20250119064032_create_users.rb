class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email, null: false, unique: true
      t.string :encrypted_password, null: false
      t.integer :role, default: 0, null: false
      
      t.timestamps
    end
    add_index :users, :email, unique: true
  end
end
