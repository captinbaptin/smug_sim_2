


O2D rumble;
float rumbleStrength = 0;
float rumbleDecayConst = 0.5;
float rumbleReturnConst = 0.7;
void initRumble() {
  resetRumble();
}
void resetRumble() {
  rumble = new O2D(0, 0, 0, 0, 0, 0, 0);
}
void updateRumble() {
  rumble.vel.times(rumbleDecayConst);
  rumble.vel.x+= random(2*rumbleStrength)-rumbleStrength; rumble.vel.y+= random(2*rumbleStrength)-rumbleStrength;
  rumble.move();
  rumble.pos.times(rumbleReturnConst);
}
void rumbleStart() {
  translate(rumble.pos.x, rumble.pos.y);
}
void rumbleEnd() {
}
