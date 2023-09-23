class Cell{
  
  int w;
  int h;
  float posX;
  float posY;
  
  List<Cell> childs = new ArrayList<Cell> ();
  Cell parent = null;
  
  boolean curDevide = false;
  boolean curUnion = false;
  int devCount = -1;
  
  boolean active = false;
  
  int border = 5;
  
  
  int genSize = 400;
  float chance = 0.4;
  
  boolean firstInfl = false;
  boolean distancing = false;
  boolean saveSize = false;
  int distanceChance = 50;
  int numberPlaces = 0;
  float closeRate = 2000;
  float cityDensity = 0.2;
  float multSize = 1;
  
  Cell(float posX, float posY, int w, int h, Cell parent){
    this.posX = posX;
    this.posY = posY;
    this.w = w;
    this.h = h;
    this.parent = parent;
  }
  
  void show(){
    stroke(220, 220, 220);
    
    if(active){
      stroke(100, 255, 100);
    }
    
    if(curUnion){
      stroke(100, 255, 255);
    }
    if(childs.size() == 0){
    strokeWeight(2);      
    line(posX + border, posY + border, posX + w - border, posY + border);
    line(posX + border, posY + border, posX + border, posY + h - border);
    line(posX + w - border, posY + h - border, posX + w - border, posY + border);
    line(posX + w - border, posY + h - border, posX + border, posY + h - border);
    strokeWeight(0);
    }
    
    for(int i = 0; i < childs.size(); i++){
      childs.get(i).show();
    }
    
    if(curDevide){
      drawDevide();
    }
    
  }
  
  void drawUnion(){
    for(int i = 0; i < childs.size(); i++){
      childs.get(i).curUnion = true;
    }
  }
  
  void doUnion(){
    childs.clear();
  }
  
  void devide(int count){
    if(count > 1){
      devCount = count;
      curDevide = true;  
    }
  }
  
  boolean checkChildUnility(){
    boolean ans = true;
    for(int i = 0; i < childs.size(); i++){
      if(childs.get(i).childs.size() > 0){
        ans = false;
        break;
      }
    }
    return ans;
  }
  
  void drawDevide(){
    if(devCount != -1){
      for(int i = 1; i < devCount; i++){
        dashedLine(posX + i * (w / devCount), posY,  posX + i * (w / devCount), posY + h, 0, 1);
        dashedLine(posX, posY  + i * (h / devCount), posX + w, posY + i * (h / devCount), 1, 0);
      }
    }
  }
  
  void dashedLine(float x1, float y1, float x2, float y2, float aX, float aY){
    stroke(220, 220, 220);
    strokeWeight(1.5);
    
    aX = 20 * aX;
    aY = 20 * aY;
    
    if(aX > 0){
      for(float x = x1; x < x2; x += aX){
          float y = y1;
          float nextX = x + aX;
          if(nextX > x2) nextX = x2;
          line(x, y, nextX, y); 
          
          x += 10;
        }
    }
    if(aY > 0){
      for(float y = y1; y <= y2; y += aY){
          float x = x1;
          float nextY = y + aY;
          if(nextY > y2) nextY = y2;
          line(x, y, x, nextY); 
          
          y+= 10;
        }
    }
  }
  
  List<Cell> getChilds(){
    List<Cell> ans = new ArrayList<Cell> ();
    if(childs.size() == 0){
      ans.add(this);
      return ans;
    }
    for(int i = 0; i < childs.size(); i++){
      ans.addAll(childs.get(i).getChilds());
    }
    return ans;
  }
  
  void doDevide(){
    for(int x = 0; x < devCount; x++){
      for(int y = 0; y < devCount; y++){
        childs.add(new Cell(posX + x * w / devCount, posY + y * h / devCount, w / devCount, h / devCount, this));
      }
    }
    
  }
  
  Cell findPraParent(){
    if(parent == null){
      return this;
    }else{
      return parent.findPraParent();
    }
  }
}
