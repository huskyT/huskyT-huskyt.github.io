int p1;
int p2;
String lWin = "None";
boolean winr = false;
String Winner;
PImage bg;
int winAt = 10;
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
  bg = loadImage("bg.jpg");
  textAlign(CENTER);
  textMode(CENTER);
  textSize(28);
}

void draw() {
  RGBCycle();
  background(bg);
  c1.exist(400, 300, curVal, curSuit);
  colorMode(HSB);
  fill(200, 150, 255);
  
  text("Last Round Winner: " + lWin, width/2, 530);
  if (winr == false) {
    text("First player to " + winAt + " points wins!", width/2, 500);
  }
  else {
    text("Winner!: " + Winner, width/2, 500);
  }
  text(">" + cardPile + "<", width/2, 250);
  if(p1 >= winAt) {
    fill(56, 255, 255);
  }
  else if (p1+cardPile >= winAt) {
    fill(hue, 255, 255);
  }
  text("Player 1: " + p1 + "pt", 100, 55);
  fill(200, 150, 255);
  if(p2 >= winAt) {
    fill(56, 255, 255);
  }
  else if (p2+cardPile >= winAt) {
    fill(hue, 255, 255);
  }
  
  text("Player 2: " + p2 + "pt", 700, 55);
  fill(200, 150, 255);
  colorMode(RGB);
  
  //turn indicator
  stroke(0);
  //p1
  if (player1 == true) {
    
  }
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