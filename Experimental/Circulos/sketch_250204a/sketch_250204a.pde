PShape arrow;
float smallCircleDiameter;  // diameter of the small moving circle

void setup() {
  size(800, 800);
  // Load the SVG arrow from the given path
  arrow = loadShape("../medias/yellow_arrow.svg");
  
  // Define the small circle’s size: initially 10% of the sketch size,
  // then made twice as small (i.e. half of that) → 800 * 0.1 = 80, then 80/2 = 40.
  smallCircleDiameter = width * 0.1; 
  smallCircleDiameter /= 2.0;
  
  // Use smooth drawing
  smooth();
}

void draw() {
  // Set a light gray background
  background(200);
  
  // --- Draw the background grid in a darker gray ---
  stroke(100);
  strokeWeight(1);
  int gridCount = 10;
  float cellSize = width / float(gridCount);
  
  // Draw vertical and horizontal grid lines
  for (int i = 0; i <= gridCount; i++) {
    line(i * cellSize, 0, i * cellSize, height);
    line(0, i * cellSize, width, i * cellSize);
  }
  
  // --- Draw the big circle (outline only) covering the window ---
  noFill();
  stroke(100);
  strokeWeight(2);
  float bigCircleDiameter = width;  // equals 800 in this sketch
  float centerX = width / 2.0;
  float centerY = height / 2.0;
  ellipse(centerX, centerY, bigCircleDiameter, bigCircleDiameter);
  
  // --- Determine the position of the small circle on the big circle ---
  // Calculate the angle from the canvas center to the mouse pointer.
  float angleSmall = atan2(mouseY - centerY, mouseX - centerX);
  float bigRadius = bigCircleDiameter / 2.0;
  // The small circle's center is on the circumference of the big circle.
  float smallCircleX = centerX + bigRadius * cos(angleSmall);
  float smallCircleY = centerY + bigRadius * sin(angleSmall);
  
  // Draw the small circle (outline only)
  stroke(100);
  strokeWeight(2);
  noFill();
  ellipse(smallCircleX, smallCircleY, smallCircleDiameter, smallCircleDiameter);
  
  // --- Draw a grid (10x10) of arrows that point toward the small circle ---
  int cols = 10;
  int rows = 10;
  float cellWidth = width / float(cols);
  float cellHeight = height / float(rows);
  
  // Get the original arrow dimensions (as set in the SVG)
  float arrowW = arrow.width;
  float arrowH = arrow.height;
  
  // Compute a scale factor so that the arrow would normally fill the cell,
  // then multiply by 0.5 to draw it at 50% of that computed size.
  float arrowScaleFactor = min(cellWidth / arrowW, cellHeight / arrowH) * 0.5;
  
  // Loop over each grid cell
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      // Compute the center of the current cell
      float cellCenterX = i * cellWidth + cellWidth / 2.0;
      float cellCenterY = j * cellHeight + cellHeight / 2.0;
      
      // Compute the angle from the cell center to the small circle’s center
      float angle = atan2(smallCircleY - cellCenterY, smallCircleX - cellCenterX);
      
      pushMatrix();
        // Move to the center of the cell
        translate(cellCenterX, cellCenterY);
        // Rotate so that the arrow points toward the small circle.
        // Since the arrow’s default orientation is -45° (i.e. -PI/4),
        // we add PI/4 to the computed angle.
        rotate(angle + PI/4);
        // Scale the arrow down to 50% of its computed size
        scale(arrowScaleFactor);
        // Draw the arrow centered at (0,0)
        shape(arrow, -arrowW / 2.0, -arrowH / 2.0);
      popMatrix();
    }
  }
}
