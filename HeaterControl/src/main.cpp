

#include <Arduino.h>
#include <Wire.h>
#include <Adafruit_TMP117.h>

#include "Settings.h"

const uint8_t LED_PIN = LED_BUILTIN;
const uint8_t CHANNEL_PINS[] = {18u, 19u, 20u, 21u};

const uint8_t I2C_ADDRESS = 0x18;

MultiTask tasks;
Adafruit_TMP117 tmp117;

unsigned int ramp = 0;

void request_event() {
  Wire1.write("hello");
}

void enter_master() {
  Wire1.end();
  Wire1.begin();
}

void enter_slave() {
  Wire1.end();
  Wire1.begin(I2C_ADDRESS);
  Wire1.onRequest(request_event);
}


void read_temperture()
{
  sensors_event_t temp;   // create an empty event to be filled
  tmp117.getEvent(&temp); // fill the empty event object with the current measurements
  Serial.print("Temperature ");
  Serial.print(temp.temperature);
  Serial.println(" degrees C");
}

void read_tmp117()
{
  enter_master();
  if (tmp117.begin(TMP117_I2CADDR_DEFAULT, &Wire1))
  {
    Serial.println("Found TMP117 chip!");
    read_temperture();
  }
  else
  {
    Serial.println("Failed to find TMP117 chip");
  }
  enter_slave();
}

void ramp_output_channels()
{
  for (int i = 0; i < 4; i++)
  {
    analogWrite(CHANNEL_PINS[i], (ramp + i * 64) % 255);
  }
  ramp++;
}




void setup()
{
  // put your setup code here, to run once
  for (int i = 0; i < 4; i++)
  {
    pinMode(CHANNEL_PINS[i], OUTPUT);
  }

  Wire1.setSDA(0x6);
  Wire1.setSCL(0x7);

  enter_slave();

  Serial.begin(115200);
  tasks.every(1000, &read_tmp117);
  tasks.every(10, &ramp_output_channels);
}



void loop()
{
  tasks.process();
}