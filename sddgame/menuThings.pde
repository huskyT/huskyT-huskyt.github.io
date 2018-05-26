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