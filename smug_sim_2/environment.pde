boolean entering, landed, leaving, bossDead;
color launchTimerColor = color(255, 0, 0);
int launchTimer, launchTimerStart = 300;
float landingJerk = 20;
float maxVelocity = 1, spaceAcceleration = 0.003;
float atmosphereConst = 1.0/500, groundConst = 0.001;
float spaceConst = 1.0/2000;
float starShowConst = 0.5;
float distanceSpace, distanceAtmosphere, velocity;
float activeGroundHeight;
float gravityConst = 0.1;
int planet;


void initEnvironment() {
  initPlanets();
  initStars();
  resetEnvironment();
}
void resetEnvironment() {
  landedOn(0);
}
void landedOn(int p) {
  planet = p;
  distanceAtmosphere = planets[p].atmosphere;
  distanceSpace = 0; velocity = 0;
  activeGroundHeight = landedGroundHeight;
  entering = false; landed = true; leaving = false; bossDead = false; if(p == 0) { bossDead = true; }
  launchTimer = -1;
}

void updateEnvironment() {
  if(!gameOver) {
    if(landed) {
      if(bossDead) {
        launchTimer = launchTimerStart;
        bossDead = false;
      }
      if(launchTimer == 0) {
        landed = false;
        leaving = true;
      }
      launchTimer--;
    }
    else if(entering) {
      velocity*=(1-spaceAcceleration);
      distanceAtmosphere+=velocity*atmosphereConst;
      if(distanceAtmosphere >= planets[planet].atmosphere) {
        distanceAtmosphere = planets[planet].atmosphere;
        entering = false;
        landed = true;
        playerCore.vel.y+=landingJerk;
      }
      if(planets[planet].atmosphere-distanceAtmosphere < groundConst) {
        activeGroundHeight = (1-(planets[planet].atmosphere-distanceAtmosphere)/groundConst)*landedGroundHeight;
      }
      else { activeGroundHeight = 0; }
    }
    else if(leaving) {
      velocity = 1-(1-velocity)*(1-spaceAcceleration);
      distanceAtmosphere-=velocity*atmosphereConst;
      if(distanceAtmosphere <= 0) {
        distanceAtmosphere = 0;
        leaving = false;
        distanceSpace = 0;
        planet++;
      }
      if(planets[planet].atmosphere-distanceAtmosphere < groundConst) {
        activeGroundHeight = (1-(planets[planet].atmosphere-distanceAtmosphere)/groundConst)*landedGroundHeight;
      }
      else { activeGroundHeight = 0; }
    }
    else {
      distanceSpace+=velocity*spaceConst;
      if(distanceSpace >= planets[planet].distance) {
        distanceSpace = planets[planet].distance;
        entering = true;
      }
    }
  }
  advanceStars(starScrollConst*velocity);
}

void dispEnvironmentBackGround() {
  if(landed) {
    planets[planet].dispAtmosphere(distanceAtmosphere);
  }
  else if(entering || leaving) {
    planets[planet].dispAtmosphere(distanceAtmosphere);
  }
  else {
    dispStars(255);
  }
}
void dispEnvironmentForeground() {
  if(landed) {
    planets[planet].dispGround(activeGroundHeight);
    if(launchTimer >= 0) { dispLaunchTimer(); }
  }
  else if(entering || leaving) {
    if(activeGroundHeight != 0) {
      planets[planet].dispGround(activeGroundHeight);
    }
  }
}


void dispLaunchTimer() {
  fill(launchTimerColor);
  textSize(720/12);
  textAlign(CENTER, CENTER);
  String launchTimerString = ("" + float(launchTimer)/60+"00000").substring(0, 4) + "s TILL LAUNCH"; 
  text(launchTimerString, 1280/2, 720/6);
}


class Planet {
  String name;
  color colorGround, colorAir, colorCloud;
  float atmosphere, clouds, distance, gravity;
  Planet(String tn, color tcg, color tca, color tcc, float ta, float tc, float td, float tg) {
    name = tn;
    colorGround = tcg; colorAir = tca; colorCloud = tcc;
    atmosphere = ta; clouds = tc; distance = td; gravity = tg;
  }
  
  void dispAtmosphere(float alt) {
    noStroke();
    if(alt != 0) {
      float alpha = 255*(alt/atmosphere);
      if((alt/atmosphere) < starShowConst) {
        dispStars(255*(((starShowConst-alt/atmosphere)/starShowConst)));
      }
      fill(red(colorAir), green(colorAir), blue(colorAir), alpha);
    }
    else { fill(colorAir); }
    rect(0, 0, 1280, 720);
  }
  void dispGround(float h) {
    noStroke();
    fill(colorGround);
    rect(0, 720-h, 1280, h);
  }
}

float landedGroundHeight = 720/6;
Planet[] planets;
void initPlanets() {
  File planetDirectory = new File(sketchPath("data/planets"));
  File[] planetFiles = planetDirectory.listFiles();
  planets = new Planet[planetFiles.length];
  for(int i = 0; i < planets.length; i++) {
    String[] buff = loadStrings(planetFiles[i].getAbsolutePath());
    int whichPlanet = 0; String tn = ""; color tcg = #FF0000, tca = #FF0000, tcc = #FF0000; float ta = 0, tc = 0, td = 0, tg = 0;
    for(int j = 0; j < buff.length; j++) {
      String[] buff2 = split(buff[j], ' ');
      if(buff2[0].equals("name")) { tn = buff2[1]; }
      if(buff2[0].equals("colorground")) { tcg = color(int(buff2[1]), int(buff2[2]), int(buff2[3])); }
      if(buff2[0].equals("colorair")) { tca = color(int(buff2[1]), int(buff2[2]), int(buff2[3])); }
      if(buff2[0].equals("colorcloud")) { tcc = color(int(buff2[1]), int(buff2[2]), int(buff2[3])); }
      if(buff2[0].equals("atmosphere")) { ta = float(buff2[1]); }
      if(buff2[0].equals("clouds")) { tc = float(buff2[1]); }
      if(buff2[0].equals("distance")) { td = float(buff2[1]); }
      if(buff2[0].equals("gravity")) { tg = float(buff2[1]); }
      if(buff2[0].equals("number")) { whichPlanet = int(buff2[1]); }
    }
    planets[whichPlanet] = new Planet(tn, tcg, tca, tcc, ta, tc, td, tg);
  }
}



PImage[] starImages;
class Star {
  int size; //0 small 1 medium 2 big
  float x, y;
  Star(float xspan, float yspan) {
    x = random(xspan); y = random(yspan);
    if(random(1) < 0.4) {
      if(random(1) < 0.33) { size = 2; }
      else { size = 1; }
    }
    else { size = 0; }
  }
  void disp(float addx) {
    image(starImages[size], x+addx-starImages[size].width/2, y-starImages[size].height/2);
  }
}
class StarColumn {
  float xpos;
  Star[] stars;
  StarColumn(int numstars, float xspan, float yspan, float txpos) {
    xpos = txpos;
    stars = new Star[numstars];
    for(int i = 0; i < stars.length; i++) {
      stars[i] = new Star(xspan, yspan);
    }
  }
  void disp() {
    for(int i = 0; i < stars.length; i++) { stars[i].disp(xpos); }
  }
}

StarColumn[] stars;
int pixelspercolumn = 20;
int starspercolumn = 10;
float starColumn = 0;
float starScrollConst = 1;
void initStars() {
  starImages = new PImage[3];
  starImages[0] = loadImage("images/environment/stars/star small.png");
  starImages[1] = loadImage("images/environment/stars/star medium.png");
  starImages[2] = loadImage("images/environment/stars/star large.png");
  stars = new StarColumn[1280/pixelspercolumn+1];
  for(int i = 0; i < stars.length; i++) {
    stars[i] = new StarColumn(starspercolumn, pixelspercolumn, 720, i*pixelspercolumn);
  }
}
void advanceStars(float advance) {
  for(int i = 0; i < stars.length; i++) {
    float temp = stars[i].xpos - advance;
    if(temp < 0) {
      stars[i] = new StarColumn(starspercolumn, pixelspercolumn, 720, temp+1280);
    }
    else { stars[i].xpos = temp; }
  }
}
void dispStars(float alpha) {
  if(alpha != 255) { tint(255, alpha); }
  for(int i = 0; i < stars.length; i++) {
    stars[i].disp();
  }
  noTint();
}
