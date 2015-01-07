class Bandera {
  float ancho_caja;
  String texto;
  int x;
  int y;
  int padding = 5;
  int punto = 2;
  int altoCaja = 13;
  boolean corona = false;
  float offset;
  PShape coronaIcon ;
  color c;
  Bandera(String t_, float offset_, color c_) {
    texto = t_;
    ancho_caja = textWidth(texto);
    offset = offset_;
    coronaIcon = loadShape("corona.svg");
    c = c_;
  }
  void update(float x_, float y_) {
    x = int(x_);
    y = int(y_);
  }
  void display() {
    textSize(10);
    stroke(c);
    fill(c);
    if (corona) {
      //ellipse(x,y-offset-10,5,5);
      shape(coronaIcon, x-11, y-offset-5-10, 15, 8);
    }
    /* ESTO ES PARA QUE LAS LINEAS SEAN PUNTOS
     rectMode(CENTER);
     fill(c);
     //int puntos = map(offset,20,90,);
     for(int i=0;i<=abs(offset)/5;i++){
     float nx = lerp(x,x,i/(offset/5));
     float ny = lerp(y,(y-offset),i/(abs(offset)/5));
     rect(nx,ny,punto,punto);
     }
     rectMode(CORNER);
     */
    // LINEA DE PUNTO A NOMBRE

    rect(x, y-offset, 2, offset);
    //strokeWeight(1);
    //println(textWidth(nombre));
    // CAJA PARA EL NOMBRE
    if (y-offset-(altoCaja/2) <= 0) {
      rect(x-ancho_caja-padding, 0, ancho_caja+padding+2, altoCaja);
    }
    else {
      rect(x-ancho_caja-padding, y-offset-(altoCaja/2), ancho_caja+padding+2, altoCaja);
    }
    textAlign(LEFT, CENTER);
    if(c == verde){
    fill(255);
    }else{
    fill(60);
    }
    textFont(mvTextBold);
    textSize(12);
    ancho_caja = textWidth(texto);
    if (y-offset-(altoCaja/2) <= 0) {
      text(texto, x-ancho_caja, altoCaja/2);
    }
    else {
      text(texto, x-ancho_caja, y-offset);
    }
  }
}

