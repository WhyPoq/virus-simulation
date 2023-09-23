class CityBuilder {

  float maxVal = 0;
  int curBoard = 0;
  int max = 100;

  float density = 1;
  int len;
  float[][] map;
  
  int posX;
  int posY;
  
  CityBuilder(int len, float density, int posX, int posY){
    this.len = len;
    this.density = density;
    this.posX = posX;
    this.posY = posY;
    
    gen();
  }

  void gen() {
    noiseSeed((long)random(-PI * 100000, PI * 100000));
    map = new float[len][len];
    noiseDetail(1, 1);
    float inc = 0.01;
    float xoff = 0.0;
    for (int x = 0; x < len; x++) {
      xoff += inc;
      float yoff = 0.0;
      for (int y = 0; y < len; y++) {
        yoff += inc;    
        float coff = len;
        coff -= (float)abs(len / 2.0 - x);
        coff -= (float)abs(len / 2.0 - y);
        if (coff < 0) coff = 0;
        coff = coff / len / 1000.0;
        float value = map(noise(xoff, yoff) * coff, 0, 1, 0, max) * 100;
        value = value - 2.5 * density;
        value = value * 90;
        if (value < 0) value = 0;
        if (value > max) value = max;
        map[x][y] = 1 + value;
        maxVal += 1 + value;
      }
    }
  }

  cords getCord(int board) {
    if(curBoard != board){
      curBoard = board;
      maxVal = 0;
      for (int x = board; x < len - board; x++) {
        for (int y = board; y < len - board; y++) {
          maxVal += map[x][y];
        }
      }
    }
    
    float rand = random(maxVal);
    float cur = 0;
    int x = 0;
    int y = 0;
    for (x = board; x < len - board; x++) {
      for (y = board; y < len - board; y++) {
        cur += map[x][y];
        if (rand <= cur) {
          break;
        }
      }
      if (rand <= cur) {
        break;
      }
    }

    return new cords(x + posX, y + posY);
  }
}

class cords {
  int x;
  int y; 

  cords(int x, int y) {
    this.x = x;
    this.y = y;
  }
}
