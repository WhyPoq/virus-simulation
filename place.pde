class Place{
  
  float posX;
  float posY;
  
  int len;
  
  Place(float posX, float posY, int len){
    this.posX = posX;
    this.posY = posY;
    this.len = len;
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
  
}
