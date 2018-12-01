class Paddle {
  public float x, y, w, h, xIncrement, yIncrement;
  boolean left = false;
  boolean right = false;
  
  Paddle(float x_, float y_, float w_, float h_) {
    x = x_;
    y = y_;
    w = w_;
    h = h_;
    xIncrement = x / 40;
  }
   
  void drawPaddle() {
    rectMode(CENTER);
    strokeWeight(2);
    stroke(#b97070);
    fill(#944949);
    rect(x, y, w, h);
  }
 
 void movePaddle() {
  if (left == true && (x - w * 0.5) > 0) {
    x -= xIncrement;
  }
  if (right == true && (x + w * 0.5) < width) {
    x += xIncrement;
  }
 }
}
