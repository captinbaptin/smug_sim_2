



void setup() {
  size(1280, 720, JAVA2D);
  
  init();
  
  //enemies[0] = new Enemy(true, 0, width/2, height/2, 0, 0, 20, 0);
}





void draw() {
  pushMatrix();
  if(menu) {
    gameDisp();
    dispMenu();
  }
  else {
    gameCalc();
    gameDisp();
  }
  //println(frameRate);
  //println(playerCore.pos.x, playerCore.pos.y);
  popMatrix();
}





void gameCalc() {
  updateEnvironment();
  updateItems();
  updateEnemies();
  updateBoss();
  updateEnemyAttacks();
  updatePlayer();
  updatePlayerAttacks();
  updateRumble();
  debugGameCalc();
}

void gameDisp() {
  rumbleStart();
  background(0);
  dispEnvironmentBackGround();
  dispItems();
  dispEnemies();
  dispBoss();
  dispEnvironmentForeground();
  dispPlayer();
  dispEnemyAttacks();
  dispPlayerAttacks();
  rumbleEnd();
  dispHUD();
  if(gameOver) { dispHighScores(); }
}





void init() {
  initMenu();
  initHighScores();
  initRumble();
  initEnvironment();
  initItems();
  initBosses();
  initEnemies();
  initPlayerAttacks();
  initEnemyAttacks();
  initPlayer();
}







void resetGame() {
  gameOver = false;
  resetEnvironment();
  resetPlayerAttacks();
  resetEnemyAttacks();
  resetEnemies();
  resetItems();
  resetPlayer();
  resetRumble();
  resetBosses();
}

boolean gameOver = false;
void gameOver() {
  gameOver = true;
}
