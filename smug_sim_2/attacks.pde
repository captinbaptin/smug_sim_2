

PImage[] playerAttackImages;
class PlayerAttack {
  boolean active;
  int type;
  O2D core;
  float damage;
  PlayerAttack(boolean ta, int tt, float tx, float ty, float tvx, float tvy, float tdiameter, float td) {
    active = ta; type = tt; core = new O2D(tx, ty, tvx, tvy, 1, tdiameter, 0); damage = td;
  }
  void move() {
    core.move();
  }
  void accelerate(P2 acc) {
    core.accelerate(acc);
  }
  
  boolean offScreen() {
    if(core.topY() > 720 || core.bottomY() < 0 || core.leftX() > 1280 || core.rightX() < 0) { return(true); }
    else { return(false); }
  }
  boolean hitGround() {
    return(core.bottomY() > 720-activeGroundHeight);
  }
  
  void disp() {
    if(active) {
      image(playerAttackImages[type], core.leftX(), core.topY());
    }
  }
}

float playerAttackSpeed = 10;
int framesBetweenShots = 10;
int shotDelayCounter = 0;
float playerAttackDamage = 5;
float shotAlignX = 12, shotAlignY = 20;
int maxPlayerAttacks = 100;
PlayerAttack[] playerAttacks;
void initPlayerAttacks() {
  playerAttacks = new PlayerAttack[maxPlayerAttacks];
  resetPlayerAttacks();
  playerAttackImages = new PImage[1];
  playerAttackImages[0] = loadImage("images/attacks/finger bullet.png");
  playerAttackImages[0].resize(playerAttackImages[0].width/2, playerAttackImages[0].height/2);
}

int inactivePlayerAttack() {
  int ans = 0;
  for(int i = 0; i < playerAttacks.length; i++) {
    if(!playerAttacks[i].active) { ans = i; }
  }
  return(ans);
}

void resetPlayerAttacks() {
  for(int i = 0; i < playerAttacks.length; i++) {
    playerAttacks[i] = new PlayerAttack(false, 0, 0, 0, 0, 0, 0, 0);
  }
}



void updatePlayerAttacks() {
  for(int i = 0; i < playerAttacks.length; i++) {
    if(playerAttacks[i].active) {
      playerAttacks[i].move();
      if(playerAttacks[i].offScreen() || playerAttacks[i].hitGround()) {
        playerAttacks[i].active = false;
      }
      if(landed && !bossDead && !bossImmune) {
        if(bosses[currentBoss()].cores[currentBossCore()].collided(playerAttacks[i].core)) {
          bosses[currentBoss()].damage(playerAttacks[i].damage);
          playerAttacks[i].active = false;
        }
      }
      for(int j = 0; j < enemies.length; j++) {
        if(enemies[j].active) {
          if(playerAttacks[i].core.collision(enemies[j].core)) {
            enemies[j].damage(playerAttacks[i].damage);
            playerAttacks[i].active = false;
          }
        }
      }
    }
  }
  shotDelayCounter--;
  if(LMPressed && shotDelayCounter <= 0) {
    playerShoot();
  }
}

void playerShoot() {
  if(!gameOver) {
    int buff = inactivePlayerAttack();
    float pax = playerCore.pos.x+shotAlignX, pay = playerCore.pos.y+shotAlignY;
    float pavx = mouseX-pax, pavy = mouseY-pay;
    playerAttacks[buff] = new PlayerAttack(true, 0, pax, pay, pavx, pavy, playerAttackImages[0].width, playerAttackDamage);
    playerAttacks[buff].core.vel.scaleMagnitude(playerAttackSpeed);
    playerAttacks[buff].core.vel.plus(playerCore.vel);
    shotDelayCounter = framesBetweenShots;
  }
}

void dispPlayerAttacks() {
  for(int i = 0; i < playerAttacks.length; i++) {
    if(playerAttacks[i].active) {
      playerAttacks[i].disp();
    }
  }
}






/*
class AttackImage {
  PImage image;
  String name;
  AttackImage(PImage i, String n) {
    image = i; name = n;
  }
}*/
PImage[] enemyAttackImages;
class EnemyAttack {
  boolean active;
  int type;
  O2D core;
  float damage;
  EnemyAttack(boolean ta, int tt, float tx, float ty, float tvx, float tvy, float tdiameter, float td) {
    active = ta; type = tt; core = new O2D(tx, ty, tvx, tvy, 1, tdiameter, 0); damage = td;
  }
  void move() {
    core.move();
  }
  void accelerate(P2 acc) {
    core.accelerate(acc);
  }
  
  boolean offScreen() {
    if(core.topY() > 720 || core.bottomY() < 0 || core.leftX() > 1280 || core.rightX() < 0) { return(true); }
    else { return(false); }
  }
  boolean hitGround() {
    return(core.bottomY() > 720-activeGroundHeight);
  }
  
  void disp() {
    if(active) {
      image(enemyAttackImages[type], core.leftX(), core.topY());
    }
  }
}

int maxEnemyAttacks = 200;
EnemyAttack[] enemyAttacks;
//AttackImage[] attackImages;
void initEnemyAttacks() {
  enemyAttacks = new EnemyAttack[maxEnemyAttacks];
  resetEnemyAttacks();
  enemyAttackImages = new PImage[4];
  enemyAttackImages[0] = loadImage("images/attacks/green ball.png");
  enemyAttackImages[0].resize(10, 10);
  enemyAttackImages[1] = loadImage("images/attacks/blue ball.png");
  enemyAttackImages[1].resize(15, 15);
  enemyAttackImages[2] = loadImage("images/attacks/fire ball.png");
  enemyAttackImages[3] = loadImage("images/attacks/fire ball.png");
  enemyAttackImages[2].resize(15, 15);
  enemyAttackImages[3].resize(30, 30);
  //attackImages[0] = loadImage("images/attacks/.png");
  /*
  File attackImageDirectory = new File(sketchPath("data/images/attacks"));
  File[] attackImageFiles = attackImageDirectory.listFiles();
  attackImages = new AttackImage[attackImageFiles.length];
  for(int i = 0; i < attackImages.length; i++) {
    String attackImageFileAbsolutePath = attackImageFiles[i].getAbsolutePath();
    String[] AIFNBuff = split(attackImageFileAbsolutePath, '\\');
    String AIFNBuff2 = AIFNBuff[AIFNBuff.length-1].substring(0, AIFNBuff[AIFNBuff.length-1].length()-4);
    AIFNBuff2 = AIFNBuff2.toLowerCase();
    String attackImageName = "";
    for(int j = 0; j < AIFNBuff2.length(); j++) {
      if(AIFNBuff2.charAt(j) != ' ') { attackImageName+=AIFNBuff2.charAt(j); }
    }
    attackImages[i] = new AttackImage(loadImage(attackImageFileAbsolutePath), attackImageName);
  }
  */
}


int inactiveEnemyAttack() {
  int ans = 0;
  for(int i = 0; i < enemyAttacks.length; i++) {
    if(!enemyAttacks[i].active) { ans = i; }
  }
  return(ans);
}

void resetEnemyAttacks() {
  for(int i = 0; i < enemyAttacks.length; i++) {
    enemyAttacks[i] = new EnemyAttack(false, 0, 0, 0, 0, 0, 0, 0);
  }
}



void updateEnemyAttacks() {
  for(int i = 0; i < enemyAttacks.length; i++) {
    if(enemyAttacks[i].active) {
      enemyAttacks[i].move();
      if(enemyAttacks[i].offScreen() || enemyAttacks[i].hitGround()) {
        enemyAttacks[i].active = false;
      }
      if(enemyAttacks[i].core.collision(playerCore)) {
        damagePlayer(enemyAttacks[i].damage);
        enemyAttacks[i].active = false;
      }
    }
  }
}

void enemyShoot(int type, float x, float y, float vx, float vy, float damage) {
if(!gameOver) {
    int buff = inactiveEnemyAttack();
    enemyAttacks[buff] = new EnemyAttack(true, type, x, y, vx, vy, enemyAttackImages[type].width, damage);
  }
}

void dispEnemyAttacks() {
  for(int i = 0; i < enemyAttacks.length; i++) {
    if(enemyAttacks[i].active) {
      enemyAttacks[i].disp();
    }
  }
}
