class Vaccine {
  float progress = 0;
  float speed = 0;
  float degree;

  boolean started = false;
  float timer = 0;
  float time = 5;

  float healTimer = 0;
  float healTime = 0.2;

  float posX;
  float posY;

  int w;
  int h;

  Handler base;
  
  int maxRate = 5;

  Vaccine(Handler base, float degree, float posX, float posY, int w, int h) {
    this.base = base;
    this.degree = degree;
    this.posX = posX;
    this.posY = posY;
    this.w = w;
    this.h = h;
  }

  void update() {

    if (progress >= 100) {
      healTimer += base.deltaTime;
      if (healTimer >= healTime) {      
        healTimer = 0;
        heal(5);
      }
    } else {
      timer += base.deltaTime;
      if (timer > time) {
        check();
        timer = 0;
      }
      if (started) {
        progress += speed * base.deltaTime;
      }
    }
    show();
  }

  void show() {
    noFill();
    strokeWeight(2);
    rect(posX, posY, w, h);
    float progressLength  = w * progress / 100.0;
    if (progressLength > w) {
      progressLength = w;
    }
    fill(100, 255, 100);
    rect(posX, posY, progressLength, h);
  }

  void begin() {
    started = true;
    speed = pow((degree * 3 * base.quarantine.dots.size() / (float)base.g.popSize), 2) + degree;
  }

  void check() {
    base.g.updateGraph();
    if (!started) {
      if (base.quarantine.dots.size() >= 7) {
        begin();
      }
    } else {
      speed = pow((degree * 3 * base.quarantine.dots.size() / (float)base.g.popSize), 2) + degree;
      if (base.g.dC.get(base.g.dC.size() - 1) > base.g.popSize * 0.80) {
        speed = speed / 100.0;
      }
    }
  }

  void heal(int count) {
    List<Dot> targets = new ArrayList<Dot>();
    base.g.updateGraph();
    for (int i = 0; i < base.tests.size(); i++) {
      if (base.tests.get(i).inflCount > 0) {
        for (int j = 0; j < base.tests.get(i).dots.size(); j++) {
          if (base.tests.get(i).dots.get(j).infl && !base.tests.get(i).dots.get(j).dead) {
            targets.add(base.tests.get(i).dots.get(j));
          }
        }
      }
    }
    for (int j = 0; j < base.quarantine.dots.size(); j++) {
      if (base.quarantine.dots.get(j).infl && !base.quarantine.dots.get(j).dead) {
        targets.add(base.quarantine.dots.get(j));
      }
    }
    if(targets.size() / 200 > maxRate){
      maxRate = count;
    }
    for(int i = 0; i < maxRate; i++){
      if(targets.size() > 0){
        int rand = (int)random(0, targets.size() - 1);
        targets.get(rand).infl = false;
        targets.get(rand).nonSymptoms = true;
        if (targets.get(rand).immuneChance >= random(1)) {
          targets.get(rand).immune = true;
        }
        targets.remove(rand);
      }
    }
  }
}
