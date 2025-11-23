import processing.serial.*;

Serial puerto;
int[] leds = {0, 0};
int[] btns = {0, 0};
int tam = 80;
int espacio = 100;
int margenX = 120;
int margenY = 100;

void setup() {
  size(500, 400);
  println(Serial.list());
  puerto = new Serial(this, Serial.list()[0], 9600);
}

void draw() {
  background(240);

  textAlign(CENTER);
  textSize(18);
  fill(0);
  text("ENTRADAS", margenX + tam, margenY - 30);

  // Dibujar entradas (E1, E2)
  for (int i = 0; i < 2; i++) {
    fill(btns[i] == 1 ? color(255, 0, 0) : color(180));
    rect(margenX + i * (tam + espacio), margenY, tam, tam);
    fill(0);
    text("E" + (i+1), margenX + i * (tam + espacio) + tam/2, margenY + tam + 20);
  }

  text("SALIDAS", margenX + tam, margenY + 150);
  
  // Dibujar salidas (L1, L2)
  for (int i = 0; i < 2; i++) {
    fill(leds[i] == 1 ? color(0, 255, 0) : color(180));
    rect(margenX + i * (tam + espacio), margenY + 180, tam, tam);
    fill(0);
    text("L" + (i+1), margenX + i * (tam + espacio) + tam/2, margenY + 180 + tam + 20);
  }

  // Leer serial
  if (puerto.available() > 0) {
    String data = puerto.readStringUntil('\n');
    if (data != null) {
      data = data.trim();
      String[] parts = split(data, ',');
      if (parts.length == 4) {
        leds[0] = int(parts[0]);
        leds[1] = int(parts[1]);
        btns[0] = int(parts[2]);
        btns[1] = int(parts[3]);
      }
    }
  }
}

void mousePressed() {
  // Detectar clic en los LEDS (L1 o L2)
  for (int i = 0; i < 2; i++) {
    int x = margenX + i * (tam + espacio);
    int y = margenY + 180;
    if (mouseX > x && mouseX < x + tam && mouseY > y && mouseY < y + tam) {
      leds[i] = 1 - leds[i];
      enviarEstados();
    }
  }
}

void enviarEstados() {
  String out = str(leds[0]) + str(leds[1]) + "\n";
  puerto.write(out);
}