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