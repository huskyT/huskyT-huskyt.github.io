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