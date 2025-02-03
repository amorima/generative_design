import de.looksgood.ani.*;

// Classe para armazenar um valor animável
class AniValue {
  float val;
  
  AniValue(float v) {
    val = v;
  }
}

AniValue[] cols = new AniValue[10];  // Larguras de cada coluna
AniValue[] rows = new AniValue[10];  // Alturas de cada linha

void setup() {
  size(600, 600);
  Ani.init(this);
  
  // Valores iniciais para que a grelha tenha uma dimensão definida
  for (int i = 0; i < 10; i++) {
    cols[i] = new AniValue(60);
    rows[i] = new AniValue(60);
  }
}

void draw() {
  background(255);
  
  // Desenha a grelha: a cada célula é atribuído uma cor (preto ou branco) alternada
  float yPos = 0;
  for (int r = 0; r < 10; r++) {
    float xPos = 0;
    for (int c = 0; c < 10; c++) {
      // Alterna a cor com base na soma dos índices (para um efeito de tabuleiro de xadrez)
      if ((r + c) % 2 == 0) {
        fill(255);  // branco
      } else {
        fill(0);    // preto
      }
      noStroke();
      rect(xPos, yPos, cols[c].val, rows[r].val);
      xPos += cols[c].val;
    }
    yPos += rows[r].val;
  }
}

void keyPressed() {
  // Ao premir a tecla espaço, anima para novos valores aleatórios para larguras e alturas
  if (key == ' ') {
    // Anima cada coluna para uma nova largura aleatória entre 30 e 120 pixels
    for (int i = 0; i < cols.length; i++) {
      float newWidth = random(30, 120);
      Ani.to(cols[i], 1.0, "val", newWidth);
    }
    // Anima cada linha para uma nova altura aleatória entre 30 e 120 pixels
    for (int i = 0; i < rows.length; i++) {
      float newHeight = random(30, 120);
      Ani.to(rows[i], 1.0, "val", newHeight);
    }
  }
}
