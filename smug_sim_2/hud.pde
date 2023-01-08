
void dispHUD() {
  noStroke();
  dispScore(scoreX, scoreY);
  dispHP(HPBarX, HPBarY);
  dispPlanetData(planetDataX, planetDataY);
  if(landed && !bossDead && launchTimer < 0) {
    dispBossHUD();
  }
}




color scoreTextColor = color(128, 255, 255);
float scoreTextSize = 30;
float scoreX = 10, scoreY = 10;
int scoreDigits = 9;
void dispScore(float x, float y) {
  textAlign(LEFT, TOP);
  textSize(scoreTextSize);
  fill(scoreTextColor);
  String scoreString = ""+playerScore; while(scoreString.length() < scoreDigits) { scoreString = "0"+scoreString; }
  text(scoreString, x, y);
}

float HPBarLength = 170;
float HPBarX = 10, HPBarY = 50;
void dispHP(float x, float y) {
  fill(255, 0, 0);
  rect(x, y, HPBarLength, 10);
  fill(0, 255, 0);
  rect(x, y, playerHP*HPBarLength/playerMaxHP, 10);
  fill(0, 192, 255);
  rect(x, y+10, playerShield*HPBarLength/maxPlayerShield, 10);
}


float planetDataX = 10, planetDataY = 80;
void dispPlanetData(float x, float y) {
  fill(255, 0.75*255);
  rect(x, y, HPBarLength, 90);
  fill(0);
  textSize(20);
  textAlign(CENTER, TOP);
  text(planets[planet].name, HPBarLength/2+x, y);
  textSize(12);
  text("altitude", HPBarLength/2+x, y+30);
  text("distance", HPBarLength/2+x, y+60);
  fill(128);
  rect(x+10, y+45, HPBarLength-20, 10);
  rect(x+10, y+75, HPBarLength-20, 10);
  fill(255, 255, 96);
  rect(x+10+(distanceAtmosphere/planets[planet].atmosphere)*(HPBarLength-25), y+45, 5, 10);
  rect(x+10+(distanceSpace/planets[planet].distance)*(HPBarLength-25), y+75, 5, 10);
}


float bossHPBarLength = 170;
float boarder = 10;
void dispBossHUD() {
  fill(255, 0.75*255);
  rect(1280-bossHPBarLength-boarder, boarder, bossHPBarLength, 30);
  fill(0);
  textSize(30);
  textAlign(CENTER, TOP);
  text(bosses[currentBoss()].name, 1280-boarder-bossHPBarLength/2, 10);
  fill(255, 0, 0);
  rect(1280-bossHPBarLength-boarder, 50, bossHPBarLength, 20);
  fill(0, 255, 0);
  rect(1280-bossHPBarLength-boarder, 50, bosses[currentBoss()].HP/bosses[currentBoss()].maxHP*bossHPBarLength, 20);
  
}
