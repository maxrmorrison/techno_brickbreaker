class Ball {
  
  float x, y, r, speedX, speedY, sysW, sysH;
  int[] heightVec;
  
  boolean serve, moving, stick;
  
  Ball(float x_, float y_, float r_, float sysW_, float sysH_, int[] heightVec_) {
    x = x_;
    y = y_;
    r = r_;
    speedX = 0.0;
    speedY = 0.0;
    sysW = sysW_;
    sysH = sysH_;
    heightVec = heightVec_;
  }
  
  void drawBall() {
    noStroke();
    fill(#a5517b);
    ellipse(x, y, r, r);
   
    if (serve == true) {
      speedX = 0.0;
      speedY = -(sysW/115.0);
      serve = false;
    }
    if (serve == false && moving == false) {
      x = sysW / 2;
    }
  }

  void moveBall() {
    x += speedX;
    y += speedY;
    if (!moving) x = paddle.x;
  }
  
  void collisionBrick(int s[][], int cols, int rows, float startX, float startY, float brickW, float brickH, boolean level1) {
    float ballRight = x + r;
    float ballLeft = x - r;
    float ballTop = y - r;
    float ballBottom = y + r;
    for (int i = 0; i < cols; ++i) {
      for (int j = 0; j < rows; ++j) {
        float brickRight = startX + (brickW * i) + brickW * 0.5;
        float brickLeft = startX + (brickW * i) - brickW * 0.5;
        float brickTop = startY + (brickH * j) - brickH * 0.5;
        float brickBottom = startY + (brickH * j) + brickH * 0.5;
        
//        if (s[i][j]
//         && ballRight >= brickLeft
//         && ballLeft <= brickRight
//         && ballTop <= brickBottom
//         && ballBottom >= brickTop) {
//           if (speedX != 0 && (ballRight > brickRight || ballLeft < brickLeft)) {
//            speedX = -speedX;
//            s[i][j] = false;
//            print("ball hit side of brick\n"); 
//           }
//           else if (speedY != 0 && (ballBottom > brickBottom || ballTop < brickTop)) {
//            if (ballBottom > brickBottom) y += 5;
//            else y -= 5;
//            
//            speedY = -speedY;
//            s[i][j] = false;
//            print("ball hit bottom of brick\n");
//           }
//         }

        //x in range and hits top of brick with bottom of ball
        if (s[i][j] == 1
          && abs(dist(x, 0, startX + (brickW * i), 0)) < brickW * 0.5
          && abs(dist(0, startY + (brickH * j) - brickH * 0.5, 0,  y + r)) < sysW/75.0
          && speedY > 0) {
            speedY = -speedY;
            s[i][j] = 2;
            print("ball hit top of brick\n");
            if (!level1) --heightVec[i];
          }
        //x in range and hits bottom of brick with top of ball
        else if (s[i][j] == 1
          && abs(dist(x, 0, startX + (brickW * i), 0)) < brickW * 0.5
          && abs(dist(0, y - r, 0, startY + (brickH * j) + brickH * 0.5)) < sysW/75.0
          && speedY < 0) {
            speedY = -speedY;
            s[i][j] = 2;
            print("ball hit bottom of brick\n");
            if (!level1) --heightVec[i];
        }
        //y in range and hits left of brick with right of ball
        else if (s[i][j] == 1
          && abs(dist(0, y, 0, startY + (brickH * j))) < brickH * 0.5
          && abs(dist(x + r, 0, startX + (brickW * i) - brickW * 0.5, 0)) < sysW/75.0
          && speedX > 0) {
            speedX = -speedX;
            s[i][j] = 2;
            print("ball hit left of brick\n");
            if (!level1) --heightVec[i];
        }
        //y in range and hits right of brick with left of ball
        else if (s[i][j] == 1
          && abs(dist(0, y, 0, startY + (brickH * j))) < brickH * 0.5
          && abs(dist(x - r, 0, startX + (brickW * i) + brickW * 0.5, 0)) < sysW/75.0
          && speedX < 0) {
            speedX = -speedX;
            s[i][j] = 2;
            print("ball hit right of brick\n");
            if (!level1) --heightVec[i];
        }
      }
    }
  }
  
  void collisionPaddleWall() {
    if (x + r >= sysW || x - r <= 0) {
      speedX = -speedX;
    }
    if (y - r <= 0) {
      speedY = -speedY;
    }
    if (abs(dist(x, 0, paddle.x, 0)) < paddle.w * 0.5
    && (abs(dist(0, y, 0, paddle.y - paddle.h * 0.5)) < 4
        || abs(dist(0, y, 0, paddle.y + paddle.h * 0.5)) < 4)
    && abs(speedY) > 0) {
      if (stick) {
        x = paddle.x;
        y = paddle.y - paddle.h * 0.5;
        speedX = 0;
        speedY = 0;
        moving = false;
        stick = false;
      }
      if (x > paddle.x) {
        speedX = dist(paddle.x, 0, x, 0) / (sysW / 120.0);
      }
      else {
        speedX = -dist(paddle.x, 0, x, 0) / (sysW / 120.0);
      }
      
      speedY = -speedY;
    }
    
    if (y > sysH) {
      x = paddle.x;
      y = paddle.y - paddle.h * 0.5;
      speedX = 0;
      speedY = 0;
      moving = false;
    }
  }
}
