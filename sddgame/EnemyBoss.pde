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