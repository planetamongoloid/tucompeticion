class Jugador implements Comparable {
  String id;
  String nombre;
  String sexo;
  PVector location;
  PVector location_next;
  PVector velocity;
  PVector dir;
  PVector vIni;
  PVector vFin;
  float easing;
  color c;
  int posicion = 0;
  float pendiente, pendiente_last;
  boolean fin = false;
  float distancia_final;
  float start;
  float stop;
  int resultado = 0;
  boolean ghost = false;
  Marcador marcador ;
  int[] puntoX ;
  int[] puntoY;
  Bandera bandera;
  Jugador(String nombre_, String id_,String sexo_, float easing_, color c_, int pos_marcador, int[] puntoX_, int[] puntoY_, float offset_bandera_, boolean ghost_) {
    id = id_;
    sexo = sexo_;
    nombre = nombre_;
    easing = easing_;
    c = c_;
    puntoX = puntoX_;
    puntoY = puntoY_;
    ghost = ghost_;
    location = new PVector(puntoX[posicion], puntoY[posicion]);
    location_next = new PVector(puntoX[posicion+1], puntoY[posicion+1]);
    vIni = new PVector(puntoX[0], puntoY[0]); 
    vFin = new PVector(puntoX[puntoX.length-1], puntoY[puntoY.length-1]); 
    dir = PVector.sub(location_next, location);
    dir.normalize();
    dir.mult(easing);
    pendiente_last = dir.heading();
    velocity = dir;
    //start = millis();
    stop = 0;
    marcador = new Marcador((pos_marcador)*width/4+190/8, 116, nombre);
    if (ghost) {
      bandera = new Bandera(nombre, offset_bandera_, c_);
    }
    else {
      bandera = new Bandera(nombre, offset_bandera_, color(255));
    }
  }
  void move() {
    location.add(velocity);
    pendiente = dir.heading();
    if (location.dist(location_next) < 1) {
      posicion += 1;
      if (posicion < puntoX.length ) {
        location_next.x = puntoX[posicion];
        location_next.y = puntoY[posicion];
      } // SI TERMINA RECORRIDO
      else {
        if (!fin) {
          stop = millis();
        }
        //println(stop-start);
        location.x = puntoX[puntoX.length-1];
        location.y = puntoY[puntoX.length-1];
        posicion=puntoX.length;
        fin = true;
      }
    }
    dir = PVector.sub(location_next, location);
    dir.normalize();
    // MULTIPLICAR POR *2 PARA QUE VAYA MÁS RAPIDO
    dir.mult(easing);
    // SI CAMBIA LA PENDIENTE MANDO LOS DATOS A ARDUINO
    if (floor(pendiente_last*100) != floor(pendiente*100)) {
      pendiente_last = pendiente;
      //println("cambia "+nombre);
      sendPendiente();
    }
    velocity = dir;
    bandera.update(location.x, location.y);
    // ACTUALIZO MARCADOR: direccion, posicion x, velocidad, vector final
    if (!fin) {
      marcador.actualizar(dir.heading(), location.x, int(map(easing, 0, 1, 0, 100)), vFin, vIni,start);
      //println(nombre+" "+dir.heading());
    }

    //Calculo distancia final
    distancia_final = location.dist(vFin);
  }
  void reset() {
    posicion = 0;
    resultado = 0;
    location.x = puntoX[posicion];
    location.y = puntoY[posicion];
    location_next.x = puntoX[posicion+1];
    location_next.y = puntoY[posicion+1];
    dir = PVector.sub(location_next, location);
    dir.normalize();
    dir.mult(easing);
    velocity = dir;
    //bandera = null;
    //marcador = null;
    fin = false;
  }
  void display() {
    if (!ghost) {
      if(!fin){
      marcador.display();
      }else{
      marcador.displayFin(start,stop);
      }
    }
    bandera.display();
    stroke(c);
    fill(c);

    ellipse(location.x, location.y, 16, 16);
    stroke(0);
  }
  int compareTo(Object o) {
    Jugador otro = (Jugador)o;
    if (otro.distancia_final>distancia_final)
      return -1;
    if (otro.distancia_final==distancia_final)
      return 0;
    else
      return 1;
  }
}

