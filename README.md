# SIAC-IoT Platform

## Project Overview

SIAC-IoT is a comprehensive IoT security and monitoring platform that combines network intrusion detection, machine learning-based anomaly detection, and real-time sensor monitoring. The platform provides:

- **Network Security**: Suricata IDS for real-time intrusion detection
- **Data Storage**: InfluxDB time-series database for efficient data management
- **Event Processing**: Node-RED for automated alert processing and routing
- **ML Intelligence**: FastAPI backend with IsolationForest anomaly detection
- **Modern Dashboard**: React frontend with real-time monitoring and analytics
- **IoT Integration**: ESP32 sensor devices with MQTT telemetry
- **Visualization**: Grafana dashboards for comprehensive data analysis

## Current Status (December 11, 2025)

### ✅ Production Ready Features
- **ESP32 Integration**: Full end-to-end telemetry pipeline (ESP32 → MQTT → Backend → InfluxDB → Frontend)
- **Real-time Monitoring**: Auto-refresh dashboard updates every 5 seconds
- **Suricata IDS**: 10,000+ network alerts with full field display and pagination
- **ML Anomaly Detection**: IsolationForest model with 30+ test scenarios
- **Smart Recommendations**: Context-aware, multi-path security actions with modal dialogs
- **IoT Dashboard**: Live sensor data display with temperature, humidity, distance metrics
- **Sensor Trends**: Interactive charts with Recharts showing historical sensor data
- **Device Management**: Comprehensive metadata, location, and status tracking
- **MQTT Support**: Non-TLS and TLS-enabled broker configurations
- **Modern UI**: Responsive design with Tailwind CSS, color-coded alerts, French localization

### 🔧 Technical Improvements
- Fixed MQTT TLS configuration (respects `MQTT_TLS_ENABLED` environment variable)
- Corrected ESP32 JSON payload format (`sensors` and `net` structure)
- Fixed InfluxDB query pivot aggregation for multi-field time-series data
- Resolved frontend data access patterns (nested sensors/net objects)
- Enhanced chart visibility (3px strokes, 5px dots, auto-scaling axes)
- Removed WebSocket event loop conflicts for stable MQTT processing
- Added comprehensive console debugging with emoji markers
- Cleaned up duplicate sensor displays

### 🛠️ Quick Start

```sh
# 1. Navigate to the web application directory
cd project-root/web-application

# 2. Start all services (backend, frontend, InfluxDB, Postgres)
docker-compose up -d

# 3. Optionally start IoT security stack (Mosquitto, Node-RED, Suricata, Grafana)
cd ../iot-security
docker-compose -f docker-compose.iot.yml up -d

# 4. Generate test ML alerts (optional)
docker exec siac-backend python generate_ml_alerts.py -c 20

# 5. Access the dashboard
# Frontend: http://localhost:5173
# Backend API: http://localhost:18000/docs
# Grafana: http://localhost:3000
```

### 📡 ESP32 Setup

```arduino
// Configure in code_esp32.ino:
const char* ssid = "YOUR_WIFI_SSID";
const char* password = "YOUR_WIFI_PASSWORD";
const char* mqtt_server = "YOUR_BACKEND_IP";
const int mqtt_port = 11883;  // Non-TLS MQTT port

// Upload to ESP32:
// 1. Open Arduino IDE
// 2. Load iot-security/esp32/code_esp32/code_esp32.ino
// 3. Install libraries: WiFi, PubSubClient, DHT
// 4. Select board: ESP32 Dev Module
// 5. Upload and monitor serial output
```

### 📁 Key Directories

- `web-application/backend/app/` — FastAPI, ML, InfluxDB service
- `web-application/frontend/src/pages/` — React dashboards, modals
- `iot-security/` — Mosquitto, Node-RED, Suricata, InfluxDB, Grafana
- `integration/` — Full stack docker-compose configuration

### 👨‍💻 Contributors

RANDRIAMBOLOLONA Manitriniaina Louis Josilde
ANDRIATSITOHAINA Faly Jean Antonio Downavan
---

## Project Structure

```text
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
- (Optional) ESP32 device with DHT22 sensor and HC-SR04 ultrasonic sensor
- (Optional) Arduino IDE for ESP32 programming

### Quick Start

```sh
# 1. Navigate to web application directory
cd project-root/web-application

# 2. Start all services
docker-compose up -d

# 3. Generate test ML alerts (optional)
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

### 5. IoT Monitoring

- Navigate to **Monitoring IoT** page
- View real-time ESP32 sensor data (temperature, humidity, distance)
- Check sensor trend charts with auto-refresh every 5 seconds
- Monitor device status, network traffic, and LED indicators

### 6. Advanced Features

- Access API docs at [http://localhost:18000/docs](http://localhost:18000/docs)
- View time-series data in Grafana ([http://localhost:3000](http://localhost:3000))
- Edit Suricata rules in `infra/suricata/rules/siac-iot.rules`
- Integrate real ESP32 devices via MQTT (see ESP32 Setup section above)

---

## Key Features

- **Real-time IoT Monitoring**: Live sensor data with auto-refresh every 5 seconds, interactive trend charts
- **IDS Alerts**: Suricata network events with full details, pagination, and device tracking
- **ML Anomaly Detection**: IsolationForest-based detection with confidence scores
- **Smart Recommendations**: Context-aware security actions with priority levels and root cause analysis
- **Device Management**: Comprehensive metadata, location tracking, and status monitoring
- **ESP32 Integration**: Full MQTT telemetry pipeline with TLS and non-TLS support
- **Modern Dashboard**: Responsive React UI with Tailwind CSS, French localization
- **Data Visualization**: Grafana dashboards and Recharts for time-series analysis

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

- Location: `infra/mosquitto/` and `iot-security/mosquitto/`
- Config: `config/mosquitto.conf`, TLS certs in `certs/`
- Ports: 11883 (non-TLS), 18883 (TLS)
- Used for ESP32 telemetry ingestion

### ESP32 Integration

- Code: `iot-security/esp32/code_esp32/code_esp32.ino`
- Sensors: DHT22 (temperature/humidity), HC-SR04 (ultrasonic distance)
- MQTT Topic: `devices/{device_id}/telemetry` (e.g., `devices/ESP32-001/telemetry`)
- Payload Format:
```json
{
  "sensors": {
    "temperature": 28.2,
    "humidity": 99.9,
    "distance": 1204,
    "motion": false
  },
  "net": {
    "tx_bytes": 0,
    "rx_bytes": 0,
    "connections": 0
  }
}
```
- Configuration: WiFi SSID/password, MQTT broker IP, port (11883 for non-TLS)
- Publishing interval: Every 5 seconds

## Data Flow

1. **ESP32 Telemetry**: ESP32 → Mosquitto MQTT (port 11883) → Backend MQTT Client → InfluxDB `telemetry` measurement
2. **ML Anomaly Detection**: Backend processes telemetry → IsolationForest model → Stores anomalies in InfluxDB `alerts` measurement
3. **Suricata IDS**: Network traffic → Suricata EVE JSON → Node-RED → InfluxDB `suricata_alerts` measurement
4. **Smart Recommendations**: Backend analyzes anomalies → Context-aware recommendations with priority and actions
5. **Frontend Dashboard**: REST API → Fetches telemetry, alerts, recommendations → Auto-refresh every 5 seconds
6. **Visualization**: Recharts (frontend trends) + Grafana (time-series analytics)

### Real-time Pipeline

```
ESP32 (5s interval) 
  ↓ MQTT publish (devices/ESP32-001/telemetry)
Mosquitto Broker (11883)
  ↓ MQTT subscribe (devices/+/telemetry)
Backend MQTT Client
  ↓ process_telemetry() 
  ├→ Save to InfluxDB (telemetry measurement)
  ├→ ML anomaly detection (IsolationForest)
  └→ Generate recommendations (if anomaly)
      ↓
InfluxDB Storage
  ↓ REST API (/api/v1/telemetry/recent)
React Frontend
  ↓ Auto-refresh (5s)
User Dashboard (IoT Monitoring page)
```

## ML System

- **Model**: IsolationForest (scikit-learn, unsupervised anomaly detection)
- **Training**: Simulated normal data, retrain via `/api/v1/ml/train` endpoint
- **Features**: `temperature`, `humidity`, `distance`, `tx_bytes`, `rx_bytes`, `connections`
- **Detection**: Real-time scoring on each telemetry message, anomaly score > 0.5 triggers alert
- **Recommendations Engine**: Context-aware analysis based on:
  - Alert reason (temperature spike, network anomaly, humidity, etc.)
  - Severity level (low, medium, high, critical)
  - Device metadata (type, location)
  - Multi-path actions (immediate, short-term, long-term)
- **Testing**: `generate_ml_alerts.py` script creates diverse test scenarios

## Environment Variables

Backend configuration (set in `docker-compose.yml` or `.env`):

```env
# InfluxDB
INFLUXDB_URL=http://influxdb:8086
INFLUXDB_TOKEN=siac-token
INFLUXDB_ORG=siac
INFLUXDB_BUCKET=bucket_iot

# MQTT
MQTT_BROKER=mosquitto_secure
MQTT_PORT=11883
MQTT_TLS_ENABLED=false
MQTT_CA_CERT=/app/certs/ca.crt

# Database
DATABASE_URL=postgresql://user:password@postgres:5432/siac_iot
```

## Troubleshooting

### Common Issues

**Backend API not responding:**
```sh
docker logs siac-backend --tail 50
docker-compose restart backend
```

**MQTT connection errors:**
- Check `MQTT_TLS_ENABLED` environment variable matches broker configuration
- Verify broker is running: `docker ps | grep mosquitto`
- Check mosquitto logs: `docker logs mosquitto_secure --tail 50`
- For non-TLS: Use port 11883, set `MQTT_TLS_ENABLED=false`
- For TLS: Use port 18883, set `MQTT_TLS_ENABLED=true`, ensure certs exist

**ESP32 not sending data:**
- Check serial monitor for WiFi connection status
- Verify MQTT broker IP address in `code_esp32.ino`
- Ensure port is 11883 for non-TLS
- Check backend logs for "MQTT message received" or "Telemetry saved"

**Frontend not displaying data:**
- Check browser console (F12) for errors
- Verify backend API is accessible: `curl http://localhost:18000/health`
- Check InfluxDB has data: Visit Grafana at `http://localhost:3000`
- Look for console logs with emoji markers (📊, 📈, ⚠️, ❌)

**InfluxDB query issues:**
- Verify InfluxDB token in environment variables
- Check bucket name matches: `bucket_iot`
- Review `influxdb/config/influx-configs` for configuration

**Chart not displaying:**
- Open browser console (F12) and check for "📊 Telemetry data for chart"
- Verify sensorData array has items with proper format
- Check Y-axis scaling (auto-scaling enabled)
- Ensure at least 2 data points exist for trend lines

**Suricata rules:**
- Edit `infra/suricata/rules/siac-iot.rules` for custom detection rules
- Restart Suricata container after rule changes

**Node-RED flows:**
- Check `iot-security/nodered/flows.json` for flow configuration
- Access Node-RED UI at `http://localhost:1880` for debugging

---

## Project Highlights

### Technical Stack

- **Backend**: FastAPI, Python 3.9+, paho-mqtt, scikit-learn, SQLAlchemy
- **Frontend**: React 18, Vite, Tailwind CSS, Recharts
- **Database**: InfluxDB 2.x (time-series), PostgreSQL (relational)
- **Messaging**: Mosquitto MQTT Broker
- **IDS**: Suricata with custom rules
- **Visualization**: Grafana, Recharts
- **Hardware**: ESP32, DHT22, HC-SR04
- **DevOps**: Docker, Docker Compose

### Performance

- Real-time telemetry processing (5-second intervals)
- Auto-refresh dashboard (5-second updates)
- Efficient time-series queries with InfluxDB Flux
- Responsive UI with optimized React components
- Scalable microservices architecture

### Security Features

- Network intrusion detection (Suricata IDS)
- ML-based anomaly detection (IsolationForest)
- MQTT TLS support for encrypted communications
- Context-aware security recommendations
- Real-time alert notifications

---

## Contributing

This project was developed as part of the SIAC-IoT initiative. Contributions, issues, and feature requests are welcome!

### Development Workflow

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## License

This project is part of an academic initiative. See individual component licenses for details.

---

## Acknowledgments

- **Development**: Tanjona (Lead Developer)
- **AI Assistance**: GitHub Copilot
- **Technologies**: FastAPI, React, InfluxDB, Suricata, Mosquitto, Grafana
- **Hardware**: ESP32 community and Arduino ecosystem

---

## Contact & Support

For questions, issues, or collaboration opportunities:
- Create an issue in the GitHub repository
- Review the documentation in each subfolder
- Check API docs at `http://localhost:18000/docs`

**Last Updated**: December 11, 2025
**Version**: 1.0 (Production Ready)

---

*Built with ❤️ for IoT Security and Monitoring*
