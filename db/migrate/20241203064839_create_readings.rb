class CreateReadings < ActiveRecord::Migration[7.1]
  def change
    create_table :readings do |t|
      t.belongs_to :thermostat, index: true, foreign_key: true
      t.integer :number
      t.float :temperature
      t.float :humidity
      t.float :battery_charge
      t.timestamps
    end
  end
end
