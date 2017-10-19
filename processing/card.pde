class card {
  void exist(int solX, int solY, String val, String suit) {
    rectMode(CENTER);
    
    //Draw the card
    fill(255);
    stroke(0);
    rect(solX, solY, 60,90);
    
    //Middle Symbol
    if (suit=="heart" || suit=="diamond") {
      fill(255,000,000); //Color of shape/number
    }
    else {
      fill(0);
    }
    noStroke();
    if (suit == "n") {
      fill(255, 255, 255, 0);
    }
    else if (suit=="heart" || suit=="club") {
      rect(solX, solY, 20, 20);
    }
    else {
      quad(solX+14, solY, solX, solY+14, solX-14, solY, solX, solY-14);
    }
    
    //Draw the values
    textMode(CENTER);
    text(val, solX+17, solY+40);
    text(val, solX-17, solY-17);
  }
  
  void cycle() {
    lastSuit = curSuit;
    lastVal = curVal;
    curSuit = suits[int(random(1, 4))];
    curVal = values[int(random(1,13))];
  }
}