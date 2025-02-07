PShape arrow;
float smallCircleDiameter;  // The diameter of the small circle

void setup() {
  size(800, 800);
  
  // Load the SVG arrow from the specified path.
  arrow = loadShape("../medias/yellow_arrow.svg");
  
  // Define the small circle’s size: 10% of the sketch width, then halved (i.e. 5% of the width)
  smallCircleDiameter = width * 0.1;
  smallCircleDiameter /= 2.0;
  
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
  float bigCircleDiameter = width;  // Full window width (800)
  float centerX = width / 2.0;
  float centerY = height / 2.0;
  ellipse(centerX, centerY, bigCircleDiameter, bigCircleDiameter);
  
  // --- Determine the position of the small circle on the big circle ---
  // Calculate the angle from the center of the window to the mouse pointer
  float angleSmall = atan2(mouseY - centerY, mouseX - centerX);
  float bigRadius = bigCircleDiameter / 2.0;
  // Position the small circle on the circumference of the big circle
  float smallCircleX = centerX + bigRadius * cos(angleSmall);
  float smallCircleY = centerY + bigRadius * sin(angleSmall);
  
  // Draw the small circle (outline only)
  stroke(100);
  strokeWeight(2);
  noFill();
  ellipse(smallCircleX, smallCircleY, smallCircleDiameter, smallCircleDiameter);
  
  // --- Draw a grid (10×10) of arrows that point toward the small circle ---
  int cols = 10;
  int rows = 10;
  float cellWidth = width / float(cols);
  float cellHeight = height / float(rows);
  
  // Retrieve the original dimensions of the arrow shape
  float arrowW = arrow.width;
  float arrowH = arrow.height;
  
  // Compute a scale factor to make the arrow fit inside a grid cell,
  // then multiply by 0.5 to draw it at 50% of that size.
  float arrowScaleFactor = min(cellWidth / arrowW, cellHeight / arrowH) * 0.5;
  
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      // Compute the center of the current grid cell
      float cellCenterX = i * cellWidth + cellWidth / 2.0;
      float cellCenterY = j * cellHeight + cellHeight / 2.0;
      
      // Calculate the angle from this cell's center to the small circle's center.
      // This is the direction the arrow should point.
      float angle = atan2(smallCircleY - cellCenterY, smallCircleX - cellCenterX);
      
      pushMatrix();
        // Translate to the center of the current cell
        translate(cellCenterX, cellCenterY);
        // Rotate so that the arrow points toward the small circle.
        // Adjust by PI/4 to account for the arrow’s default orientation of -45°.
        rotate(angle-radians(45));
        // Scale the arrow to 50% of its computed size
        scale(arrowScaleFactor);
        // Draw the arrow such that its center (or defined pivot) is at (0, 0)
        shape(arrow, -arrowW / 2.0, -arrowH / 2.0);
      popMatrix();
    }
  }
}
