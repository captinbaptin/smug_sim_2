boolean immortal = false;
PImage[] playerImages;
PImage playerShieldImage;
float playerShield, maxPlayerShield = 50;
float playerMaxHP = 100;
float playerAirAcc = 0.2, playerGroundAcc = 1;
//float playerJump = 3;
float playerJumpZone = 5;
float playerDrag = 0.02;
float playerSize = 75;
float playerBrakes = 0.9;
float playerBounceDamping = 0.5;
float playerFriction = 0.1;

float playerHP;
int playerScore;
float enemyPoints = 100;
O2D playerCore;
boolean playerOnGround;

void initPlayer() {
  resetPlayer();
  
  playerImages = new PImage[4];
  for(int i = 0; i < 4; i++) {
    playerImages[i] = loadImage("images/player/" + i +".png");
    playerImages[i].resize(int(playerSize), int(float(playerImages[i].height)/(float(playerImages[i].width)/playerSize)));
  }
  playerShieldImage = loadImage("images/items/shield.png");
}

void resetPlayer() {
  playerHP = playerMaxHP;
  playerShield = 50;
  playerScore = 0;
  playerCore = new O2D(1280/2, 720-landedGroundHeight, 0, 0, 1, playerSize, 0);
  playerOnGround = true;
}



void healPlayer(float hp) {
  if(!gameOver) {
    playerHP += hp;
    if(playerHP > playerMaxHP) { playerHP = playerMaxHP; }
  }
}

void shieldPlayer(float s) {
  if(!gameOver) {
    playerShield+=s;
    if(playerShield > maxPlayerShield) { playerShield = maxPlayerShield; }
  }
}

void damagePlayer(float d) {
  if(!immortal) {
    if(!gameOver) {
      if(playerShield == 0) {
        playerHP-=d;
        if(playerHP <= 0) {
          playerHP = 0;
          gameOver();
          submitHighScore(playerScore);
        }
      }
      else {
        playerShield-=d;
        if(playerShield <= 0) {
          playerShield = 0;
        }
      }
    }
  }
}



void movePlayer() {
  playerCore.move();
}
void acceleratePlayer(P2 acc) {
  playerCore.accelerate(acc);
}

void updatePlayer() {
  //player inupt
  if(!gameOver) {
    float pxa = 0, pya = 0;
    if(WPressed) { pya-=1; }
    if(APressed) { pxa-=1; }
    if(SPressed) { pya+=1; }
    if(DPressed) { pxa+=1; }
    P2 pa = new P2(pxa, pya);
    if(playerOnGround) { pa.scaleMagnitude(playerGroundAcc*planets[planet].gravity); }
    else { pa.scaleMagnitude(playerAirAcc); }
    //jump
    playerCore.accelerate(pa);
    if(spacePressed) {
      playerCore.vel.times(playerBrakes);
    }
  }
  //gravity
  if(landed) {
    P2 grav = new P2(0, planets[planet].gravity*gravityConst);
    playerCore.accelerate(grav);
  }
  //air drag
  if(landed || entering || leaving) {
    float atmosphereDrag = 1-(playerDrag*distanceAtmosphere);
    playerCore.vel.times(atmosphereDrag);
  }
  //friction on ground
  if(playerOnGround) {
    playerCore.vel.x*=1-(planets[planet].gravity*playerFriction);
  }
  //update position
  movePlayer();
  //keep player inbounds and above ground
  if(playerCore.bottomY() > 720-activeGroundHeight) {
    playerCore.pos.y-=(playerCore.bottomY()-(720-activeGroundHeight));
    playerCore.vel.y = - playerCore.vel.y*playerBounceDamping;
  }
  if(playerCore.topY() < 0) {
    playerCore.pos.y-=(playerCore.topY());
    playerCore.vel.y = - playerCore.vel.y*playerBounceDamping;
  }
  if(playerCore.leftX() < 0) {
    playerCore.pos.x-=(playerCore.leftX());
    playerCore.vel.x = - playerCore.vel.x*playerBounceDamping;
  }
  if(playerCore.rightX() > 1280) {
    playerCore.pos.x-=(playerCore.rightX()-1280);
    playerCore.vel.x = - playerCore.vel.x*playerBounceDamping;
  }
  //check if player is on ground
  if(activeGroundHeight > 0 && playerCore.bottomY() >= 720-activeGroundHeight-playerJumpZone) {
    playerOnGround = true;
  }
  else { playerOnGround = false; }
}

void dispPlayer() {
  int currentPlayerImage = 0;
  if(playerHP < playerMaxHP) {
    currentPlayerImage = 1;
    if(playerHP < playerMaxHP/2) {
      currentPlayerImage = 2;
      if(playerHP < playerMaxHP/4) { currentPlayerImage = 3; }
    }
  }
  image(playerImages[currentPlayerImage], playerCore.leftX(), playerCore.topY());
  if(playerShield > 0) {
    tint(255, playerShield*255/maxPlayerShield);
    image(playerShieldImage, playerCore.pos.x-playerShieldImage.width/2, playerCore.pos.y-playerShieldImage.height/2);
    noTint();
  }
}
