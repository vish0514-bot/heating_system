FactoryBot.define do
  factory :reading do
    temperature { 22.5 }
    humidity { 60 }
    battery_charge { 80 }
    thermostat
  end
end