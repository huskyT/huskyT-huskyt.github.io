/* @pjs preload="bg.jpg" */
int p1;
int p2;
PImage bg;
String lWin = "None";
boolean winr = false;
String Winner;
int winAt = 100;
card c1 = new card();
boolean player1 = true;
String lastSuit;
String lastVal;
String curSuit = "n";
String curVal = "n";
int cardPile;
String[] suits = {"heart", "spade", "diamond", "club" };
String[] values = {"A", "2", "3", "4", "5", "6", "7", "8", "9", "T", "J", "Q", "K" };

void setup() {
  size(800,600);
  textAlign(CENTER);
  textMode(CENTER);
  textSize(28);
  bg = loadImage("bg.jpg");
  bg.loadPixels();
  for (int i = 0; i < bg.pixels.length; i++) {
    bg.pixels[i] = color(0, 90, 102); 
  }
  bg.updatePixels();
}

void draw() {
  RGBCycle();
  background(bg);
  c1.exist(400, 300, curVal, curSuit);
  colorMode(HSB);
  fill(200, 150, 255);
  
  text("Last Round Winner: " + lWin, width/2, 540);
  if (winr == false) {
    text("First player to " + winAt + " points wins!", width/2, 500);
  }
  else {
    text("Winner!: " + Winner, width/2, 500);
  }
  
  //cards in the pile
  text(">" + cardPile + "<", width/2, 247);
  if(p1 >= winAt) {
    fill(56, 255, 255);
  }
  else if (p1+cardPile >= winAt) {
    fill(hue, 255, 255);
  }
  text("Player 1: " + p1 + "pt", 150, 55);
  fill(200, 150, 255);
  if(p2 >= winAt) {
    fill(56, 255, 255);
  }
  else if (p2+cardPile >= winAt) {
    fill(hue, 255, 255);
  }
  
  text("Player 2: " + p2 + "pt", 650, 55);
  fill(200, 150, 255);
  colorMode(RGB);
  
  //turn indicator
  stroke(0);
  //p1
  if (player1 == true) {
    fill(255,200, 190);
  }
  else {
    fill(255, 255, 255, 0);
  }
  rect(385, 365, 20, 20);
  
  if (player1 == false) {
    fill(190, 255, 255);
  }
  else {
    fill(255, 255, 255, 0);
  }
  rect(415, 365, 20, 20);
}

void keyPressed() {
  if (key == 'A' || key == 'a') {
    if (player1 == true) {
      c1.cycle();
      cardPile += 1;
      player1 = false;
    }
  }
  if (key == 'k' || key == 'K') {
    if (player1 == false) {
      c1.cycle();
      cardPile += 1;
      player1 = true;
    }
  }
  if (key == 's' || key == 'S') {
    if (lastVal == curVal) {
      p1 += cardPile;
      cardPile = 0;
      lWin = "Player 1";
      curSuit = "n";
    }
    else {
      p2 += cardPile;
      cardPile = 0;
      lWin = "Player 2";
      curSuit = "n";
    }
  }
  if (key == 'L' || key == 'l') {
    if (lastVal == curVal) {
      p2 += cardPile;
      cardPile = 0;
      lWin = "Player 2";
      curSuit = "n";
    }
    else {
      p1 += cardPile;
      cardPile = 0;
      lWin = "Player 1";
      curSuit = "n";
    }
  }
  
  if (winr == false) {
    if (p1 >= winAt){
      Winner = "Player 1";
      winr = true;
    }
    else if (p2 >= winAt) {
      Winner = "Player 2";
      winr = true;
    }
  }
}

class card {
  void exist(int solX, int solY, String val, String suit) {
    rectMode(CENTER);
    
    //Draw the card
    fill(255);
    stroke(0);
    rect(solX, solY, 60,90);
    
    //Middle Symbol
    if (suit=="heart" || suit=="diamond") {
      fill(255,000,000); //Color of shape/number
    }
    else {
      fill(0);
    }
    noStroke();
    if (suit == "n") {
      fill(255, 255, 255, 0);
    }
    else if (suit=="heart" || suit=="club") {
      rect(solX, solY, 20, 20);
    }
    else {
      quad(solX+14, solY, solX, solY+14, solX-14, solY, solX, solY-14);
    }
    
    //Draw the values
    textMode(CENTER);
    text(val, solX+17, solY+40);
    text(val, solX-17, solY-17);
  }
  
  void cycle() {
    lastSuit = curSuit;
    lastVal = curVal;
    curSuit = suits[int(random(1, 4))];
    curVal = values[int(random(1,13))];
  }
}

//Initial declare hue
int hue = 0;

color RGBCycle() {
  colorMode(HSB);
  hue += 2;
  if (hue>255) {
    hue = 0;
  }
  color returnColor = color(hue,0,0);
  colorMode(RGB);
  return(returnColor);
}
