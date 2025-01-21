#include <GxEPD2_3C.h>
#include <WiFi.h>

// Display
#define WIDTH 792
#define HEIGHT 272

#define PIN_CS 13
#define PIN_DC 22
#define PIN_RST 21
#define PIN_BUSY 14

// WiFi
const char* ssid         = "";
const char* password     = "";

unsigned int localPort   = 8555;

GxEPD2_3C<GxEPD2_579c_GDEY0579Z93, HEIGHT> display(GxEPD2_579c_GDEY0579Z93(PIN_CS, PIN_DC, PIN_RST, PIN_BUSY));

WiFiServer server(localPort);

void setup()
{
  // Start serial communication
  Serial.begin(115200);
  
  display.init();

  // Connect to WiFi
  Serial.print("Connecting to WiFi");
  WiFi.begin(ssid, password);

  while (WiFi.status() != WL_CONNECTED)
  {
    delay(500);
    Serial.print(".");
  }

  Serial.println("\nWiFi connected");
  Serial.print("IP address: ");
  Serial.println(WiFi.localIP());

  // Start TCP
  server.begin();
  Serial.print("Listening on TCP port ");
  Serial.println(localPort);
}

void loop()
{
  WiFiClient client = server.available();
  if (client)
  {
    Serial.println("Client connected!");

    int bytesReceived = 0;
    uint8_t* buffer = display.getBlackBuffer(); // Start with the black buffer
    size_t bufferSize = (WIDTH * HEIGHT) / 8;
    bool processingColorBuffer = false;

    while (client.connected())
    {
      while (client.available() > 0 && bytesReceived < bufferSize * 2)
      {
        size_t index = bytesReceived % bufferSize;
        buffer[index] = client.read();
        bytesReceived++;

        // Switch to color buffer when black buffer is filled
        if (bytesReceived == bufferSize && !processingColorBuffer)
        {
          buffer = display.getColorBuffer();
          processingColorBuffer = true;
        }
      }

      // Break if we've received enough data
      if (bytesReceived >= bufferSize * 2)
        break;
    }

    if (bytesReceived == bufferSize * 2)
    {
      Serial.println("Buffer full. Updating display.");
      display.display();
    }

    Serial.print("Bytes received: ");
    Serial.println(bytesReceived);

    client.stop();
    Serial.println("Client disconnected.");
  }
}
