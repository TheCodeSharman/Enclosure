

#include <Arduino.h>
#include <Wire.h>
#include <Adafruit_TMP117.h>

#include "Settings.h"

const uint8_t LED_PIN = LED_BUILTIN;
const uint8_t CHANNEL_PINS[] = {18u, 19u, 20u, 21u};

const uint8_t I2C_ADDRESS = 0x18;

MultiTask tasks;
MultiTask::CallbackFunction* search_for_tmp117_task;
MultiTask::CallbackFunction* read_tmp117_task;
Adafruit_TMP117 tmp117;

unsigned int ramp = 0;

void request_event() {
  Wire.write("hello");
}


void read_temperture()
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
    search_for_tmp117_task->setPeriod(0);
    read_tmp117_task = tasks.every(1000,read_temperture);
  }
  else
  {
    Serial.println("Failed to find TMP117 chip");
  }
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
  Serial.begin(115200);
  
  for (int i = 0; i < 4; i++)
  {
    pinMode(CHANNEL_PINS[i], OUTPUT);
  }

  Wire.setSDA(0x4);
  Wire.setSCL(0x5);
  Wire.begin(I2C_ADDRESS);
  Wire.onRequest(request_event);

  Wire1.setSDA(0x6);
  Wire1.setSCL(0x7);

  search_for_tmp117_task = tasks.every(100, &search_for_tmp117);
  tasks.every(10, &ramp_output_channels);
}

void loop()
{
  tasks.process();
}