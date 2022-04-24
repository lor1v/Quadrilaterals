class poly {
  PVector a, b, c, d, a2, b2, c2, d2;
  color col;
  boolean grow = false;
  boolean animating=false;

  poly(PVector tl, PVector tr, PVector br, PVector bl, color col_) {
    a = tl;
    b = tr;
    c = br;
    d = bl;
    col = col_;

    a2 = a.copy();
    b2 = b.copy();
    c2 = c.copy();
    d2 = d.copy();
  }

  void appear() {
    float alpha = map(a2.copy().sub(a.copy()).mag(), 0, number/3, 255, -20);
    fill(col, alpha);
    quad(a2.x, a2.y, b2.x, b2.y, c2.x, c2.y, d2.x, d2.y);
  }
  float grow_time = 0.5;
  void grow_or_shrink() {
    if (!grow) {
      n--;
      a2.add(em.get(3).copy().normalize().mult(grow_time));
      b2.add(em.get(2).copy().normalize().mult(grow_time));
      c2.add(em.get(0).copy().normalize().mult(grow_time));
      d2.add(em.get(1).copy().normalize().mult(grow_time));
    } else {
      n++;
      a2.sub(em.get(3).copy().normalize().mult(grow_time));
      b2.sub(em.get(2).copy().normalize().mult(grow_time));
      c2.sub(em.get(0).copy().normalize().mult(grow_time));
      d2.sub(em.get(1).copy().normalize().mult(grow_time));
    }
  }
  float dis = 10; //when to stop shrinking/growing
  void check_size() {
    if (PVector.sub(a2.copy(), c2.copy()).mag()<=dis || b2.copy().sub(d2.copy()).mag()<=dis || a2.copy().sub(d2.copy()).mag()<=dis || a2.copy().sub(c2.copy()).mag()<=dis || b2.copy().sub(c2.copy()).mag()<=dis || c2.copy().sub(d2.copy()).mag()<=dis) {
      grow = true;
    }
    if (a2.copy().sub(a.copy()).mag()<=dis || b2.copy().sub(b.copy()).mag()<=dis || c2.copy().sub(c.copy()).mag()<=dis || d2.copy().sub(d.copy()).mag()<=dis) {
      grow = false;
    }
  }

  float n = 50; // 100 if number=100
  void check_size_time() {
    if (n<0) {
      grow = true;
    }
    if (n>40) {
      grow = false;
    }
  }
  float base_an = 15*(1/grow_time);
  float an = -base_an;
  void animation() {
    animating=true;

    if (an>0) {
      grow = true; 
    }
    if (an<=0) {
      grow = false; 
    }

    if (an>-base_an) {
      grow_or_shrink();
    } else if (an<=-base_an) {
      animating = false;
    }
    an--;
  }

  void check_animation(float i) {
    //circular
    //if ((abs(a.copy().mag()-i)<10 || abs(sqrt(sq(width)*2)-a.copy().mag()-i)<100) && !animating){
    //linear
    if (abs(a.copy().x-i)< 10 && !animating) {
      an=base_an;
    }
  }

  void check_animation_walker() {
    if (walker.copy().sub(a.copy()).mag() < 100 && !animating) {
      an=base_an;
    }
  }
}

void hide_all() {
  float base_an = 0;
  float an = 0;
  for (poly p : quads) {
    p.an = 0;    
    base_an = -p.base_an;
  }
  while (an>base_an) {
    for (poly p : quads) {
      p.check_animation(pos_of_animated_square);
      p.animation();
    }
    println(an, base_an);
    an--;
  }

  pos_of_animated_square = 0;
}
