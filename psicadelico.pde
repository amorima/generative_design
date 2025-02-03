import de.looksgood.ani.*;
import java.io.File;

PImage img;
boolean imgLoaded = false;

int cols = 30;
int rows = 30;
PVector[][] baseGrid;
PVector[][] currentGrid;
PVector[][] targetGrid;
float maxOffset = 40;

float noiseScale = 0.1;
float noiseTime = 0;

void setup() {
  size(800, 600, P3D);
  Ani.init(this);
  
  println("Starting sketch. Opening file selector...");
  selectInput("Select an image to manipulate:", "fileSelected");
}

void draw() {
  background(0);
  
  if (imgLoaded) {
    noiseTime += 0.01;
    
    // Update grid vertices toward target positions plus a noise offset
    for (int i = 0; i <= cols; i++) {
      for (int j = 0; j <= rows; j++) {
        currentGrid[i][j].x = lerp(currentGrid[i][j].x, targetGrid[i][j].x, 0.1);
        currentGrid[i][j].y = lerp(currentGrid[i][j].y, targetGrid[i][j].y, 0.1);
        
        float n = noise(i * noiseScale, j * noiseScale, noiseTime);
        float angle = n * TWO_PI;
        float dx = cos(angle) * 5;
        float dy = sin(angle) * 5;
        currentGrid[i][j].x += dx;
        currentGrid[i][j].y += dy;
      }
    }
    
    noStroke();
    textureMode(NORMAL);
    
    // Draw the mesh
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        beginShape();
        texture(img);
        
        PVector a = currentGrid[i][j];
        PVector b = currentGrid[i+1][j];
        PVector c = currentGrid[i+1][j+1];
        PVector d = currentGrid[i][j+1];
        
        float u0 = map(i, 0, cols, 0, 1);
        float v0 = map(j, 0, rows, 0, 1);
        float u1 = map(i+1, 0, cols, 0, 1);
        float v1 = map(j+1, 0, rows, 0, 1);
        
        vertex(a.x, a.y, u0, v0);
        vertex(b.x, b.y, u1, v0);
        vertex(c.x, c.y, u1, v1);
        vertex(d.x, d.y, u0, v1);
        endShape(CLOSE);
      }
    }
  }
}

void keyPressed() {
  if (key == ' ' && imgLoaded) {
    println("Space pressed: updating grid targets.");
    for (int i = 0; i <= cols; i++) {
      for (int j = 0; j <= rows; j++) {
        float baseX = baseGrid[i][j].x;
        float baseY = baseGrid[i][j].y;
        float offsetX = random(-maxOffset, maxOffset);
        float offsetY = random(-maxOffset, maxOffset);
        Ani.to(targetGrid[i][j], 1.5, "x", baseX + offsetX);
        Ani.to(targetGrid[i][j], 1.5, "y", baseY + offsetY);
      }
    }
  }
}

void fileSelected(File selection) {
  if (selection == null) {
    println("No image file selected.");
  } else {
    println("Image selected: " + selection.getAbsolutePath());
    img = loadImage(selection.getAbsolutePath());
    if (img == null) {
      println("Error loading image.");
      return;
    }
    img.resize(width, height);
    imgLoaded = true;
    
    baseGrid = new PVector[cols+1][rows+1];
    currentGrid = new PVector[cols+1][rows+1];
    targetGrid = new PVector[cols+1][rows+1];
    
    for (int i = 0; i <= cols; i++) {
      for (int j = 0; j <= rows; j++) {
        float x = map(i, 0, cols, 0, width);
        float y = map(j, 0, rows, 0, height);
        baseGrid[i][j] = new PVector(x, y);
        currentGrid[i][j] = new PVector(x, y);
        targetGrid[i][j] = new PVector(x, y);
      }
    }
    println("Grid initialized.");
  }
}
