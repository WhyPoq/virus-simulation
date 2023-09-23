class Quarantine{
  
  long lastFrame;
  List<Dot> dots = new ArrayList<Dot>();
  
  float posX;
  float posY;
  float len;
  float dotSize;
  
  int inflCount = 0;
  int susCount = 0;
  int deadCount = 0;
  
  Quarantine(float posX, float posY, float len){
    this.posX = posX;
    this.posY = posY;
    this.len = len;
    
    dotSize = (int)(0.0125 * (float)len);
  }
  
  void update(){
    moveDots();
    showDots();
    show();
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
  
  void show(){
    stroke(220, 220, 220);
    strokeWeight(2);      
    line(posX, posY, posX + len, posY);
    line(posX, posY, posX, posY + len);
    line(posX + len, posY + len, posX +len, posY);
    line(posX + len, posY + len, posX, posY +len);
    strokeWeight(0);    
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
  
}
