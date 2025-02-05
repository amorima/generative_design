import processing.sound.*;

AudioIn mic;
Amplitude amp;

void setup() {
  size(800, 800, P3D);  // Enable 3D rendering
  smooth();
  
  // Set up microphone input
  mic = new AudioIn(this, 0);
  mic.start();
  
  // Set up amplitude analysis
  amp = new Amplitude(this);
  amp.input(mic);
  
  frameRate(60);
}

void draw() {
  background(200);
  lights();  // Enable default lighting for cool 3D shading
  
  // Get the current amplitude level (typically very low values)
  float level = amp.analyze();
  
  // Map the amplitude to a distortion amount (for vertex displacement)
  // Adjust mapping as needed based on your mic sensitivity.
  float distortion = map(level, 0, 0.05, 0, 100);
  
  // Map the amplitude to a normalized value for color and face count interpolation.
  float t = constrain(map(level, 0, 0.05, 0, 1), 0, 1);
  
  // As sound gets louder, increase the number of faces
  int minFaces = 4;   // At low sound: a simple quadrilateral
  int maxFaces = 20;  // At high sound: a shape with up to 20 faces (or more if you adjust)
  int faceCount = int(lerp(minFaces, maxFaces, t));
  
  // Interpolate the shape color from dark blue (low sound) to red (high sound)
  color lowColor = color(0, 0, 139);    // Dark blue
  color highColor = color(255, 0, 0);     // Red
  color shapeColor = lerpColor(lowColor, highColor, t);
  
  // Set continuous rotation (for a dynamic 3D view)
  float rotX = millis() / 2000.0;
  float rotY = millis() / 3000.0;
  float rotZ = millis() / 4000.0;
  
  // Move the origin to the center of the window and apply rotation
  translate(width/2, height/2, 0);
  rotateX(rotX);
  rotateY(rotY);
  rotateZ(rotZ);
  
  noStroke();
  fill(shapeColor);
  
  float baseRadius = 150;  // Base radius for the shape
  float time = millis() / 1000.0;  // Time variable for evolving noise
  
  beginShape();
  // Loop through each vertex of the shape
  for (int i = 0; i < faceCount; i++) {
    float angle = TWO_PI * i / faceCount;
    
    // Use Perlin noise for smooth, evolving distortion in the radius.
    // The noise input is based on the angle and current time.
    float noiseFactor = noise(cos(angle) + 1, sin(angle) + 1, time);
    float r = baseRadius + map(noiseFactor, 0, 1, -distortion, distortion);
    
    // Compute x and y positions along the circle
    float x = r * cos(angle);
    float y = r * sin(angle);
    
    // Also compute a z offset to make the shape truly 3D.
    float z = map(noise(cos(angle) * 2 + 10, sin(angle) * 2 + 10, time), 0, 1, -distortion, distortion);
    
    vertex(x, y, z);
  }
  endShape(CLOSE);
}
