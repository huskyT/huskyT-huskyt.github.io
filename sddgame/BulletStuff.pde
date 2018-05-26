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