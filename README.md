# SIAC-IoT Platform

## Project Overview

SIAC-IoT is a modular IoT security and monitoring platform integrating:
- Suricata IDS for network intrusion detection
- InfluxDB for time-series data storage
- Node-RED for event processing
- FastAPI backend for ML anomaly detection and REST API
- React frontend for dashboards and alert management
- ESP32 and sensor integration for real-world telemetry

## Current Status (December 2025)

### ✅ Features Implemented
- Suricata IDS alerts (10,000+ events) with full field display and pagination
- ML anomaly detection (IsolationForest) with 30+ test alerts, realistic device scenarios
- ML-powered recommendations: context-aware, multi-path, safety/security actions
- Alert recommendations shown in modal dialogs (not toasts) for better UX
- Pagination for both ML alerts and recommendations (3 items per page)
- Device metadata and location displayed in recommendations
- Backend queries fixed (manual aggregation, no pivot errors)
- Frontend UI: modern, color-coded, responsive
- ESP32 MQTT integration ready for deployment

### ⚠️ In Progress / Known Issues
- MQTT client initialization error (connection reset by peer)
- Some alerts may have similar recommendations if reasons are generic
- Hardware integration (ESP32) pending final field test
- Further ML model tuning possible for more granular recommendations

### 🛠️ How to Run
1. `docker-compose up` (all services: backend, frontend, InfluxDB, Suricata, Node-RED)
2. Generate ML alerts: `docker exec siac-backend python generate_ml_alerts.py -c 20`
3. Access dashboard: [http://localhost:5173](http://localhost:5173)
4. Backend API: [http://localhost:18000/docs](http://localhost:18000/docs)

### 📁 Key Directories
- `web-application/backend/app/` — FastAPI, ML, InfluxDB service
- `web-application/frontend/src/pages/` — React dashboards, modals
- `iot-security/` — Suricata, Node-RED, InfluxDB config
- `infra/` — Grafana, Mosquitto, Postgres, Suricata rules

### 👨‍💻 Contributors
- Tanjona (Lead Developer)
- GitHub Copilot (AI Assistant)

## Project Structure

```
project-root/
├── README.md
├── integration/
│   └── docker-compose.full.yml, env/
├── iot-security/
│   ├── docker-compose.iot.yml
│   ├── esp32/code_esp32/
│   ├── grafana/
│   ├── influxdb/
│   ├── mosquitto/
│   ├── nodered/
│   └── suricata/
├── web-application/
│   ├── dataset.csv
│   ├── DEPLOY.md
│   ├── docker-compose.*.yml
│   ├── generate_dataset.py
│   ├── backend/
│   │   ├── Dockerfile, requirements.txt
│   │   └── app/
│   │       ├── database.py, feature_engineering.py, influxdb_data_service.py, influxdb_service.py, main.py, ml_service.py, models.py
│   ├── frontend/
│   │   ├── Dockerfile, index.html, nginx.conf, package.json
│   │   └── src/
│   │       ├── App.jsx, main.jsx, styles.css
│   │       ├── components/
│   │       ├── contexts/
│   │       ├── lib/
│   │       └── pages/
│   └── infra/
│       ├── grafana/
│       ├── mosquitto/
│       ├── postgres/
│       └── suricata/
```

## Getting Started

### Prerequisites

- Docker & Docker Compose installed
- (Optional) ESP32 device for real telemetry

### Quick Start

```sh
# 1. Clone the repository
# 2. Navigate to the main project directory
cd project-root/web-application

# 3. Start all services (backend, frontend, InfluxDB, Suricata, Node-RED)
docker-compose up

# 4. Generate ML alerts for demo/testing
# (in another terminal)
docker exec siac-backend python generate_ml_alerts.py -c 20
```

### Access the Platform
- **Frontend Dashboard:** [http://localhost:5173](http://localhost:5173)
- **Backend API Docs:** [http://localhost:18000/docs](http://localhost:18000/docs)
- **Grafana:** [http://localhost:3000](http://localhost:3000)
- **Node-RED:** [http://localhost:1880](http://localhost:1880)

---

## Demo Guide

### 1. Simulate ML Alerts
- Run: `docker exec siac-backend python generate_ml_alerts.py -c 10`
- This will create 10 diverse ML anomaly alerts in InfluxDB

### 2. Explore the Dashboard
- Open [http://localhost:5173](http://localhost:5173)
- Go to the **Alerts** page to view ML alerts
- Click **Analyser** on any alert to open the modal with AI-powered recommendations
- Use pagination to browse alerts and recommendations (3 per page)

### 3. View Recommendations
- Recommendations are context-aware, based on the type of anomaly (temperature, network, humidity, ML behavior)
- Modal displays priority, urgency, root cause analysis, and actionable steps

### 4. Test Suricata IDS Alerts
- Suricata network alerts are shown on the **IDS Alerts** page
- Includes full details, device info, and pagination

### 5. Advanced
- Access API docs at [http://localhost:18000/docs](http://localhost:18000/docs)
- View time-series data in Grafana ([http://localhost:3000](http://localhost:3000))
- Edit Suricata rules in `infra/suricata/rules/siac-iot.rules`
- Integrate real ESP32 devices via MQTT (see `iot-security/esp32/code_esp32/`)

---
For troubleshooting, see the Troubleshooting section above or check container logs with `docker logs siac-backend --tail 50`.

## Usage Guide

### 1. Prerequisites
- Docker & Docker Compose installed
- (Optional) ESP32 device for real telemetry

### 2. Quick Start
```sh
# Start all services
cd project-root/web-application
# Launch backend, frontend, InfluxDB, Suricata, Node-RED
# (edit docker-compose.full.yml for full stack)
docker-compose up

# Generate ML alerts for testing
# (in another terminal)
docker exec siac-backend python generate_ml_alerts.py -c 20
```

### 3. Accessing the Platform
- **Frontend Dashboard:** [http://localhost:5173](http://localhost:5173)
- **Backend API Docs:** [http://localhost:18000/docs](http://localhost:18000/docs)
- **Grafana:** [http://localhost:3000](http://localhost:3000)
- **Node-RED:** [http://localhost:1880](http://localhost:1880)

### 4. Main Features
- **IDS Alerts:** Suricata network events, paginated, with full details
- **ML Alerts:** Anomaly detection, recommendations modal, pagination
- **Recommendations:** Context-aware, safety/security actions, modal display
- **Device Management:** Metadata, location, and type shown in UI
- **ESP32 Integration:** MQTT telemetry, real device support

### 5. Development
- **Backend:** FastAPI, Python, InfluxDB client
- **Frontend:** React, Vite, Tailwind CSS
- **ML:** IsolationForest, feature engineering
- **Infrastructure:** Docker Compose, Grafana, Mosquitto, Node-RED

### 6. Troubleshooting
- If backend API fails, check container logs: `docker logs siac-backend --tail 50`
- For MQTT issues, verify broker config in `iot-security/mosquitto/config/mosquitto.conf`
- For Suricata rules, edit `infra/suricata/rules/siac-iot.rules`

---
For more details, see documentation in each subfolder and API docs.

## Architecture Overview

SIAC-IoT is composed of several microservices and infrastructure components:

- **Suricata IDS**: Monitors network traffic, generates security alerts (EVE JSON format)
- **Node-RED**: Processes Suricata alerts, formats and forwards to InfluxDB
- **InfluxDB**: Stores all time-series data (telemetry, alerts, ML anomalies)
- **FastAPI Backend**: Provides REST API, ML anomaly detection, recommendations, and data aggregation
- **React Frontend**: User dashboard for alerts, recommendations, device status, and analytics
- **Grafana**: Visualization of time-series data and security events
- **Mosquitto MQTT Broker**: Handles telemetry from ESP32 and other IoT devices
- **ESP32 Devices**: Send real sensor data (temperature, humidity, etc.) via MQTT

## Service Details

### Backend (FastAPI)
- Location: `web-application/backend/app/`
- Main entry: `main.py`
- ML: IsolationForest (scikit-learn), feature engineering in `feature_engineering.py`
- Endpoints:
  - `/api/v1/alerts/recent` — Get recent ML alerts
  - `/api/v1/alerts/recommendations` — Get ML-powered recommendations
  - `/api/v1/ml/train` — Train ML model
  - `/api/v1/ml/status` — ML model status
  - `/api/v1/suricata/logs` — Suricata IDS logs
- Environment variables:
  - `INFLUXDB_URL`, `INFLUXDB_TOKEN`, `INFLUXDB_ORG`, `INFLUXDB_BUCKET`

### Frontend (React)
- Location: `web-application/frontend/src/`
- Main entry: `App.jsx`, `main.jsx`
- Pages:
  - `Alerts.jsx` — ML alerts, recommendations modal, pagination
  - `IDSAlerts.jsx` — Suricata IDS alerts, pagination
  - `Devices.jsx`, `Dashboard.jsx`, etc.
- UI: Tailwind CSS, react-hot-toast (for notifications), custom modal dialogs

### Suricata IDS
- Location: `iot-security/suricata/`
- Config: `infra/suricata/rules/siac-iot.rules`
- Output: EVE JSON alerts, processed by Node-RED

### Node-RED
- Location: `iot-security/nodered/`
- Flows: `flows.json`, `flows_cred.json`
- Custom logic for parsing Suricata alerts and writing to InfluxDB

### InfluxDB
- Location: `iot-security/influxdb/`
- Config: `config/influx-configs`
- Data:
  - `suricata_alerts` measurement: IDS events
  - `alerts` measurement: ML anomaly alerts

### Grafana
- Location: `infra/grafana/`
- Dashboards: `provisioning/dashboards/dashboard.yml`
- Datasources: `provisioning/datasources/influxdb.yml`

### Mosquitto MQTT
- Location: `infra/mosquitto/`
- Config: `config/mosquitto.conf`, TLS certs in `certs/`
- Used for ESP32 telemetry ingestion

### ESP32 Integration
- Code: `iot-security/esp32/code_esp32/code_esp32.ino`
- Sensors: DHT22, ultrasonic, servo
- MQTT topics: `iot/telemetry/{device_id}`
- TLS support: Certificates in `iot-security/mosquitto/certs/`
- Data sent: temperature, humidity, distance, etc.

## Data Flow

1. **Telemetry**: ESP32 devices → Mosquitto MQTT → Node-RED → InfluxDB
2. **IDS Alerts**: Suricata → Node-RED → InfluxDB
3. **ML Alerts**: Backend queries InfluxDB, runs anomaly detection, stores results in `alerts` measurement
4. **Recommendations**: Backend analyzes ML alerts, generates context-aware recommendations
5. **Frontend**: Fetches alerts, recommendations, device info via REST API
6. **Visualization**: Grafana dashboards for time-series analytics

## ML System
- Model: IsolationForest (unsupervised anomaly detection)
- Training: Simulated normal data, retrain via `/api/v1/ml/train`
- Features: temperature, humidity, tx_bytes, rx_bytes, connections
- Alert generation: `generate_ml_alerts.py` script for test/demo data
- Recommendations: Multi-path, context-aware, based on alert reason and severity

## Environment Variables
- Set in Docker Compose or `.env` files
- Example:
  - `INFLUXDB_URL=http://influxdb:8086`
  - `INFLUXDB_TOKEN=siac-token`
  - `INFLUXDB_ORG=siac`
  - `INFLUXDB_BUCKET=bucket_iot`

## Troubleshooting
- Backend API not responding: `docker logs siac-backend --tail 50`
- InfluxDB issues: Check `iot-security/influxdb/config/influx-configs`
- MQTT connection errors: Verify `infra/mosquitto/config/mosquitto.conf` and TLS certs
- Suricata rules: Edit `infra/suricata/rules/siac-iot.rules`
- Node-RED flows: Check `iot-security/nodered/flows.json`
- ML alerts not showing: Ensure backend is running and ML model is trained

## Demo Walkthrough

1. **Start all services**: `docker-compose up`
2. **Generate ML alerts**: `docker exec siac-backend python generate_ml_alerts.py -c 20`
3. **Open dashboard**: [http://localhost:5173](http://localhost:5173)
4. **View ML alerts**: Go to Alerts page, use pagination
5. **Open recommendations**: Click Analyser on any alert for modal with AI actions
6. **Test IDS alerts**: Go to IDS Alerts page for Suricata events
7. **View Grafana analytics**: [http://localhost:3000](http://localhost:3000)
8. **API docs**: [http://localhost:18000/docs](http://localhost:18000/docs)
9. **Integrate ESP32**: Flash code, connect to WiFi, verify MQTT telemetry in dashboard

---
For further details, see documentation in each subfolder and API docs. Contributions and feedback welcome!
