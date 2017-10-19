//Initial declare hue
int hue = 0;

color RGBCycle() {
  colorMode(HSB);
  hue += 2;
  if (hue>255) {
    hue = 0;
  }
  color returnColor = color(hue,0,0);
  colorMode(RGB);
  return(returnColor);
}