# Simple Suricata Alert Simulator
param(
    [int]$Count = 10,
    [int]$IntervalSeconds = 5
)

$logDir = "$PSScriptRoot\logs"
$eveLogPath = "$logDir\eve.json"
$fastLogPath = "$logDir\fast.log"

# Create logs directory
if (!(Test-Path $logDir)) {
    New-Item -ItemType Directory -Path $logDir -Force | Out-Null
}

Write-Host "Suricata Alert Simulator" -ForegroundColor Cyan
Write-Host "Generating $Count alerts (interval: ${IntervalSeconds}s)" -ForegroundColor Green
Write-Host ""

# Alert templates
$alerts = @(
    @{sig="SIAC-IoT: Unencrypted MQTT Connection"; sid=1000001; sev=2; cat="Policy Violation"; sport=54321; dport=1883}
    @{sig="SIAC-IoT: MQTT Publish Flooding"; sid=1000004; sev=1; cat="Attempted DoS"; sport=12345; dport=1883}
    @{sig="SIAC-IoT: Port Scan from IoT Device"; sid=1000011; sev=2; cat="Attempted Recon"; sport=54321; dport=22}
    @{sig="SIAC-IoT: SSH Brute Force Attempt"; sid=1000020; sev=1; cat="Attempted Admin"; sport=44556; dport=22}
    @{sig="SIAC-IoT: Mirai Botnet Scanner"; sid=1000030; sev=1; cat="Trojan Activity"; sport=33445; dport=23}
    @{sig="SIAC-IoT: Unauthorized InfluxDB Access"; sid=1000040; sev=2; cat="Attempted Admin"; sport=55667; dport=8086}
    @{sig="SIAC-IoT: SQL Injection Attempt"; sid=1000051; sev=1; cat="Web Application Attack"; sport=44332; dport=8000}
)

for ($i = 0; $i -lt $Count; $i++) {
    $template = $alerts | Get-Random
    $timestamp = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ss.ffffffZ")
    
    # EVE JSON
    $eve = @{
        timestamp = $timestamp
        flow_id = Get-Random -Minimum 1000000 -Maximum 9999999
        event_type = "alert"
        src_ip = "192.168.43.$((Get-Random -Minimum 100 -Maximum 200))"
        src_port = $template.sport
        dest_ip = "172.20.0.$((Get-Random -Minimum 2 -Maximum 10))"
        dest_port = $template.dport
        proto = "TCP"
        alert = @{
            action = "allowed"
            gid = 1
            signature_id = $template.sid
            rev = 1
            signature = $template.sig
            category = $template.cat
            severity = $template.sev
        }
    }
    
    $eveJson = $eve | ConvertTo-Json -Compress
    Add-Content -Path $eveLogPath -Value $eveJson
    
    # Fast log
    $sevText = if ($template.sev -eq 1) {"HIGH"} elseif ($template.sev -eq 2) {"MEDIUM"} else {"LOW"}
    $fastLine = "$timestamp [**] [1:$($template.sid):1] $sevText $($template.sig) {TCP} $($eve.src_ip):$($eve.src_port) -> $($eve.dest_ip):$($eve.dest_port)"
    Add-Content -Path $fastLogPath -Value $fastLine
    
    Write-Host "[$($i+1)/$Count] " -NoNewline -ForegroundColor Cyan
    Write-Host $template.sig -ForegroundColor Yellow
    
    if ($i -lt ($Count - 1)) {
        Start-Sleep -Seconds $IntervalSeconds
    }
}

Write-Host ""
Write-Host "Done! Generated $Count alerts" -ForegroundColor Green
Write-Host "EVE log: $eveLogPath" -ForegroundColor Gray
Write-Host "Fast log: $fastLogPath" -ForegroundColor Gray
