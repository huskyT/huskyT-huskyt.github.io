
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