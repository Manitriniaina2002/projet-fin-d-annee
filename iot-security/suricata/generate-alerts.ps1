# Suricata Alert Simulator for SIAC-IoT
# This script generates sample Suricata alerts in EVE JSON format for testing
# Run this script to populate the suricata/logs directory with test data

$logDir = "$PSScriptRoot\logs"
$eveLogPath = "$logDir\eve.json"
$fastLogPath = "$logDir\fast.log"

# Create logs directory if it doesn't exist
if (!(Test-Path $logDir)) {
    New-Item -ItemType Directory -Path $logDir -Force | Out-Null
}

Write-Host "🔐 Suricata Alert Simulator for SIAC-IoT" -ForegroundColor Cyan
Write-Host "Generating test alerts..." -ForegroundColor Yellow
Write-Host ""

# Sample alert types
$alertTemplates = @(
    @{
        signature = "SIAC-IoT: Unencrypted MQTT Connection Detected"
        signature_id = 1000001
        severity = 2
        category = "Policy Violation"
        src_ip = "192.168.43.198"
        dest_ip = "172.20.0.2"
        src_port = 54321
        dest_port = 1883
        proto = "TCP"
    },
    @{
        signature = "SIAC-IoT: MQTT Publish Flooding"
        signature_id = 1000004
        severity = 1
        category = "Attempted DoS"
        src_ip = "192.168.43.100"
        dest_ip = "172.20.0.2"
        src_port = 12345
        dest_port = 1883
        proto = "TCP"
    },
    @{
        signature = "SIAC-IoT: Port Scan from IoT Device"
        signature_id = 1000011
        severity = 2
        category = "Attempted Recon"
        src_ip = "192.168.43.150"
        dest_ip = "192.168.43.1"
        src_port = 54321
        dest_port = 22
        proto = "TCP"
    },
    @{
        signature = "SIAC-IoT: SSH Brute Force Attempt"
        signature_id = 1000020
        severity = 1
        category = "Attempted Admin"
        src_ip = "203.0.113.45"
        dest_ip = "192.168.43.198"
        src_port = 44556
        dest_port = 22
        proto = "TCP"
    },
    @{
        signature = "SIAC-IoT: Mirai Botnet Scanner Detected"
        signature_id = 1000030
        severity = 1
        category = "Trojan Activity"
        src_ip = "198.51.100.23"
        dest_ip = "192.168.43.150"
        src_port = 33445
        dest_port = 23
        proto = "TCP"
    },
    @{
        signature = "SIAC-IoT: Unauthorized InfluxDB Access Attempt"
        signature_id = 1000040
        severity = 2
        category = "Attempted Admin"
        src_ip = "192.168.43.99"
        dest_ip = "172.20.0.3"
        src_port = 55667
        dest_port = 8086
        proto = "TCP"
    },
    @{
        signature = "SIAC-IoT: SQL Injection Attempt"
        signature_id = 1000051
        severity = 1
        category = "Web Application Attack"
        src_ip = "198.51.100.77"
        dest_ip = "192.168.43.198"
        src_port = 44332
        dest_port = 8000
        proto = "TCP"
    }
)

# Generate alerts every 30 seconds for 5 minutes
$duration = 5 # minutes
$interval = 30 # seconds
$iterations = [int](($duration * 60) / $interval)

Write-Host "Generating alerts for $duration minutes (every $interval seconds)..." -ForegroundColor Green
Write-Host "EVE Log: $eveLogPath" -ForegroundColor Gray
Write-Host "Fast Log: $fastLogPath" -ForegroundColor Gray
Write-Host ""

for ($i = 0; $i -lt $iterations; $i++) {
    # Select random alert template
    $template = $alertTemplates | Get-Random
    $timestamp = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ss.ffffffZ")
    
    # EVE JSON format (detailed)
    $eveAlert = @{
        timestamp = $timestamp
        flow_id = Get-Random -Minimum 1000000 -Maximum 9999999
        event_type = "alert"
        src_ip = $template.src_ip
        src_port = $template.src_port
        dest_ip = $template.dest_ip
        dest_port = $template.dest_port
        proto = $template.proto
        alert = @{
            action = "allowed"
            gid = 1
            signature_id = $template.signature_id
            rev = 1
            signature = $template.signature
            category = $template.category
            severity = $template.severity
        }
    } | ConvertTo-Json -Compress
    
    # Fast log format (simple)
    $severityText = switch ($template.severity) {
        1 { "[**] [1:$($template.signature_id):1] HIGH" }
        2 { "[**] [1:$($template.signature_id):1] MEDIUM" }
        3 { "[**] [1:$($template.signature_id):1] LOW" }
    }
    
    $fastAlert = "$timestamp $severityText $($template.signature) {$($template.proto)} $($template.src_ip):$($template.src_port) -> $($template.dest_ip):$($template.dest_port)"
    
    # Append to log files
    Add-Content -Path $eveLogPath -Value $eveAlert
    Add-Content -Path $fastLogPath -Value $fastAlert
    
    Write-Host "[$i/$iterations] Generated: " -NoNewline -ForegroundColor Cyan
    Write-Host "$($template.signature)" -ForegroundColor Yellow
    
    if ($i -lt ($iterations - 1)) {
        Start-Sleep -Seconds $interval
    }
}

Write-Host ""
Write-Host "✅ Alert generation complete!" -ForegroundColor Green
Write-Host ""
Write-Host "📊 Summary:" -ForegroundColor Cyan
Write-Host "  - Total alerts: $iterations" -ForegroundColor White
Write-Host "  - Alert types: $($alertTemplates.Count)" -ForegroundColor White
$eveLineCount = if (Test-Path $eveLogPath) { (Get-Content $eveLogPath).Count } else { 0 }
$fastLineCount = if (Test-Path $fastLogPath) { (Get-Content $fastLogPath).Count } else { 0 }
Write-Host "  - EVE log: $eveLineCount lines" -ForegroundColor White
Write-Host "  - Fast log: $fastLineCount lines" -ForegroundColor White
Write-Host ""
Write-Host "🔍 View alerts:" -ForegroundColor Yellow
Write-Host "  Get-Content '$fastLogPath' -Tail 20" -ForegroundColor Gray
Write-Host "  Get-Content '$eveLogPath' -Tail 5 | ConvertFrom-Json" -ForegroundColor Gray
Write-Host ""
Write-Host "📡 These logs are now available to Node-RED at: ./suricata/logs/" -ForegroundColor Green
