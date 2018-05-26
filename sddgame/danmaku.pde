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

//A GameObject for bullets


class Bullet extends GameObject {

  //Angle of the thingo
  float angle;
  PImage sprite;
  float speed;

  //Constructor
  Bullet(float _angle, float _speed, PImage _sprite, int _wx, int _wy, int _hp) {
    angle = _angle;
    sprite = _sprite;
    speed = _speed;
    wx = _wx; wy = _wy;
    
    //Location + speed
    pos.x = random(0, width);
    pos.y = 0.0;
    vel.y = speed * sin(angle);
    vel.x = speed * cos(angle);

    //Size of boolets
    //wx = 220;
    //wy = 110;
    
    sprite.resize(wx, wy);
    
    hp = _hp;
  }

  void show() {
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(angle-PI/2);
    imageMode(CENTER);
    image(sprite, 0, 0);
    popMatrix();
  }

  //Check if the thing is a deceased parrot
  boolean isDead() {
    //Destroy thing when the thing goes below the thing
    return (pos.y > height || pos.x > botX+15 || pos.x < topX-15 || pos.y < 0 || hp <1);
    
  }
}

 //Stuff the player will shoote
class PlayerBullet extends Bullet {

  //Constructor
  PlayerBullet(float angle, float speed, PImage sprite, int wx, int wy, float xpos, float ypos, int hp) {
    super(angle-PI/2, speed, sprite, wx, wy, hp);
    //Create the bullet at player location
    pos.x = xpos;
    pos.y = ypos;
    
  }
}

class PlayerIce extends PlayerBullet {
  PlayerIce(float angle, float xpos, float ypos) {
    super(angle, 10, blackstream, 8, 34, xpos, ypos, 1);
  }
}

class PlayerSnowball extends PlayerBullet { //Long projectile belonging to player that kills enemy bullets
  PlayerSnowball(float angle, float xpos, float ypos) {
    super(angle, 10, iceshard, 8, 40, xpos, ypos, 5);
  }
  
  void move() { 
    pos.add(vel);
    vel.add(accel);
    
    int i = 0;
    while (i < engine.size()) {
      GameObject hit = engine.get(i);
      //Test for hit if the object is a bullet
      if (hit instanceof EnemyBullet) {
        if (isColliding(hit)) {
          hit.hp -= 1;
        }
      }
      i++;
    }
  }
}

class TinyRed extends EnemyBullet { //Small diamond projectile
  TinyRed(float angle, float xpos, float ypos) {
    super(angle, 2, redshap, 8, 20, xpos, ypos, 1);
  }
}

class TinyCyan extends EnemyBullet { //Small diamond projectile
  TinyCyan(float angle, float xpos, float ypos) {
    super(angle, 2, cyanshap, 8, 20, xpos, ypos, 1);
  }
}

class TinyBall extends EnemyBullet { //small balls
  TinyBall(float angle, float xpos, float ypos) {
    super(angle, 4, redball, 15, 15, xpos, ypos, 1);
  }
}

class SlowBall extends EnemyBullet { //small balls
  SlowBall(float angle, float xpos, float ypos) {
    super(angle, 1, purpleball, 15, 15, xpos, ypos, 1);
  }
}

class EnemyShot1 extends EnemyBullet { //small balls
  EnemyShot1(float angle, float xpos, float ypos) {
    super(angle, 5, cyanball, 12, 12, xpos, ypos, 1);
  }
}

void displayCoords() {
  fill(255);
  rectMode(CENTER);
  noStroke();
  //rect(596, 15, 66, 15);
  fill(200,125,130);
  textAlign(CENTER);
  textSize(12);
  //text(mouseX +", "+ mouseY, 596, 19);
  if (lunaticMode) {
    text("Lunatic", 560, 455);
  }
}

void displayFPS() {
  fill(255);
  textSize(20);
  textAlign(CENTER);
  if (lunaticMode) fill(255,144,144);
  else fill(255);
  text(int(frameRate) + " FPS", 560, 470);
}

void displayScore() {
  fill(255);
  textSize(20);
  textAlign(CENTER);
  text("HScor: " + nf(highscore, 9), 527, 76);
  text("Score: " + nf(finalScore, 9), 527, 102);
}

void displayFire() {
  rectMode(CORNER);
  noStroke();
  fill(255);
  imageMode(CORNER);
  image(abbar, 464, 159);
  rect(465, 160, 130*realPlayer.aleft/realPlayer.atimer, 20);
  image(hpbar, 464, 119);
  rect(465, 120, 130-(130*realPlayer.hp/realPlayer.maxhp), 20);
  rectMode(CENTER);
  imageMode(CENTER);
  if(playerisdead) {
    textAlign(CENTER);
    text("Press R to Restart", 530, 420);
    text("Press E to Exit", 530, 390);
  }
}

class Boss extends Enemy {
  Gun gun;
  Boss(int x, int y, PImage sprite) {
    super(x, y, sprite, 45, 45);
    gun = new Gun();
    ammo = 0;
    phase = 0;
  }
  void move() {
    //Move the boss and the gun.
    pos.add(vel);
    vel.add(accel);
    gun.pos.x = pos.x;
    gun.pos.y = pos.y;
    shoot();
    alivetime += 1;
    
    //Test hitbox with stuff
    int i = 0;
    while (i < engine.size()) {
      GameObject hit = engine.get(i);
      //Test for hit if the object is a bullet
      if (hit instanceof PlayerBullet) {
        if (isColliding(hit)) {
          hp-=1;
          hit.hp -= 3;
        }
      }
      i++;
    }
    alivetime++;
    if (hp < 1) {
      bexplode(pos.x, pos.y, 21);
    }
  }
  
  void shoot() { 
  }
}

class BossOne extends Boss {
  BossOne(int x, int y) {
    super(x, y, boss1);
    gun = new Gun();
    hp = 500;
    fireRate = 20;
    fireDelay = 50;
    btimer = fireDelay;
    ammo = 0;
    phase = 0;
    phasecount = 7;
    
    vel.x = 0;
    vel.y = 0;
    
    points = 2300;
    ogpoints = 1500;
    tbonus = 800;
  }
  void shoot() {
    float angletoPlayer = atan2(realPlayer.pos.y-pos.y,realPlayer.pos.x - pos.x)-PI/2;
    //if ze e kee is held down then ado a fire a boolet (if btimer is up) only if you have ammo
    if (btimer == 0) { 
      switch(phase) { //Depending on which phase, shoot a different thing from the gun
        case 1:
          if (difficulty == 3) {
            gun.fastFanE(0, 35, TWO_PI, ammo, PI/3); // Direction, bulletcount-1, cone of fire
          }
          else {
            gun.fanFireE(angletoPlayer, 6, PI/3); // Direction, bulletcount-1, cone of fire
          }
          break;
        case 2:
          if (difficulty >= 2) {
            gun.tinyFanE(angletoPlayer, 6, PI/3); // Direction, bulletcount-1, cone of fire
          }
          break;
        case 3:
          if (difficulty == 3) {
            gun.tinyFanE(angletoPlayer, 2, PI/6);
          }
          else gun.tinyFireE(angletoPlayer);
          break;
        case 4:
          //Do nothing!
          break;
        case 5: //Fire which fans off
          gun.fastFireE(-PI/4, ammo, PI/18, 3);
          break;
        case 6: //fan off in other direction now
          gun.fastFireE(PI/4, ammo, -PI/18, 3);
          break;
        case 7:
          //idle
          break;
      }
      //Start the timer till next bullet can be fired (in frames)
      btimer = fireRate;
      ammo-=1; //-1 to ammo
    }
    btimer -= 1;
    if (ammo == 0) { //When ammo reaches zeho...
      phase += 1;
      if (phase > phasecount) phase = 1;
      loadGun(phase);
    }
  }
  
  void move() {
    if (pos.y < 100) vel.y = 1;
    else vel.y = 0;
    
    //Move the boss and the gun.
    pos.add(vel);
    vel.add(accel);
    gun.pos.x = pos.x;
    gun.pos.y = pos.y;
    shoot();
    alivetime += 1;
    
    points = ogpoints + tbonus-alivetime/10;
    
    //Test hitbox with stuff
    int i = 0;
    while (i < engine.size()) {
      GameObject hit = engine.get(i);
      //Test for hit if the object is a bullet
      if (hit instanceof PlayerBullet) {
        if (isColliding(hit)) {
          hp-=1;
          hit.hp -= 3;
        }
      }
      i++;
    }
    alivetime++;
    if (hp < 1) {
      bexplode(pos.x, pos.y, 21);
    }
  }
  
  void loadGun(int phase){
    switch(phase) {
      case 1:
        ammo = 3;
        fireRate = 10;
        break;
      case 2:
        if (difficulty == 3) {
          ammo = 3;
        }
        else ammo = 1;
        fireRate = 30;
        btimer = 50;
        break;
      case 3:
        if (difficulty == 1) {
          ammo = 18;
          fireRate = 16;
        }
        else {
          ammo = 20;
          fireRate = 12;
        }
        btimer = 40;
        break;
      case 4:
        ammo = 1;
        fireRate = 120;
        break;
      case 5:
        ammo = 12;
        fireRate = 4;
        break;
      case 6:
        ammo = 12;
        fireRate = 4;
        break;
      case 7:
        ammo = 1;
        fireRate = 120;
        break;
    }
  }
}

class BossFinal extends Boss {
  BossFinal(int x, int y) {
    super(x, y, boss1);
    gun = new Gun();
    hp = 800;
    fireRate = 20;
    fireDelay = 50;
    btimer = fireDelay;
    ammo = 0;
    phase = 0;
    phasecount = 7;
    
    vel.x = 0;
    vel.y = 0;
    
    points = 3900;
    ogpoints = 2400;
    tbonus = 1500;
  }
  void shoot() {
    float angletoPlayer = atan2(realPlayer.pos.y-pos.y,realPlayer.pos.x - pos.x)-PI/2;
    //if ze e kee is held down then ado a fire a boolet (if btimer is up) only if you have ammo
    if (btimer == 0) { 
      switch(phase) { //Depending on which phase, shoot a different thing from the gun
        case 1:
          if (ammo%2 == 0) {
            gun.fastFanE(0, 35, TWO_PI, ammo, PI/16); // Direction, bulletcount-1, cone of fire
          }
          else gun.fastFanF(0, 35, TWO_PI, ammo, PI/16); // Direction, bulletcount-1, cone of fire
          break;
        case 2:
          gun.slowFanE(0, 23, TWO_PI, ammo, PI/3);
          break;
        case 3:
          //gun.tinyFanE(angletoPlayer, 2, PI/6);
          gun.crossFireE(angletoPlayer, PI/24, ammo);
          break;
        case 4:
          gun.fastFireE(PI/4, ammo, -PI/18, 3);
          break;
        case 5: //Fire which fans off
          gun.fastFireE(-PI/4, ammo, PI/18, 3);
          break;
        case 6: //fan off in other direction now
          gun.fastFireE(PI/4, ammo, -PI/25, 3);
          break;
        case 7:
          gun.fastFireE(-PI/4, ammo, PI/25, 3);
          break;
      }
      //Start the timer till next bullet can be fired (in frames)
      btimer = fireRate;
      ammo-=1; //-1 to ammo
    }
    btimer -= 1;
    if (ammo == 0) { //When ammo reaches zeho...
      phase += 1;
      if (phase > phasecount) phase = 1;
      loadGun(phase);
    }
  }
  
  void move() {
    if (pos.y < 100) vel.y = 1;
    else vel.y = 0;
    
    //Move the boss and the gun.
    pos.add(vel);
    vel.add(accel);
    gun.pos.x = pos.x;
    gun.pos.y = pos.y;
    shoot();
    alivetime += 1;
    
    points = ogpoints + tbonus-alivetime/10;
    
    //Test hitbox with stuff
    int i = 0;
    while (i < engine.size()) {
      GameObject hit = engine.get(i);
      //Test for hit if the object is a bullet
      if (hit instanceof PlayerBullet) {
        if (isColliding(hit)) {
          hp-=1;
          hit.hp -= 3;
        }
      }
      i++;
    }
    alivetime++;
    if (hp < 1) {
      bexplode(pos.x, pos.y, 21);
    }
  }
  
  void loadGun(int phase){
    switch(phase) {
      case 1:
        ammo = 6;
        fireRate = 10;
        break;
      case 2:
        ammo = 3;
        fireRate = 30;
        btimer = 90;
        break;
      case 3:
        ammo = 60;
        fireRate = 5;
        btimer = 40;
        break;
      case 4:
        ammo = 12;
        fireRate = 4;
        break;
      case 5:
        ammo = 12;
        fireRate = 4;
        break;
      case 6:
        ammo = 11;
        fireRate = 4;
        break;
      case 7:
        ammo = 11;
        fireRate = 4;
        break;
    }
  }
}

class EnemyBullet extends Bullet {
  EnemyBullet(float angle, float speed, PImage sprite, int wx, int wy, float xpos, float ypos, int hp) {
    super(angle-(3*PI)/2, speed, sprite, wx, wy, hp);
    pos.x = xpos;
    pos.y = ypos;
  }
}

class Enemy extends GameObject {
  
  boolean hitBull = false; //Am I touching a bullet right now???
  int hp;
  PImage sprite;
  int alivetime;
  int fireDelay = 0; //The delay before the first shot
  int fireRate, btimer; //Fire rate
  int ammo = 0; //number of bullets it fires
  int phase, phasecount;
  int tbonus, ogpoints;
  
  Enemy(int locx, int locy, PImage _sprite, int _wx, int _wy) {
    pos.x = locx;
    pos.y = locy;
    sprite = _sprite;
    alivetime = 0;
    
    wx = _wx;
    wy = _wy;
    
    hp = 1;
    
    sprite.resize(wx, wy);
    points = 100;
  }
  
  void move() {
    pos.add(vel);
    vel.add(accel);
    
    //Test hitbox with stuff
    int i = 0;
    while (i < engine.size()) {
      GameObject hit = engine.get(i);
      //Test for hit if the object is a bullet
      if (hit instanceof PlayerBullet) {
        if (isColliding(hit)) {
          hp-=1;
          hit.hp -= 3;
        }
      }
      i++;
    }
    alivetime++;
    if (hp < 1) {
      explode(pos.x, pos.y, 5);
    }
  }
  
  void show() {
    fill(125,175,200);
    stroke(0);
    image(sprite, pos.x, pos.y);
  }
  
  boolean isDead() {
    return(pos.y > height+100 || pos.x > botX+115 || pos.x < topX-115 || pos.y < -100 || hp <1); 
  }
}

class TestEnemy extends Enemy {
Gun gun;
  TestEnemy(int x, int y) {
    super(x, y, jellyfish, 25, 25);
    gun = new Gun();
    hp = 1;
    fireRate = 20;
    fireDelay = 60;
    btimer = fireDelay;
    ammo = 2;
    vel.x = random(-1, 1);
    vel.y = random(1.5,2);
    points = 100;
  }
  
  void move() {
    //if ze e kee is held down then do a fire a boolet (if btimer is up) only if you have ammo
    if (btimer == 0 && ammo > 0) {
      //shoot to player?
      float angletoPlayer = atan2(realPlayer.pos.y-pos.y,realPlayer.pos.x - pos.x)-PI/2;
      if (difficulty >= 2){
        gun.tinyFanE(angletoPlayer, 2, PI/6); // Direction, bulletcount-1, cone of fire
      }
      else gun.tinyFireE(angletoPlayer);
      //Start the timer till next bullet can be fired (in frames)
      btimer = fireRate;
      ammo-=1; //-1 to ammo
    }
    btimer -= 1;
    
    pos.add(vel);
    vel.add(accel);
    gun.pos.x = pos.x;
    gun.pos.y = pos.y;
    
    //Test hitbox with stuff
    int i = 0;
    while (i < engine.size()) {
      GameObject hit = engine.get(i);
      //Test for hit if the object is a bullet
      if (hit instanceof PlayerBullet) {
        if (isColliding(hit)) {
          hp-=1;
          hit.hp -= 3;
        }
      }
      i++;
    }
    alivetime++;
    if (hp < 1) {
      explode(pos.x, pos.y, 5);
    }
  }
  
  void shoot() {
    
  }
}

class Enemy2 extends Enemy {
Gun gun;
  Enemy2(int x, int y) {
    super(x, y, enem2, 25, 25);
    gun = new Gun();
    hp = 30;
    fireRate = 60;
    fireDelay = 30;
    btimer = fireDelay;
    ammo = 12;
    vel.x = 0;
    vel.y = 0.7;
    points = 350;
  }
  
  void move() {
    
    //if ze e kee is held down then do a fire a boolet (if btimer is up) only if you have ammo
    if (btimer == 0 && ammo > 0) {
      //shoot to player?
      float angletoPlayer = atan2(realPlayer.pos.y-pos.y,realPlayer.pos.x - pos.x)-PI/2;
      if (difficulty == 1) {
        gun.fanFireE(angletoPlayer, 3, TWO_PI); // Direction, bulletcount-1, cone of fire
      }
      else gun.fanFireE(angletoPlayer, 6, TWO_PI);
      //Start the timer till next bullet can be fired (in frames)
      btimer = fireRate;
      ammo-=1; //-1 to ammo
    }
    btimer -= 1;
    
    pos.add(vel);
    vel.add(accel);
    gun.pos.x = pos.x;
    gun.pos.y = pos.y;
    
    //Test hitbox with stuff
    int i = 0;
    while (i < engine.size()) {
      GameObject hit = engine.get(i);
      //Test for hit if the object is a bullet
      if (hit instanceof PlayerBullet) {
        if (isColliding(hit)) {
          hp-=1;
          hit.hp -= 3;
        }
      }
      i++;
    }
    alivetime++;
    if (hp < 1) {
      explode(pos.x, pos.y, 5);
    }
  }
  
  void shoot() {
    
  }
}
//-----________________________________________________________________________________________________________________________________________________

abstract class GameObject {
  float dx, dy, spd; //Coordinates and speed of objects
  int wx, wy;
  PVector pos, vel, accel;
  int hp;
  int points;
  
  GameObject() {
    pos = new PVector(0, 0);
    vel = new PVector(0, 0);
    accel = new PVector(0, 0);
  }
  
  //Rendering, showing, animations, etc 
  void show() {
  }
  
  //Do whatever an object's gotta do
  void move() {
    pos.add(vel);
    vel.add(accel);
  }
  //Is the THING DEAD???
  boolean isDead() {
    return false;
  }
  
  boolean isColliding(GameObject other) {
    if (other.pos.x - other.wx/2 < this.pos.x - this.wx/2 + this.wx && this.pos.x - this.wx/2 < other.pos.x - other.wx/2 + other.wx 
    && other.pos.y - other.wy/2 < this.pos.y - this.wy/2 + this.wy 
    && this.pos.y-this.wy/2 < other.pos.y-other.wy/2 + other.wy) return true;
    else return false;
  }
  
}

class ExParticle extends GameObject {
  int lifetime = int(random(12,24));
  int life;
  int girth, posx, posy;
  ExParticle(int _girth, float posx, float posy) {
    life = lifetime;
    vel.x = random(-2,2); vel.y = random(-2,2);
    pos.x = posx; pos.y = posy;
    girth = _girth;
  }
  
  void move() {
    pos.add(vel);
    vel.add(accel);
    life--;
  }
  
  void show() {
    fill(random(255),random(255), random(255));
    rect(pos.x, pos.y, girth, girth);
  }
  
  boolean isDead() {
    return (life < 1);
  }
}

int scrollHeight;
int currentScroll = 0;
int currentStage = 1;
Stage activeStage = new stageOne();
int stageGap = 0;
int difficulty = 3;

void playScreen() {
  //Redraw background
  background(255,255,0);
  imageMode(CORNER);
  
  scrollHeight = longbg.height;
  finalScore = playScore*difficulty*100;
  
  image(longbg, topX, botY-scrollHeight+currentScroll);
  image(longbg, topX, botY-scrollHeight+currentScroll-scrollHeight);
  currentScroll+=10;
  if (currentScroll>scrollHeight) {
    currentScroll = 0;
  }
  
  imageMode(CENTER);
  
  defaultDraw();
  
  if (stageGap == 0) {
    activeStage.move();
  }
  else stageGap -= 1;
  
  if (activeStage.complete == true) {
    switch(currentStage) {
      case 1:
        activeStage = new stageTwo();
        currentStage = 2;
        stageGap = 180;
        break;
      case 2:
        activeStage = new stageThree();
        currentStage = 3;
        stageGap = 120;
        break;
      case 3:
        activeStage = new stageFour();
        currentStage = 4;
        stageGap = 120;
        break;
      case 4:
        activeStage = new stageOne();
        currentStage = 1;
        stageGap = 240;
        break;
    }
  }
  
  //Do a thing with every game object
  int i = engine.size()-1;
  while (i >= 0) {
    GameObject obj = engine.get(i); //This can represent a thing
    obj.show();
    obj.move();
    if (obj.isDead()) {
      if (playerisdead ==false) playScore += engine.get(i).points;
      engine.remove(i);
    }
    i--;
  }
  
  //The overlay menu ish thing
  image(bg, width/2, height/2);
  
  displayFire();
  displayScore();
  
  //Test if high score has been beaten when the player dies
  if (playerisdead) {
    println(playScore + " vs the " + highscore);
    if (finalScore > highscore) {
      highscore = finalScore;
      String[] temphs = split(str(highscore), ' ');
      saveStrings("hs/hs.txt", temphs);
    }
  }
}

void menuScreen() {
  image(helpimage,width/2,height/2);
  int z = menu.size()-1;
  while (z >= 0) {
    MenuButton obj = menu.get(z); //This can represent a thing
    obj.show();
    z--;
  }
}

void resetGame() {
  int i = engine.size()-1;
  while (i >= 0) {
    engine.remove(i);
    i--;
  }
  realPlayer.hp = realPlayer.maxhp;
  realPlayer.aleft = 0;
  engine.add(realPlayer);
  playerisdead = false;
  
  realPlayer.pos.x = centX;
  realPlayer.pos.y = 300;
  realPlayer.iframes = 60;
  
  activeStage = new stageOne();
  currentStage = 1;
  
  playScore = 0;
}

class Stage {
  int totalEnemies, tillNext, etimer;
  boolean complete, bossStage;
  Stage() {
  }
  void move() {
    //Summon enemy every tillNext amount of time.
    if (etimer < 0 && totalEnemies >0) {
      etimer = tillNext;
      act();
      totalEnemies -= 1;
    }
    etimer -= 1;
    if (totalEnemies <= 0) complete = true; //Finish the stage if the total is done.
    if (bossStage && enemyAlive()) {
      complete = false;
    }
  }
  void act() {
  }
}

class stageOne extends Stage {
  stageOne() {
    complete = false;
    totalEnemies = 12;
    tillNext = 30;
    etimer = tillNext;
    bossStage = false;
  }
  void act() {
    engine.add(new TestEnemy(int(random(topX+100, botX-100)), 0));
  }
}

class stageTwo extends Stage {
  stageTwo() {
    complete = false;
    totalEnemies = 1;
    tillNext = 120;
    etimer = tillNext;
    bossStage = true;
  }
  void act() {
    if (lunaticMode) engine.add(new BossFinal(int((topX+botX)/2), topY));
    else engine.add(new BossOne(int((topX+botX)/2), topY));
  }
}

class stageThree extends Stage {
  stageThree() {
    complete = false;
    totalEnemies = 3;
    tillNext = 30;
    etimer = tillNext;
    bossStage = false;
  }
  void act() {
    engine.add(new TestEnemy(int(random(topX, botX)), 0));
    engine.add(new TestEnemy(int(random(topX, botX)), 0));
    engine.add(new TestEnemy(int(random(topX, botX)), 0));
  }
}

class stageFour extends Stage {
  stageFour() {
    complete = false;
    totalEnemies = 3;
    tillNext = 210;
    etimer = tillNext;
    bossStage = true;
  }
  void act() {
    engine.add(new Enemy2(topX+100, 0));
    engine.add(new Enemy2(botX-100, 0));
  }
}

boolean enemyAlive() {
  int i = 0;
  while (i < engine.size()) {
    GameObject hit = engine.get(i);
    //Test for hit if the object is a bullet
    if (hit instanceof Enemy) {
      return true;
    }
    i++;
  }
  return false;
}

int fireTill;
int fireOf;
int iceTill;
int iceOf;

class Gun extends GameObject {
  int fireRate;
  Gun() {
  }
  
  void fanFire(float direction, int bulletCount, float aoe) {
    for (int z=bulletCount; z>=0; z--) {
      engine.add(new PlayerSnowball(aoe/bulletCount*z-aoe/2+direction, realPlayer.pos.x, realPlayer.pos.y));
    }
  }
  
  void doubleFire(int gap) {
    engine.add(new PlayerIce(0, realPlayer.pos.x+gap/2, realPlayer.pos.y));
    engine.add(new PlayerIce(0, realPlayer.pos.x-gap/2, realPlayer.pos.y));
  }
  
  void fanFireE(float direction, int bulletCount, float aoe) {
    for (int z=bulletCount; z>=0; z--) {
      engine.add(new TinyRed(aoe/bulletCount*z-aoe/2+direction, pos.x, pos.y));
    }
  }
  
  void fastFanE(float direction, int bulletCount, float aoe, int tilt, float tiltamount) {
    for (int z=bulletCount; z>=0; z--) {
      engine.add(new TinyRed(aoe/bulletCount*z-aoe/2+direction + tilt*tiltamount, pos.x, pos.y));
    }
  }
  void fastFanF(float direction, int bulletCount, float aoe, int tilt, float tiltamount) {
    for (int z=bulletCount; z>=0; z--) {
      engine.add(new TinyCyan(aoe/bulletCount*z-aoe/2+direction + tilt*tiltamount, pos.x, pos.y));
    }
  }
  
  void slowFanE(float direction, int bulletCount, float aoe, int tilt, float tiltamount) {
    for (int z=bulletCount; z>=0; z--) {
      engine.add(new SlowBall(aoe/bulletCount*z-aoe/2+direction + tilt*tiltamount, pos.x, pos.y));
    }
  }
  
  void tinyFireE(float direction) {
    engine.add(new TinyBall(direction, pos.x, pos.y));
  }
  
  void crossFireE(float direction, float tiltamount, int tilt) {
    engine.add(new TinyBall(direction+tilt*tiltamount+PI/2, pos.x, pos.y));
    engine.add(new TinyBall(direction-tilt*tiltamount+PI/2, pos.x, pos.y));
    engine.add(new TinyBall(direction+tilt*tiltamount-PI/2, pos.x, pos.y));
    engine.add(new TinyBall(direction-tilt*tiltamount-PI/2, pos.x, pos.y));
  }
  
  void tinyFanE(float direction, int bulletCount, float aoe) {
    for (int z=bulletCount; z>=0; z--) {
      engine.add(new TinyBall(aoe/bulletCount*z-aoe/2+direction, pos.x, pos.y));
    }
  }
  
  void fastFireE(float direction, int tilt, float tiltamount, int multi) {
    for (int i = 0; i < multi; i += 1) {
      engine.add(new EnemyShot1(direction + tilt*tiltamount-tiltamount*i, pos.x, pos.y));
    }
  }
}


class EnemyFan extends Gun {
  EnemyFan() {
    super(); //This is the fire rate
  }
  
  void shoot() {
    //b fire (ability)
    float angletoPlayer = atan((realPlayer.pos.x - pos.x)/(realPlayer.pos.y - pos.y));
    fanFireE(angletoPlayer, 2, PI/6); // Direction, bulletcount-1, cone of fire
  }
}

void explode(float posx, float posy, int amount) {
  for (int i = amount; i > 0; i = i-1) {
    engine.add(new ExParticle(3, posx, posy));
  }
}

void bexplode(float posx, float posy, int amount) {
  for (int i = amount; i > 0; i = i-1) {
    engine.add(new BexParticle(4, posx, posy));
  }
}

class BexParticle extends GameObject {
  int lifetime = int(random(33,75));
  int life;
  int girth, posx, posy;
  BexParticle(int _girth, float posx, float posy) {
    life = lifetime;
    vel.x = random(-3,3); vel.y = random(-3,3);
    pos.x = posx; pos.y = posy;
    girth = _girth;
  }
  
  void move() {
    pos.add(vel);
    vel.add(accel);
    life--;
  }
  
  void show() {
    fill(random(255),random(255), random(255));
    rect(pos.x, pos.y, girth, girth);
  }
  
  boolean isDead() {
    return (life < 1);
  }
}

ArrayList<MenuButton> menu;

void transition() {
  //Do the white transition here
  for (int i = tFrames; i > 0; i -= 1) {
    noStroke();
    tint(255,10);
    image(white, width/2, height/2);
    noTint();
  }
  tFrames -= 2;
}

void clearMenu() {
  int i = menu.size()-1;
  while (i >= 0) {
    menu.remove(i);
    i--;
  }
}

//Function that might display a menu button 
class MenuButton{
  String label;
  PVector pos = new PVector(0,0);
  int wx;
  int wy;
  String function;
  int argument;
  
  MenuButton(String _label, int _tall, int _wide, String _function, int _argument, int _ex, int _why) {
    label = _label;
    wx = _wide;
    wy = _tall;
    function = _function;
    argument = _argument;
    pos.x = _ex;
    pos.y = _why;
  }
  
  void show() {
    rectMode(CENTER);
    stroke(0);
    fill(123,70,200);
    if (isHover()==true) {
      fill(255,255,255);
    }
    rect(pos.x, pos.y, wx, wy);
    textAlign(CENTER, CENTER);
    fill(0);
    textSize(15);
    text(label, pos.x, pos.y);
  }
  
  void action() { //When a click is detected this is what the booton does.
    print("test");
    if (isHover() == true) { //What to do when the button is clicked:
      if (function == "resetGame") {
        //Switch to gamescreen and reset it
        switchTo("game");
        resetGame();
        difficulty = argument;
      }
      else if (function == "menuSwitch") {
        menuSwitch(argument);
      }
    }
  }
  
  boolean isHover() {
    if (mouseX < this.pos.x + this.wx/2   && this.pos.x - this.wx/2 < mouseX 
    && mouseY < this.pos.y - this.wy/2 + this.wy 
    && this.pos.y-this.wy/2 < mouseY) return true;
    else return false;
  }
  
}

void menuSwitch(int screen) {
  //First remove all the current bootons.
  clearMenu();
  tFrames = tLength;
  //Then add the new bootons based on waht the screen value is.
  switch(screen) {
    case(1): //Initial Screen
    menu.add(new MenuButton("Start Game", 40, 160, "menuSwitch", 2, 320, 200));
    menu.add(new MenuButton("Information", 40, 160, "menuSwitch", 3, 320, 270));
    helpimage = menubg;
    break;
    case(2): //the 2nd menu Screen
    menu.add(new MenuButton("Easy", 40, 175, "resetGame", 1, 320, 180));
    menu.add(new MenuButton("Kinda Easy", 40, 175, "resetGame", 2, 320, 260));
    menu.add(new MenuButton("Normal", 40, 175, "resetGame", 3, 320, 340));
    helpimage = menubg;
    break;
    case(3): //the 2nd menu Screen
    menu.add(new MenuButton("Next", 30, 120, "menuSwitch", 4, 320, 450));
    helpimage = help1;
    break;
    case(4): //the 2nd menu Screen
    menu.add(new MenuButton("Next", 30, 120, "menuSwitch", 5, 320, 450));
    helpimage = help2;
    break;
    case(5): //the 2nd menu Screen
    menu.add(new MenuButton("Return", 30, 120, "menuSwitch", 1, 320, 450));
    helpimage = help3;
    break;
  }
}

void switchTo(String a) {
  tFrames = tLength;
  currentScreen = a;
}

boolean playerisdead;
int blinkstate = 1;

//class of the controllable ship that represents the player etc
class Player extends GameObject {
  Gun gun;
  int maxhp = 6-difficulty;
  int iframes;
  int maxiframes = 40;
  int btimer, bleft;
  int atimer, aleft;
  
  Player() {
    //Location and whatnot
    pos.x = centX;
    pos.y = 300;
    spd = 3.5;
    
    gun = new Gun();//Initialise the dude's gun
    hp = maxhp;
    iframes = 60; //Invincibility frames
    wx = 1; wy = 1;
    
    //Bullet timer
    btimer = 6;
    bleft = 0;
    
    //Special Timer
    atimer = 600;
    aleft = 0;
  }

  //Render the thing whoo
  void show() {
    if (iframes > 0) {
      //Do a thing where blink every 4 frames somehow with maths
      if (frameCount%6 == 0) {
        blinkstate = blinkstate * (-1);
      }
      if (blinkstate == -1) {
        tint(123, 0, 255, 225);
      }
    }
    imageMode(CENTER);
    if (zk) image(psprite1, pos.x, pos.y);
    else image(psprite, pos.x, pos.y);
    noTint();
    
    if (shiftk){
      image(indicator, pos.x, pos.y);
    }
  }
  
  //Make sprite move according to current velocity
  void move(){
    //Move the thing
    pos.add(vel);
    
    
    //Make the speeds 0
    vel.x = 0; vel.y = 0;
    //Add speeds if buttons is helddded downs.
    if (downk && pos.y < botY) vel.y += spd;
    if (upk && pos.y > topY) vel.y -= spd;
    if (rightk && pos.x < botX) vel.x += spd;
    if (leftk && pos.x > topX) vel.x -= spd;
    
    //Fire when it's at 0 and z is pressed.
    if (zk && bleft == 0) {
      gun.doubleFire(8);
      bleft = btimer;
    }
    if (bleft>0) {
      bleft -= 1;
    }
    
    //Fire when it's at 0 and x is pressed.
    if (xk && aleft == 0) {
      gun.fanFire(0, 35, TWO_PI); // Direction, bulletcount-1, cone of fire - fires 36 bullets in a circle
      aleft = atimer;
    }
    if (aleft>0) {
      aleft -= 1;
    }
    
    //if shif is held then slow the player
    if (shiftk) spd = 2;
    else spd = 3.5;
    
    //Hittest
    int i = 0;
    
    //If you have no iframes, do hitcheck
    while (i < engine.size()) {
      GameObject hit = engine.get(i);
      //Test for hit if the object is a bullet
      if (hit instanceof EnemyBullet) {
        if (isColliding(hit)) {
          if (iframes < 1) {
            hp-=1;
            iframes = maxiframes;
            hit.hp -= 1;
          }
        }
      }
      i++;
    }
    if (hp < 1) {
      explode(pos.x, pos.y, 30);
      playerisdead = true;
    }
    if (iframes > 0) {
      iframes--;
    }
  }
  
  boolean isDead() {
    return (hp<1);
  }
}

PImage psprite, psprite1;
PImage cyanball, pinkball, cyanshap, orangeball, redshap, purpleball, redball;
PImage blackstream;
PImage iceshard;
PImage abbar, hpbar;
PImage jellyfish, enem2, boss1;
PImage gamebg, menubg, longbg;
PImage white;
PImage indicator;
PImage help1, help2, help3;
PImage helpimage;

void loadSprites() {
  psprite = loadImage("aseex/psprite.png"); //Player frame 1
  psprite1 = loadImage("aseex/psprite1.png");
  abbar = loadImage("aseex/abbar.png");
  hpbar = loadImage("aseex/hpbar.png");
  
  blackstream = loadImage("aseex/blackstream.png");
  
  orangeball = loadImage("aseex/orangeball.png");
  cyanball = loadImage("aseex/cyanball.png");
  cyanshap = loadImage("aseex/cyanshap.png");
  redshap = loadImage("aseex/redsharp.png");
  pinkball = loadImage("aseex/pinkball.png");
  purpleball = loadImage("aseex/purpleball.png");
  redball = loadImage("aseex/redball.png");
  
  iceshard = loadImage("aseex/cyanshap.png");
  
  jellyfish = loadImage("aseex/jellyfish.png");
  enem2 = loadImage("aseex/enem2.png");
  boss1 = loadImage("aseex/boss1.png");
  
  white = loadImage("aseex/white.png");
  gamebg = loadImage("aseex/gamebg.png");
  menubg = loadImage("aseex/menubg.png");
  helpimage = menubg;
  longbg = loadImage("aseex/longbg.png");
  scrollHeight = longbg.height;
  
  help1 = loadImage("aseex/help1.png");
  help2 = loadImage("aseex/help2.png");
  help3 = loadImage("aseex/help3.png");
  
  indicator = loadImage("aseex/redball.png");
  indicator.resize(6,6);
}