boolean WPressed = false, APressed = false, SPressed = false, DPressed = false, spacePressed = false;
boolean LMPressed = false;


void keyPressed() {
  if(keyCode == ESC) {
    key = 0;
    menu = !menu;
  }
  if(key == 'w' || key == 'W') {
    WPressed = true;
  }
  if(key == 'a' || key == 'A') {
    APressed = true;
  }
  if(key == 's' || key == 'S') {
    SPressed = true;
  }
  if(key == 'd' || key == 'D') {
    DPressed = true;
  }
  if(key == ' ') {
    spacePressed = true;
  }
  if(key == 'u' || key == 'U') {
    if(gameOver) {
      resetGame();
    }
  }
}

void keyReleased() {
  if(key == 'w' || key == 'W') {
    WPressed = false;
  }
  if(key == 'a' || key == 'A') {
    APressed = false;
  }
  if(key == 's' || key == 'S') {
    SPressed = false;
  }
  if(key == 'd' || key == 'D') {
    DPressed = false;
  }
  if(key == ' ') {
    spacePressed = false;
  }
}


void mousePressed() {
  if(mouseButton == LEFT) {
    LMPressed = true;
    if(shotDelayCounter <= 0) {
      playerShoot();
    }
  }
}

void mouseReleased() {
  if(mouseButton == LEFT) {
    LMPressed = false;
  }
}
