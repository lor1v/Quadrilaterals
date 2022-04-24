ArrayList <PVector> points = new ArrayList<PVector>();
ArrayList<PVector> em = new ArrayList<PVector>();
ArrayList<poly> quads = new ArrayList<poly>();

PVector one = new PVector(5, 5); //randomness of points / 100 je kul

int number = 50; // width of one
float d =10; // gap

color randomColor() {
  colorMode(HSB);
  return color(random(190, 250), random(0, 200), random(10, 250));
}

color [] colors = {#EF6461, #E4B363, #E8E9Eb, #E0DFD5, #313638};
color [] colors2 = {#042A2B, #5EB1BF, #CDEDF6, #EF7B45, #D84727};
color randomColor2() {
  int i = round(random(-0.4, 4.4));
  return colors2[i];
}
color bg_color;

void setup() {
  size(800, 800);
  //fullScreen();
  frameRate(30);
  noStroke();
  bg_color = randomColor2();
  background(bg_color);
  
  em.add(new PVector(-d, -d)); //botom right corner 0
  em.add(new PVector(d, -d));  //bottom left corner 1 
  em.add(new PVector(-d, d)); //top right 2
  em.add(new PVector(d, d));// top left 3

  for (int i = 0; i<=height; i+=number) {
    for (int j = 0; j<=width; j+=number) {
      if (j==0 || i ==0 || j==height || i ==width) {
        points.add(new PVector(j, i));
      } else {
        points.add(new PVector(j, i).add(one.copy().rotate(random(0, TWO_PI))));
      }
    }
  }
  createQuads();
  //hide_all();
}



void createQuads() {

  PVector topLeft = new PVector();
  PVector topRight = new PVector();
  PVector bottomRight = new PVector();
  PVector bottomLeft = new PVector();

  int i = 0;
  while (i<points.size()-width/number-2) {
    if (points.get(i).x<width-d*2) { //  
      color c = randomColor2();
      while (c==bg_color){
         c = randomColor2();
      }
      fill(c);
      
      topLeft.set(points.get(i).add(em.get(3).copy()));
      topRight.set(points.get(i+1).copy().add(em.get(2).copy()));
      bottomLeft.set(points.get(i+width/number+1).copy().add(em.get(1).copy()));
      bottomRight.set(points.get(i+width/number+2).copy().add(em.get(0).copy()));
      
      quads.add(new poly(topLeft.copy(), topRight.copy(), bottomRight.copy(), bottomLeft.copy(),c));
      }
    i+=1;
  }
}

boolean hidden = false;
float pos_of_animated_square=0;
float noise_line = 0;
PVector walker = new PVector(300,300);

void draw() {
  background(bg_color);
  if (!hidden){
    hide_all();
    hidden = true;
  }
  for (poly p: quads){
    p.appear();
    //p.check_animation(pos_of_animated_square);
    p.check_animation_walker();
    p.animation();

  }
  
  increase_poas();
  
  
  move_walker();
  println(walker.x,walker.y);
}

void mouseClicked() {
  save("[results]/Quads - " + str(year()) + "-" + str(month()) + "-" + str(day()) + " " + str(hour()) + "." + str(minute()) + "." + str(second()) + ".png");
  println("SAVED");
 
}

PVector dir = new PVector(10,10);
void move_walker(){  
  walker.add(dir.copy().rotate(random(-PI/2,PI/2)));
  while (walker.x>width || walker.y>height || walker.x<0 || walker.y<0){
    dir.rotate(random(PI/3));
    walker.add(dir.copy());
  }
}

void increase_poas(){
  pos_of_animated_square+=10;  
  if (pos_of_animated_square>1000){
    pos_of_animated_square=0;
  } 
}
