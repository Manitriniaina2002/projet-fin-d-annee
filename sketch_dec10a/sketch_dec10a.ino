#include <WiFi.h>
#include <WiFiClientSecure.h>
#include <PubSubClient.h>
#include <DHT.h>

// ======================================================
// 🔧 CONFIGURATION WIFI
// ======================================================
const char *ssid = "*.*";
const char *password = "AFJAD@2002!";

// ======================================================
// 🔐 CONFIG MQTT TLS
// ======================================================
const char *mqtt_server = "192.168.43.198"; // Host machine IP address
const int mqtt_port = 18883;                // TLS port mapped to host
const char *mqtt_user = "esp32";
const char *mqtt_pass = "admin123";

// ======================================================
// 📌 CERTIFICAT CA - Updated December 10, 2025
// ======================================================
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

// ======================================================
// 📌 DHT22 CONFIG
// ======================================================
#define DHTPIN 15
#define DHTTYPE DHT22
DHT dht(DHTPIN, DHTTYPE);

// ======================================================
// 📌 LEDS
// ======================================================
#define LED_ROUGE 4
#define LED_VERTE 5

// ======================================================
// 📌 HC‑SR04
// ======================================================
#define TRIG 27
#define ECHO 26

WiFiClientSecure espClient;
PubSubClient client(espClient);

// ======================================================
// 📩 CALLBACK MQTT : COMMANDE LEDS
// ======================================================
void mqttCallback(char *topic, byte *payload, unsigned int length)
{
  String msg = "";
  for (int i = 0; i < length; i++)
    msg += (char)payload[i];

  msg.trim();

  if (String(topic) == "iot/cmd/led_rouge")
  {
    digitalWrite(LED_ROUGE, (msg == "ON") ? HIGH : LOW);
  }

  if (String(topic) == "iot/cmd/led_verte")
  {
    digitalWrite(LED_VERTE, (msg == "ON") ? HIGH : LOW);
  }
}

// ======================================================
// 📡 WIFI
// ======================================================
void setup_wifi()
{
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED)
    delay(300);
}

// ======================================================
// 🔄 MQTT AUTO-RECONNECT
// ======================================================
void reconnect()
{
  while (!client.connected())
  {
    if (client.connect("ESP32Client", mqtt_user, mqtt_pass))
    {

      // ABONNEMENTS ICI 👇
      client.subscribe("iot/#");
      client.subscribe("iot/cmd/led_rouge");
      client.subscribe("iot/cmd/led_verte");
    }
    else
    {
      delay(2000);
    }
  }
}

// ======================================================
// 📏 MESURE HC-SR04
// ======================================================
float readDistance()
{
  digitalWrite(TRIG, LOW);
  delayMicroseconds(2);
  digitalWrite(TRIG, HIGH);
  delayMicroseconds(10);
  digitalWrite(TRIG, LOW);
  long duration = pulseIn(ECHO, HIGH);
  return duration * 0.0343 / 2;
}

// ======================================================
// 🚀 SETUP
// ======================================================
void setup()
{
  Serial.begin(115200);
  pinMode(LED_ROUGE, OUTPUT);
  pinMode(LED_VERTE, OUTPUT);
  pinMode(TRIG, OUTPUT);
  pinMode(ECHO, INPUT);

  dht.begin();
  setup_wifi();

  espClient.setCACert(ca_cert);
  client.setServer(mqtt_server, mqtt_port);
  client.setCallback(mqttCallback);
}

// ======================================================
// 🔁 LOOP
// ======================================================
void loop()
{
  if (!client.connected())
    reconnect();
  client.loop();

  static unsigned long last = 0;
  if (millis() - last > 5000)
  {
    last = millis();

    float temp = dht.readTemperature();
    float hum = dht.readHumidity();
    float dist = readDistance();

    // LED automatique selon distance
    digitalWrite(LED_ROUGE, dist < 20 ? HIGH : LOW);
    digitalWrite(LED_VERTE, dist >= 20 ? HIGH : LOW);

    // Publication JSON
    char payload[150];
    snprintf(payload, sizeof(payload),
             "{\"temp\": %.2f, \"hum\": %.2f, \"distance\": %.2f}",
             temp, hum, dist);

    client.publish("iot/data/esp32", payload);
    Serial.println(payload);
  }
}
