enum Task {
  nothing, devision, union, process
}

class InterfaceHandler {

  float boardX;
  float BoardY;
  int wBoard;
  int hBoard;

  List<Cell> childs = new ArrayList<Cell> ();

  int devGrade = -1;
  List<Cell> all = new ArrayList<Cell> ();

  Task curTask = Task.nothing;

  int picked = -1;

  List<Integer> massPicked = new ArrayList<Integer> ();
  boolean shift = false;

  boolean firstDiv = false;
  boolean firstUnion = false;

  List<Line> lines = new ArrayList<Line> ();
  List<Box> boxes = new ArrayList<Box> ();

  float movingChance = 0.05;
  int inflRad = 50;
  int daysAlive = 7;
  float aliveChance = 0.2;
  int immuneChance = 10;
  int symptoms;
  float quarantineChance;
  float vaccineSpeed;

  int activeLineId = -1;

  float speed = 1;
  boolean paused = false;

  int localLinesSize = 0;
  int globalLinesSize = 0;
  int localBoxesSize = 0;
  int globalBoxesSize = 0;

  InterfaceHandler(float boardX, float BoardY, int wBoard, int hBoard) {
    this.boardX = boardX;
    this.BoardY = BoardY;
    this.wBoard = wBoard;
    this.hBoard = hBoard;

    if (wBoard > hBoard) {
      if (wBoard > 2 * hBoard) {
        childs.add(new Cell(boardX, BoardY, hBoard, hBoard, null));
        childs.add(new Cell(boardX, BoardY + hBoard + 40, hBoard, hBoard, null));
      } else {
        childs.add(new Cell(boardX, BoardY, hBoard, hBoard, null));
      }
    } else {
      if (hBoard > 2 * wBoard) {
        childs.add(new Cell(boardX, BoardY, wBoard, wBoard, null));
        childs.add(new Cell(boardX, BoardY + wBoard + 40, wBoard, wBoard, null));
      } else {
        childs.add(new Cell(boardX, BoardY, wBoard, wBoard, null));
      }
    }
    getAll();
    initInterface();
  }

  void initInterface() {
    lines.add(new Line(200 / 1920.0 * width, 100 / 1080.0 * height, 300 / 1920.0 * width, 1, 8000, 400, "size", 1, false));
    lines.add(new Line(200 / 1920.0 * width, 200 / 1080.0 * height, 300 / 1920.0 * width, 0.01, 1, 0.4, "chance", 1, true));
    lines.add(new Line(200 / 1920.0 * width, 300 / 1080.0 * height, 300 / 1920.0 * width, 1, 100, 50, "distanceRad", 1, false));
    lines.add(new Line(200 / 1920.0 * width, 400 / 1080.0 * height, 300 / 1920.0 * width, 0, 10, 2, "numberPlaces", 1, false));
    lines.add(new Line(700 / 1920.0 * width, 100 / 1080.0 * height, 300 / 1920.0 * width, 0, 10000, 100, "closeRate", 1, false));
    lines.add(new Line(700 / 1920.0 * width, 200 / 1080.0 * height, 300 / 1920.0 * width, 0, 1, 0.2, "cityDensity", 1, true));
    lines.add(new Line(700 / 1920.0 * width, 300 / 1080.0 * height, 300 / 1920.0 * width, 0.01, 2, 1, "multSize", 1, true));
    localLinesSize = lines.size();

    lines.add(new Line(200 / 1920.0 * width, 600 / 1080.0 * height, 300 / 1920.0 * width, 1, 300, 60, "inflRad", 0, false));
    lines.add(new Line(200 / 1920.0 * width, 700 / 1080.0 * height, 300 / 1920.0 * width, 0, 1, 0.1, "aliveChance", 0, true));
    lines.add(new Line(200 / 1920.0 * width, 800 / 1080.0 * height, 300 / 1920.0 * width, 1, 100, 30, "daysAlive", 0, false));
    lines.add(new Line(200 / 1920.0 * width, 900 / 1080.0 * height, 300 / 1920.0 * width, 0, 100, 50, "movingChance", 0, false));
    lines.add(new Line(200 / 1920.0 * width, 1000 / 1080.0 * height, 300 / 1920.0 * width, 0, 100, 40, "imuneChance", 0, false));   
    lines.add(new Line(700 / 1920.0 * width, 600 / 1080.0 * height, 300 / 1920.0 * width, 1, 10000, 3000, "symptoms", 0, false));
    lines.add(new Line(700 / 1920.0 * width, 700 / 1080.0 * height, 300 / 1920.0 * width, 0, 100, 0, "quarantineChance", 0, false));
    lines.add(new Line(700 / 1920.0 * width, 800 / 1080.0 * height, 300 / 1920.0 * width, 0, 1000, 0, "vaccineSpeed", 0, false));
    globalLinesSize = 8;

    boxes.add(new Box(20 / 1920.0 * width, 100 / 1080.0 * height, 60 / 1920.0 * width, true, "first", 1));
    boxes.add(new Box(20 / 1920.0 * width, 300 / 1080.0 * height, 60 / 1920.0 * width, true, "distancing", 1));
    boxes.add(new Box(20 / 1920.0 * width, 500 / 1080.0 * height, 60 / 1920.0 * width, true, "saveSize", 1));
    localBoxesSize = 3;


    lines.add(new Line(200 / 1920.0 * width, 700 / 1080.0 * height, 300 / 1920.0 * width, 0.0, 4, 1, "speed", 2, true));
    boxes.add(new Box(20 / 1920.0 * width, 700 / 1080.0 * height, 60 / 1920.0 * width, false, "pause", 2));
  }

  void wheel(int sign) {
    if (curTask == Task.devision && picked != -1) {
      if (picked != -1) {
        devGrade += sign;
        if (devGrade <= 0) {
          devGrade = 2;
        }
        if (devGrade != 0) {
          if (all.get(picked).w / devGrade < 75) {
            devGrade = all.get(picked).w / 75;
          }
        }
      }
      all.get(picked).devide(devGrade);
    }
  }


  void update(boolean started) {
    if (!started) {
      beginUpdate();
    } else {
      processUpdate();
    }
  }

  void processUpdate() {
    for (int i = 0; i < lines.size(); i++) {
      if (lines.get(i).local == 2) {
        lines.get(i).show();
      }
    }
    for (int i = 0; i < boxes.size(); i++) {
      if (boxes.get(i).local == 2) {
        boxes.get(i).show();
      }
    }
  }

  void beginUpdate() {
    if (firstDiv) {
      wheel(0);
      firstDiv = false;
    }  
    if (firstUnion) {
      firstUnion = false;
      if (picked != -1 && curTask == Task.union) {
        if (all.get(picked).parent != null) {
          if (all.get(picked).parent.checkChildUnility()) {
            all.get(picked).parent.drawUnion();
          } else {
            all.get(picked).active = false;
            picked = -1;
          }
        }
      }
    }    
    drawSettings();   

    for (int i = 0; i < childs.size(); i++) {
      childs.get(i).show();
    }
  }

  void getAll() {
    all.clear();
    for (int i = 0; i < childs.size(); i++) {
      all.addAll(childs.get(i).getChilds());
    }
  }

  int findActiveCell() {
    getAll();
    for (int i = 0; i < all.size(); i++) {
      if (all.get(i).posX <= mouseX && all.get(i).posX + all.get(i).w >= mouseX) {
        if (all.get(i).posY <= mouseY && all.get(i).posY +  all.get(i).h >= mouseY) {
          return i;
        }
      }
    }
    return -1;
  }

  void mouseHold() {   
    if (activeLineId != -1) {
      if (curTask == Task.process) {
        checkInterfaceProcess(true);
      } else {
        checkInterface(true);
      }
    }
  }

  void mouse(int button) {
    if (curTask == Task.process) {
      checkInterfaceProcess(false);
    } else if (checkInterface(false)) {
    } else {    
      if (picked != -1 && curTask == Task.union) {
        if (button == 1) {
          if (picked == findActiveCell()) {
            doUnion();
          }
          clearUnion();
          getAll();
        }
        if (button == 0) {
          clearUnion();
        }
      } else {
        if (picked != -1 && curTask == Task.devision) {
          if (button == 1) {
            DoDevide();
            clearDevide();
            getAll();
          }
          if (button == 0) {
            clearDevide();
          }
        } else {  
          if (button == 1) {
            int active = findActiveCell();
            if (active != -1) {
              if (!shift || curTask != Task.nothing) {
                for (int i = 0; i < massPicked.size(); i++) {
                  all.get(Integer.valueOf(massPicked.get(i))).active = false;
                }
                massPicked.clear();
                picked = active;
                all.get(picked).active = true;
                massPicked.add(picked);
                firstDiv = true;
                firstUnion = true;
              } else {
                if (massPicked.contains(active)) {
                  all.get(Integer.valueOf(active)).active = false;
                  massPicked.remove(Integer.valueOf(active));
                  if (massPicked.size() > 0) {
                    picked = massPicked.get(massPicked.size() - 1);
                  } else {
                    picked = -1;
                  }
                } else {
                  picked = active;
                  massPicked.add(picked);
                  all.get(picked).active = true;
                }
              }
            }
          } else if (button == 0) {
            if (picked != -1) {
              all.get(picked).active = false;
              for (int i = 0; i < massPicked.size(); i++) {
                all.get(massPicked.get(i)).active = false;
              }
              massPicked.clear();
            }
            picked = -1;
          }
        }
      }
    }
  }

  void clearDevide() {
    all.get(picked).curDevide = false;
    all.get(picked).active = false;
    all.get(picked).devCount = -1;
    devGrade = -1;
    picked = -1;
  }

  void DoDevide() {
    all.get(picked).doDevide();
  }

  void doUnion() {
    if (all.get(picked).parent != null) {
      all.get(picked).parent.doUnion();
    }
  }

  void clearUnion() {
    if (all.get(picked).parent != null) {
      all.get(picked).active = false;
      for (int i = 0; i < all.get(picked).parent.childs.size(); i++) {
        all.get(picked).parent.childs.get(i).curUnion = false;
      }
      picked = -1;
    }
  }

  void drawSettings() {
    if (picked != -1 && curTask == Task.nothing && massPicked.size() == 1) {
      lines.get(0).value = all.get(picked).genSize;
      lines.get(1).value = all.get(picked).chance;
      lines.get(2).value = all.get(picked).distanceChance;
      lines.get(3).value = all.get(picked).numberPlaces;
      lines.get(4).value = all.get(picked).closeRate;
      lines.get(5).value = all.get(picked).cityDensity;
      lines.get(6).value = all.get(picked).multSize;

      boxes.get(0).value = all.get(picked).firstInfl;
      boxes.get(1).value = all.get(picked).distancing;
      boxes.get(2).value = all.get(picked).saveSize;

      for (int i = 0; i < lines.size(); i++) {
        if (lines.get(i).local != 2) {
          lines.get(i).show();
        }
      }
      for (int i = 0; i < boxes.size(); i++) {
        if (boxes.get(i).local != 2) {
          boxes.get(i).show();
        }
      }
    } else {
      for (int i = 0; i < lines.size(); i++) {
        if (lines.get(i).local == 0) {
          lines.get(i).show();
        }
      }
      for (int i = 0; i < boxes.size(); i++) {
        if (lines.get(i).local == 0) {
          boxes.get(i).show();
        }
      }
    }
  }

  void setValue() {
    inflRad = (int)lines.get(localLinesSize).value;
    aliveChance = lines.get(localLinesSize + 1).value;
    daysAlive = (int)lines.get(localLinesSize + 2).value;
    movingChance = lines.get(localLinesSize + 3).value;
    immuneChance = (int)lines.get(localLinesSize + 4).value;
    symptoms = (int)lines.get(localLinesSize + 5).value;
    quarantineChance = (int)lines.get(localLinesSize + 6).value;
    vaccineSpeed = (int)lines.get(localLinesSize + 7).value;
    if (picked != -1) {
      all.get(picked).genSize = (int)lines.get(0).value;
      all.get(picked).chance = lines.get(1).value;
      all.get(picked).distanceChance = (int)lines.get(2).value;    
      all.get(picked).numberPlaces = (int)lines.get(3).value;
      all.get(picked).closeRate = (int)lines.get(4).value;
      all.get(picked).cityDensity = lines.get(5).value;
      all.get(picked).multSize = lines.get(6).value;
    }
  }

  boolean checkInterface(boolean serial) {
    boolean ans = false;

    if (serial) {
      lines.get(activeLineId).setValue(serial);
      setValue();
    }

    for (int i = 0; i < lines.size(); i++) {
      if (lines.get(i).local == 0) {
        if (lines.get(i).checkClick()) {
          lines.get(i).setValue(serial);
          setValue();
          activeLineId = i;
          ans = true;
          break;
        }
      }
    }
    ans = checkInterfaceLocal(serial);
    return ans;
  }

  boolean checkInterfaceLocal(boolean serial) {
    boolean ans = false;

    if (picked != -1 && curTask == Task.nothing && massPicked.size() == 1) {
      for (int i = 0; i < lines.size(); i++) {
        if (lines.get(i).checkClick() && lines.get(i).local == 1 || lines.get(i).checkClick()) {
          lines.get(i).setValue(serial);
          setValue();
          activeLineId = i;
          ans = true;
          break;
        }
      }
      if (!serial) {
        for (int i = 0; i < boxes.size(); i++) {
          if (boxes.get(i).checkClick() && boxes.get(i).local == 1) {
            all.get(picked).firstInfl = boxes.get(0).value;
            all.get(picked).distancing = boxes.get(1).value;  
            all.get(picked).saveSize = boxes.get(2).value;  
            ans = true;
            break;
          }
        }
      }
    }

    return ans;
  }

  boolean checkInterfaceProcess(boolean serial) {
    boolean ans = false;

    if (serial) {
      lines.get(activeLineId).setValue(serial);
      speed = lines.get(activeLineId).value;
    }

    for (int i = 0; i < lines.size(); i++) {
      if (lines.get(i).local == 2) {
        if (lines.get(i).checkClick()) {
          lines.get(i).setValue(serial);
          speed = lines.get(i).value;
          activeLineId = i;
          ans = true;
          break;
        }
      }
    }
    
    for (int i = 0; i < boxes.size(); i++) {
      if (boxes.get(i).local == 2) {
        if (boxes.get(i).checkClick()) {
          paused = boxes.get(i).value;
          ans = true;
          break;
        }
      }
    }

    return ans;
  }
}
