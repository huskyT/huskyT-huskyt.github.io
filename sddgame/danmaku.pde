/*

Created by Taesung Jung on 24.05.18.
Copyright © 2018 Taesung Jung. All rights reserved.

Version - BETA 1.7

rex0355@gmail.com
http://github.com/huskyT

*/

int highscore;
ArrayList<GameObject> engine;
PImage bg;
String currentScreen; //Use menu, game, help, instruction,
int playScore, finalScore;
boolean lunaticMode;

boolean upk, downk, rightk, leftk, zk, xk, shiftk;
Player realPlayer;

int tFrames = 60; //frames of animation left for transition
int tLength = tFrames; //animation length.

//Variables for convenience
int centX = 224; //Co-orinates of game area
int centY = 240;
int wid = 384; //height and width of game area
int hei = 448;
int topX = 32;
int topY = 16;
int botX = 415;
int botY = 463;

void setup() {
  rectMode(CENTER);
  size(640,480,FX2D); //Use FX2D maybe
  
  imageMode(CENTER);
  
  engine = new ArrayList<GameObject>(200); //Capacity of array list
  menu = new ArrayList<MenuButton>(200); //Capacity of array list
  bg = loadImage("aseex/background.png");
  
  loadSprites();
  
  menuSwitch(1); //Start off the menu screen on the inital page.
  
  realPlayer = new Player();
  engine.add(realPlayer);
  playerisdead = false;
  frameRate(60);
  
  currentScreen = "menu";
  String[] temphs = loadStrings("hs/hs.txt");
  highscore = int(temphs[0]);
  println(highscore);
}

void draw() {
  if (currentScreen == "game") {
    playScreen();
  }
  else if (currentScreen == "menu") {
    menuScreen();
  }
  displayCoords();
  displayFPS();
  transition();
}

void keyPressed() {
  if (key == 'z' || key == 'Z') zk = true;
  if (key == 'x' || key == 'X') xk = true;
  if (keyCode == DOWN) downk = true;
  if (keyCode == UP) upk = true;
  if (keyCode == RIGHT) rightk = true;
  if (keyCode == LEFT) leftk = true;
  if (keyCode == SHIFT) shiftk = true;
  if (key == 'r' || key == 'R') {
    //Reset game if you're in the game screen
    if (currentScreen == "game") {
      resetGame();
      tFrames = tLength;
    }
  }
  if (keyCode == '1') difficulty = 1;
  if (keyCode == '2') difficulty = 2;
  if (keyCode == '3') difficulty = 3;
}

void keyReleased() {
  if (key == 'z' || key == 'Z') zk = false;
  if (key == 'x' || key == 'X') xk = false;
  if (keyCode == DOWN) downk = false;
  if (keyCode == UP) upk = false;
  if (keyCode == RIGHT) rightk = false;
  if (keyCode == LEFT) leftk = false;
  if (keyCode == SHIFT) shiftk = false;
  if (key == 'L' || key == 'l') lunaticMode = ! lunaticMode;
  if ((key == 'E' || key == 'e')&& playerisdead) { 
    currentScreen = "menu";
    menuSwitch(1);
  }
}

//Default color etc
void defaultDraw() {
  colorMode(RGB);
  tint(255,255);
  fill(255);
}

void mouseClicked() {
  int z = menu.size()-1;
  while (z >= 0 && currentScreen == "menu") {
    MenuButton obj = menu.get(z); //This can represent a thing
    obj.action();
    z--;
  }
}