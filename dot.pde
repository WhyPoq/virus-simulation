class Dot { //<>// //<>//

  float x;
  float y;

  float w;
  float h;

  float speed = 20;
  float size;

  float aX;
  float aY;

  float changeDirectionTime = 0;
  float moveDir = 0.5;

  boolean dead = false;
  boolean infl = false;
  boolean immune = false;
  boolean off = false;
  boolean moving = false;
  boolean arrived = false;
  boolean nonSymptoms = true;
  boolean movingToPlace = false;
  boolean movingBack = false;
  boolean toTheQuarantine = false;

  float maxCircle = 0;
  float curCircle = -1;
  boolean rti = false;
  float curFade = -1;
  float maxFade = 0;
  float immuneChance;
  float aliveChance = 0.2;

  float quarantineChance = 0.05;
  float curQuarantineChance;

  float symptoms;  
  float symptomsTimer = 0.5; 
  float curSymptoms;

  int cR = 100;
  int cG = 200;
  int cB = 200;

  float inflRad;
  float fadeSpeed;

  float inflTimer;
  float inflRate;

  float inflAlive = 0;
  long maxInflAlive;

  float boardX;
  float boardY;

  Handler base;
  int gen;
  int planetTarget = -1;
  float xT = -1;
  float yT = -1;

  float startXPoint;
  float startYPoint;
  float distToTarget = -1;

  boolean distancing = false;
  float distance;

  float aliveTimer;

  float waitPlaceTimer = -1;
  float waitPlace;

  float normalTime = 0.2;
  float normalTimer;
  
  float border;

  Gen planet;

  Dot(int w, int h, int size, int inflRad, int fadeSpeed, int inflRate, long maxInflAlive, int boardX, int boardY, 
    Handler base, int gen, boolean distancing, int distanceChance, float aliveChance, 
    float immuneChance, float symptoms, float waitPlace, float quarantineChance, Gen planet, float border) {
    this.boardX = boardX;
    this.boardY = boardY;

    this.w = w;
    this.h = h;
    this.immuneChance = immuneChance;

    if (distancing) {
      distance = (int)random(0, distanceChance);
      changeDirectionTime = random(moveDir / 4.0, moveDir * 4);
    }

    this.size = size;
    this.inflRad = inflRad;
    this.fadeSpeed = fadeSpeed;
    this.inflRate = inflRate / 1000.0;
    this.maxInflAlive = maxInflAlive;
    this.base = base;
    this.gen = gen;
    this.distancing = distancing;
    this.aliveChance = aliveChance;
    this.symptoms = symptoms;
    this.waitPlace = waitPlace;
    this.planet = planet;

    this.quarantineChance = quarantineChance;
    curQuarantineChance = 1 - quarantineChance;

    curSymptoms = 1 - symptoms;
    if(symptoms == 0.1){
      nonSymptoms = false;
    }

    aliveTimer = 0;
    normalTimer = 0;

    cords c = planet.city.getCord(size);
    x = c.x;
    y = c.y;
    
    this.border = border;
  }

  int findNear() {
    if (gen == -1) {
      return -1;
    }
    int indNear = -1;
    float minDist = 1000000000;
    for (int i = 0; i < handler.tests.get(gen).dots.size(); i++) {
      if (handler.tests.get(gen).dots.get(i) != this) {
        float dist = dist(x, y, handler.tests.get(gen).dots.get(i).x, handler.tests.get(gen).dots.get(i).y);
        if (dist < distance && dist < minDist) {
          float chance = 0.35;
          if (!handler.tests.get(gen).dots.get(i).nonSymptoms && !handler.tests.get(gen).dots.get(i).dead && handler.tests.get(gen).dots.get(i).infl) {
            chance = chance * 3;
          }
          if (chance > random(1)) {
            minDist = dist;
            indNear = i;
          }
        }
      }
    }
    return indNear;
  }

  void takeMove(int xTimes) {
    float dX =  (float)(aX * speed * base.deltaTime);
    float dY = (float)(aY * speed * base.deltaTime);
    x += dX * xTimes;
    y += dY * xTimes;
  }

  void checkPos() {
    boolean bad = false;
    if (x > width || y > height || x < 0 || y < 0) {
      bad = true;
    }
    if (distToTarget != -1) {
      if (dist(x, y, startXPoint, startYPoint) - 30 > distToTarget) {
        bad = true;
        distToTarget = -1;
      }
    }
    if (bad) {
      toTheQuarantine = false;
      movingToPlace = false;
      waitPlaceTimer = -1;
      movingBack = false;
      moving = false;
    }
  }


  void move() {
    if (dead) {
      return;
    }


    checkPos();
    if (toTheQuarantine) {
      takeMove(10);
      if (dist(x, y, xT, yT) < 15) {
        toTheQuarantine = false;
        distToTarget = -1;
      }
    } else if (movingToPlace) {
      takeMove(1);
      if (dist(x, y, xT, yT) < 5) {
        movingToPlace = false;
        distToTarget = -1;
        waitPlaceTimer = 0;
      }
    } else if (waitPlaceTimer >= 0) {
      waitPlaceTimer -= base.deltaTime;
      if (waitPlaceTimer > waitPlace) {
        waitPlaceTimer = -1;
        movingBack = true;
        pathToPoint(x, y, startXPoint, startYPoint);
        distToTarget = dist(x, y, startXPoint, startYPoint);
      }
    } else if (movingBack) {
      takeMove(1);
      if (dist(x, y, startXPoint, startYPoint) < 5) {
        distToTarget = -1;
        movingBack = false;
      }
    } else if (moving) {
      if (!arrived) {
        takeMove(2);
        if (dist(x, y, xT, yT) < 5 && !arrived) {
          arrived = true;
          base.arrived(this, gen);
        }
      }
    } else if (changeDirectionTime <= 0) {
      if (!distancing) {
        aX = random(-1, 1);
        aY = random(-1, 1);
        changeDirectionTime = random(moveDir / 4.0, moveDir * 4);
      } else {
        int indNear = findNear();         
        if (indNear != -1) {
          pathToPoint(x, y, handler.tests.get(gen).dots.get(indNear).x, handler.tests.get(gen).dots.get(indNear).y);
          aX = -aX;
          aY = -aY;
          takeMove(1);
          border();
        } else {
          aX = random(-1, 1);
          aY = random(-1, 1);
          changeDirectionTime = random(moveDir / 4.0, moveDir * 4);
          takeMove(1);
          border();
        }
      }
    } else {
      changeDirectionTime -= base.deltaTime;
      takeMove(1);
      border();
    }
  }

  void border() {
    if (x < size + boardX + border) {
      aX =  -aX;
      x = size + boardX + border;
    }
    if (x > w - size + boardX - border) {
      aX = -aX;
      x = w - size - 1 + boardX - border;
    }
    if (y < size + boardY + border) {
      aY =  -aY;
      y = size + boardY + border;
    }
    if (y > h - size + boardY - border) {
      aY =  -aY;
      y = h - size - 1 + boardY - border;
    }
  }

  void pickColor() {
    if (!infl && !dead) {
      cR = 100;
      cG = 200;
      cB = 200;
    } else if (infl && !dead && nonSymptoms) {
      cR = 230;
      cG = 230;
      cB = 100;
    } else if (infl && !dead && !nonSymptoms) {
      cR = 230;
      cG = 100;
      cB = 100;
    } else if (dead) {
      cR = 150;
      cG = 150;
      cB = 150;
    }
  }

  void show() {    
    noStroke();
    if (infl && !dead) {
      inflAlive += base.deltaTime;
    }
    if (inflAlive > maxInflAlive) {  
      dead = true;     
      inflAlive = 0;
    }

    if (infl && !dead && nonSymptoms) {
      symptomsTimer += base.deltaTime;
    }
    if (infl && !dead && nonSymptoms && symptomsTimer > 0.5) {
      symptomsTimer = 0;
      if (curSymptoms <= random(1)) {
        nonSymptoms = false;
      }
      curSymptoms -= symptoms;
    }
    normalTimer += base.deltaTime;
    if (normalTimer >= normalTime) {
      callMoving();
      callQuarantine();
      normalTimer = 0;
    }

    if (!off && infl) {
      aliveTimer += base.deltaTime;
      if (aliveTimer > 2) {
        if (aliveChance > random(1)) {
          infl = false;
          inflAlive = 0;
          if (immuneChance > random(1)) {
            immune = true;
          }
        }
        aliveTimer = 0;
      }
    }

    pickColor();
    fill(cR, cG, cB);   
    ellipse(x, y, size, size);

    if (!dead && infl && gen != -1) {
      if (inflTimer >= inflRate) {
        inflTimer = 0;
        drawCircle();
      }else{
        inflTimer += base.deltaTime;
      }
    } 

    if (curCircle > -1) {
      noFill();
      strokeWeight(fadeSpeed);
      stroke(230, 100, 100);
      ellipse(x, y, curCircle, curCircle);
      curCircle += 1 * maxCircle * base.deltaTime;
      stroke(0, 0, 0);
      strokeWeight(0);
      if (curCircle > maxCircle) {
        curCircle = -1;
        rti = true;
        curFade = maxFade * size / 6.0;
      }
      noStroke();
    }
    if (curFade > -1) {
      noFill();
      strokeWeight(curFade);
      stroke(230, 100, 100);
      ellipse(x, y, maxCircle, maxCircle);
      curFade -= 20 * base.deltaTime;
      noStroke();
      strokeWeight(0);
    }
    if (curFade <= 0) {
      curFade = -1;
    }
  }

  void drawCircle() {
    if (curCircle == -1) {
      curCircle = size * 2;
      maxCircle = random(inflRad / 1.5, inflRad * 1.5);
      maxFade = fadeSpeed;
      curFade = -1;
    }
  }

  void moveToThePlanet(int planetTarget, float xT, float yT) {
    moving = true;
    this.planetTarget = planetTarget;
    this.xT = xT;
    this.yT = yT;
    startXPoint = x;
    startYPoint = y;
    pathToPoint(x, y, xT, yT);
    distToTarget = dist(x, y, xT, yT);
    size = base.tests.get(planetTarget).dotSize;
    inflRad = base.tests.get(planetTarget).inflRad;
  }

  void pathToPoint(float xFrom, float yFrom, float xTo, float yTo) {

    aX = abs(xFrom - xTo);
    aY = abs(yFrom - yTo);

    if (aX == 0) {
      aY = aY / abs(yFrom - yTo);
    } else if (aY == 0) {
      aX = aX / abs(xFrom - xTo);
    } else {
      if (aX < aY) {
        aX = aX / aY;
        aY = 1;
      } else {
        aY = aY / aX;
        aX = 1;
      }

      aX = aX * (abs(xFrom - xTo) / -(float)(xFrom - xTo));
      aY = aY * (abs(yFrom - yTo) / -(float)(yFrom - yTo));
    }
  }

  void moveToThePlace(float xTo, float yTo, float waitTime) {
    pathToPoint(x, y, xTo, yTo);
    waitPlace = waitTime / 1000.0;
    movingToPlace = true;
    xT = xTo;
    yT = yTo;
    startXPoint = x;
    startYPoint = y;
    distToTarget = dist(x, y, xT, yT);
  }

  void quarantine() {
    xT = random(base.quarantine.posX, base.quarantine.posX + base.quarantine.len);
    yT = random(base.quarantine.posY, base.quarantine.posY + base.quarantine.len);
    pathToPoint(x, y, xT, yT);
    startXPoint = x;
    startYPoint = y;
    distToTarget = dist(x, y, xT, yT);
    toTheQuarantine = true;
    boardX = base.quarantine.posX;
    boardY = base.quarantine.posY;    
    w = base.quarantine.len;
    h = base.quarantine.len;

    movingToPlace = false;
    arrived = false;
    moving = false;
    waitPlaceTimer = -1;

    base.quarantine.dots.add(this);
    base.tests.get(gen).dots.remove(this);   
    gen = -1;
  }

  boolean askQuarantine() {
    if (!dead && infl && !nonSymptoms && gen != -1) {
      if (curQuarantineChance < random(1)) {
        return true;
      }else{
        curQuarantineChance -= quarantineChance;
      }
    }
    return false;
  }

  void callMoving() {
    if (gen != -1 && !dead && !moving) {
      if (base.tests.size() > 1 && !base.tests.get(gen).closed) {
        base.moving(gen, this);
      }
    }
  }

  void callQuarantine() {
    if (askQuarantine()) {
      quarantine();
    }
  }
}
