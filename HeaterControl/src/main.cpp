

#include <Arduino.h>
#include <Wire.h>
#include <Adafruit_TMP117.h>

#include "Settings.h"

const uint8_t LED_PIN = LED_BUILTIN;
const uint8_t CHANNEL_PINS[] = {18u, 19u, 20u, 21u};

MultiTask tasks;
Adafruit_TMP117 tmp117;

unsigned int ramp = 0;
MultiTask::CallbackFunction *search;

void test_tmp117()
{
  sensors_event_t temp;   // create an empty event to be filled
  tmp117.getEvent(&temp); // fill the empty event object with the current measurements
  Serial.print("Temperature ");
  Serial.print(temp.temperature);
  Serial.println(" degrees C");
}

void search_for_tmp117()
{
  if (tmp117.begin(TMP117_I2CADDR_DEFAULT, &Wire1))
  {
    Serial.println("Found TMP117 chip!");
    search->setPeriod(0);
    tasks.every(1000, &test_tmp117);
  }
  else
  {
    Serial.println("Failed to find TMP117 chip");
  }
  // Wire1.begin();
  // Serial.println("Scanning...");
  // for(uint8_t addr = 0; addr < 128; addr++) {
  //   Serial.print("addr ");
  //   Serial.print(addr);
  //   if (Wire1.requestFrom(addr++,1) > 0)
  //     Serial.print(" Found");
  //   Serial.print("\n");
  // }
  // Wire1.end();
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
  Wire1.begin();

  Serial.begin(115200);
  search = tasks.every(100, &search_for_tmp117);
  tasks.every(10, &ramp_output_channels);
}

void loop()
{
  tasks.process();
}