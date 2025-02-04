import controlP5.*;

ControlP5 cp5;
float seedValue = 0;

void setup() {
  // Janela mais larga e mais baixa:
  size(800, 400);
  
  // Cria o slider na parte inferior da janela:
  cp5 = new ControlP5(this);
  cp5.addSlider("seedValue")
     .setPosition(20, height - 40)
     .setSize(200, 20)
     .setRange(0, 1000)
     .setValue(0);
     
  smooth();
}

void draw() {
  background(255);
  
  // Usamos o valor do slider para definir o seed dos números aleatórios
  randomSeed(int(seedValue));
  
  int rows = 3;   // 3 linhas
  int cols = 20;  // 20 colunas
  
  float rowHeight = height / float(rows);
  
  // Dividimos as colunas em grupos de 3
  int groups = ceil(cols / 3.0);
  
  // Para que os grupos aumentem progressivamente de tamanho,
  // usamos um fator que cresce com o índice do grupo:
  // O grupo g (começando em 0) terá peso (g+1). A largura do grupo será proporcional a esse peso.
  float totalGroupFactor = 0;
  for (int g = 0; g < groups; g++) {
    totalGroupFactor += (g + 1);
  }
  
  // Para cada linha, definimos aleatoriamente um tipo de progressão interna:
  // 0: progressão crescente (dentro do grupo: 1, 2, 3, ...),
  // 1: progressão decrescente (dentro do grupo: 3, 2, 1, ...),
  // 2: progressão aleatória agressiva.
  int[] progressionType = new int[rows];
  for (int r = 0; r < rows; r++) {
    progressionType[r] = int(random(3));
  }
  
  // Para cada linha...
  for (int r = 0; r < rows; r++) {
    float y = r * rowHeight;
    float xCursor = 0;  // posição horizontal atual na linha
    int colCount = 0;   // contador de colunas já desenhadas na linha
    
    // Para cada grupo...
    for (int g = 0; g < groups; g++) {
      // Calcula a largura deste grupo baseada no fator progressivo
      float groupWidth = ((g + 1) / totalGroupFactor) * width;
      
      // Determina quantas colunas este grupo terá (pode ser 3 ou, no final, menos)
      int groupCols = 3;
      if (colCount + groupCols > cols) {
        groupCols = cols - colCount;
      }
      
      // Array que guardará as larguras individuais das células deste grupo
      float[] cellWidths = new float[groupCols];
      
      if (progressionType[r] == 0) {
        // Progressão crescente: larguras proporcionais a 1, 2, 3, ...
        float totalWeight = 0;
        for (int i = 0; i < groupCols; i++) {
          totalWeight += (i + 1);
        }
        for (int i = 0; i < groupCols; i++) {
          cellWidths[i] = groupWidth * ((i + 1) / totalWeight);
        }
      } 
      else if (progressionType[r] == 1) {
        // Progressão decrescente: larguras proporcionais a groupCols, groupCols-1, ..., 1
        float totalWeight = 0;
        for (int i = 0; i < groupCols; i++) {
          totalWeight += (groupCols - i);
        }
        for (int i = 0; i < groupCols; i++) {
          cellWidths[i] = groupWidth * ((groupCols - i) / totalWeight);
        }
      } 
      else {  
        // Progressão aleatória agressiva: intervalo de pesos amplo
        float totalWeight = 0;
        float[] weightsRaw = new float[groupCols];
        for (int i = 0; i < groupCols; i++) {
          // Intervalo aumentado: de 0.1 a 3.0
          weightsRaw[i] = random(0.1, 3.0);
          totalWeight += weightsRaw[i];
        }
        for (int i = 0; i < groupCols; i++) {
          cellWidths[i] = groupWidth * (weightsRaw[i] / totalWeight);
        }
      }
      
      // Desenha cada célula deste grupo
      for (int i = 0; i < groupCols; i++) {
         // Alterna cores: colunas pares = preto, ímpares = branco
         if ((colCount % 2) == 0) {
           fill(0);
         } else {
           fill(255);
         }
         stroke(0);
         rect(xCursor, y, cellWidths[i], rowHeight);
         
         // Avança o cursor horizontal e o contador de colunas
         xCursor += cellWidths[i];
         colCount++;
      }
    }
  }
}
