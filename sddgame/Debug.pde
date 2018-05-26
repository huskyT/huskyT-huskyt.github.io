void displayCoords() {
  fill(255);
  rectMode(CENTER);
  noStroke();
  //rect(596, 15, 66, 15);
  fill(200,125,130);
  textAlign(CENTER);
  textSize(12);
  //text(mouseX +", "+ mouseY, 596, 19);
  if (lunaticMode) {
    text("Lunatic", 560, 455);
  }
}

void displayFPS() {
  fill(255);
  textSize(20);
  textAlign(CENTER);
  if (lunaticMode) fill(255,144,144);
  else fill(255);
  text(int(frameRate) + " FPS", 560, 470);
}

void displayScore() {
  fill(255);
  textSize(20);
  textAlign(CENTER);
  text("HScor: " + nf(highscore, 9), 527, 76);
  text("Score: " + nf(finalScore, 9), 527, 102);
}

void displayFire() {
  rectMode(CORNER);
  noStroke();
  fill(255);
  imageMode(CORNER);
  image(abbar, 464, 159);
  rect(465, 160, 130*realPlayer.aleft/realPlayer.atimer, 20);
  image(hpbar, 464, 119);
  rect(465, 120, 130-(130*realPlayer.hp/realPlayer.maxhp), 20);
  rectMode(CENTER);
  imageMode(CENTER);
  if(playerisdead) {
    textAlign(CENTER);
    text("Press R to Restart", 530, 420);
    text("Press E to Exit", 530, 390);
  }
}