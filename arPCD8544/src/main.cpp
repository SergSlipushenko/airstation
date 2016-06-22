#include <SPI.h>
#include <Wire.h>
#include <Adafruit_GFX.h>
#include <Adafruit_PCD8544.h>

// Software SPI (slower updates, more flexible pin options):
// pin 7 - Serial clock out (SCLK)
// pin 6 - Serial data out (DIN)
// pin 5 - Data/Command select (D/C)
// pin 4 - LCD chip select (CS)
// pin 3 - LCD reset (RST)
Adafruit_PCD8544 display = Adafruit_PCD8544(7, 6, 5, 4, 3);
String serialBuffer = "";

void execMessage(String msg);
void receiveEvent(int howMany);

void execMessage(String msg) {
  String cmd = msg.substring(0,3);
  Serial.println(cmd);
  String args = msg.substring(3);
  Serial.println(args);
  if (cmd == "DSP") {
    display.display();}
  else if (cmd == "CLR") {
    display.clearDisplay();
    display.setCursor(0,0);}
  else if (cmd == "CNT") {
    display.setContrast(args.toInt());}
  else if (cmd == "CRS") {
    display.setCursor(args.substring(0,2).toInt(), args.substring(2,4).toInt());}
  else if (cmd == "TSZ") {
    display.setTextSize(args.toInt());}
  else if (cmd == "PRL") {
    display.println(args);}
  else if (cmd == "PRN") {
    display.print(args);}
  else if (cmd == "I2C") {
    Wire.begin((uint8_t)args.toInt());               
    Wire.onReceive(receiveEvent);}
  else { 
    Serial.println("Unknown command :(");}
}

void receiveEvent(int howMany) {
  String data = "";
  data.reserve(howMany);
  while (Wire.available()) { 
    char c = (char)Wire.read();
    data += c;
  }
  execMessage(data);
}

void setup() {
  serialBuffer.reserve(32);
  Serial.begin(9600);
  Wire.begin(42);
  Wire.onReceive(receiveEvent);
  display.begin();              
  display.setContrast(52);      
  display.setTextSize(2);
  display.setTextColor(BLACK);
  display.setCursor(0,0);
  display.clearDisplay();       
  display.display();   
  display.println("Ready");
  display.println("to");
  display.println("go!");
  display.display();
  Serial.println("Setup done");
}

void loop() {
  while (Serial.available()) {
    char c = (char) Serial.read();
    if (c == 13) {
      Serial.println("");
      execMessage(serialBuffer);
      serialBuffer="";}
    else if ( c > 15) {
      serialBuffer += c;
      Serial.write(c);
   }
  }
  delay(42);
}
