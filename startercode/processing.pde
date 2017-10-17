//Might have been made by Taesung Jung, 2017
//Additional information can be found on http://www.amarok.pw

//Initialize program
void setup() {
  //Resolution, etc
  size(300,150);
  rectMode(CENTER);
  noStroke();
}

//Execute every frame
void draw() {
  fill(255, 10);
  rect(width/2, height/2, width, height);
  fill(random(255), random(255), random(255), 75);
  for(int i = 0; i < 5; i++) {
    ellipse(random(50000), random(960), 30, 200000);
  }
}

void mousePressed () {
  
}
