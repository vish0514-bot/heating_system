class Reading < ApplicationRecord
  belongs_to :thermostat

  after_create :increment_number

  private

  def increment_number
    self.update_column(:number, thermostat.readings.count)
  end
end
