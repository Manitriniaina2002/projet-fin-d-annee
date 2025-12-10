# Script to generate TLS certificates for Mosquitto MQTT Broker
# Run this script in PowerShell

Write-Host "Generating TLS certificates for MQTT Broker..." -ForegroundColor Green

# Set certificate directory
$certDir = $PSScriptRoot

# Change to cert directory
Set-Location $certDir

# 1. Generate CA private key
Write-Host "`n[1/6] Generating CA private key..." -ForegroundColor Cyan
openssl genrsa -out ca.key 4096

# 2. Generate CA certificate
Write-Host "`n[2/6] Generating CA certificate..." -ForegroundColor Cyan
openssl req -new -x509 -days 3650 -key ca.key -out ca.crt -subj "/C=MG/ST=Madagascar/L=Antananarivo/O=IoT-Security/CN=IoT-CA"

# 3. Generate server private key
Write-Host "`n[3/6] Generating server private key..." -ForegroundColor Cyan
openssl genrsa -out server.key 4096

# 4. Generate server certificate signing request (CSR)
Write-Host "`n[4/6] Generating server CSR..." -ForegroundColor Cyan
openssl req -new -key server.key -out server.csr -subj "/C=MG/ST=Madagascar/L=Antananarivo/O=IoT-Security/CN=mosquitto.local"

# 5. Create extension file for Subject Alternative Names
Write-Host "`n[5/6] Creating certificate extension file..." -ForegroundColor Cyan
@"
subjectAltName = @alt_names
[alt_names]
DNS.1 = mosquitto.local
DNS.2 = mosquitto_secure
DNS.3 = localhost
IP.1 = 127.0.0.1
IP.2 = 172.20.0.2
"@ | Out-File -FilePath server.ext -Encoding ASCII

# 6. Sign server certificate with CA
Write-Host "`n[6/6] Signing server certificate..." -ForegroundColor Cyan
openssl x509 -req -in server.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out server.crt -days 3650 -sha256 -extfile server.ext

# Verify certificates
Write-Host "`nVerifying certificates..." -ForegroundColor Cyan
openssl verify -CAfile ca.crt server.crt

# Set permissions (for Windows, this is informational)
Write-Host "`nSetting file permissions..." -ForegroundColor Cyan
icacls ca.key /inheritance:r /grant:r "${env:USERNAME}:(R)"
icacls server.key /inheritance:r /grant:r "${env:USERNAME}:(R)"

Write-Host "`n✅ Certificate generation complete!" -ForegroundColor Green
Write-Host "`nGenerated files:" -ForegroundColor Yellow
Write-Host "  - ca.crt (CA certificate - distribute to clients)"
Write-Host "  - ca.key (CA private key - keep secure!)"
Write-Host "  - server.crt (Server certificate)"
Write-Host "  - server.key (Server private key - keep secure!)"
Write-Host "  - server.csr (Certificate signing request)"
Write-Host "  - server.ext (Extension file)"
Write-Host "  - ca.srl (Serial number file)"

Write-Host "`nNext steps:" -ForegroundColor Yellow
Write-Host "  1. Copy ca.crt to ESP32 code"
Write-Host "  2. Copy ca.crt to Node-RED data folder"
Write-Host "  3. Restart Mosquitto: docker-compose restart mosquitto"
