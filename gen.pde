class Gen{
  
  int inflRate;
  
  List<Dot> dots = new ArrayList<Dot>();
  List<Place> places = new ArrayList<Place>();
  
  int w;
  int h;
  
  int dotSize = 10;
  int fadeSpeed = 5;
  
  int inflRad;  
  int genSize;
  long maxInflAlive;
  float chance;
  int distanceChance;
  float immuneChance;
  float symptoms;
  int numberPlaces;
  float quarantineChance;
  float closeRate;
  
  int posX;
  int posY;
  
  int deadCount = 0;
  int inflCount = 0;
  int susCount = 0;
  
  Handler base;
  int number;
  
  boolean first = false;
  boolean distancing = false;
  boolean saveSize = false;
  boolean closed = false;
  
  int border = 5;
  float timeAtThePlace = 2000;
  float moveToPlaceChance = 0.0005;
  
  float aliveChance;
  
  CityBuilder city;
  
  Gen(int genSize, int inflRate, int inflRad, long maxInflAlive, float chance, int w, int h, int posX, int posY, Handler base,
  int number, boolean first, boolean distancing, int distanceChance, boolean saveSize, int parentSize, float aliveChance, 
  float immuneChance, float symptoms, int numberPlaces, float quarantineChance, float closeRate, float cityDensity, float sizeMult){
    this.inflRate = inflRate;
    this.inflRad = inflRad;
    this.genSize = genSize;  
    this.maxInflAlive = maxInflAlive;
    this.chance = chance;
    this.w = w - border;
    this. h = h - border;
    this.posX = posX;// + border;
    this.posY = posY;// + border;
    this.base = base;
    this.number = number;
    this.first = first;
    this.distancing = distancing;
    this.distanceChance = distanceChance;
    this.saveSize = saveSize;
    this.aliveChance = aliveChance;
    this.immuneChance = immuneChance;
    this.symptoms = symptoms;
    this.numberPlaces = numberPlaces;
    this.quarantineChance = quarantineChance;
    this.closeRate = closeRate;
    
    city = new CityBuilder(this.w, cityDensity, this.posX, this.posY);
    genPlaces();
    
    if(!saveSize){
      dotSize = (int)(0.0125 * (float)w);
      //fadeSpeed = (int)((float)w * 0.005);
      this.inflRad = (int)((float)inflRad * (float)w / 800.0);
    }else{
      dotSize = (int)(0.0125 * (float)parentSize * sizeMult);
      if(dotSize == 0) dotSize = 1;
      //fadeSpeed = (int)((float)parentSize * 0.005);
      this.inflRad = (int)((float)inflRad * (float)parentSize / 800.0  * sizeMult);
      if(inflRad == 0) inflRad = 1;
    }

    createGen(genSize);
  }
  
  void genPlaces(){
    for(int i = 0; i < numberPlaces; i++){
     // places.add(new Place(random(posX, posX + w - w / 20), random(posY, posY + h - h / 30), w / 30)); 
     cords c = city.getCord(w / 30);
     places.add(new Place(c.x, c.y, w / 30));
    }
  }
  
  void frame() {
    update();
    
  }
  
  void createGen(int size){
    for(int i = 0; i < size; i++){
      dots.add(new Dot(w, h, dotSize, inflRad, fadeSpeed, inflRate, maxInflAlive, posX, posY, base, number,
      distancing, distanceChance, aliveChance, immuneChance, symptoms, timeAtThePlace, quarantineChance, this, border));
    }
    if(first){
      dots.get(0).infl = true;
    }
  }
  
  void update(){
    updateGraph();
    doInfl();
    checkDead();
    tryClose();
    
    moveToThePlace();
    moveDots();
    showDots();
    showPlaces();
    
    stroke(220, 220, 220);
    if(closed){
      stroke(40, 100, 100);
    }
    strokeWeight(2);      
    /*line(posX, posY, posX + w, posY);
    line(posX, posY, posX, posY + h);
    line(posX + w, posY + h, posX + w, posY);
    line(posX + w, posY + h, posX, posY + h);*/
    line(posX + border, posY + border, posX + w - border, posY + border);
    line(posX + border, posY + border, posX + border, posY + h - border);
    line(posX + w - border, posY + h - border, posX + w - border, posY + border);
    line(posX + w - border, posY + h - border, posX + border, posY + h - border);
    strokeWeight(0);
    noStroke();
  }
  
  void showPlaces(){
    for(int i = 0; i < places.size(); i++)
    {
      places.get(i).show();
    }
  }
  
  void showDots(){
    for(int i = 0; i < dots.size(); i++){
      dots.get(i).show();
    }
  }
  
  void moveDots(){
    for(int i = 0; i < dots.size(); i++){
      dots.get(i).move();
    }
  } 
  
  void tryClose(){
    if(!closed){
      if(base.quarantine.dots.size() >= base.g.popSize * closeRate){
        closed = true;        
      }
    }    
  }
  
  void doInfl(){
    List<Dot> willInfl = new ArrayList<Dot> ();
    List<Dot> rtiOver = new ArrayList<Dot> ();
    
    for(int i = 0; i < dots.size(); i++){
      if(dots.get(i).rti && !dots.get(i).dead && !dots.get(i).moving){
        for(int j = 0; j < dots.size(); j++)
        {
          if(j != i && !dots.get(j).infl && !dots.get(j).dead && !dots.get(j).immune){
            if(dist(dots.get(i).x, dots.get(i).y, dots.get(j).x, dots.get(j).y) <= inflRad / 2){
              willInfl.add(dots.get(j));
            }
          }
        }
      }
    }
    
    for(int i = 0; i < willInfl.size(); i++){
      if(chance >= random(1)){    
        willInfl.get(i).infl = true;
        willInfl.get(i).inflTimer = 0;
      }
    }
    for(int i = 0; i < rtiOver.size(); i++){
      rtiOver.get(i).rti = false;
    }
  }
  
  void checkDead(){
    for(int i = 0; i < dots.size(); i++){
      if(dots.get(i).dead && !dots.get(i).off){
        dots.get(i).off = true;
      }
      
    }
  }
  
  void updateGraph(){
    inflCount = 0;
    susCount = 0;
    deadCount = 0;
    
    for(int i = 0; i < dots.size(); i++){
      if(dots.get(i).infl && !dots.get(i).dead){
        inflCount++;
      }else if(dots.get(i).dead){
        deadCount++;
      }else{
        susCount++;
      }
    }
  }
  
  void moveToThePlace(){
    if(places.size() > 0){
      for(int i = 0; i < dots.size(); i++){
        if(!dots.get(i).dead && !dots.get(i).moving && !dots.get(i).movingToPlace){
          if(moveToPlaceChance > random(1)){
            int rand = (int)random(0, places.size());
            dots.get(i).moveToThePlace(places.get(rand).posX + places.get(rand).len / 2, places.get(rand).posY + places.get(rand).len / 2, timeAtThePlace);
          }
        }    
      }
    }
  }
}
