// Step-by-step guide and example code for Processing.

// 1. In Processing, create a new sketch and specify the size:
//    void setup() {
//      size(1920, 960);
//    }
//    Also, add fullScreen() if you want it to run maximized.

// 2. Load your .svg images (logo.svg and olho.svg) using loadShape()
//    inside setup(). Something like:
//    PShape logo;
//    PShape olho;
//
//    void setup() {
//      size(1920, 960);
//      background(0);
//      logo = loadShape("../assets/logo.svg");
//      olho = loadShape("../assets/olho.svg");
//    }

// 3. In draw(), set the background to black each frame:
//    void draw() {
//      background(0);
//
// 4. Place the logo at the center of the canvas with its original size.
//    You can position it by calculating the center or by using shapeMode(CENTER).
//    For example:
//      shapeMode(CENTER);
//      shape(logo, width/2, height/2);
//
//    If shapeMode(CORNER) is default, you might need an offset to place it precisely.

// 5. Place two "eyes" using your olho.svg at the coordinates x=743,y=390 and x=1018,y=390.
//    You can do something like:
//      // Eye 1
//      pushMatrix();
//      translate(743, 390);
//      // Possibly center the shape by offsetting half its width/height
//      shape(olho, 0, 0);
//      popMatrix();
//
//      // Eye 2
//      pushMatrix();
//      translate(1018, 390);
//      shape(olho, 0, 0);
//      popMatrix();
//
//    The above places the eyes. But we still need to make them track the mouse.

// 6. To have each eye "look" at the mouse, we can rotate the eye shape toward the mouse.
//    The general idea:
//      // We find the angle from the center of the eye to the mouse
//      float angle = atan2(mouseY - eyeCenterY, mouseX - eyeCenterX);
//
//      // We then rotate the shape by that angle.
//      pushMatrix();
//      translate(eyeCenterX, eyeCenterY);
//      // If the shape originally points to the right, but we want the default to be upwards,
//      // we can subtract PI/2 from the angle:
//      rotate(angle - PI/2);
//      // Then draw the shape, offset to center it properly:
//      shape(olho, -olho.width/2, -olho.height/2);
//      popMatrix();
//
//    We'll do this for both eyes independently.

// 7. Putting it all together, a minimal example might look like this:

PShape logo;
PShape olho;

void setup() {
  size(1920, 960);
  // If you want to open in full screen, use fullScreen();
  // fullScreen();

  logo = loadShape("../data/logo.svg");
  olho = loadShape("../data/olho.svg");
}

void draw() {
  background(0);

  // Draw the logo in the center
  shapeMode(CENTER);
  shape(logo, width/2, height/2);

  // Eye 1: coordinates ~ (743, 390)
  float eye1X = 835.49;
  float eye1Y = 459.49;

  // Calculate angle
  float angle1 = atan2(mouseY - eye1Y, mouseX - eye1X);

  // Draw first eye
  pushMatrix();
    translate(eye1X, eye1Y);
    // Subtract PI/2 if your shape originally faces right but should default to up
    rotate(angle1 + PI/2);
    shapeMode(CENTER);
    shape(olho, 0, 0);
  popMatrix();

  // Eye 2: coordinates ~ (1018, 390)
  float eye2X = 1110.49;
  float eye2Y = 459.49;

  // Calculate angle
  float angle2 = atan2(mouseY - eye2Y, mouseX - eye2X);

  // Draw second eye
  pushMatrix();
    translate(eye2X, eye2Y);
    rotate(angle2 + PI/2);
    shapeMode(CENTER);
    shape(olho, 0, 0);
  popMatrix();
}

// 8. That’s it! With this setup, the eyes will follow your mouse pointer.
//    Each eye is calculated independently, so they track the mouse from their own positions.
//    The background is black, the size is 1920 x 960, the logo is centered, and the eyes track.
//    Adjust any offsets or rotations as needed if the default orientation of olho.svg is different.
