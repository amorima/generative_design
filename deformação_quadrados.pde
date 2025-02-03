// Usamos o renderizador P3D para habilitar recursos 3D (necessário para mapeamento de textura com vértices)
PImage img;          // Imagem carregada
boolean imgLoaded = false;  // Flag para indicar se a imagem já foi carregada

// Definições da grelha
int gridCols = 6;   // Número de células horizontais
int gridRows = 6;   // Número de células verticais
PVector[][] gridPoints;   // Posições atuais dos pontos da grelha (dimensão: (gridCols+1) x (gridRows+1))
PVector[][] gridTargets;  // Destinos para onde cada ponto deve se mover (baseados na posição "ideal" + deslocamento)
float maxOffset = 20;     // Deslocamento máximo (em pixels) para cada ponto

// Taxa de interpolação (quanto menor, mais lenta a transição)
float lerpFactor = 0.1;

void setup() {
  // Tamanho inicial – se a imagem for carregada, ela será desenhada em escala.
  size(800, 800, P3D);
  // Solicita a seleção da imagem
  selectInput("Selecione uma imagem:", "fileSelected");
}

void draw() {
  background(0);
  
  if (imgLoaded) {
    // Atualiza as posições dos pontos interpolando para os destinos
    updateGridPoints();
    
    // Desenha a imagem distorcida, usando a grelha para mapear as texturas
    drawWarpedImage();
  }
}

// Atualiza os pontos da grelha aproximando-os dos seus destinos
void updateGridPoints() {
  for (int i = 0; i <= gridCols; i++) {
    for (int j = 0; j <= gridRows; j++) {
      gridPoints[i][j].x = lerp(gridPoints[i][j].x, gridTargets[i][j].x, lerpFactor);
      gridPoints[i][j].y = lerp(gridPoints[i][j].y, gridTargets[i][j].y, lerpFactor);
    }
  }
}

// Desenha a imagem usando pequenos quadriláteros texturizados
void drawWarpedImage() {
  // Habilita textura e desativa contornos
  noStroke();
  textureMode(NORMAL);
  
  // Percorre cada célula da grelha (cada quadrilátero)
  for (int i = 0; i < gridCols; i++) {
    for (int j = 0; j < gridRows; j++) {
      // Calcula as coordenadas de textura para cada vértice,
      // com base na posição relativa na imagem
      float u0 = map(i, 0, gridCols, 0, 1);
      float v0 = map(j, 0, gridRows, 0, 1);
      float u1 = map(i+1, 0, gridCols, 0, 1);
      float v1 = map(j+1, 0, gridRows, 0, 1);
      
      beginShape();
      texture(img);
      // Vértice superior-esquerdo
      vertex(gridPoints[i][j].x, gridPoints[i][j].y, u0, v0);
      // Vértice superior-direito
      vertex(gridPoints[i+1][j].x, gridPoints[i+1][j].y, u1, v0);
      // Vértice inferior-direito
      vertex(gridPoints[i+1][j+1].x, gridPoints[i+1][j+1].y, u1, v1);
      // Vértice inferior-esquerdo
      vertex(gridPoints[i][j+1].x, gridPoints[i][j+1].y, u0, v1);
      endShape(CLOSE);
    }
  }
}

// Quando a tecla espaço é pressionada, gera novos destinos para os pontos da grelha
void keyPressed() {
  if (key == ' ') {
    // Para cada ponto da grelha, calcula o destino: posição ideal + deslocamento aleatório
    for (int i = 0; i <= gridCols; i++) {
      for (int j = 0; j <= gridRows; j++) {
        // Posição "ideal" (sem deslocamento)
        float idealX = map(i, 0, gridCols, 0, width);
        float idealY = map(j, 0, gridRows, 0, height);
        // Novo destino: posição ideal + deslocamento aleatório no intervalo [-maxOffset, maxOffset]
        float dx = random(-maxOffset, maxOffset);
        float dy = random(-maxOffset, maxOffset);
        gridTargets[i][j].set(idealX + dx, idealY + dy);
      }
    }
  }
}

// Callback chamado após a seleção da imagem
void fileSelected(File selection) {
  if (selection == null) {
    println("Nenhuma imagem selecionada.");
  } else {
    img = loadImage(selection.getAbsolutePath());
    // Redimensiona a imagem para caber na tela, se necessário.
    img.resize(width, height);
    imgLoaded = true;
    
    // Inicializa as matrizes da grelha (dimensão: gridCols+1 x gridRows+1)
    gridPoints = new PVector[gridCols+1][gridRows+1];
    gridTargets = new PVector[gridCols+1][gridRows+1];
    
    for (int i = 0; i <= gridCols; i++) {
      for (int j = 0; j <= gridRows; j++) {
        float x = map(i, 0, gridCols, 0, width);
        float y = map(j, 0, gridRows, 0, height);
        gridPoints[i][j] = new PVector(x, y);
        // Inicialmente, os destinos são iguais às posições ideais
        gridTargets[i][j] = new PVector(x, y);
      }
    }
  }
