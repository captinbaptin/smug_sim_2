boolean menu = false;

PImage menuImage;

void initMenu() {
  menuImage = loadImage("images/menu/menu.png");
}

void dispMenu() {
  image(menuImage, 0, 0);
}
