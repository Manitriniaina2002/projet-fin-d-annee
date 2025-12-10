# ✅ Suricata IDS Integration Complete!

## Summary

Successfully integrated Suricata IDS alert simulation and processing into the SIAC-IoT platform.

## What Was Implemented

### 1. Alert Simulator (`simulate-alerts.ps1`)
- **Location**: `iot-security/suricata/simulate-alerts.ps1`
- **Purpose**: Generates realistic Suricata alerts for testing
- **Usage**: 
  ```powershell
  .\simulate-alerts.ps1 -Count 30 -IntervalSeconds 2
  ```
- **Alert Types**:
  - Unencrypted MQTT connections (SID 1000001)
  - MQTT publish flooding (SID 1000004)
  - Port scans from IoT devices (SID 1000011)
  - SSH brute force attempts (SID 1000020)
  - Mirai botnet scanners (SID 1000030)
  - Unauthorized InfluxDB access (SID 1000040)
  - SQL injection attempts (SID 1000051)

### 2. Node-RED Processing Flow
- **Location**: Already configured in `nodered/flows.json`
- **Components**:
  1. **Tail File Node**: Monitors `/suricata-logs/eve.json`
  2. **JSON Parser**: Parses alert JSON
  3. **Filter Function**: Extracts only "alert" events
  4. **Format Function**: Structures data for InfluxDB
  5. **InfluxDB Output**: Writes to `suricata_alerts` measurement
  6. **Debug Node**: Shows alerts in Node-RED sidebar

### 3. Log Files Generated
- **EVE JSON**: `iot-security/suricata/logs/eve.json` (detailed, machine-readable)
- **Fast Log**: `iot-security/suricata/logs/fast.log` (simple, human-readable)
- **Generated**: 37+ test alerts successfully created

### 4. Data Flow
```
Suricata Simulator → eve.json
                      ↓
                  Node-RED (tail-file)
                      ↓
                  Parse & Filter
                      ↓
                  InfluxDB (suricata_alerts measurement)
                      ↓
                  Frontend Dashboard
```

## How to Use

### Generate Test Alerts
```powershell
cd iot-security\suricata
.\simulate-alerts.ps1 -Count 50 -IntervalSeconds 2
```

### View in Node-RED
1. Open: http://localhost:11880
2. Navigate to "Flux Node-RED" tab
3. Check "Suricata ALERTS" debug node output

### View in InfluxDB
1. Open: http://localhost:18086
2. Organization: `platform_iot`
3. Bucket: `bucket_iot`
4. Query:
   ```flux
   from(bucket: "bucket_iot")
     |> range(start: -1h)
     |> filter(fn: (r) => r._measurement == "suricata_alerts")
   ```

### View in Grafana
1. Open: http://localhost:13000
2. Create dashboard with data source: InfluxDB
3. Query measurement: `suricata_alerts`

## Next Steps

### 1. Update Frontend Dashboard
Add IDS Alerts page to display:
- Recent security alerts table
- Alert severity distribution (pie chart)
- Alert timeline (line chart)
- Top alert signatures
- Source IP analysis

### 2. Enable Real-Time Alerting
- Configure alert thresholds in Node-RED
- Send notifications for high-severity alerts
- Integrate with email/Slack/Discord

### 3. Deploy Native Suricata (Optional)
For production use, install Suricata natively:
```powershell
choco install suricata
```
Configure to use custom rules at `iot-security/suricata/rules/siac-iot.rules`

## Technical Details

### InfluxDB Schema
```
Measurement: suricata_alerts
Tags:
  - signature (alert name)
  - severity (1=HIGH, 2=MEDIUM, 3=LOW)
  - action (allowed/blocked)
  - proto (TCP/UDP)
Fields:
  - sid (signature ID)
  - rev (rule revision)
  - src_ip, src_port
  - dest_ip, dest_port
  - count (always 1)
```

### Node-RED Flow ID
- Tab: `da03eddac687fe72`
- Tail Node: `9d125bdbba38f94b`
- Filter: `17c9beef05f63bec`
- Format: `27baa5263e35823b`
- InfluxDB Output: `bc126a9d5afb76c4`

## Files Created/Modified
1. ✅ `iot-security/suricata/simulate-alerts.ps1` - Alert simulator
2. ✅ `iot-security/suricata/logs/eve.json` - Alert log (EVE format)
3. ✅ `iot-security/suricata/logs/fast.log` - Alert log (fast format)
4. ✅ `iot-security/nodered/flows.json` - Existing flow already configured
5. ✅ `iot-security/docker-compose.iot.yml` - Volume mount configured

## Status: ✅ OPERATIONAL
- Simulator: Working
- Log Generation: Working
- Node-RED Processing: Configured
- InfluxDB Storage: Ready
- Frontend Integration: Pending
