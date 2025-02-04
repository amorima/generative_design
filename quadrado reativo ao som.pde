import processing.sound.*;

AudioIn mic;
Amplitude amp;

void setup() {
  size(800, 800);
  
  // Set up the microphone input and start it.
  mic = new AudioIn(this, 0);
  mic.start();
  
  // Set up amplitude analysis.
  amp = new Amplitude(this);
  amp.input(mic);
  
  frameRate(60);
}

void draw() {
  background(255);
  
  // Analyze the current amplitude from the microphone.
  float level = amp.analyze();
  
  // Map the amplitude to a distortion value.
  // Adjust these parameters if needed based on your microphone sensitivity.
  float distortion = map(level, 0, 0.05, 0, 50);
  
  // Map the amplitude to a value between 0 and 1 for color interpolation.
  float t = constrain(map(level, 0, 0.05, 0, 1), 0, 1);
  
  // Define the two colors: dark blue for low sound and red for high sound.
  color lowColor = color(0, 0, 139);  // Dark blue
  color highColor = color(255, 0, 0);   // Red
  
  // Interpolate between lowColor and highColor based on t.
  color squareColor = lerpColor(lowColor, highColor, t);
  
  // Define the center and base size of the square.
  float cx = width / 2.0;
  float cy = height / 2.0;
  float squareSize = 200;
  float half = squareSize / 2.0;
  
  // Distort each corner of the square by adding a random offset in the range [-distortion, distortion].
  float x1 = cx - half + random(-distortion, distortion);
  float y1 = cy - half + random(-distortion, distortion);
  
  float x2 = cx + half + random(-distortion, distortion);
  float y2 = cy - half + random(-distortion, distortion);
  
  float x3 = cx + half + random(-distortion, distortion);
  float y3 = cy + half + random(-distortion, distortion);
  
  float x4 = cx - half + random(-distortion, distortion);
  float y4 = cy + half + random(-distortion, distortion);
  
  // Draw the distorted square with the interpolated color.
  noStroke();
  fill(squareColor);
  beginShape();
    vertex(x1, y1);
    vertex(x2, y2);
    vertex(x3, y3);
    vertex(x4, y4);
  endShape(CLOSE);
}
