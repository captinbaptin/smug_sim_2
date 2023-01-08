class BossCore {
  O2D main;
  O2D mainColl;
  O2D[] coll;
  BossCore(O2D[] tc, O2D tmain) {
    coll = tc;
    float top = tc[0].topY(), bottom = tc[0].bottomY(), left = tc[0].leftX(), right = tc[0].rightX();
    for(int i = 1; i < tc.length; i++) {
      if(tc[i].topY() < top) { top = tc[i].topY(); }
      if(tc[i].bottomY() > bottom) { bottom = tc[i].bottomY(); }
      if(tc[i].rightX() > right) { right = tc[i].rightX(); }
      if(tc[i].leftX() < left) { left = tc[i].leftX(); }
    }
    mainColl = new O2D((left+right)/2, (top+bottom)/2, 0, 0, 0, right-left, top-bottom);
    main = tmain;
  }
  
  void move() {
    main.move();
    mainColl.move();
    for(int i = 0; i < coll.length; i++) {
      coll[i].move();
    }
  }
  void accelerate(P2 acc) {
    main.accelerate(acc);
    mainColl.accelerate(acc);
    for(int i = 0; i < coll.length; i++) {
      coll[i].accelerate(acc);
    }
  }
  
  void setVel(P2 nv) {
    main.vel = nv;
    mainColl.vel = nv;
    for(int i = 0; i < coll.length; i++) { coll[i].vel = nv; }
  }
  
  boolean collided(O2D in) {
    boolean ans = false;
    //if(mainColl.collision(in)) {
      for(int i = 0; i < coll.length; i++) {
        if(coll[i].collision(in)) { ans = true; i+= coll.length; }
      }
    //}
    return(ans);
  }
}

PImage[][] bossImages;
int numBosses = 1;
class Boss {
  String name;
  int which;
  float HP, maxHP;
  BossCore[] cores;
  float upness, leftness;
  int state;
  int points;
  Boss(String tn, float tmhp, BossCore[] tc, int tp) {
    name = tn; which = 0; maxHP = tmhp; HP = maxHP;
    cores = tc;
    upness = 0; leftness = 0; state = 0;
    points = tp;
  }
  
  void damage(float d) {
    playerScore+=d*bossDamageMult;
    HP -= d;
    if(HP <= 0) {
      HP = 0;
      bossDead();
      playerScore+=points;
    }
  }
}

float bossDamageMult = 2;
float sachikoHP = 1500;
float sachikoUpRate = 2;
float sachikoX = 1280-200, sachikoY = 720+350/2-120;
float sachikoHeight = 350;
boolean bossImmune = true;
int sachikoFBRate = 30, sachikoFBDabRate = 20; //frames per fireball
float sachikoFBS = 3, sachikoFBD = 20;
int sachikoGBRate = 20;
float sachikoGBS = 5, sachikoGBD = 10;
float sachikoMaxDabSpeed = 12;
int dabDelayTimer = 0, dabHitDelay = 10;
float dabDamage = 20;
int sachikoPoints = 10000;
int timer = 0, setTimer = 200;
float sachikoArmRot = -0.2, sachikoArmRotRate = 0.01;
float sachikoMaxArmRot = PI*0.4, sachikoMinArmRot = -PI*0.1;
boolean sachikoArmDir = true;
float sachikoArmX = 1280-150, sachikoArmY = 720-100;
float sachikoArmRotX, sachikoArmRotY;
int sachikoBBRate = 50;
float sachikoBBS = 5, sachikoBBD = 15;
Boss[] bosses;
void initBosses() {
  bossImages = new PImage[numBosses][];
  int sachikoImageNum = 6;
  bossImages[0] = new PImage[sachikoImageNum];
  bossImages[0][0] = loadImage("images/bosses/sachiko/0.png");
  bossImages[0][0].resize(300, 350); //original is 1280x1480
  bossImages[0][1] = loadImage("images/bosses/sachiko/1.png");
  bossImages[0][1].resize(300, 350); //original is 1280x1480
  bossImages[0][2] = loadImage("images/bosses/sachiko/2.png");
  bossImages[0][2].resize(350, 350); //original is 1049x1075
  bossImages[0][3] = loadImage("images/bosses/sachiko/dab.png");
  bossImages[0][3].resize(350, 350); //original is 1280x1280
  bossImages[0][4] = loadImage("images/bosses/sachiko/dabflip.png");
  bossImages[0][4].resize(350, 350); //original is 1280x1280
  bossImages[0][5] = loadImage("images/bosses/sachiko/arm.png");
  bossImages[0][5].resize(175, 175); //original is 339x339
  sachikoArmRotX = 1*bossImages[0][5].width; sachikoArmRotY = 0.6*bossImages[0][5].height;
  
  
  resetBosses();
}

void resetBosses() {
  BossCore[] sachikoCores = new BossCore[3];
  O2D[] SC1 = new O2D[2];
  O2D SC1main = new O2D(sachikoX, sachikoY, 0, 0, 0, bossImages[0][0].width, bossImages[0][0].height);
  SC1[0] = new O2D(SC1main.leftX()+0.476*bossImages[0][0].width, SC1main.topY()+0.42*bossImages[0][0].height, 0, 0, 1, 0.672*bossImages[0][0].height, 0);
  SC1[1] = new O2D(SC1main.leftX()+(0.15+0.9)/2*bossImages[0][0].width, SC1main.topY()+(0.7+1)/2*bossImages[0][0].height, 0, 0, 0, 0.75*bossImages[0][0].width, 0.3*bossImages[0][0].height);
  sachikoCores[0] = new BossCore(SC1, SC1main);
  
  O2D[] SC2 = new O2D[2];
  O2D SC2main = new O2D(sachikoX, sachikoY, 0, 0, 0, bossImages[0][1].width, bossImages[0][1].height);
  SC2[0] = new O2D(SC2main.leftX()+0.467*bossImages[0][1].width, SC2main.topY()+0.415*bossImages[0][1].height, 0, 0, 1, 0.78*bossImages[0][1].height, 0);
  SC2[1] = new O2D(SC2main.leftX()+(0.15+0.9)/2*bossImages[0][1].width, SC2main.topY()+(0.7+1)/2*bossImages[0][1].height, 0, 0, 0, 0.75*bossImages[0][1].width, 0.3*bossImages[0][1].height);
  sachikoCores[1] = new BossCore(SC2, SC2main);
  
  O2D[] SC3 = new O2D[6];
  O2D SC3main = new O2D(sachikoX, sachikoY, 0, 0, 0, bossImages[0][3].width, bossImages[0][3].height);
  SC3[0] = new O2D(SC3main.leftX()+0.221*bossImages[0][3].width, SC3main.topY()+0.38*bossImages[0][3].height, 0, 0, 1, 0.392*bossImages[0][3].height, 0);
  SC3[1] = new O2D(SC3main.leftX()+0.11*bossImages[0][3].width,  SC3main.topY()+0.534*bossImages[0][3].height, 0, 0, 1, 0.194*bossImages[0][3].height, 0);
  SC3[2] = new O2D(SC3main.leftX()+(0.201+0.491)/2*bossImages[0][3].width, SC3main.topY()+(0.42+0.641)/2*bossImages[0][3].height, 0, 0, 0, 0.29*bossImages[0][3].width, 0.221*bossImages[0][3].height);
  SC3[3] = new O2D(SC3main.leftX()+0.377*bossImages[0][3].width, SC3main.topY()+0.681*bossImages[0][3].height, 0, 0, 1, 0.31*bossImages[0][3].height, 0);
  SC3[4] = new O2D(SC3main.leftX()+0.462*bossImages[0][3].width, SC3main.topY()+0.864*bossImages[0][3].height, 0, 0, 1, 0.329*bossImages[0][3].height, 0);
  SC3[5] = new O2D(SC3main.leftX()+0.478*bossImages[0][3].width, SC3main.topY()+bossImages[0][3].height, 0, 0, 1, 0.385*bossImages[0][3].height, 0);
  sachikoCores[2] = new BossCore(SC3, SC3main);
  
  
  bosses = new Boss[numBosses];
  bosses[0] = new Boss("SACHIKO", sachikoHP, sachikoCores, sachikoPoints);
}



void updateBoss() {
  timer--;
  if(landed && !bossDead) {
    if(planet == 1) {
      dabDelayTimer--;
      if(bosses[0].state == 0) {
        if(bosses[0].upness < 1) {
          bosses[0].upness += sachikoUpRate/sachikoHeight;
          P2 upvel = new P2(0, -sachikoUpRate);
          bosses[0].cores[0].setVel(upvel);
          bosses[0].cores[0].move();
          bosses[0].cores[1].setVel(upvel);
          bosses[0].cores[1].move();
        }
        else {
          bosses[0].upness=1;
          bosses[0].state = 1;
          bossImmune = false;
          timer = setTimer;
        }
      }
      else {
        if(bosses[0].state < 3 && bosses[0].HP < bosses[0].maxHP/4) {
          bosses[0].state = 3;
          bossImmune = true;
        }
        if(bosses[0].state == 1) {
          if(timer == 0) {
            bosses[0].state = 2;
            timer = setTimer;
          }
          sachikoGB(1);
          sachikoArmUpdate();
        }
        else if(bosses[0].state == 2) {
          if(timer == 0) {
            bosses[0].state = 1;
            timer = setTimer;
          }
          sachikoFB(false);
          sachikoGB(2);
          sachikoArmUpdate();
        }
        else if(bosses[0].state == 3) {
          if(bosses[0].upness > 0) {
            bosses[0].upness -= sachikoUpRate/sachikoHeight;
            P2 upvel = new P2(0, sachikoUpRate);
            bosses[0].cores[0].setVel(upvel);
            bosses[0].cores[0].move();
            bosses[0].cores[1].setVel(upvel);
            bosses[0].cores[1].move();
          }
          else {
            bosses[0].upness=0;
            bosses[0].state = 4;
          }
        }
        else if(bosses[0].state == 4) {
          if(bosses[0].upness < 1) {
            bosses[0].upness += sachikoUpRate/sachikoHeight;
            P2 upvel = new P2(0, -sachikoUpRate);
            bosses[0].cores[2].setVel(upvel);
            bosses[0].cores[2].move();
          }
          else {
            bosses[0].upness=1;
            bosses[0].state = 5;
            P2 stat = new P2(0, 0);
            bosses[0].cores[2].setVel(stat);
            bossImmune = false;
          }
        }
        else if(bosses[0].state == 5) {
          P2 sv = new P2(-0.1, 0);
          if(bosses[0].cores[2].main.vel.x > -sachikoMaxDabSpeed) { bosses[0].cores[2].accelerate(sv); }
          bosses[0].cores[2].move();
          if(bosses[0].cores[2].main.pos.x < -600) {
            P2 quickfix = new P2(2400, 0);
            bosses[0].cores[2].setVel(quickfix);
            bosses[0].cores[2].move();
            P2 stat = new P2(0, 0);
            bosses[0].cores[2].setVel(stat);
            /*
            P2 stat = new P2(0, 0);
            bosses[0].cores[2].setVel(stat);
            bosses[0].state = 6;
            */
          }
          if(dabDelayTimer <= 0 && bosses[0].cores[2].collided(playerCore)) {
            dabDelayTimer = dabHitDelay;
            damagePlayer(dabDamage);
          }
          sachikoFB(true);
          sachikoGB(5);
        }
        else if(bosses[0].state == 6) {
          P2 sv = new P2(0.1, 0);
          if(bosses[0].cores[2].main.vel.x < sachikoMaxDabSpeed) { bosses[0].cores[2].accelerate(sv); }
          bosses[0].cores[2].move();
          if(bosses[0].cores[2].main.pos.x > 1800) {
            P2 stat = new P2(0, 0);
            bosses[0].cores[2].setVel(stat);
            bosses[0].state = 5;
          }
        }
        else if(bosses[0].state == 7) {
          if(bosses[0].upness > 0) {
            bosses[0].upness -= sachikoUpRate/sachikoHeight;
            P2 upvel = new P2(0, sachikoUpRate);
            bosses[0].cores[2].setVel(upvel);
            bosses[0].cores[2].move();
          }
          else {
            bosses[0].upness=0;
            bossDead = true;
            submitHighScore(playerScore);
            gameOver();
          }
        }
      }
    }
    else if(planet == 2) {
      
    }
  }
}

void sachikoArmUpdate() {
  if(sachikoArmDir) {
    sachikoArmRot+=sachikoArmRotRate;
    if(sachikoArmRot>sachikoMaxArmRot) { sachikoArmDir = false; }
  }
  else {
    sachikoArmRot-=sachikoArmRotRate;
    if(sachikoArmRot<sachikoMinArmRot) { sachikoArmDir = true; }
  }
  if(timer%sachikoBBRate == 0) {
    float sin = sin(sachikoArmRot), cos = cos(sachikoArmRot);
    float tx = 0.02*bossImages[0][5].width-sachikoArmRotX, ty = 0.06*bossImages[0][5].height-sachikoArmRotY;
    float x = tx*cos-ty*sin+sachikoArmX, y = tx*sin+ty*cos+sachikoArmY;
    P2 avel = new P2(playerCore.pos.x-x, playerCore.pos.y-y);
    avel.scaleMagnitude(sachikoBBS);
    enemyShoot(1, x, y, avel.x, avel.y, sachikoBBD);
  }
}
void sachikoFB(boolean dab) {
  if(dab) {
    if(timer%sachikoFBDabRate == 0) {
      float x = bosses[0].cores[2].main.leftX()+0.895*bossImages[0][1].width, y = bosses[0].cores[2].main.topY()+0.142*bossImages[0][1].height;
      P2 avel = new P2(playerCore.pos.x-x, playerCore.pos.y-y);
      avel.scaleMagnitude(sachikoFBS);
      enemyShoot(3, x, y, avel.x, avel.y, sachikoFBD);
    }
  }
  else {
    if(timer%sachikoFBRate == 0) {
      float x = bosses[0].cores[1].main.leftX()+0.44*bossImages[0][1].width, y = bosses[0].cores[1].main.topY()+0.68*bossImages[0][1].height;
      P2 avel = new P2(playerCore.pos.x-x, playerCore.pos.y-y);
      avel.scaleMagnitude(sachikoFBS);
      enemyShoot(3, x, y, avel.x, avel.y, sachikoFBD);
    }
  }
}
void sachikoGB(int state) {
  if(timer%sachikoGBRate == 0) {
    if(state == 1 || state == 2) {
      if((timer/60)%2 == 0) {
        float x = 0, y = 0;
        if(state == 1) {
          if(random(1) < 0.5) {
            x = bosses[0].cores[1].main.leftX()+0.3*bossImages[0][1].width; y = bosses[0].cores[1].main.topY()+0.495*bossImages[0][1].height;
          }
          else {
            x = bosses[0].cores[1].main.leftX()+0.512*bossImages[0][1].width; y = bosses[0].cores[1].main.topY()+0.437*bossImages[0][1].height;
          }
        }
        else {
          if(random(1) < 0.5) {
            x = bosses[0].cores[1].main.leftX()+0.27*bossImages[0][1].width; y = bosses[0].cores[1].main.topY()+0.54*bossImages[0][1].height;
          }
          else {
            x = bosses[0].cores[1].main.leftX()+0.57*bossImages[0][1].width; y = bosses[0].cores[1].main.topY()+0.48*bossImages[0][1].height;
          }
        }
        P2 avel = new P2(playerCore.pos.x-x, playerCore.pos.y-y);
        avel.scaleMagnitude(sachikoGBS);
        enemyShoot(0, x, y, avel.x, avel.y, sachikoGBD);
      }
    }
    else if(state == 5) {
      float x = bosses[0].cores[2].main.leftX()+0.895*bossImages[0][1].width, y = bosses[0].cores[2].main.topY()+0.142*bossImages[0][1].height;
      P2 avel = new P2(playerCore.pos.x-x, playerCore.pos.y-y);
      avel.scaleMagnitude(sachikoGBS);
      enemyShoot(0, x, y, avel.x, avel.y, sachikoGBD);
    }
  }
}



void dispBoss() {
  if(landed && !bossDead) {
    if(currentBoss() == 0) {
      if(bosses[0].state == 0) {
        image(bossImages[0][0], bosses[0].cores[0].main.leftX(), bosses[0].cores[0].main.topY());
      }
      else if(bosses[0].state == 1) {
        image(bossImages[0][0], bosses[0].cores[0].main.leftX(), bosses[0].cores[0].main.topY());
        dispRotImage(bossImages[0][5], sachikoArmX, sachikoArmY, sachikoArmRot, sachikoArmRotX, sachikoArmRotY);
      }
      else if(bosses[0].state == 2) {
        image(bossImages[0][1], bosses[0].cores[1].main.leftX(), bosses[0].cores[1].main.topY());
        dispRotImage(bossImages[0][5], sachikoArmX, sachikoArmY, sachikoArmRot, sachikoArmRotX, sachikoArmRotY);
      }
      else if(bosses[0].state == 3) {
        image(bossImages[0][1], bosses[0].cores[1].main.leftX(), bosses[0].cores[1].main.topY());
      }
      else if(bosses[0].state == 4 || bosses[0].state == 5) {
        image(bossImages[0][3], bosses[0].cores[2].main.leftX(), bosses[0].cores[2].main.topY());
      }
      else if(bosses[0].state == 6) {
        image(bossImages[0][4], bosses[0].cores[2].main.leftX(), bosses[0].cores[2].main.topY());
      }
      else if(bosses[0].state == 7) {
        image(bossImages[0][2], bosses[0].cores[2].main.leftX(), bosses[0].cores[2].main.topY());
      }
      
      /*for(int i = 0; i < bosses[0].cores[currentBossCore()].coll.length; i++) {
        bosses[0].cores[currentBossCore()].coll[i].disp();
      }*/
    }
    else if(currentBoss() == 1) {
      
    }
  }
}

int currentBoss() {
  if(planet == 0) { return(0); }
  return(planet-1);
}
int currentBossCore() {
  int ans = 0;
  if(currentBoss() == 0) {
    if(bosses[0].state == 0 || bosses[0].state == 1) {
      ans = 0;
    }
    else if(bosses[0].state == 2 || bosses[0].state == 3) {
      ans = 1;
    }
    else if(bosses[0].state == 4 || bosses[0].state == 5 || bosses[0].state == 6) {
      ans = 2;
    }
  }
  return(ans);
}




void bossDead() {
  if(currentBoss() == 0) {
    bosses[0].state = 7;
    bossImmune = true;
  }
}
