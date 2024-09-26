int x = 50;
int y = 50;
int grote = 20;
int horSpeed = 1;
int rand = 1;

void setup(){
  size(1000,500);
}


void draw(){
  x += horSpeed;//x++;x = x + 1;
  background(255);
  ellipse(x,y,grote,grote);
  if(x > 1000){
    rand++;
  horSpeed = -2 * rand;
  }
  if (x < grote/2){
    horSpeed = 2 * rand;
  }

}
