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