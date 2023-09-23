class Graph{
  
  int posX;
  int posY;
  int popSize;
  int w;
  int h;  
  
  long valuesCount = 0; 
  float lastTime;
  
  List<Integer> sC = new ArrayList<Integer> ();
  List<Integer> dC = new ArrayList<Integer> ();
  List<Integer> iC = new ArrayList<Integer> ();
  
  Handler base;
  
  Graph(int posX, int posY, int w, int h, Handler base){
    this.posX = posX;
    this.posY = posY;
    this.w = w;
    this.h = h;
    this.base = base;
    for(int i = 0; i < base.tests.size(); i++){
      popSize += base.tests.get(i).genSize;    
    }
    
    lastTime = 0;
    collectInformation();
  }
  
  void update(){
    lastTime += base.deltaTime;
    if(lastTime >= 0.02){
      lastTime = 0;
      valuesCount++;
      collectInformation();
    }
      
    float valuesCountDim = (float)valuesCount / 20.0;
      
    noStroke();
    for(int i = 1; i <= valuesCount; i++){
      if(iC.get(i) > 0){
        fill(230, 100, 100);  
        rect(posX + (float)(i - 1) * (float)w / (float)valuesCount, posY + h, 
        (float)w / (float)valuesCount + 1, -h * (float)iC.get(i) / (float)popSize);
      }
      
      if(sC.get(i) > 0){
        fill(100, 200, 200);  
        rect(posX + (float)(i - 1) * (float)w / (float)valuesCount, posY + h -h / (float)popSize * (float)iC.get(i), 
        (float)w / (float)valuesCount + 1, -h / (float)popSize * (float)sC.get(i));
      }
      
      if(dC.get(i) > 0){
        fill(150, 150, 150);  
        rect(posX + (float)(i - 1) * (float)w / (float)valuesCount, posY + h -h / (float)popSize * (float)iC.get(i) 
        -h / (float)popSize * (float)sC.get(i), 
        (float)w / (float)valuesCount + 1, -h / (float)popSize * (float)dC.get(i));
      }
    }
      
    stroke(220, 220, 220);
    strokeWeight(2);
      
    line(posX, posY, posX, posY + h + 20);
    line(posX - 20, posY + h, posX + w, posY + h);
      
    for(int i = 0; i < 10; i++){
      line(posX - 10, posY + i * h * 0.1, posX + 10, posY + i * h * 0.1);
    }
   
    int step = 1;
    if(valuesCountDim > 10){
      step = 5;
      int tmp = (int)valuesCountDim;
      tmp = tmp / 100;
      while(tmp > 0){
        step = step * 10;
        tmp = tmp / 10;
      }
    }
    textSize((20 * pow((1 / 1920.0 * width), 1 / 3.0)));
    for(int i = step; i < valuesCountDim; i += step){
      line(posX + i * w / valuesCountDim, posY + h - 10, posX + i * w / valuesCountDim, posY + h + 10);
      fill(255, 255, 255);
      text(i, posX + i * w / valuesCountDim - 5,  posY + h + 35); 
    }
    textSize((15 * pow((1 / 1920.0 * width), 1 / 3.0)));
    
   strokeWeight(0);      
  }
  
  void collectInformation(){
    int sumS = 0;
    int sumI = 0;
    int sumD = 0;
    updateGraph();
    for(int i = 0; i < base.tests.size(); i++){
      sumS += base.tests.get(i).susCount;
      sumI += base.tests.get(i).inflCount;
      sumD += base.tests.get(i).deadCount;
    }   
    sumS += base.quarantine.susCount;
    sumI += base.quarantine.inflCount;
    sumD += base.quarantine.deadCount;
    
    sC.add(sumS);
    iC.add(sumI);
    dC.add(sumD);
  }
  
  void updateGraph(){
    for(int i = 0; i < base.tests.size(); i++){
      base.tests.get(i).updateGraph();     
    }
    base.quarantine.updateGraph();
  }
}
