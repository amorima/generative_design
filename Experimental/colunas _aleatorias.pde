import controlP5.*;
import processing.svg.*;
import processing.pdf.*;

ControlP5 cp5;
float seedValue = 0;

void setup() {
  size(800, 400);
  noStroke();  // Garante que não haja stroke
  smooth();
  
  cp5 = new ControlP5(this);
  
  // Slider na parte inferior da janela
  cp5.addSlider("seedValue")
     .setPosition(20, height - 40)
     .setSize(200, 20)
     .setRange(0, 1000)
     .setValue(0);
  
  // Botão para salvar em SVG
  cp5.addButton("saveSVG")
     .setLabel("SAVE SVG")
     .setPosition(240, height - 40)
     .setSize(100, 20);
     
  // Botão para salvar em PDF
  cp5.addButton("savePDF")
     .setLabel("SAVE PDF")
     .setPosition(360, height - 40)
     .setSize(100, 20);
}

void draw() {
  background(255);
  drawScene();
}

// Toda a lógica de desenho está concentrada nesta função
void drawScene() {
  // Garante que não haja stroke durante o desenho (mesmo em exportação)
  noStroke();
  
  // Usamos o valor do slider para definir a semente dos números aleatórios
  randomSeed(int(seedValue));
  
  int rows = 3;   // 3 linhas
  int cols = 20;  // 20 colunas
  
  float rowHeight = height / float(rows);
  
  // Dividimos as colunas em grupos de 3
  int groups = ceil(cols / 3.0);
  
  // Cada grupo aumenta progressivamente em largura
  float totalGroupFactor = 0;
  for (int g = 0; g < groups; g++) {
    totalGroupFactor += (g + 1);
  }
  
  // Define o tipo de progressão interna para cada linha:
  // 0 = crescente, 1 = decrescente, 2 = "aleatória agressiva"
  int[] progressionType = new int[rows];
  for (int r = 0; r < rows; r++) {
    progressionType[r] = int(random(3));
  }
  
  // Desenha cada linha
  for (int r = 0; r < rows; r++) {
    float y = r * rowHeight;
    float xCursor = 0;   // Posição horizontal atual
    int colCount = 0;    // Contador de colunas desenhadas
    
    // Para cada grupo...
    for (int g = 0; g < groups; g++) {
      // Largura do grupo baseada no fator progressivo (g+1)
      float groupWidth = ((g + 1) / totalGroupFactor) * width;
      
      // Quantas colunas neste grupo?
      int groupCols = 3;
      if (colCount + groupCols > cols) {
        groupCols = cols - colCount;
      }
      
      // Array para armazenar as larguras das células deste grupo
      float[] cellWidths = new float[groupCols];
      
      if (progressionType[r] == 0) {
        // Crescente: larguras proporcionais a (1, 2, 3, ...)
        float totalWeight = 0;
        for (int i = 0; i < groupCols; i++) {
          totalWeight += (i + 1);
        }
        for (int i = 0; i < groupCols; i++) {
          cellWidths[i] = groupWidth * ((i + 1) / totalWeight);
        }
      } 
      else if (progressionType[r] == 1) {
        // Decrescente: larguras proporcionais a (groupCols, groupCols-1, ...)
        float totalWeight = 0;
        for (int i = 0; i < groupCols; i++) {
          totalWeight += (groupCols - i);
        }
        for (int i = 0; i < groupCols; i++) {
          cellWidths[i] = groupWidth * ((groupCols - i) / totalWeight);
        }
      } 
      else {
        // "Aleatória agressiva": pesos variam de 0.1 a 3.0
        float totalWeight = 0;
        float[] weightsRaw = new float[groupCols];
        for (int i = 0; i < groupCols; i++) {
          weightsRaw[i] = random(0.1, 3.0);
          totalWeight += weightsRaw[i];
        }
        for (int i = 0; i < groupCols; i++) {
          cellWidths[i] = groupWidth * (weightsRaw[i] / totalWeight);
        }
      }
      
      // Desenha cada célula do grupo
      float xCurrent = xCursor;
      for (int i = 0; i < groupCols; i++) {
        // Alterna cores: colunas pares = preto, ímpares = branco
        if ((colCount % 2) == 0) {
          fill(0);
        } else {
          fill(255);
        }
        rect(xCurrent, y, cellWidths[i], rowHeight);
        xCurrent += cellWidths[i];
        colCount++;
      }
      xCursor += groupWidth;
    }
  }
}

// Verifica os eventos dos controles (botões)
void controlEvent(ControlEvent theEvent) {
  if (theEvent.isFrom("saveSVG")) {
    promptForSVGSave();
  } else if (theEvent.isFrom("savePDF")) {
    promptForPDFSave();
  }
}

// Abre uma caixa de diálogo para salvar SVG
void promptForSVGSave() {
  selectOutput("Select a location to save your SVG file", "fileSelectedSVG");
}

// Abre uma caixa de diálogo para salvar PDF
void promptForPDFSave() {
  selectOutput("Select a location to save your PDF file", "fileSelectedPDF");
}

// Callback para o diálogo de salvamento de SVG
void fileSelectedSVG(File selection) {
  if (selection == null) {
    println("User canceled the save dialog.");
  } else {
    String path = selection.getAbsolutePath();
    if (!path.toLowerCase().endsWith(".svg")) {
      path += ".svg";
    }
    println("Saving SVG to: " + path);
    beginRecord(SVG, path);
      drawScene();
    endRecord();
    println("SVG saved successfully!");
  }
}

// Callback para o diálogo de salvamento de PDF
void fileSelectedPDF(File selection) {
  if (selection == null) {
    println("User canceled the save dialog.");
  } else {
    String path = selection.getAbsolutePath();
    if (!path.toLowerCase().endsWith(".pdf")) {
      path += ".pdf";
    }
    println("Saving PDF to: " + path);
    beginRecord(PDF, path);
      drawScene();
    endRecord();
    println("PDF saved successfully!");
  }
}
