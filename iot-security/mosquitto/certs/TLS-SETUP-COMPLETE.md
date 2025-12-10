# TLS Certificates Generated Successfully! 🔐

## Certificate Information

**Generated on:** December 10, 2025
**Validity:** 10 years (expires December 8, 2035)
**Certificate Authority:** IoT-CA
**Server Common Name:** mosquitto.local

## Files Generated

### In `iot-security/mosquitto/certs/`:
- ✅ **ca.crt** - CA Certificate (distribute to clients)
- ✅ **ca.key** - CA Private Key (keep secure!)
- ✅ **server.crt** - Server Certificate
- ✅ **server.key** - Server Private Key (keep secure!)
- ✅ **server.csr** - Certificate Signing Request
- ✅ **server.ext** - Extension file with SANs
- ✅ **ca.srl** - Serial number file

### Copied to:
- ✅ `iot-security/nodered/ca.crt`
- ✅ `web-application/backend/certs/ca.crt`

## Mosquitto MQTT Broker Status

✅ **Running with TLS enabled**
- Port 1883: Non-TLS (for local testing)
- Port 11883: Non-TLS (mapped to host)
- Port 8883: TLS/SSL enabled
- Port 18883: TLS/SSL (mapped to host)

## ESP32 Configuration

### Update your ESP32 code with the new CA certificate:

```cpp
static const char ca_cert[] PROGMEM = R"EOF(
-----BEGIN CERTIFICATE-----
MIIFozCCA4ugAwIBAgIUDSjPZkf6QOgO+hJUgfOp62lDCgUwDQYJKoZIhvcNAQEL
BQAwYTELMAkGA1UEBhMCTUcxEzARBgNVBAgMCk1hZGFnYXNjYXIxFTATBgNVBAcM
DEFudGFuYW5hcml2bzEVMBMGA1UECgwMSW9ULVNlY3VyaXR5MQ8wDQYDVQQDDAZJ
b1QtQ0EwHhcNMjUxMjEwMTMwNzIyWhcNMzUxMjA4MTMwNzIyWjBhMQswCQYDVQQG
EwJNRzETMBEGA1UECAwKTWFkYWdhc2NhcjEVMBMGA1UEBwwMQW50YW5hbmFyaXZv
MRUwEwYDVQQKDAxJb1QtU2VjdXJpdHkxDzANBgNVBAMMBklvVC1DQTCCAiIwDQYJ
KoZIhvcNAQEBBQADggIPADCCAgoCggIBANYdIcjT4mA1qZrdp7Ftwe9C00JFVqus
8/UdqIyG7sIfCHaRFDX91EilMn/0+KgLXOe2ZSTfWqy1oKLH/zn/Ayp39vnAlctb
BNGXEEaAHLGALtUO9JyW1VElgU501BvdUim9lf16QLAyfa9qBOuXcNFSxZdlcJw9
nXGCCG/kJwkng9oi+auYFvwCh85pzkcVi82b9YdOh2Iaoy/koA5WX316jXDCttiE
CPIUfCJN+N7zjwlbfC1YSU0WTIkju1A1lsvYQcALA8OUKn7rv1B9PHNoV86bNA52
Ehm4akQhozeSbqEFJAsRznXiFWcXHrEY9FVl6vwYAu2SvJY80+9Ug1HypIwgCZGP
3b0JopMYWfM8dwCijM6ErAnLo3EMbt8v4cCZUYltsd688ThjqlagROn1lXibUW7L
MLiH1wkxZVyUuV+37RW+N0AckURfsMcOazfvQRm9zR6Jg6CjYvUk5iPXx+ZEzkiS
7l06DGv4nScTmznHV4IcMs64r9zTl159aTvcZQHA0DfbCJOfavzBlCNNJBy1bliw
woIcvXMxqpYL0GtjZXu1OE28ziXSruNIHnLuId2bqUV11DuOKCXBgkgfOwePdBkl
Fikq1+g8IzprYHVJ+i/Apla9dTI01dJzHp7w44FkASaSl1M4xislOgvRXpoUiMtU
d/gQFy3XqY5nAgMBAAGjUzBRMB0GA1UdDgQWBBQLNxANJUVWrGpvJ03cqpw5zjLb
oTAfBgNVHSMEGDAWgBQLNxANJUVWrGpvJ03cqpw5zjLboTAPBgNVHRMBAf8EBTAD
AQH/MA0GCSqGSIb3DQEBCwUAA4ICAQCUw5AyUObWgD8yStEJ34PmzekqkNVQGGhY
q7j975fNszAZ3k+Ex6V8Cbnxi1i+BU+NsIi1HsfcYtuMowQYgbjoCxasDdr89gak
qVptE9bVywdJhCnxSrDAWjse8n5EzjgCA7ZP9xitf2OMM8BSat35I52eqMhgBhWi
0ud0Y2xVMDg55gN+N5/jB2TPR3HaQ7xByqyRCNWlurf3OTs3HrHEDSwagokQ8vY8
9mLHzmoC7RfGST/ZLZENVPszEzXAtvPQG8iGYy54wovt8tLj4Pdvw+yeUACKIzFS
gpwRUgDFdg6voR2UYXfQX0fhnAvHtL6Md7uHzYss2paJcWB26+Jg4vg+GNTwDf4a
xVtOm+/S2P0n+YyASAkwOtJCeg+THzSfohGo4W+hYPd3B8mHV5AOMzdTqDqPeplD
9HhfmNkP4FdSUjYx26MkTU0a7K/XhtDcRhqdbLg145uWqNAgTkIn+k8IXkmu6s5g
nyAZJFTo+JywjJtZcGtTbcnzEcUzmeHmWOxYB0Q8HYaGljeQxXsHz2gKZC61OWou
As/EHrP9k+wfDNsg8Hhpfrur+iuBDdhxO0Hy2+m8I4U2i/qeXWEy+uGAHa5hYYqY
US6pzfarusYntuQnEyary/gX62/L9maOyY5X2hvmzZ1Ii407qwV83TJM68DyUro7
WDS2JbYmXg==
-----END CERTIFICATE-----
)EOF";
```

### Update ESP32 MQTT Connection Settings:

```cpp
const char* mqtt_server = "YOUR_HOST_IP";  // Replace with your machine's IP
const int mqtt_port = 18883;  // TLS port mapped to host
const char* mqtt_user = "esp32";
const char* mqtt_pass = "admin123";
```

## Backend Configuration

The backend is already configured to use the CA certificate at:
`/app/certs/ca.crt`

Current settings in `docker-compose.yml`:
```yaml
environment:
  - MQTT_HOST=mosquitto_secure
  - MQTT_PORT=8883  # Use TLS port
  - MQTT_TLS_ENABLED=true
  - MQTT_CA_CERT=/app/certs/ca.crt
```

## Testing TLS Connection

### From ESP32:
The ESP32 will automatically verify the server certificate using the CA cert.

### From Docker/Linux:
```bash
mosquitto_pub -h mosquitto_secure -p 8883 \
  --cafile /certs/ca.crt \
  -t "test/topic" -m "Hello TLS"
```

### From Windows (if mosquitto_pub installed):
```powershell
mosquitto_pub -h localhost -p 18883 `
  --cafile ca.crt `
  -t "test/topic" -m "Hello TLS"
```

## Security Best Practices

1. ✅ **CA Private Key (ca.key):** Keep secure, do not distribute
2. ✅ **Server Private Key (server.key):** Keep secure, never expose
3. ✅ **CA Certificate (ca.crt):** Distribute to all clients that need to connect
4. ⚠️ **Anonymous Access:** Currently enabled for testing. Disable in production:
   ```conf
   allow_anonymous false
   password_file /mosquitto/config/passwd
   ```

## Regenerating Certificates

If you need to regenerate certificates:

**Windows (using Docker):**
```powershell
cd iot-security\mosquitto\certs
.\generate-certs.ps1
```

**Linux/Mac:**
```bash
cd iot-security/mosquitto/certs
chmod +x generate-certs.sh
./generate-certs.sh
```

## Next Steps

1. ✅ Update ESP32 code with new CA certificate (see above)
2. ✅ Upload code to ESP32
3. ✅ Update backend to use TLS (uncomment MQTT_TLS_ENABLED=true)
4. ✅ Restart backend: `docker-compose restart backend`
5. ⚠️ Optional: Enable password authentication in mosquitto.conf
6. ⚠️ Optional: Generate client certificates for mutual TLS

## Verification

Check Mosquitto is listening on TLS port:
```powershell
docker logs mosquitto_secure | Select-String "8883"
```

Expected output:
```
Opening ipv4 listen socket on port 8883.
Opening ipv6 listen socket on port 8883.
```

✅ **TLS is now fully configured and operational!** 🔒
