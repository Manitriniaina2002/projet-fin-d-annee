# Suricata IDS Integration for SIAC-IoT

## Overview
Suricata is an Intrusion Detection System (IDS) that monitors network traffic for security threats.

## Current Setup

### Files Created:
1. **Custom Rules**: `suricata/rules/siac-iot.rules`
   - MQTT protocol security rules
   - IoT device anomaly detection  
   - Network security rules
   - Malware & attack detection
   - API security rules
   - DDoS protection

2. **Configuration**: `suricata/config/suricata-vars.yaml`
   - Network variables
   - Port definitions

3. **Docker Service**: Added to `docker-compose.iot.yml`

## Quick Start (Alternative Method)

### Option 1: Use Suricata on Host (Recommended for Windows)

Since Docker networking on Windows has limitations, install Suricata directly:

```powershell
# Using Chocolatey
choco install suricata

# Or download from: https://suricata.io/download/
```

**Run Suricata:**
```powershell
# Find your network interface
Get-NetAdapter | Select-Object Name, Status

# Run Suricata (replace "Wi-Fi" with your interface name)
suricata -c C:\Program Files\Suricata\suricata.yaml -i Wi-Fi -l C:\Users\Tanjona\Desktop\project-root\iot-security\suricata\logs -S C:\Users\Tanjona\Desktop\project-root\iot-security\suricata\rules\siac-iot.rules -v
```

### Option 2: Use Docker with Network Mirroring

For Docker to work properly, you need to mirror traffic to the container. This is complex on Windows.

**Simplified Docker Approach:**
```yaml
suricata:
  image: jasonish/suricata:latest
  container_name: suricata_ids
  restart: unless-stopped
  network_mode: host  # Monitor host network
  cap_add:
    - NET_ADMIN
    - NET_RAW
  volumes:
    - ./suricata/logs:/var/log/suricata
  command: -i Ethernet --set rule-files[0]=/etc/suricata/rules/suricata.rules -v
```

### Option 3: Monitor Specific Container Traffic

Use tcpdump to capture and feed to Suricata:

```powershell
# Capture traffic from siac-network
docker run --rm --net=container:mosquitto_secure nicolaka/netshoot tcpdump -i any -w - | docker exec -i suricata_ids suricata -r -
```

## Integration with SIAC-IoT

### 1. View Alerts in Real-Time

```powershell
# Watch Suricata alerts
Get-Content C:\Users\Tanjona\Desktop\project-root\iot-security\suricata\logs\fast.log -Wait -Tail 20
```

### 2. Node-RED Integration

The logs are already configured to be read by Node-RED:
- Volume mounted: `suricata_logs:/suricata-logs:ro`
- Node-RED can parse `/suricata-logs/eve.json` for structured alerts

### 3. Backend API Integration

Your backend already has a Suricata log endpoint:
```python
# GET /api/v1/suricata/logs
# Returns parsed Suricata alerts
```

## Alert Types Generated

1. **MQTT Security**
   - Unencrypted connections
   - Invalid protocol versions
   - Large payloads
   - Publish flooding

2. **IoT Anomalies**
   - Unexpected broker connections
   - Port scanning
   - Data exfiltration

3. **Network Attacks**
   - SSH brute force
   - Insecure protocols (Telnet, FTP)
   - DDoS attempts

4. **Malware Detection**
   - Mirai botnet
   - Command injection
   - Shell commands

5. **API Security**
   - Authentication failures
   - SQL injection
   - XSS attempts

## Viewing Alerts

### Fast Log (Simple format):
```powershell
Get-Content .\suricata\logs\fast.log -Tail 20
```

### EVE JSON (Structured format - best for Node-RED):
```powershell
Get-Content .\suricata\logs\eve.json -Tail 5 | ConvertFrom-Json | Format-Table
```

### Stats:
```powershell
Get-Content .\suricata\logs\stats.log -Tail 20
```

## Testing Suricata

### Test MQTT Detection:
```powershell
# Connect to non-TLS MQTT (should trigger alert)
mosquitto_pub -h localhost -p 11883 -t "test/topic" -m "test"
```

### Test Port Scan Detection:
```powershell
# Scan ports (should trigger alert)
1..100 | ForEach-Object { Test-NetConnection localhost -Port $_ -WarningAction SilentlyContinue }
```

## Troubleshooting

### Docker Issues:
- **Container restarting**: Check `docker logs suricata_ids`
- **No alerts**: Verify network interface exists in container
- **Permission denied**: Ensure NET_ADMIN and NET_RAW capabilities

### Performance:
- Suricata can be CPU intensive
- Reduce rules if performance is an issue
- Use `-F` flag for better performance

## Production Recommendations

1. **Enable Rule Updates**:
   ```bash
   suricata-update
   ```

2. **Add ET Open Rules**:
   - Download from: https://rules.emergingthreats.net/open/

3. **Configure Alerting**:
   - Email notifications
   - Syslog integration
   - SIEM integration

4. **Tune Performance**:
   - Adjust thread count
   - Configure buffer sizes
   - Enable hardware acceleration

## Current Status

⚠️ **Docker Suricata on Windows has limitations**

**Recommended**: Use Suricata natively on Windows or run on Linux host

**Alternative**: View alerts through Node-RED dashboard which reads log files

The rules are ready and will work once Suricata is properly capturing traffic!
