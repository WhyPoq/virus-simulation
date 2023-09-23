import java.util.*;

Handler handler;
InterfaceHandler UI;

boolean started = false;
boolean info = false;

void setup() {
  
  //surface.setSize(h, w);
  //size(1280, 900);
  fullScreen();
  frameRate(60);
  textSize(15 * pow((1 / 1920.0 * width), 1 / 3.0));//15 / 1920.0 * width
  UI = new InterfaceHandler(1120 / 1920.0 * width, 45 / 1080.0 * height, (int)(490 / 1920.0 * width), (int)(1025 / 1080.0 * height));//(900, 45, 505, 505);
  handler = new Handler(UI);
}

void draw() {
  background(40);
  if(info){
    fill(220);
    rect(1870 / 1920.0 * width, 10 / 1080.0 * height, 40 / 1920.0 * width, 40 / 1920.0 * width);
    fill(255, 40, 40);
    textSize(20 * pow((1 / 1920.0 * width), 1 / 2.0));
    textAlign(CENTER, CENTER);
    text("x", 1870 / 1920.0 * width, 5 / 1080.0 * height, 40 / 1920.0 * width, 40 / 1920.0 * width);
    textAlign(LEFT);
    textSize(15 * pow((1 / 1920.0 * width), 1 / 3.0));
    
    fill(220);
    textSize(30 * pow((1 / 1920.0 * width), 1 / 3.0));
    text("S - старт", 100 / 1920.0 * width, 100 / 1080.0 * height);
    text("P - выбрать", 100 / 1920.0 * width, 200 / 1080.0 * height);
    text("D - разделить", 100 / 1920.0 * width, 300 / 1080.0 * height);
    text("U - объединить", 100 / 1920.0 * width, 400 / 1080.0 * height);
    textSize(15 * pow((1 / 1920.0 * width), 1 / 3.0));
  }
  else{
    UI.update(started);  
    if(started){
      handler.update();
    }
    if(mousePressed){
      if(mouseButton == LEFT){
        UI.mouseHold();
      }
    }
    
    if(!started){
      fill(220);
      rect(1870 / 1920.0 * width, 10 / 1080.0 * height, 40 / 1920.0 * width, 40 / 1920.0 * width);
      fill(40);
      textSize(20 * pow((1 / 1920.0 * width), 1 / 2.0));
      textAlign(CENTER, CENTER);
      text("?", 1870 / 1920.0 * width, 5 / 1080.0 * height, 40 / 1920.0 * width, 40 / 1920.0 * width);
      textAlign(LEFT);
      textSize(15 * pow((1 / 1920.0 * width), 1 / 3.0));
    }
  }
}

boolean overRect(float x, float y, float w, float h)  {
  if (mouseX >= x && mouseX <= x+w && 
      mouseY >= y && mouseY <= y+h) {
    return true;
  } else {
    return false;
  }
}

void mousePressed(){
  if(info){
    if (overRect(1870 / 1920.0 * width, 10 / 1080.0 * height, 40 / 1920.0 * width, 40 / 1920.0 * width)) {
      info = false;
    }
  }
  else{
    if(mouseButton == RIGHT){
      UI.mouse(0);
    }
    if(mouseButton == LEFT){
      UI.mouse(1);
    }
    
    if (overRect(1870 / 1920.0 * width, 10 / 1080.0 * height, 40 / 1920.0 * width, 40 / 1920.0 * width) && !started) {
      info = true;
    }
  }
 
} 
  
void mouseWheel(MouseEvent event) {
  if(info) return;
    float e = event.getCount();
    UI.wheel(-(int)e);
}

void keyPressed(){
  if(info) return;
  if(key == 'd' || key == 'D' || key == 'в' ||key == 'В'){
    if(UI.curTask != Task.devision){
      UI.curTask = Task.devision;
      UI.massPicked.clear();
      UI.firstDiv = true;
    }
  }
  if(key == 'u' || key == 'U' || key == 'г' || key == 'Г'){
    if(UI.curTask != Task.union){
      UI.curTask = Task.union;
      UI.massPicked.clear();
      UI.firstUnion = true;
    }
  }
  if(key == 'p' || key == 'P' || key == 'з' || key == 'З'){
    if(UI.curTask != Task.nothing){
      UI.curTask = Task.nothing;
      UI.massPicked.clear();
    }
  }
  if(key == 's' || key == 'S' || key == 'ы' || key == 'Ы'){
    started = true;
    handler.activate();
  }
  if(keyCode  == SHIFT){
    UI.shift = true;
  }
}

void keyReleased(){
  if(info) return;
  if(keyCode  == SHIFT){
    UI.shift = false;
  }
}
 

void mouseReleased(){
  UI.activeLineId = -1;
}
