int numCurves = 10;       // Fewer curves for simpler rendering
float noiseScale = 0.01;
float time = 0;

void setup() {
  size(800, 800);
  noFill();
  strokeWeight(1);       // Thinner lines
  background(255);
}

void draw() {
  background(255);
  time += 0.01;
  
  for (int i = 0; i < numCurves; i++) {
    float offset = map(i, 0, numCurves, 0, TWO_PI);
    
    // Monochromatic stroke (black)
    stroke(0);
    
    beginShape();
    for (float x = 0; x <= width; x += 5) {
      // Amplitude mapped from mouseY, so moving the mouse vertically changes the wave height
      float amplitude = map(mouseY, 0, height, 50, 300);
      // Adding mouseX * noiseScale to make horizontal position react to mouseX
      float y = height/2 
                + sin(x * noiseScale + offset + time + mouseX * 0.01) 
                * amplitude 
                * noise(x * noiseScale, time);
      vertex(x, y);
    }
    endShape();
  }
}
