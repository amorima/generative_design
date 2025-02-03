PImage img;
int gridSize = 30;
float deformationIntensity = 0;

void setup() {
  size(600, 600);
  // Certifique-se de que a imagem "hello.png" está na pasta "data" do seu sketch
  img = loadImage("hello.png");
  img.resize(width, height);
}

void draw() {
  background(255);
  
  // Carrega os pixels da imagem
  loadPixels();
  img.loadPixels();
  
  // Aplica deformação triangular
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      // Encontra o triângulo ao qual o pixel pertence
      int gridX = x / gridSize;
      int gridY = y / gridSize;
      
      // Calcula a posição dentro do grid
      float localX = (x % gridSize) / (float)gridSize;
      float localY = (y % gridSize) / (float)gridSize;
      
      // Decide em qual metade do quadrado o pixel está
      boolean isUpperTriangle = (localX + localY) < 1;
      
      // Aplica distorção baseada no triângulo
      float distortX, distortY;
      
      if (isUpperTriangle) { // Para mudar a deformação, mudar o último valor de cada linha (ex.: [* 10]  =>  [* 3])
        distortX = sin(gridX * gridY * 0.1 + deformationIntensity) * 10;
        distortY = cos(gridX * gridY * 0.1 + deformationIntensity) * 10;
      } else {
        distortX = cos(gridX * gridY * 0.1 + deformationIntensity) * 10;
        distortY = sin(gridX * gridY * 0.1 + deformationIntensity) * 10;
      }
      
      int sourceX = constrain(x + int(distortX), 0, width - 1);
      int sourceY = constrain(y + int(distortY), 0, height - 1);
      
      int loc = x + y * width;
      int sourceLoc = sourceX + sourceY * width;
      
      pixels[loc] = img.pixels[sourceLoc];
    }
  }
  
  updatePixels();
  
  // Desenha grade de triângulos
  stroke(255, 0, 0, 50);
  for (int x = 0; x < width; x += gridSize) {
    line(x, 0, x, height);
  }
  for (int y = 0; y < height; y += gridSize) {
    line(0, y, width, y);
  }
  
  // Texto de feedback
  fill(255, 0, 0);
  textSize(16);
  text("Triangulation Deformation: " + nf(deformationIntensity, 0, 2), 10, 20);
}

void keyPressed() {
  // Quando a tecla espaço for pressionada
  if (key == ' ') {
    // Incrementa o nível de deformação
    deformationIntensity += 0.3;
    
    // Reseta se passar de 3
    if (deformationIntensity > 3) {
      deformationIntensity = 0;
    }
  }
}
