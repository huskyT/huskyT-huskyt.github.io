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