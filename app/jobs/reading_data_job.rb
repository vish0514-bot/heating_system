class ReadingDataJob < ApplicationJob
  queue_as :default

  def perform(reading_params)
    thermostat = Thermostat.find_by(household_token: reading_params[:household_token])
    if thermostat
      reading = thermostat.readings.create!(
        temperature: reading_params[:temperature],
        humidity: reading_params[:humidity],
        battery_charge: reading_params[:battery_charge],
      )
    else
      raise "Thermostat not found for household_token"
    end
  end
end
