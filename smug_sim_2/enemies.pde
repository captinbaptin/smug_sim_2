

PImage[] enemyImages;
P2[] leftEye, rightEye;
boolean[] enemyHasMouth;
P2[] mouth;
class Enemy {
  boolean active;
  int type;
  O2D core;
  float HP;
  float strength;
  int dontDeleteBuff;
  Enemy(boolean ta, int tt, float tx, float ty, float tvx, float tvy, float thp, float ts) {
    float xdim = enemyImages[tt].width, ydim = enemyImages[tt].height;
    active = ta; type = tt; core = new O2D(tx, ty, tvx, tvy, 0, xdim, ydim); strength = ts; HP = thp;
    dontDeleteBuff = 100;
  }
  void move() {
    core.move();
  }
  void accelerate(P2 acc) {
    core.accelerate(acc);
  }
  
  void attack() {
    float x = core.leftX(), y = core.topY();
    int whichSpawn = int(random(2)), whichAttack = 0;
    float damage = 3;
    if(enemyHasMouth[type] && random(1) < 0.5) { whichSpawn = 2; damage = 5; }
    if(random(1) < 0.2) { whichAttack = 1; }
    if(whichSpawn == 0) {
      x+=float(enemyImages[type].width)*leftEye[type].x;
      y+=float(enemyImages[type].height)*leftEye[type].y;
    }
    else if(whichSpawn == 1) {
      x+=float(enemyImages[type].width)*rightEye[type].x;
      y+=float(enemyImages[type].height)*rightEye[type].y;
    }
    else {
      x+=float(enemyImages[type].width)*mouth[type].x;
      y+=float(enemyImages[type].height)*mouth[type].y;
      whichAttack = 2; damage = 10;
    }
    P2 avel = new P2(playerCore.pos.x-x, playerCore.pos.y-y);
    avel.scaleMagnitude(enemyAttackSpeed);
    enemyShoot(whichAttack, x, y, avel.x, avel.y, damage);
  }
  
  void damage(float d) {
    playerScore+=d;
    HP-=d;
    if(HP <= 0) {
      active = false;
      playerScore+=strength*enemyPoints;
    }
  }
  
  void disp() {
    if(active) {
      image(enemyImages[type], core.leftX(), core.topY());
    }
  }
  
  boolean offScreen() {
    if(core.topY() > 720 || core.bottomY() < 0 || core.leftX() > 1280 || core.rightX() < 0) { return(true); }
    else { return(false); }
  }
}

int smugNum = 30;
int maxEnemies = 10;
float enemySize = 100;
float enemySpeed = 0.5, enemyXSpeed = 2;
float enemyHPConst = 20;
float enemyStrengthConst = 1;
int currentEnemies = 0;
float enemySpawnConst = 7, enemySpawnConst2 = 0.0004;
float emptyBoost = 3;
float enemyAttackConst = 0.03;
float enemyAttackSpeed = 5;
Enemy[] enemies;
void initEnemies() {
  enemyImages = new PImage[smugNum];
  leftEye = new P2[smugNum]; rightEye = new P2[smugNum];
  enemyHasMouth = new boolean[smugNum]; mouth = new P2[smugNum];
  String[] smugdata = loadStrings("smug.txt");
  for(int i = 0; i < smugNum; i++) {
    enemyImages[i] = loadImage("images/enemies/"+(i+1)+".png");
    if(enemyImages[i].width > enemyImages[i].height) {
      enemyImages[i].resize(int(enemySize), int(float(enemyImages[i].height)/(float(enemyImages[i].width)/enemySize)));
    }
    else {
      enemyImages[i].resize(int(float(enemyImages[i].width)/(float(enemyImages[i].height)/enemySize)), int(enemySize));
    }
    String[] splitsmugdata = split(smugdata[i], ' ');
    leftEye[i] = new P2(float(splitsmugdata[0]), float(splitsmugdata[1]));
    rightEye[i] = new P2(float(splitsmugdata[2]), float(splitsmugdata[3]));
    enemyHasMouth[i] = boolean(splitsmugdata[4]);
    mouth[i] = new P2(float(splitsmugdata[5]), float(splitsmugdata[6]));
  }
  
  enemies = new Enemy[maxEnemies];
  resetEnemies();
}

void resetEnemies() {
  for(int i = 0; i < enemies.length; i++) {
    enemies[i] = new Enemy(false, 0, 0, 0, 0, 0, 0, 0);
  }
}



void updateEnemies() {
  if(!landed && !entering && !leaving) {
    currentEnemies = 0;
    for(int i = 0; i < enemies.length; i++) { if(enemies[i].active) { currentEnemies++; } }
    float spawnPressure = enemySpawnConst-float(currentEnemies);
    if(currentEnemies == 0) { spawnPressure*=emptyBoost; }
    if(currentEnemies < maxEnemies && spawnPressure > 0) {
      if(random(1) < enemySpawnConst2*spawnPressure*spawnPressure) {
        spawnEnemy();
      }
    }
  }
  for(int i = 0; i < enemies.length; i++) {
    if(enemies[i].active) {
      enemies[i].move();
      if(enemies[i].dontDeleteBuff < 0 && enemies[i].offScreen()) { enemies[i].active = false; }
      else {
        enemies[i].dontDeleteBuff--;
        if(random(1) < enemyAttackConst) {
          enemies[i].attack();
        }
      }
    }
  }
}

void spawnEnemy() {
  if(!gameOver) {
    int buff = inactiveEnemy();
    int rtype = unusedEnemyType();
    enemies[buff] = new Enemy(true, rtype, 1280+enemySize, random(720-enemySize)+enemySize/2,
                              -velocity*enemyXSpeed+2*random(enemySpeed)-2*enemySpeed, 2*random(enemySpeed)-enemySpeed,
                              enemyHPConst, enemyStrengthConst);
  }
}
int unusedEnemyType() {
  int ans = 0;
  boolean taken = true;
  do {
    ans = int(random(smugNum));
    taken = false;
    for(int i = 0; i < enemies.length; i++) {
      if(enemies[i].active && enemies[i].type == ans) { taken = true; }
    }
  } while(taken);
  return(ans);
}


void dispEnemies() {
  for(int i = 0; i < enemies.length; i++) {
    enemies[i].disp();
  }
}




int inactiveEnemy() {
  int ans = 0;
  for(int i = 0; i < enemies.length; i++) {
    if(!enemies[i].active) { ans = i; }
  }
  return(ans);
}
