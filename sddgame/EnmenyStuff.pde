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