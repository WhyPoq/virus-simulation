class Line {
  float posX;
  float posY; 
  float len;

  float from;
  float to;

  int w = 10;
  float value;
  String name;

  int local;
  boolean perc = false;

  Line(float posX, float posY, float len, float from, float to, float value, String name, int local, boolean perc) {
    this.posX = posX;
    this.posY = posY;
    this.len = len;
    this.from = from;
    this.to = to;
    this.value = value;
    this.name = name;
    this.local = local;
    this.perc = perc;
  }

  void setValue(boolean serial) {
    if(serial || checkClick()){
      value = (to - from) * (mouseX - posX) / len;
      if (String.valueOf(to).split("\\.")[1].length() == 1 && String.valueOf(from).split("\\.")[1].length() == 1 && !perc) {
        value = (int)value;
      }
      if (value < from) value = from;
      if (value > to) value = to;
    }
  }

  boolean checkClick() {
    if (posY - w * 2< mouseY && mouseY < posY + w * 2) {
      if (posX - w * 2 < mouseX && posX > mouseX) {
        value = from;
        return true;
      } else if (posX + len < mouseX && posX + len + w * 2 > mouseX) {
        value = to;
        return true;
      } else if (posX < mouseX && mouseX < posX + len) {

        return true;
      }
    }

    return false;
  } 

  void show() {
    stroke(220, 220, 220);
    fill(220, 220, 220);
    strokeWeight(2);  
    line(posX, posY, posX + len, posY);
    ellipse(posX + (value - from) / (to - from) * len, posY, w, w);    
    text(name, posX, posY - 20); 
    text(fmt(value), posX + 0.75 * len, posY - 20);
    strokeWeight(0);
  }

  String fmt(float d)
  {
    if (d == (long) d)
      return String.format("%d", (long)d);
    else
      return String.format("%.2f", d);
  }
}
