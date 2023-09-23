const int buttonPin = 2;
int buttonState = 0; 

bool pressed = false;

void setup() {
  Serial.begin(9600);
  pinMode(buttonPin, INPUT);
}

void loop() {
  buttonState = digitalRead(buttonPin);
 
  if (buttonState == HIGH) {
    if(pressed == false){
      Serial.println("press");
    }
    pressed = true;
  } else {
    pressed = false;
  }
}
