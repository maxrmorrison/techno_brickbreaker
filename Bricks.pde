class Bricks {
     
  int cols = 32;
  int rows = 6;
  float x, y, w, h;
  int oldStep1 = 0;
  int oldStep2 = 0;
  boolean newStep1 = true;
  boolean newStep2 = true;
  boolean newTone = true;
  boolean messageSent;
  int oldHeight = 0;
  int pitchHeight = 0;
  boolean newStep = true;
  boolean snarePlayed = false;
  boolean kickPlayed = false;
  boolean closedHiHatPlayed = false;
  boolean openHiHatPlayed = false;
  boolean shakerPlayed = false;
  boolean clapPlayed = false;
  int os = 20;
  int sample = 10;
  
  Bricks(float x_, float y_, float w_, float h_, int cols_, int rows_) {
    x = x_;
    y = y_;
    w = w_;
    h = h_;
    cols = cols_;
    rows = rows_;
  }

  int[][] brickOn1 = new int[cols][rows];
  int[][] brickOn2 = new int[16][rows];
    
  void setupLevel1(int on) {
    print("cp");
    for (int i = 0; i < cols; ++i) {
      for (int j = 0; j < rows; ++j) {
        brickOn1[i][j] = 0;
      }
    }
    
    for(int i = 0; i < cols; ++i) {
      if (i == 0 || i == 2 || i == 6 || i == 7 || i == 11 || i == 14 ||
          i == 18 || i == 22 || i == 23 || i == 27 || i == 28 || i == 30) {
            brickOn1[i][2] = on;
    }
    }
    for(int i = 0; i < cols; ++i) {
      if (i != 8 && i != 24) {
            brickOn1[i][0] = on;
    }
    }
    
    for (int i = 0; i < cols; ++i) {
      if (i == 4 || i == 14 || i == 20 || i == 30) {
        brickOn1[i][3] = on;
      }
    }
    
    for (int i = 0; i < cols; ++i) {
      if (i == 4 || i == 10 || i == 11 || i == 13 ||
          i == 20 || i == 24 || i == 29 || i == 31) {
            brickOn1[i][4] = on;
          }
    }
    
    for (int i = 0; i < cols; ++i) {
      if (i == 0 || i == 4 || i == 8 || i == 12 || i == 15 || i == 14 ||
          i == 16 || i == 20 || i == 24 || i == 28 || i == 30 || i == 31) {
            brickOn1[i][5] = on;
          }
    }
    
    for (int i = 0; i < cols; ++i) {
      if (i == 3 || i == 6 || i == 31 || i == 30) {
        brickOn1[i][1] = on;
      }
    }

  }
  
  void setupLevel2() {
    cols = 16;
    for(int i = 0; i < cols; ++i) {
      for (int j = 0; j < rows; ++j) {
        brickOn2[i][j] = 1;
      }
    }
  }

  boolean drawLevel1(color c1, color c2, OscP5 oscP5, NetAddress myRemoteLocation, int activeStep){
    boolean goToL2 = true;
    for(int i = 0; i < cols; ++i) {
      for (int j = 0; j < rows; ++j) {
        if (brickOn1[i][j] == 1) {
          fill(c1);
          goToL2 = false;
        }
        else if (brickOn1[i][j] == 2 && i == activeStep % 32) fill(c2);
        else if (brickOn1[i][j] == 2) fill(#3B1D2C);
        else fill(0,0,0);
        
        if (oldStep1 != activeStep % 32) messageSent = false;
        
        if (i == activeStep % 32) {
          stroke(#c9a4b6);
          strokeWeight(2);
        }
        else {
          stroke(0);
          strokeWeight(1);
        }
        rectMode(CENTER);
        rect(x + i * w + (w * 0.5), y + j * h + (h * 0.5), w - 2, h - 2);

        if (brickOn1[i][j] == 2 && i == activeStep % 32 && !messageSent) {
          if (os != i || sample != j) {
            print("message sent"); 
            messageSent = true;
            OscMessage myMessage = new OscMessage("/Drums");
            myMessage.add(1);
            myMessage.add(j); // add an int to the osc message
            oscP5.send(myMessage, myRemoteLocation);
          }
          os = i;
          sample = j;
        }      
      }
    }
    
    oldStep1 = activeStep % 32;
    if (goToL2) {
      w = w * 2;
      setupLevel2();
      return false;
    }
    else {
      return true;
    }
  }
  
  void drawLevel2(color c, int[] heightVec, OscP5 oscP5, NetAddress myRemoteLocation, int activeStep,
                  PImage blinkOn, PImage blinkOff, int screenWidth, int screenHeight){
    pitchHeight = heightVec[(activeStep % 32) / 2];
    
    if (oldStep2 != (activeStep % 32) / 2) {
      newStep2 = true;
    }
    
    if (oldHeight != pitchHeight) {
      newTone = true;
    }
    
    boolean goToHS = true, atHS = false;
    for(int i = 0; i < cols; ++i) {
          if (i == (activeStep % 32) / 2) {
          newStep2 = false;
          
          if (newTone) {
            newTone = false;
            OscMessage myMessage = new OscMessage("/Synth");
            myMessage.add(2);
            myMessage.add(pitchHeight); // add an int to the osc message
            oscP5.send(myMessage, myRemoteLocation);
          }  
  }
      for (int j = 0; j < rows; ++j) {
        if (brickOn2[i][j] == 1) {
          fill(c);
          goToHS = false;
        }
        else fill(0, 0, 0);
        
        if (i == (activeStep % 32) / 2) {
          if (atHS) {
            stroke(0);
            strokeWeight(0);
          }
          else {
            stroke(#c9a4b6);
            strokeWeight(2);
          }
        }
        else {
          stroke(0);
          strokeWeight(1);
        }
        rectMode(CENTER);
        rect(x + i * w + (w * 0.5), y + j * h + (h * 0.5), w - 2, h - 2);
      }
    }
    oldStep2 = (activeStep % 32) / 2;
    oldHeight = pitchHeight;
  
  for(int i = 0; i < 32; ++i) {
      for (int j = 0; j < rows; ++j) {
        
        if (oldStep1 != activeStep % 32) messageSent = false;

        if (brickOn1[i][j] == 2 && i == activeStep % 32 && !messageSent) {
          messageSent = true;
          OscMessage myMessage = new OscMessage("/Drums");
          myMessage.add(1);
          myMessage.add(j); // add an int to the osc message
          oscP5.send(myMessage, myRemoteLocation);
        }      
      }
    }
  oldStep1 = activeStep % 32;
  
  if (goToHS) {
    atHS = true;
    if(second() % 2 == 0) image(blinkOn, 0, 0, screenWidth, screenHeight);
    else image(blinkOff, 0, 0, screenWidth, screenHeight);
  }
}
}

