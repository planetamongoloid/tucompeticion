class Marcador {
  float xpos;
  float ypos;
  float valor1;
  float valor2;
  int ptoRecorrido;
  String nombre;
  int diametro = 93;
  int diametro2 = 68;
  int grosor = 10;
  int velocidad = 0;
  float v_media = 0;
  int pendiente =0;
  int puesto = 0;
  color azul = color(95, 193, 218);
  color verde = color(121, 180, 41);
  color azul_oscuro = color(53, 61, 72);
  int margen_caja = 10;
  int ancho_caja = 50;
  PShape mediaIcon ;
  Marcador(float tempXpos, float tempYpos, String nombre_) {
    xpos = tempXpos;
    ypos = tempYpos;
    nombre = nombre_;
    mediaIcon = loadShape("mediaIcon.svg");
  }
  void displayFin(float start_,float stop_){
    float x=xpos;
    float y=ypos;
    float centro=0;
    float altura;
    float columna2;
    if (num_jugadores > 0) {
      pushMatrix();
      translate(x, y);
      textAlign(LEFT, TOP);
      // NOMBRE
      fill(255);
      textFont(mvBold);
      textSize(18);
      if (textWidth(nombre) > diametro+ancho_caja+margen_caja+grosor) {
        text(nombre.substring(0, 16)+"...", 0, 0);
      }
      else {
        text(nombre, 0, 0);
      }
      altura = int(textAscent() + textDescent())+2;
      textFont(mvBold);
      //float anchoNombre = textWidth(nombre);
      stroke(255);
      // LINEA
      textSize(diametro);
      strokeWeight(3);
      line(0, altura, diametro+ancho_caja+margen_caja+grosor, altura);
      
      altura = altura +10;
      textAlign(CENTER, TOP);
     

      fill(azul);
      centro = (diametro)+grosor;
       noStroke();
      //ellipseMode(CENTER);
      ellipse(centro-20, altura+55,diametro,diametro);
      fill(255);
      textSize(45);
      textAlign(CENTER, BASELINE);
      // PUESTO
      text(int(puesto)+"º", centro-20, altura+65);
      textAlign(LEFT, TOP);
      textSize(10);
      float total = (stop_ - start_)/1000;
    
      int minutes = floor(total/60);
      int segundos = int(total - minutes *60);
      String centesimas = split(str(total),".")[1];
      text("Tiempo:"+minutes+"'"+segundos+"\""+" "+centesimas, 0, altura+120);
      //text("Tiempo: 105.56 segundos",0,altura+120);
      text("Velocidad media: "+nf(v_media,0,2)+" km/h",0,altura+140);
      textAlign(CENTER, TOP);
      popMatrix();
    }
  }
  void display() {
    float x=xpos;
    float y=ypos;
    float centro=0;
    float altura;
    float columna2;
    if (num_jugadores > 0) {
      pushMatrix();
      translate(x, y);
      //checkLinea(x,y);
      textAlign(LEFT, TOP);
      // NOMBRE
      fill(255);
      textFont(mvBold);
      textSize(18);
      if (textWidth(nombre) > diametro+ancho_caja+margen_caja+grosor) {
        text(nombre.substring(0, 16)+"...", 0, 0);
      }
      else {
        text(nombre, 0, 0);
      }
      altura = int(textAscent() + textDescent())+2;

      textFont(mvBold);
      //float anchoNombre = textWidth(nombre);
      stroke(255);

      // VELOCIDAD
      textSize(diametro);
      strokeWeight(3);
      line(0, altura, diametro+ancho_caja+margen_caja+grosor, altura);

      altura = altura +10;
      textAlign(CENTER, TOP);
      text(velocidad, diametro/2, altura);
      altura = int(textAscent() + textDescent())+30;
      //checkLinea(x,y);
      textSize(20);
      // VALOR POSICION (CENTRO CIRCULO)
      //checkLinea(x, y);
      stroke(73, 147, 163);
      strokeWeight(grosor);
      strokeCap(SQUARE);
      textSize(45);
      textAlign(CENTER, BASELINE);

      fill(255);
      centro = (diametro/2)+grosor/2;
      // PUESTO
      text(int(puesto)+"º", centro, altura+centro+15);
      textAlign(CENTER, TOP);
      //fill(azul);
      textSize(12);
      //text("puesto", centro, altura+centro);
      noFill();
      // LINEA FONDO
      stroke(82, 82, 82, 81.5);
      arc(centro, altura+centro, diametro, diametro, 0+HALF_PI, TWO_PI+HALF_PI );
      noFill();
      // LINEA DE FUERA
      stroke(azul);
      arc(centro, altura+centro, diametro, diametro, 0+HALF_PI, valor1 );
      //println(sin(millis()/1000.0));
      // LINEA DE FONO
      stroke(82, 82, 82, 81.5);
      arc(centro, altura+centro, diametro2, diametro2, 0+HALF_PI, TWO_PI+HALF_PI );
      // LINEA DE DENTRO
      stroke(verde);
      arc(centro, altura+centro, diametro2, diametro2, 0+HALF_PI, valor2 );
      stroke(255);
      strokeWeight(3);
      line(centro, altura+diametro2+grosor, centro, altura+diametro+grosor);
      noStroke();
      fill(verde);
      rect(0, altura+diametro+grosor+10, 10, 10);
      fill(255);
      textFont(mvTextBold);
      textAlign(LEFT, TOP);
      textSize(12);
      text("Potencia", 15, altura+diametro+grosor+10);
      fill(azul);
      rect(0, altura+diametro+grosor+25, 10, 10);
      fill(255);
      text("Pendiente", 15, altura+diametro-grosor+45);
      textSize(11);
      textLeading(10);
      text("distancia\nrecorrida", diametro+grosor+margen_caja+2, altura+diametro-grosor+30);

      // COLUMNA 2
      strokeWeight(1);
      stroke(255);
      columna2= diametro+grosor+margen_caja; 
      // CAJA ABAJO
      textFont(mvBold);
      textAlign(CENTER, TOP);
      noStroke();
      fill(255);
      rect(columna2, altura, ancho_caja, diametro+grosor);
      fill(verde);
      textSize(20);
      text(nf(ptoRecorrido, 2), columna2+ancho_caja/2-11, altura+5);
      text("%", columna2+ancho_caja/2+13, altura+5);
      fill(verde, 230);
      rect(columna2, altura+diametro+grosor, ancho_caja, map(ptoRecorrido, 0, 100, 0, -(diametro+grosor)));
      fill(azul_oscuro);
      textAlign(LEFT, BASELINE);
      textSize(15);
      // KILOMETROS RECORRRIDOS SOBRE LOS 144 KM DE LA ETAPA
      String recorr = nf(map(ptoRecorrido, 0, 99, 0, 144), 1, 1);
      text(recorr, columna2+5, altura+diametro);
      float a = textWidth("88,8");
      textFont(mvTextRegular);
      textSize(8);
      fill(255);
      text("km", columna2+a+5, altura+diametro);
      altura = altura-55;
      //textAlign(CENTER);
      textFont(mvTextBold);
      textAlign(RIGHT);
      textSize(20);
      text("km/h", columna2+ancho_caja, altura+5);
      stroke(255);
      line(columna2, altura+10, columna2+ancho_caja, altura+10);
      //fill(verde);
      //noStroke();
      //ellipse(x+7,y+20,13,13);
      shape(mediaIcon, columna2, altura+15, 15, 15);
      fill(255);
      textFont(mvTextRegular);
      textSize(24);

      text(int(v_media), columna2+ancho_caja, altura+30);
      //translate(diametro/2+grosor/2, y-grosor/2);
      //textArq("aicnetop", diametro/2, diametro2, grosor,0,30);
      //textArq("etneidnep", diametro/2, diametro, grosor,0,20);

      popMatrix();
    }
    else {  // SI ES INDIVIDUAL
      textAlign(BASELINE);
      diametro = 122;
      diametro2 = 86;
      textFont(mvTextRegular);
      textSize(12);
      noStroke();
      fill(azul);
      rect(67, 108, 10, 10);
      fill(verde);
      rect(148, 108, 10, 10);
      fill(255);
      text("Pendiente", 82, 117);
      text("Potencia", 162, 117);
      strokeWeight(16);
      strokeCap(SQUARE);
      noFill();
      // LINEA FONDO
      stroke(82, 82, 82, 81.5);
      arc(138, 206, diametro, diametro, 0+HALF_PI, TWO_PI+HALF_PI );
      noFill();
      // LINEA DE FUERA
      stroke(azul);
      arc(138, 206, diametro, diametro, 0+HALF_PI, valor1 );
      //println(sin(millis()/1000.0));
      // LINEA DE FONO
      stroke(82, 82, 82, 81.5);
      arc(138, 206, diametro2, diametro2, 0+HALF_PI, TWO_PI+HALF_PI );
      // LINEA DE DENTRO
      stroke(verde);
      arc(138, 206, diametro2, diametro2, 0+HALF_PI, valor2 );
      // CIRCULO CENTRO
      noStroke();
      fill(255);
      arc(138, 206, 37, 37, 0+HALF_PI, TWO_PI+HALF_PI  );
      rect(68, 288, 53, 28);
      rect(137, 241, 2, 35);
      fill(azul);
      rect(121, 288, 87, 28);
      fill(gris);
      text("Tiempo", 74, 306);
      fill(blanco);
      text("vs. M. Team", 128, 306);
      fill(azul);
      textFont(mvBold);
      textSize(27);
      text("+00:03:22", 70, 343);
      textFont(mvRegular);
      textSize(30);
      fill(blanco);
      text(nombre, 281, 148);
      rect(281, 163, 205, 2);
      textFont(mvBold);
      textSize(210);
      text(velocidad, 276, 340);
      textSize(40);
      text("km/h", 522, 280);
      rect(520, 300, 105, 2);
      arc(529, 333, 18, 18, 0+HALF_PI, TWO_PI+HALF_PI);
      fill(gris);
      textSize(12);
      text("M", 523.5, 337);
      fill(blanco);
      textSize(25);
      text(int(v_media), 547, 340);
      textSize(15);
      text("km/h", 580, 340);
      rect(680, 345, 100, -216);
      fill(verde, 230);
      rect(680, 345, 100, map(ptoRecorrido, 0, 100, 0, -219));
      fill(gris);
      textSize(40);
      text(nf(map(ptoRecorrido, 0, 100, 0, 130), 1, 1), 690, 319);
      textFont(mvRegular);
      textSize(15);
      fill(blanco);
      text("kms", 740, 319);
      text("recorridos", 701, 336);
      fill(verde);
      textFont(mvBold);
      textSize(40);
      text(nf(ptoRecorrido, 2), 688, 174);
      text("%", 733, 174);
      noStroke();
      strokeWeight(1);
    }
  }
  void actualizar(float pendiente_, float locationx_, int v_, PVector vFin_, PVector vIni_,float start_) {
    //map(easing, 0, 1, 0, TWO_PI), map(location.x, 0, width, 0, TWO_PI)
    ptoRecorrido = int(map(locationx_, vIni_.x, vFin_.x, 0, 100));
    //pendiente = round(pendiente,4);
    //pendiente_ = round(pendiente_,4);

    pendiente_ = int(sin(pendiente_)*100);
    //println(int(pendiente_)); 
    //pendiente = sin(pendiente_);
    if (int(pendiente) < int(pendiente_)) {
      pendiente += 1;
    }
    else if (int(pendiente) > int(pendiente_)) {
      pendiente -= 1;
    }
    else {
      pendiente = int(pendiente_);
    }
    //valor1 = map(pendiente, -1.5, 1.5, TWO_PI, 0)+HALF_PI;
    valor1 = map(pendiente, 100, -100, 0+HALF_PI, TWO_PI+HALF_PI);
    //valor2 = map(locationx_, 0, width, 0, TWO_PI)+HALF_PI;
    //println("velocidad "+v_+" pendiente"+pendiente);
    valor2 = map(v_*pendiente, 3000, -3000, 0, TWO_PI)+HALF_PI;
    velocidad = v_;
    //v_media = map(ptoRecorrido, 1, 100, 0, 144)/( map(millis(), 0, 40000, 0, 7200000)/(1000*60*60));
    v_media =  map(ptoRecorrido, 1, 100, 0, 0.65198188)/(( millis()-start_)/(1000*60*60));
    //println(map(ptoRecorrido,1,100,0,130)+" "+ map(millis(),0,40000,0,7200000)/(1000*60*60));
  }
  void textArq(String message, float r, float diametro2, float grosor, float y_, int angulo) {

    //message = "aicnetop";
    r = diametro2/2+grosor/3;
    noFill();
    stroke(255, 0, 0);
    //ellipse(0, 0, diametro2+grosor, diametro2+grosor);
    float arclength = 0;
    textAlign(CENTER);
    textSize(10);
    // For every box
    for (int i = 0; i < message.length(); i ++ ) {

      // The character and its width
      char currentChar = message.charAt(i);
      // Instead of a constant width, we check the width of each character.
      float w = textWidth(currentChar); 
      // Each box is centered so we move half the width
      arclength += w/2;

      // Angle in radians is the arclength divided by the radius
      // Starting on the left side of the circle by adding PI
      float theta = QUARTER_PI-radians(angulo) + arclength / r;

      pushMatrix();

      // Polar to Cartesian conversion allows us to find the point along the curve. See Chapter 13 for a review of this concept.
      translate(r*cos(theta), r*sin(theta)); 
      // Rotate the box (rotation is offset by 90 degrees)
      rotate(theta + radians(270)); 

      // Display the character
      fill(150);
      text(currentChar, 0, 0);

      popMatrix();

      // Move halfway again
      arclength += w/2;
    }
    //translate(diametro/2+grosor/2, 160);
    textAlign(LEFT);
  }

  void checkLinea(float x_, float y_) {
    stroke(255, 0, 0);
    line(x_, y_, width, y_);
    stroke(255);
  }
}

