class Stage {
  int totalEnemies, tillNext, etimer;
  boolean complete, bossStage;
  Stage() {
  }
  void move() {
    //Summon enemy every tillNext amount of time.
    if (etimer < 0 && totalEnemies >0) {
      etimer = tillNext;
      act();
      totalEnemies -= 1;
    }
    etimer -= 1;
    if (totalEnemies <= 0) complete = true; //Finish the stage if the total is done.
    if (bossStage && enemyAlive()) {
      complete = false;
    }
  }
  void act() {
  }
}

class stageOne extends Stage {
  stageOne() {
    complete = false;
    totalEnemies = 12;
    tillNext = 30;
    etimer = tillNext;
    bossStage = false;
  }
  void act() {
    engine.add(new TestEnemy(int(random(topX+100, botX-100)), 0));
  }
}

class stageTwo extends Stage {
  stageTwo() {
    complete = false;
    totalEnemies = 1;
    tillNext = 120;
    etimer = tillNext;
    bossStage = true;
  }
  void act() {
    if (lunaticMode) engine.add(new BossFinal(int((topX+botX)/2), topY));
    else engine.add(new BossOne(int((topX+botX)/2), topY));
  }
}

class stageThree extends Stage {
  stageThree() {
    complete = false;
    totalEnemies = 3;
    tillNext = 30;
    etimer = tillNext;
    bossStage = false;
  }
  void act() {
    engine.add(new TestEnemy(int(random(topX, botX)), 0));
    engine.add(new TestEnemy(int(random(topX, botX)), 0));
    engine.add(new TestEnemy(int(random(topX, botX)), 0));
  }
}

class stageFour extends Stage {
  stageFour() {
    complete = false;
    totalEnemies = 3;
    tillNext = 210;
    etimer = tillNext;
    bossStage = true;
  }
  void act() {
    engine.add(new Enemy2(topX+100, 0));
    engine.add(new Enemy2(botX-100, 0));
  }
}

boolean enemyAlive() {
  int i = 0;
  while (i < engine.size()) {
    GameObject hit = engine.get(i);
    //Test for hit if the object is a bullet
    if (hit instanceof Enemy) {
      return true;
    }
    i++;
  }
  return false;
}