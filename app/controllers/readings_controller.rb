class ReadingsController < ApplicationController

  def create
    thermostat = Thermostat.find_by(household_token: params[:household_token])

    if thermostat
      reading_params = params[:reading].present? ? params.require(:reading).permit(:temperature, :humidity, :battery_charge) : {}
        return render json: { error: 'Reading data is missing or empty' }, status: :unprocessable_entity if reading_params.blank?

        ReadingDataJob.perform_now(reading_params.merge(household_token: thermostat.household_token))
        render json: { sequence_number: thermostat.readings.count }, status: :ok
    else
      render json: { error: 'Thermostat not found' }, status: :not_found
    end
  end

  def show
    reading = Reading.find_by(id: params[:id])
    if reading
      render json: {
        reading_id: reading.id,
        temperature: reading.temperature,
        humidity: reading.humidity,
        battery_charge: reading.battery_charge,
      }, status: :ok
    else
      render json: { error: "Reading not found" }, status: :not_found
    end
  end

  def stat_data
    thermostat = Thermostat.find_by(household_token: params[:household_token])
    return render json: { error: 'household_token is missing or empty' }, status: :unauthorized if thermostat.blank?

      readings = thermostat.readings
     if readings.any?
        stats = {
          average_temperature: readings.average(:temperature),
          min_temperature: readings.minimum(:temperature),
          max_temperature: readings.maximum(:temperature),
          average_humidity: readings.average(:humidity),
          min_humidity: readings.minimum(:humidity),
          max_humidity: readings.maximum(:humidity),
          average_battery_charge: readings.average(:battery_charge),
          min_battery_charge: readings.minimum(:battery_charge),
          max_battery_charge: readings.maximum(:battery_charge)
        }

        render json: stats, status: :ok
      else
        render json: { error: "No readings found for this thermostat" }, status: :not_found
      end
  end
end
