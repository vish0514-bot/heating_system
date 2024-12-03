class CreateThermostats < ActiveRecord::Migration[7.1]
  def change
    create_table :thermostats do |t|
      t.text :household_token
      t.text :location
      t.timestamps
    end
  end
end
