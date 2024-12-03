require 'rails_helper'

RSpec.describe ReadingsController, type: :controller do
  let(:thermostat) { create(:thermostat) }
  let(:reading) { create(:reading, thermostat: thermostat) }

  describe 'POST #create' do
    context 'when thermostat is found' do
      context 'when reading data is valid' do
        let(:valid_params) do
          { household_token: thermostat.household_token, reading: { temperature: 25.0, humidity: 70, battery_charge: 90 } }
        end

        it 'creates a new reading and returns status ok' do
          expect do
            post :create, params: valid_params
          end.to change { thermostat.readings.count }.by(1)

          expect(response).to have_http_status(:ok)
          expect(JSON.parse(response.body)['sequence_number']).to eq(thermostat.readings.count)
        end
      end

      context 'when reading data is missing or empty' do
        let(:invalid_params) { { household_token: thermostat.household_token, reading: {} } }

        it 'returns an error when reading data is missing' do
          post :create, params: invalid_params

          expect(response).to have_http_status(:unprocessable_entity)
          expect(JSON.parse(response.body)['error']).to eq('Reading data is missing or empty')
        end
      end
    end

    context 'when thermostat is not found' do
      let(:invalid_token_params) { { household_token: 'non_existing_token', reading: { temperature: 25.0, humidity: 70, battery_charge: 90 } } }

      it 'returns an error when thermostat is not found' do
        post :create, params: invalid_token_params

        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)['error']).to eq('Thermostat not found')
      end
    end
  end

  describe 'GET #show' do
    context 'when reading is found' do
      it 'returns the reading details' do
        get :show, params: { id: reading.id }

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['reading_id']).to eq(reading.id)
        expect(JSON.parse(response.body)['temperature']).to eq(reading.temperature)
      end
    end

    context 'when reading is not found' do
      it 'returns an error when reading is not found' do
        get :show, params: { id: 999999 }

        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)['error']).to eq('Reading not found')
      end
    end
  end

  describe 'GET #stat_data' do
    context 'when thermostat is found' do
      context 'when there are readings' do
        it 'returns statistics for the thermostat readings' do
          readings = create_list(:reading, 3, thermostat: thermostat)

          get :stat_data, params: { household_token: thermostat.household_token }

          expect(response).to have_http_status(:ok)
          stats = JSON.parse(response.body)
          expect(stats['average_temperature']).to be_present
          expect(stats['min_temperature']).to be_present
          expect(stats['max_temperature']).to be_present
          expect(stats['average_humidity']).to be_present
          expect(stats['min_humidity']).to be_present
          expect(stats['max_humidity']).to be_present
          expect(stats['average_battery_charge']).to be_present
          expect(stats['min_battery_charge']).to be_present
          expect(stats['max_battery_charge']).to be_present
        end
      end

      context 'when there are no readings' do
        it 'returns an error when no readings exist for the thermostat' do
          get :stat_data, params: { household_token: thermostat.household_token }

          expect(response).to have_http_status(:not_found)
          expect(JSON.parse(response.body)['error']).to eq('No readings found for this thermostat')
        end
      end
    end

    context 'when thermostat is not found' do
      it 'returns an error when thermostat is missing or empty' do
        get :stat_data, params: { household_token: 'non_existing_token' }

        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)['error']).to eq('household_token is missing or empty')
      end
    end
  end
end