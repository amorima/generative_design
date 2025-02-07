/*
Keys:
  f: Toggle full screen.
  c: Capture the current frame in SVG and PNG.
  r: Randomize the background, grid, eyes, and logo colors.
  s: Toggle the type of shape drawn in the cells:
       0 - "Cut-out" triangle
       1 - Organic ellipse (organic outline with 20 points)
       2 - Abstract quadrilateral (distorted quadrilateral)
       3 - Abstract blob (organic shape with 8 points)
       4 - Abstract star (irregular star with 10 points)
  0: Reset to the initial configuration.
Click/Drag: Zoom or trigger the wave animation (the shapes morph smoothly as the wave passes).
*/

// Auxiliary function to generate contours according to the mode and size (in local coordinates)
PVector[] generateShape(int mode, float size) {
  PVector[] verts;
  int n;
  switch(mode) {
    case 0:
      // Triangle
      n = 3;
      verts = new PVector[n];
      int pivot = int(random(4));
      float aFactor = random(0.5, 1.0);
      float bFactor = random(0.4, 0.8);
      if (pivot == 0) {
        verts[0] = new PVector(0, 0);
        verts[1] = new PVector(aFactor * size, 0);
        verts[2] = new PVector(0, bFactor * size);
      } else if (pivot == 1) {
        verts[0] = new PVector(size, 0);
        verts[1] = new PVector(size - aFactor * size, 0);
        verts[2] = new PVector(size, bFactor * size);
      } else if (pivot == 2) {
        verts[0] = new PVector(size, size);
        verts[1] = new PVector(size - aFactor * size, size);
        verts[2] = new PVector(size, size - bFactor * size);
      } else {
        verts[0] = new PVector(0, size);
        verts[1] = new PVector(aFactor * size, size);
        verts[2] = new PVector(0, size - bFactor * size);
      }
      break;
    case 1:
      // Organic ellipse – 20 points around the center, with random radii
      n = 20;
      verts = new PVector[n];
      for (int i = 0; i < n; i++) {
        float angle = map(i, 0, n, 0, TWO_PI);
        float r = random(size * 0.3, size * 0.5);
        verts[i] = new PVector(size/2 + r * cos(angle), size/2 + r * sin(angle));
      }
      break;
    case 2:
      // Abstract quadrilateral – 4 points with perturbation
      n = 4;
      verts = new PVector[n];
      for (int i = 0; i < n; i++) {
        float angle = PI/2 * i;
        float r = size/2 + random(-size * 0.1, size * 0.1);
        verts[i] = new PVector(size/2 + r * cos(angle), size/2 + r * sin(angle));
      }
      break;
    case 3:
      // Abstract blob – 8 points
      n = 8;
      verts = new PVector[n];
      for (int i = 0; i < n; i++) {
        float angle = map(i, 0, n, 0, TWO_PI);
        float r = random(size * 0.3, size * 0.6);
        verts[i] = new PVector(size/2 + r * cos(angle), size/2 + r * sin(angle));
      }
      break;
    case 4:
      // Abstract star – 10 points, alternating fixed and random radius
      n = 10;
      verts = new PVector[n];
      for (int i = 0; i < n; i++) {
        float angle = map(i, 0, n, 0, TWO_PI);
        float r = (i % 2 == 0) ? size * 0.5 : random(size * 0.2, size * 0.4);
        verts[i] = new PVector(size/2 + r * cos(angle), size/2 + r * sin(angle));
      }
      break;
    default:
      n = 3;
      verts = new PVector[n];
      verts[0] = new PVector(0, 0);
      verts[1] = new PVector(size, 0);
      verts[2] = new PVector(0, size);
      break;
  }
  return verts;
}

// Auxiliary function to clone an array of PVectors
PVector[] cloneShape(PVector[] shape) {
  PVector[] newShape = new PVector[shape.length];
  for (int i = 0; i < shape.length; i++) {
    newShape[i] = shape[i].copy();
  }
  return newShape;
}

// ===================================================
// Global variables and sketch setup
// ===================================================
import processing.svg.*;
import java.awt.Frame;
import java.awt.GraphicsDevice;
import java.awt.GraphicsEnvironment;
import processing.awt.PSurfaceAWT;

PShape logo;
PShape olho;

int cellSize = 60;
int cols, rows;
Cell[][] grid;

float waveDelayFactor = 0.5;

float zoomFactor = 1.0;
float initialZoomFactor = 1.0;
float dragStartX, dragStartY;
boolean draggingForZoom = false;

boolean isFullScreen = false;
Frame nativeFrame;
GraphicsDevice device;

int prevW, prevH;

boolean capturingSVG = false;
int captureCount = 0;
String captureFilename = "";

boolean randomColors = false;
color bgColor = color(27,73,63);
color gridRectColor = color(0);
color gridTriColor = color(255);
color eyeColor;
color dominantColor, complementaryColor;
color logoColor;

int cellShapeMode = 0;

void setup() {
  //size(1920, 960);
  fullScreen(1);
  pixelDensity(displayDensity());
  smooth();
  
  logo = loadShape("../data/logo.svg");
  olho = loadShape("../data/olho.svg");
  
  PSurfaceAWT surf = (PSurfaceAWT) surface;
  PSurfaceAWT.SmoothCanvas canvas = (PSurfaceAWT.SmoothCanvas) surf.getNative();
  nativeFrame = canvas.getFrame();
  device = GraphicsEnvironment.getLocalGraphicsEnvironment().getDefaultScreenDevice();
  
  reinitializeGrid();
  prevW = width;
  prevH = height;
  
  frameRate(120);
}

void draw() {
  if (capturingSVG) {
    beginRecord(SVG, captureFilename);
  }
  
  if (width != prevW || height != prevH) {
    reinitializeGrid();
    prevW = width;
    prevH = height;
  }
  
  background(bgColor);
  
  pushMatrix();
    scale(zoomFactor);
    float currentTime = millis();
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        grid[i][j].update(currentTime);
        grid[i][j].display();
      }
    }
  popMatrix();
  
  shapeMode(CENTER);
  float logoX = width/2;
  float logoY = height/2;
  if (randomColors) {
    logo.disableStyle();
    noStroke();
    fill(logoColor);
    shape(logo, logoX, logoY);
  } else {
    noTint();
    shape(logo, logoX, logoY);
  }
  
  float eye1OffsetX = -124.51;
  float eye1OffsetY = -20.51;
  float eye2OffsetX = 150.49;
  float eye2OffsetY = -20.51;
  float eye1X = logoX + eye1OffsetX;
  float eye1Y = logoY + eye1OffsetY;
  float eye2X = logoX + eye2OffsetX;
  float eye2Y = logoY + eye2OffsetY;
  
  float angle1 = atan2(mouseY - eye1Y, mouseX - eye1X);
  pushMatrix();
    translate(eye1X, eye1Y);
    rotate(angle1 + PI/2);
    olho.disableStyle();
    noStroke();
    fill(randomColors ? eyeColor : 0);
    shape(olho, 0, 0);
  popMatrix();
  
  float angle2 = atan2(mouseY - eye2Y, mouseX - eye2X);
  pushMatrix();
    translate(eye2X, eye2Y);
    rotate(angle2 + PI/2);
    olho.disableStyle();
    noStroke();
    fill(randomColors ? eyeColor : 0);
    shape(olho, 0, 0);
  popMatrix();
  
  if (capturingSVG) {
    endRecord();
    capturingSVG = false;
    println("Saved " + captureFilename);
    String pngFilename = captureFilename.substring(0, captureFilename.lastIndexOf('.')) + ".png";
    saveFrame(pngFilename);
    println("Saved " + pngFilename);
  }
}

void mousePressed() {
  dragStartX = mouseX;
  dragStartY = mouseY;
  initialZoomFactor = zoomFactor;
  draggingForZoom = false;
}

void mouseDragged() {
  if (dist(dragStartX, dragStartY, mouseX, mouseY) > 5) {
    draggingForZoom = true;
    float deltaY = mouseY - dragStartY;
    zoomFactor = initialZoomFactor * (1 - deltaY / 300.0);
    zoomFactor = constrain(zoomFactor, 0.1, 10);
  }
}

void mouseReleased() {
  if (!draggingForZoom) {
    float worldMouseX = mouseX / zoomFactor;
    float worldMouseY = mouseY / zoomFactor;
    float currentTime = millis();
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        Cell cell = grid[i][j];
        float cellCenterX = cell.x + cell.size/2;
        float cellCenterY = cell.y + cell.size/2;
        float d = dist(worldMouseX, worldMouseY, cellCenterX, cellCenterY);
        float delay = d * waveDelayFactor;
        cell.startAnimation(currentTime, delay);
      }
    }
  }
}

void keyPressed() {
  if (key == 'f' || key == 'F') {
    isFullScreen = !isFullScreen;
    if (isFullScreen) {
      int newW = device.getDisplayMode().getWidth();
      int newH = device.getDisplayMode().getHeight();
      device.setFullScreenWindow(nativeFrame);
      surface.setSize(newW, newH);
    } else {
      device.setFullScreenWindow(null);
      surface.setSize(1920, 960);
    }
  }
  
  if (key == 'c' || key == 'C') {
    captureCount++;
    captureFilename = String.format("captures/hoot_%04d.svg", captureCount);
    capturingSVG = true;
    println("Capturing frame to " + captureFilename);
  }
  
  if (key == 'r' || key == 'R') {
    colorMode(HSB, 360, 100, 100);
    float hue = random(0,360);
    boolean isDominantDark = random(1) < 0.5;
    float sat = random(70,90);
    float domB, compB;
    if(isDominantDark) {
      domB = random(25,40);
      compB = random(85,95);
    } else {
      domB = random(85,95);
      compB = random(25,40);
    }
    dominantColor = color(hue, sat, domB);
    float compHue = (hue+180) % 360;
    complementaryColor = color(compHue, sat, compB);
    colorMode(RGB,255);
    
    bgColor = complementaryColor;
    gridRectColor = dominantColor;
    gridTriColor = complementaryColor;
    eyeColor = dominantColor;
    
    float lum = 0.299*red(dominantColor)+0.587*green(dominantColor)+0.114*blue(dominantColor);
    logoColor = (lum<128) ? color(255) : color(0);
    
    randomColors = true;
  }
  
  if (key == 's' || key == 'S') {
    // Update the mode and then update all cells to use the new mode
    cellShapeMode = (cellShapeMode + 1) % 5;
    println("Cell shape mode: " + cellShapeMode);
    // For each cell, update the contour according to the new mode
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        Cell cell = grid[i][j];
        cell.currentShape = generateShape(cellShapeMode, cell.size);
        cell.previousShape = cloneShape(cell.currentShape);
        cell.targetShape = cloneShape(cell.currentShape);
      }
    }
  }
  
  if (key == '0') {
    randomColors = false;
    cellShapeMode = 0;
    bgColor = color(27,73,63);
    gridRectColor = color(0);
    gridTriColor = color(255);
    zoomFactor = 1.0;
    reinitializeGrid();
    println("Reset to initial configuration.");
  }
}

void reinitializeGrid() {
  cols = (int) ceil(width/(float)cellSize);
  rows = (int) ceil(height/(float)cellSize);
  grid = new Cell[cols][rows];
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      grid[i][j] = new Cell(i*cellSize, j*cellSize, cellSize);
    }
  }
}

// ===================================================
// Cell class – each cell stores the current, previous, and target contours,
// generated according to the mode (cellShapeMode). During the animation,
// it interpolates between previousShape and targetShape.
// ===================================================
class Cell {
  float x, y, size;
  PVector[] currentShape, previousShape, targetShape;
  float animStartTime;
  float animDuration;
  boolean animating;
  float animProgress;
  
  Cell(float x, float y, float size) {
    this.x = x;
    this.y = y;
    this.size = size;
    currentShape = generateShape(cellShapeMode, size);
    previousShape = cloneShape(currentShape);
    targetShape = cloneShape(currentShape);
    animating = false;
    animStartTime = 0;
    animDuration = 500;
    animProgress = 1;
  }
  
  // Start the animation: copy the current contour to previousShape and generate a new targetShape
  void startAnimation(float currentTime, float delay) {
    for (int i = 0; i < currentShape.length; i++) {
      previousShape[i] = currentShape[i].copy();
    }
    targetShape = generateShape(cellShapeMode, size);
    // If the number of vertices changed, adjust to avoid errors:
    if (targetShape.length != previousShape.length) {
      currentShape = targetShape;
      previousShape = cloneShape(targetShape);
    }
    animStartTime = currentTime + delay;
    animDuration = 500;
    animating = true;
  }
  
  // Update the animation by interpolating between previousShape and targetShape
  void update(float currentTime) {
    float t;
    if (animating) {
      t = (currentTime - animStartTime) / animDuration;
      if(t < 0) t = 0;
      else if(t >= 1) { t = 1; animating = false; }
    } else {
      t = 1;
    }
    animProgress = t;
    if(previousShape.length == targetShape.length) {
      for (int i = 0; i < currentShape.length; i++) {
        currentShape[i].x = lerp(previousShape[i].x, targetShape[i].x, t);
        currentShape[i].y = lerp(previousShape[i].y, targetShape[i].y, t);
      }
    } else {
      currentShape = targetShape;
    }
  }
  
  // Draw the current contour offset by position (x, y)
  void display() {
    noStroke();
    if (randomColors) fill(gridRectColor); else fill(0);
    rect(x, y, size+2, size+2);
    
    if (randomColors) fill(gridTriColor); else fill(255);
    beginShape();
      for (int i = 0; i < currentShape.length; i++) {
        vertex(x + currentShape[i].x, y + currentShape[i].y);
      }
    endShape(CLOSE);
  }
}
