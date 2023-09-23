class Handler {

  List<Gen> tests = new ArrayList<Gen> ();
  Graph g;
  Quarantine quarantine;
  Vaccine vaccine;

  float movingChance = 0.05;
  float quarantineChance = 0.05;
  int inflRad = 50;
  int daysAlive = 12;
  float aliveChance = 0.2;
  float immuneChance = 0.1;
  float symptoms;
  int numberPlaces = 0;
  
  float deltaTime = 0;
  long lastFrame = 0;

  InterfaceHandler UI;

  Handler(InterfaceHandler UI) {
    this.UI = UI;
  }

  void update() {
    deltaTime = (millis() - lastFrame) / 1000.0 * UI.speed;
    if(UI.paused){
      deltaTime = 0;
    }
    lastFrame = millis();
    
    strokeWeight(0);
    for (int i = 0; i < tests.size(); i++) {
      tests.get(i).frame();
    }

    quarantine.update();
    vaccine.update();
    g.update();
  }

  void moving(int gen, Dot dot) {
    if (movingChance > random(1)) {
      List<Gen> readyToMove = new ArrayList<Gen>();
      for(int i = 0; i < tests.size(); i++){
        if(!tests.get(i).closed){
          readyToMove.add(tests.get(i));
        }
      }
      int randPlanet = (int)random(0, readyToMove.size());
      
      cords c = tests.get(randPlanet).city.getCord(0);
      int xCord = c.x;
      int yCord = c.y;
      for(int i = 0; i < tests.get(gen).dots.size(); i++){
        if(tests.get(gen).dots.get(i) == dot){
          tests.get(gen).dots.get(i).moveToThePlanet(randPlanet, xCord, yCord);
        }
      }
    }
  }

void arrived(Dot dot, int gen) {
  dot.boardX = tests.get(dot.planetTarget).posX;
  dot.boardY = tests.get(dot.planetTarget).posY;    
  dot.w = tests.get(dot.planetTarget).w;
  dot.h = tests.get(dot.planetTarget).h;

  tests.get(dot.planetTarget).dots.add(dot);
  tests.get(gen).dots.remove(dot);

  dot.arrived = false;
  dot.moving = false;
  dot.gen = dot.planetTarget;
}

void activate() {
  UI.getAll();
  UI.picked = -1;
  UI.setValue();
  UI.curTask = Task.process;
  movingChance = UI.movingChance / 30000.0;
  inflRad = UI.inflRad;
  daysAlive = UI.daysAlive;
  aliveChance = UI.aliveChance / 10.0;
  immuneChance = UI.immuneChance / 10.0;
  symptoms = UI.symptoms / 100000.0;
  quarantineChance = UI.quarantineChance / 8000.0;


  int count = 0;
  for (int i = 0; i < UI.all.size(); i++) {
    if (UI.all.get(i).active) {  
      tests.add(new Gen(UI.all.get(i).genSize, 2000, inflRad, daysAlive, UI.all.get(i).chance / 10, 
        UI.all.get(i).w, UI.all.get(i).h, (int)UI.all.get(i).posX, (int)UI.all.get(i).posY, this, count, 
        UI.all.get(i).firstInfl, UI.all.get(i).distancing, UI.all.get(i).distanceChance, UI.all.get(i).saveSize, 
        UI.all.get(i).findPraParent().w, aliveChance, immuneChance, symptoms, UI.all.get(i).numberPlaces,
        quarantineChance, UI.all.get(i).closeRate / 4000.0, UI.all.get(i).cityDensity, UI.all.get(i).multSize));
      count++;
    }
  }
  quarantine = new Quarantine(650 / 1920.0 * width, 600 / 1080.0 * height, 200 / 1920.0 * width);
  g = new Graph((int)(50 / 1920.0 * width), (int)(50 / 1080.0 * height), (int)(800 / 1920.0 * width), (int)(500 / 1080.0 * height), this);
  vaccine = new Vaccine(this, UI.vaccineSpeed / 200, 450 / 1920.0 * width, 850 / 1080.0 * height, (int)(400 / 1920.0 * width), (int)(50 / 1080.0 * height));
}
}
