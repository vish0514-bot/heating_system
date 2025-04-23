# Heating System API

This project is a backend API built with Ruby on Rails to collect and analyze data from IoT thermostats in apartments with centralized heating systems. The goal is to help maintain consistent temperatures across rooms with varying insulation properties.

## 🚀 Project Overview

In apartment complexes, temperature can vary between rooms due to differences in insulation. This system collects data from thermostats and provides real-time insights for temperature regulation.

### 📦 Models

**Thermostat**
- `id`
- `household_token` (text)
- `location` (string)

**Reading**
- `id`
- `thermostat_id` (foreign key)
- `number` (sequence number per household)
- `temperature` (float)
- `humidity` (float)
- `battery_charge` (float)

## 📡 API Endpoints

1. **POST /readings**  
   Stores temperature, humidity, and battery charge data.  
   - Authenticated via `household_token`.  
   - Returns a generated sequence number.  
   - Uses background job (Sidekiq) to write data to the DB for performance.

2. **GET /readings/:id**  
   Fetches a reading using `reading_id`.  
   - Returns data instantly, even if background job hasn't completed (ensures consistency).

3. **GET /stats**  
   Returns average, minimum, and maximum of:
   - `temperature`
   - `humidity`
   - `battery_charge`  
   - Fast (O(1)) access with real-time accuracy.

## ⚙️ Tools & Technologies

- Ruby on Rails
- Sidekiq for background processing
- PostgreSQL
- RSpec for testing
- Redis
- JSON API serialization
- Secure token-based authentication

## 🔒 Error Handling

- Returns structured JSON error responses for bad requests
- Appropriate HTTP status codes

## 🧪 Testing

Thoroughly tested with RSpec, covering:
- Request specs
- Model validations
- Background job logic
- Edge cases & invalid input

## 📍 Project Purpose

Built as a performance-focused API for a smart home solution. Designed to handle high request volume while remaining consistent and fast.

---

## 👤 Author

**Vishwa Shihora**  
Ruby on Rails Developer

---

## 📄 License

This project is open-source and available under the [MIT License](LICENSE).
