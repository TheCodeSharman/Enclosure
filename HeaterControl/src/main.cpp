#include <Arduino.h>


const uint8_t LED_PIN = LED_BUILTIN; 

const uint8_t CHANNEL_PINS[] = { 18u, 19u, 20u, 21u };


void setup() {
  // put your setup code here, to run once
  for(int i = 0; i<4; i++) {
    pinMode(CHANNEL_PINS[i], OUTPUT);
  }
  for(int i = 0; i<4; i++) {
    digitalWrite(CHANNEL_PINS[i], HIGH);  
  }
}

void loop() {

  
}