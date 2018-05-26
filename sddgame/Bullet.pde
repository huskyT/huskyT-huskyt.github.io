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