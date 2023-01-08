



class P2 {
  float x, y;
  P2(float tx, float ty) {
    x = tx; y = ty;
  }
  void plus(P2 in) {
    x+=in.x; y+=in.y;
  }
  void times(float in) {
    x*=in; y*=in;
  }
  
  void scaleMagnitude(float newmag) {
    if(magnitude() != 0) {
      float scalefact = newmag/magnitude();
      x*=scalefact; y*=scalefact;
    }
  }
  
  float distance(P2 in) {
    return(sqrt((x-in.x)*(x-in.x)+(y-in.y)*(y-in.y)));
  }
  float magnitude() {
    return(sqrt(x*x+y*y));
  }
}



class O2D {
  P2 pos, vel;
  int shape; //0 rectangle 1 circle
  float dimensionX, dimensionY;
  O2D(float tx, float ty, float tvx, float tvy, int ts, float tdimx, float tdimy) {
    pos = new P2(tx, ty); vel = new P2(tvx, tvy);
    shape = ts; dimensionX = tdimx; dimensionY = tdimy;
  }
  void move() {
    pos.plus(vel);
  }
  void accelerate(P2 acc) {
    vel.plus(acc);
  }
  void drag(float drag) {
    vel.times(drag);
  }
  
  float leftX() {
    return(pos.x-dimensionX/2);
  }
  float rightX() {
    return(pos.x+dimensionX/2);
  }
  float topY() {
    if(shape == 0) { return(pos.y-dimensionY/2); }
    else { return(pos.y-dimensionX/2); }
  }
  float bottomY() {
    if(shape == 0) { return(pos.y+dimensionY/2); }
    else { return(pos.y+dimensionX/2); }
  }
  
  
  boolean collision(O2D in) {
    float blx = 0, bmx = 0, bly = 0, bmy = 0, cmx = 0, cmy = 0, cr = 0;
    if(shape == 0) {
      if(in.shape == 0) {
        if(abs(pos.x-in.pos.x) <= (dimensionX+in.dimensionX)/2 && abs(pos.y-in.pos.y) <= (dimensionY+in.dimensionY)/2) { return(true); }
        else { return(false); }
      }
      else {
        blx = leftX(); bmx = rightX(); bly = topY(); bmy = bottomY(); cmx = in.pos.x; cmy = in.pos.y; cr = in.dimensionX/2;
      }
    }
    else {
      if(in.shape == 0) {
        blx = in.leftX(); bmx = in.rightX(); bly = in.topY(); bmy = in.bottomY(); cmx = pos.x; cmy = pos.y; cr = dimensionX/2;
      }
      else {
        if(pos.distance(in.pos) <= (dimensionX+in.dimensionX)/2) { return(true); }
        else { return(false); }
      }
    }
    if(cmx >= blx-cr && cmx <= bmx+cr && cmy >= bly && cmy <= bmy) { return(true); }
    if(cmy >= bly-cr && cmy <= bmy+cr && cmx >= blx && cmx <= bmx) { return(true); }
    P2 c = new P2(cmx, cmy); P2 corn = new P2(blx, bly);
    if(c.distance(corn) <= cr) { return(true); }
    corn = new P2(blx, bmy); if(c.distance(corn) <= cr) { return(true); }
    corn = new P2(bmx, bly); if(c.distance(corn) <= cr) { return(true); }
    corn = new P2(bmx, bmy); if(c.distance(corn) <= cr) { return(true); }
    return(false);
  }
  
  
  
  void disp() {
    fill(0, 64);
    if(shape == 0) {
      rect(leftX(), topY(), rightX()-leftX(), bottomY()-topY());
    }
    else {
      ellipse(leftX(), topY(), rightX()-leftX(), bottomY()-topY());
    }
  }
}











void dispRotImage(PImage in, float x, float y, float rot, float rx, float ry) {
  translate(x, y);
  rotate(rot);
  image(in, -rx, -ry);
  rotate(-rot);
  translate(-x, -y);
}
