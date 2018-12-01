

/**************************************************************************************
 ***************************************************************************************
 **************************Techno Brickbreaker******************************************
 **********************Step Sequencer and Ostinato**************************************
 ****************by Max Morrison and PAT 413 Winter 2015********************************
 *********loosely adapted from http://www.openprocessing.org/sketch/88276***************
 ***************************************************************************************
 **************************************************************************************/

final int MONITOR_TO_USE = 0; //0 is main monitor, 1 is external monitor

import java.util.*;
import java.awt.DisplayMode;
import java.awt.GraphicsDevice;
import java.awt.GraphicsEnvironment;
import oscP5.*;
import netP5.*;

GraphicsEnvironment ge = GraphicsEnvironment.getLocalGraphicsEnvironment();
GraphicsDevice[] gs = ge.getScreenDevices();

DisplayMode mode = gs[MONITOR_TO_USE].getDisplayMode();
int screenWidth = mode.getWidth();
int screenHeight = mode.getHeight();

OscP5 oscP5;
NetAddress myRemoteLocation;

PImage blinkOn;
PImage blinkOff;

int cols = 32;
int rows = 6;
int activeStep;
float brickStartX = 0;
float brickStartY = screenWidth * 0.08;
float brickWidth = screenWidth / cols;
float brickHeight = (screenHeight / 3.0) / rows;
int[] heightVec = new int[16];


Ball ball = new Ball(screenWidth * 0.5, screenHeight * 0.66, 
screenWidth / 90.0, screenWidth, screenHeight, heightVec);
Paddle paddle = new Paddle(screenWidth * 0.5, screenHeight * 0.85, 
screenWidth * 0.12, screenHeight * 0.02);
Bricks brick1 = new Bricks(brickStartX, brickStartY, brickWidth, 
brickHeight, cols, rows);



boolean start = true;
boolean level1 = true;
boolean goTo2 = false;

void setup() {
  size(screenWidth, screenHeight);
  blinkOn = loadImage("on.png");
  blinkOff = loadImage("off.png");

  // start oscP5, telling it to listen for incoming messages at port 5001 */
  oscP5 = new OscP5(this, 5003);

  // set the remote location to be the localhost on port 5001
  myRemoteLocation = new NetAddress("127.0.0.1", 5002);

  brick1.setupLevel1(1);

  for (int i = 0; i < 16; ++i) {
    heightVec[i] = rows - 1;
  }
  
  
}

void draw() {
  smooth();
  background(0);
  if (goTo2) level1 = false;
  if (level1) makeLevel1();
  else makeLevel2();

  ball.drawBall();
  ball.moveBall();

  ball.collisionPaddleWall();

  paddle.drawPaddle();
  paddle.movePaddle();
}

void keyPressed() {
  if (keyCode == LEFT) {
    paddle.left = true;
  }
  if (keyCode == RIGHT) {
    paddle.right = true;
  }
  if (keyCode == ' ' && ball.moving == false) {
    ball.serve = true;
    ball.moving = true;
  } else if (keyCode == ' ') {
    ball.stick = true;
  }
  if (keyCode == BACKSPACE) {
    print("check");
    for (int i = 0; i < cols; ++i) {
      if (i == 0 || i == 2 || i == 6 || i == 7 || i == 11 || i == 14 ||
        i == 18 || i == 22 || i == 23 || i == 27 || i == 28 || i == 30) {
        brick1.brickOn1[i][2] = 2;
      }
    }
    for (int i = 0; i < cols; ++i) {
      if (i != 8 && i != 24) {
        brick1.brickOn1[i][0] = 2;
      }
    }

    for (int i = 0; i < cols; ++i) {
      if (i == 4 || i == 14 || i == 20 || i == 30) {
        brick1.brickOn1[i][3] = 2;
      }
    }

    for (int i = 0; i < cols; ++i) {
      if (i == 4 || i == 10 || i == 11 || i == 13 ||
        i == 20 || i == 24 || i == 29 || i == 31) {
        brick1.brickOn1[i][4] = 2;
      }
    }

    for (int i = 0; i < cols; ++i) {
      if (i == 0 || i == 4 || i == 8 || i == 12 || i == 15 || i == 14 ||
        i == 16 || i == 20 || i == 24 || i == 28 || i == 30 || i == 31) {
        brick1.brickOn1[i][5] = 2;
      }
    }
    for (int i = 0; i < cols; ++i) {
      if (i == 3 || i == 6 || i == 31 || i == 30) {
        brick1.brickOn1[i][1] = 2;
      }
    }
  }
}

void keyReleased() {
  if (keyCode == LEFT) {
    paddle.left = false;
  }
  if (keyCode == RIGHT) {
    paddle.right = false;
  }
}

void makeLevel1() {
  level1 = brick1.drawLevel1(#94496e, #49946f, oscP5, myRemoteLocation, activeStep);
  ball.collisionBrick(brick1.brickOn1, cols, rows, brickStartX, brickStartY, 
  brickWidth, brickHeight, level1);

  if (start) {
    ball.x = paddle.x;
    ball.y = paddle.y - paddle.h * 0.5;
    ball.speedX = 0;
    ball.speedY = 0;
    ball.moving = false;
    start = false;
    brick1.setupLevel1(1);
  }

  if (!level1) {
    start = true;
    brick1.setupLevel2();
    cols = 16;
    brickWidth = screenWidth / cols;
  }
}

void makeLevel2() {

  brick1.drawLevel2(#94496e, heightVec, oscP5, myRemoteLocation, activeStep, blinkOn, blinkOff, screenWidth, screenHeight);
  ball.collisionBrick(brick1.brickOn2, cols, rows, brickStartX, brickStartY, 
  brickWidth, brickHeight, level1);

  if (start) {
    ball.x = paddle.x;
    ball.y = paddle.y - paddle.h * 0.5;
    ball.speedX = 0;
    ball.speedY = 0;
    ball.moving = false;
    start = false;
    brick1.setupLevel2();
  }
}

/*
incoming osc message are forwarded to the oscEvent method.
 oscEvent() runs in the background, so whenever a message arrives,
 it is input to this method as the "theOscMessage" argument
 */
void oscEvent(OscMessage theOscMessage)
{
  //println("the Check");

  if (theOscMessage.checkAddrPattern("/Brickbreaker") == true)
  {
    activeStep = theOscMessage.get(0).intValue();
    /*
         there is only one UDP input, but with the prefixes, you can have multiple streams that are unpacked seperately
     the .get() method starts at 0, will return items in a list seperated by spaces
     there are also .floatValue() .stringValue and so on
     
     the oscP5 library has more methods for checking the format of your input stream, but you should know what
     you are sending and be able to just use the right methods without checking first
     
     */
  }
}


