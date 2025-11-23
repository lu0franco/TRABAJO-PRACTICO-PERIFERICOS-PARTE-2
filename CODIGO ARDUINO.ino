const int ledPins[] = {2, 3};
const int btnPins[] = {4, 5};
int ledStates[] = {0, 0};
int btnStates[] = {0, 0};

void setup() {
  Serial.begin(9600);
  for (int i = 0; i < 2; i++) {
    pinMode(ledPins[i], OUTPUT);
    pinMode(btnPins[i], INPUT_PULLUP);
  }
}

void loop() {
  // Leer botones y prender LEDs si se aprieta
  for (int i = 0; i < 2; i++) {
    btnStates[i] = !digitalRead(btnPins[i]); // LOW = presionado
    if (btnStates[i]) {
      ledStates[i] = 1;
    }
    digitalWrite(ledPins[i], ledStates[i]);
  }

  // Enviar estados a Processing
  String output = String(ledStates[0]) + "," + String(ledStates[1]) + "," +
                  String(btnStates[0]) + "," + String(btnStates[1]);
  Serial.println(output);

  // Recibir comandos desde Processing
  if (Serial.available() > 0) {
    String input = Serial.readStringUntil('\n');
    input.trim();
    if (input.length() == 2) {
      ledStates[0] = input[0] - '0';
      ledStates[1] = input[1] - '0';
    }
  }

  delay(100);
}