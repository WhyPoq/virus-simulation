class Box{
  float posX;
  float posY; 
  float len;
  String name;
  
  boolean value;
  
  int local;
  
  Box(float posX, float posY, float len, boolean value, String name, int local){
    this.posX = posX;
    this.posY = posY;
    this.len = len;
    this.value = value;
    this.name = name;
    this.local = local;
  }
  
  boolean checkClick(){
    if(posX < mouseX && mouseX < posX + len){
      if(posY < mouseY && mouseY < posY + len){
        value = !value;
        return true;
      }
    }
    return false;  
  }  
  
  void show(){
    stroke(220, 220, 220);
    fill(220, 220, 220);
    strokeWeight(2);      
    line(posX, posY , posX + len, posY);
    line(posX, posY, posX, posY + len);
    line(posX + len, posY + len, posX + len, posY);
    line(posX + len, posY + len, posX, posY + len);
    if(value){
      ellipse(posX + len / 2, posY + len / 2, len / 2, len / 2);
    }
    text(name, posX, posY - 20);
    strokeWeight(0);
  }
}
