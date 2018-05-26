int scrollHeight;
int currentScroll = 0;
int currentStage = 1;
Stage activeStage = new stageOne();
int stageGap = 0;
int difficulty = 3;

void playScreen() {
  //Redraw background
  background(255,255,0);
  imageMode(CORNER);
  
  scrollHeight = longbg.height;
  finalScore = playScore*difficulty*100;
  
  image(longbg, topX, botY-scrollHeight+currentScroll);
  image(longbg, topX, botY-scrollHeight+currentScroll-scrollHeight);
  currentScroll+=10;
  if (currentScroll>scrollHeight) {
    currentScroll = 0;
  }
  
  imageMode(CENTER);
  
  defaultDraw();
  
  if (stageGap == 0) {
    activeStage.move();
  }
  else stageGap -= 1;
  
  if (activeStage.complete == true) {
    switch(currentStage) {
      case 1:
        activeStage = new stageTwo();
        currentStage = 2;
        stageGap = 180;
        break;
      case 2:
        activeStage = new stageThree();
        currentStage = 3;
        stageGap = 120;
        break;
      case 3:
        activeStage = new stageFour();
        currentStage = 4;
        stageGap = 120;
        break;
      case 4:
        activeStage = new stageOne();
        currentStage = 1;
        stageGap = 240;
        break;
    }
  }
  
  //Do a thing with every game object
  int i = engine.size()-1;
  while (i >= 0) {
    GameObject obj = engine.get(i); //This can represent a thing
    obj.show();
    obj.move();
    if (obj.isDead()) {
      if (playerisdead ==false) playScore += engine.get(i).points;
      engine.remove(i);
    }
    i--;
  }
  
  //The overlay menu ish thing
  image(bg, width/2, height/2);
  
  displayFire();
  displayScore();
  
  //Test if high score has been beaten when the player dies
  if (playerisdead) {
    println(playScore + " vs the " + highscore);
    if (finalScore > highscore) {
      highscore = finalScore;
      String[] temphs = split(str(highscore), ' ');
      saveStrings("hs/hs.txt", temphs);
    }
  }
}

void menuScreen() {
  image(helpimage,width/2,height/2);
  int z = menu.size()-1;
  while (z >= 0) {
    MenuButton obj = menu.get(z); //This can represent a thing
    obj.show();
    z--;
  }
}

void resetGame() {
  int i = engine.size()-1;
  while (i >= 0) {
    engine.remove(i);
    i--;
  }
  realPlayer.hp = realPlayer.maxhp;
  realPlayer.aleft = 0;
  engine.add(realPlayer);
  playerisdead = false;
  
  realPlayer.pos.x = centX;
  realPlayer.pos.y = 300;
  realPlayer.iframes = 60;
  
  activeStage = new stageOne();
  currentStage = 1;
  
  playScore = 0;
}