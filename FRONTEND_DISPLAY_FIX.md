# Frontend Display Fix - IDS Alerts Page

## Issues Fixed

### 1. **Missing Destination IP Field**
**Problem**: The alert cards were showing "Port Dest" instead of "IP Dest"  
**Solution**: Updated `IDSAlerts.jsx` to display `dest_ip` field

### 2. **Backend Query Structure**
**Problem**: InfluxDB query was returning each field as a separate record, causing incomplete data display  
**Solution**: Added `pivot()` transformation in the Flux query to properly group all fields by timestamp

### 3. **Field Visibility Issues**
**Problem**: Not all 6 required fields (Timestamp, Signature, Severity, IP Source, IP Dest, Action) were clearly visible  
**Solution**: Reorganized alert card layout with dedicated sections for each field

## Changes Made

### Frontend (`web-application/frontend/src/pages/IDSAlerts.jsx`)

#### High Priority Alerts Section
- Changed from 4-column grid to 3-column grid for better field visibility
- Added dedicated section for Signature field (no longer truncated)
- Updated IP Dest field to check both `dest_ip` and `dst_ip` properties
- Made Action field uppercase and monospace for clarity
- Added stronger text colors for better readability

**Before:**
```jsx
<div className="grid grid-cols-2 md:grid-cols-4 gap-4 text-sm">
  <div>IP Source: {alert.src_ip}</div>
  <div>Port Dest: {alert.dst_port}</div>
  <div>Action: {alert.action}</div>
  <div className="truncate">Signature: {alert.signature}</div>
</div>
```

**After:**
```jsx
<div className="grid grid-cols-2 md:grid-cols-3 gap-4 text-sm">
  <div>
    <span className="font-medium text-gray-700">IP Source:</span>
    <div className="font-mono text-gray-900">{alert.src_ip || 'N/A'}</div>
  </div>
  <div>
    <span className="font-medium text-gray-700">IP Dest:</span>
    <div className="font-mono text-gray-900">{alert.dest_ip || alert.dst_ip || 'N/A'}</div>
  </div>
  <div>
    <span className="font-medium text-gray-700">Action:</span>
    <div className="font-mono text-gray-900 uppercase">{alert.action || 'logged'}</div>
  </div>
</div>
<div className="mt-3 pt-3 border-t border-gray-200">
  <div className="text-sm">
    <span className="font-medium text-gray-700">Signature:</span>
    <div className="text-gray-900 mt-1">{alert.signature || 'N/A'}</div>
  </div>
</div>
```

#### Recent Events Section
- Changed from horizontal to vertical layout for better field display
- Added separate lines for IP Source, IP Dest, and Action
- Used monospace font for IP addresses and action
- Improved spacing and alignment

**Before:**
```jsx
<div className="text-sm text-gray-600">
  {category} • {alert.src_ip || 'IP inconnue'}
</div>
```

**After:**
```jsx
<div className="text-sm text-gray-600 mt-1">
  {category}
</div>
<div className="flex flex-wrap gap-3 mt-2 text-xs">
  <span className="font-mono text-gray-700">
    <strong>Src:</strong> {alert.src_ip || 'N/A'}
  </span>
  <span className="font-mono text-gray-700">
    <strong>Dest:</strong> {alert.dest_ip || alert.dst_ip || 'N/A'}
  </span>
  <span className="font-mono text-gray-700 uppercase">
    <strong>Action:</strong> {alert.action || 'logged'}
  </span>
</div>
```

### Backend (`web-application/backend/app/influxdb_data_service.py`)

#### InfluxDB Query Fix
**Problem**: Original query returned separate records for each field:
- Record 1: `_field="signature", _value="MQTT over TLS not detected"`
- Record 2: `_field="severity", _value=1`
- Record 3: `_field="src_ip", _value="192.168.1.100"`
- etc.

This resulted in incomplete alert objects where most fields were `null`.

**Solution**: Added `pivot()` transformation to restructure data:

**Before:**
```python
flux_query = f'''
from(bucket: "{self.bucket}")
|> range(start: -24h)
|> filter(fn: (r) => r._measurement == "suricata_alerts")
|> sort(columns: ["_time"], desc: true)
|> limit(n: {limit})
'''

for record in table.records:
    logs.append({
        "src_ip": record["_value"] if record["_field"] == "src_ip" else None,
        "dest_ip": record["_value"] if record["_field"] == "dest_ip" else None,
        # ... each field checks if it's the current record's field
    })
```

**After:**
```python
flux_query = f'''
from(bucket: "{self.bucket}")
|> range(start: -24h)
|> filter(fn: (r) => r._measurement == "suricata_alerts")
|> pivot(rowKey:["_time"], columnKey: ["_field"], valueColumn: "_value")
|> sort(columns: ["_time"], desc: true)
|> limit(n: {limit})
'''

for record in table.records:
    log_entry = {
        "event_ts": record.get_time(),
        "signature": record.values.get("signature", ""),
        "severity": record.values.get("severity", 3),
        "action": record.values.get("action", "logged"),
        "src_ip": record.values.get("src_ip", ""),
        "dest_ip": record.values.get("dest_ip", ""),
        # ... all fields are now in the same record
    }
```

The `pivot()` function transforms the data from long format (one row per field) to wide format (one row per timestamp with all fields as columns).

## All 6 Required Fields Now Visible

✅ **Timestamp**: Displayed at top-right of each alert card (French format)  
✅ **Signature**: Full text in dedicated section (no truncation)  
✅ **Severity**: Color-coded badge with French labels (CRITIQUE/ÉLEVÉ/MOYEN/FAIBLE)  
✅ **IP Source**: Monospace font in grid layout  
✅ **IP Dest**: Monospace font in grid layout (checks both `dest_ip` and `dst_ip`)  
✅ **Action**: Uppercase monospace font in grid layout

## Testing

1. **Generate test alerts**:
   ```powershell
   .\iot-security\suricata\simulate-alerts.ps1 -Count 20 -IntervalSeconds 2
   ```

2. **Check frontend** at http://localhost:5173/ids-alerts:
   - Login with admin/admin123
   - Navigate to "Alertes IDS" page
   - Verify all 6 fields are visible in alert cards
   - Test pagination (3 alerts per page)
   - Test date filters (All, 1h, 24h, 7d, 30d, Custom)
   - Test Excel/PDF export

3. **Verify data structure** in backend logs:
   ```bash
   docker logs siac-backend -f
   ```

## Next Steps

- [ ] Test export functionality (Excel and PDF)
- [ ] Verify ESP32 device integration with MQTT
- [ ] Monitor Node-RED for continuous alert processing
- [ ] Check Grafana dashboards for visualization

## Related Files

- `web-application/frontend/src/pages/IDSAlerts.jsx` - Frontend display component
- `web-application/backend/app/influxdb_data_service.py` - Backend data query service
- `iot-security/nodered/flows.json` - Node-RED alert processing flow
- `iot-security/suricata/simulate-alerts.ps1` - Alert generator script
