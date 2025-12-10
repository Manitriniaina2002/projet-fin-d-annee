#!/bin/bash
# Script to generate TLS certificates for Mosquitto MQTT Broker

set -e

echo "🔐 Generating TLS certificates for MQTT Broker..."

# Certificate details
COUNTRY="MG"
STATE="Madagascar"
CITY="Antananarivo"
ORG="IoT-Security"
CA_CN="IoT-CA"
SERVER_CN="mosquitto.local"
DAYS=3650

echo ""
echo "[1/6] Generating CA private key..."
openssl genrsa -out ca.key 4096

echo ""
echo "[2/6] Generating CA certificate..."
openssl req -new -x509 -days $DAYS -key ca.key -out ca.crt \
  -subj "/C=$COUNTRY/ST=$STATE/L=$CITY/O=$ORG/CN=$CA_CN"

echo ""
echo "[3/6] Generating server private key..."
openssl genrsa -out server.key 4096

echo ""
echo "[4/6] Generating server CSR..."
openssl req -new -key server.key -out server.csr \
  -subj "/C=$COUNTRY/ST=$STATE/L=$CITY/O=$ORG/CN=$SERVER_CN"

echo ""
echo "[5/6] Creating certificate extension file..."
cat > server.ext <<EOF
subjectAltName = @alt_names
[alt_names]
DNS.1 = mosquitto.local
DNS.2 = mosquitto_secure
DNS.3 = localhost
IP.1 = 127.0.0.1
IP.2 = 172.20.0.2
IP.3 = 192.168.1.100
EOF

echo ""
echo "[6/6] Signing server certificate..."
openssl x509 -req -in server.csr -CA ca.crt -CAkey ca.key \
  -CAcreateserial -out server.crt -days $DAYS -sha256 -extfile server.ext

echo ""
echo "🔍 Verifying certificates..."
openssl verify -CAfile ca.crt server.crt

echo ""
echo "🔒 Setting file permissions..."
chmod 600 ca.key server.key
chmod 644 ca.crt server.crt

echo ""
echo "✅ Certificate generation complete!"
echo ""
echo "📁 Generated files:"
echo "  - ca.crt (CA certificate - distribute to clients)"
echo "  - ca.key (CA private key - keep secure!)"
echo "  - server.crt (Server certificate)"
echo "  - server.key (Server private key - keep secure!)"
echo "  - server.csr (Certificate signing request)"
echo "  - server.ext (Extension file)"
echo "  - ca.srl (Serial number file)"
echo ""
echo "📋 Next steps:"
echo "  1. Copy ca.crt to ESP32 code"
echo "  2. Copy ca.crt to Node-RED: cp ca.crt ../../nodered/ca.crt"
echo "  3. Copy ca.crt to backend: cp ca.crt ../../../web-application/backend/certs/ca.crt"
echo "  4. Restart Mosquitto: docker-compose restart mosquitto"
