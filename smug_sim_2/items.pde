


PImage[] itemImages;
float itemSpeed = 3;
class Item {
  boolean active;
  int type;
  O2D core;
  int deleteBuff;
  Item(boolean ta, int tt) {
    active = ta; type = tt;
    core = new O2D(1280+itemImages[tt].width/2, random(720-itemImages[tt].height)+itemImages[tt].height/2, -itemSpeed, 0, 1, itemImages[tt].width, 0);
    deleteBuff = 10;
  }
  void move() {
    core.move();
  }
  
  boolean offScreen() {
    if(core.topY() > 720 || core.bottomY() < 0 || core.leftX() > 1280 || core.rightX() < 0) { return(true); }
    else { return(false); }
  }
  
  void disp() {
    image(itemImages[type], core.leftX(), core.topY());
  }
}

int maxItems = 10;
Item[] items;
float heartHPConst = 5;
float shieldConst = 15;
float heartSpawnConst = 0.002;
float shieldSpawnConst = 0.002;
void initItems() {
  itemImages = new PImage[2];
  itemImages[0] = loadImage("images/items/shield.png");
  itemImages[0].resize(50, 50);
  itemImages[1] = loadImage("images/items/heart.png");
  //itemImages[0] = loadImage("images/items/.png");
  
  items = new Item[maxItems];
  resetItems();
}

void resetItems() {
  for(int i = 0; i < items.length; i++) {
    items[i] = new Item(false, 0);
  }
}


void updateItems() {
  if(!landed && !entering && !leaving) {
    if(!gameOver) {
      trySpawnItem();
    }
  }
  for(int i = 0; i < items.length; i++) {
    if(items[i].active) {
      items[i].deleteBuff--;
      items[i].move();
      if(items[i].core.collision(playerCore)) {
        items[i].active = false;
        if(items[i].type == 0) {
          shieldPlayer(shieldConst);
        }
        else if(items[i].type == 1) {
          healPlayer(heartHPConst);
        }
      }
      if(items[i].offScreen() && items[i].deleteBuff < 0) {
        items[i].active = false;
      }
    }
  }
}

void trySpawnItem() {
  if(random(1) < shieldSpawnConst) {
    items[inactiveItem()] = new Item(true, 0);
  }
  if(random(1) < heartSpawnConst) {
    items[inactiveItem()] = new Item(true, 1);
  }
}

int inactiveItem() {
  int ans = 0;
  for(int i = 0; i < items.length; i++) {
    if(!items[i].active) { ans = i; }
  }
  return(ans);
}




void dispItems() {
  for(int i = 0; i < items.length; i++) {
    if(items[i].active) { items[i].disp(); }
  }
}
