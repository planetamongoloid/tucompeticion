void pantallaPodio() {
  // subo feed facebook
  if(tengoFb){
     for(int i=0;i<num_jugadores;i++){
       if (jugadoresList.get(i).id != "x") {
          loadStrings(URL+"/setTiempo/"+str((jugadoresList.get(i).stop - jugadoresList.get(i).start)/1000)+"/"+jugadoresList.get(i).id);
        }
       fbThread[i] = new FbThread(jugadoresList.get(i).id);
       //fbThread[i] = new FbThread(jugadoresList.get(i).id);
       fbThread[i].start();
     }
     tengoFb = false;
  }
  float[] tiempos_max;
  // MOSTRAMOS EL RANKING DURANTE TIME_RANKING
  nextScreen(timeIniPodio, TIME_PODIO, RANKING);

  background(fondo);
  image(fondo_imagen,0,0);
  fill(255);
  textSize(39);
  textAlign(LEFT);
  text("Podio", margenIzq, posTitulo);
  stroke(255);
  strokeWeight(2);
  textFont(mvBold);
  line(margenIzq, posTitulo+15, width-margenIzq, posTitulo+15);
  // SI ES JUEGO COMPETICION -- si necesito meter un timing aki -> || millis() - timeIniPodio > TIME_PODIO/3
  if (num_jugadores > 1 ) {

    int x1 = 0;
    int ancho = 0;
    ancho = width/num_jugadores;
    /*switch(modoJuego) {
     case NORM:
     println("norm");
     
     break;
     case GHOST:
     println("ghost");
     ancho = width/(num_jugadores-1);
     break;
     }*/
    //println(ancho);
    tiempos_max = new float[num_jugadores];
    // RELLENO TIEMPO MAXIMO Y TIEMPO MINMO
    for (int i=0;i<num_jugadores;i++) {
      tiempos_max[i] = jugadoresList.get(i).stop - jugadoresList.get(i).start;
    }
    tiempos_max = sort(tiempos_max);
    for (int i=0;i<num_jugadores;i++) {
      if (!jugadoresList.get(i).ghost) {
        // HAGO UN MAPEO DE LOS TIEMPOS QUE TARDA LA PEÑA PARA LA ALTURA DEL CUADRADO
        //float tiempo = map((jugadoresList.get(i).stop - jugadoresList.get(i).start), tiempos_max[0], tiempos_max[tiempos_max.length-1], height-200, 100);
        float tiempo = 0;
        switch(jugadoresList.get(i).resultado){
          case 1:
            tiempo = 250;
            break;
          case 2:
            tiempo = 200;
            break;
          case 3:
            tiempo = 150;
            break;
          case 4:
            tiempo = 100;
            break;
           
        }
        
        stroke(fondo);
        //noStroke();
        //if (jugadoresList.get(i).resultado == 1) {
        // COLOR RECTANGULO FONDO
        fill((jugadoresList.get(i).resultado == 1)? azul:255);
        rect(x1, height-tiempo, ancho, height);
        // COLOR TEXTO TIEMPOS
        fill((jugadoresList.get(i).resultado == 1)? 255:azul);
        textSize(15);
        String texto_tiempo = "tiempo total: "+str((jugadoresList.get(i).stop - jugadoresList.get(i).start)/1000);
        text(texto_tiempo, x1+5, height-30);
        String texto_velocidad = "velocidad Media: "+nf(jugadoresList.get(i).marcador.v_media,0,2)+"km/h";
        text(texto_velocidad, x1+5, height-15); 
        textSize(120); 
        int posNombre = 0;
        // NUMEROS DE POSICION
        if (jugadoresList.get(i).resultado == 1) {
          int a = int(textAscent() + textDescent());
          int b = int(textWidth("1"));
          text(jugadoresList.get(i).resultado, x1+ancho/2-b/2, height-tiempo+a);
        }
        else {
          posNombre = int(textWidth(str(jugadoresList.get(i).resultado)));
          text(jugadoresList.get(i).resultado, x1+5, height-tiempo-10);
        }
        fill(255);
        // NOMBRES
        textSize(24);
        //println(textWidth(jugadoresList.get(i).nombre)+" ancho "+ancho);
        if (textWidth(jugadoresList.get(i).nombre)+posNombre >= ancho)
          text(jugadoresList.get(i).nombre.substring(0, 10)+"...", x1+posNombre+15, height-tiempo-10);
        else {
          text(jugadoresList.get(i).nombre, x1+posNombre+15, height-tiempo-10);
        }
      }

      // INCREMENTO X1
      x1 = x1+ancho;
      //println(jugadoresList.get(i).nombre+" fin:"+jugadoresList.get(i).resultado);
    }
  } // MUESTRO EL TIEMPO INDIVIDUAL O DE EQUIPO DURANTE 3 SEGUNDOS
  else {
    noStroke();
    textSize(39);
    float altura = textAscent() + textDescent();
    // TU TIEMPO
    text("Tu Tiempo", 10, height-100-textDescent()-10);
    // CAJAS DE JUGADOR/EQUIPO
    fill(160);
    rect(0, height-100, width/4, height);
    fill(255);
    rect(width/4, height-100, width/4, height);
    // TEXTO TIEMPO JUGADOR/EQUIPO
    fill(96, 191, 215);   
    textSize(15);
    float a = textAscent();
    text("tiempo total:", width/4+10, height-100+a+10);
    textSize(22);
    a = a+textAscent();
    // CAMBIAR ESTO PARA UN SOLO JUGADOR !!!!!!!!!!!!
    //float tiempo_primero = (jugadoresList.get(0).stop - jugadoresList.get(0).start)/1000;
    //float tiempo_ultimo = (jugadoresList.get(3).stop - jugadoresList.get(3).start)/1000;
    float total = (jugadoresList.get(0).stop - jugadoresList.get(0).start)/1000;
    
    int minutes = floor(total/60);
    int segundos = int(total - minutes *60);
    String centesimas = split(str(total),".")[1];
    text(minutes+"'"+segundos+"\""+" "+centesimas, width/4+10, height-100+a+15);
    textSize(15);
    a = a+textAscent();
    text("velocidad media: "+nf(jugadoresList.get(0).marcador.v_media,0,2)+"km/h", width/4+10, height-100+a+20);
    // CAJAS DE MOVISTAR
    fill(96, 191, 215);
    rect(width/2, height-200, width/4, height);
    fill(80, 127, 139);
    rect(width-(width/4), height-200, width/4, height);
    shape(mvIcon, width-mvIcon.width-20, 100, 254, 70);
    // TEXTO TIEMPO MOVISTAR
    float mvtotal = (jugadoresList.get(jugadoresList.size()-1).stop-jugadoresList.get(0).start)/1000;
    //println(mvtotal);
    int mvminutes = floor(mvtotal/60);
    int mvsegundos = int(mvtotal - mvminutes *60);
    String mvcentesimas = split(str(mvtotal),".")[1];
    fill(255);
    a = textAscent();
    text("tiempo total:", width/2+10, height-200+a+10);
    textSize(22);
    a = a+textAscent();
    text(mvminutes+"'"+mvsegundos+"\""+" "+mvcentesimas, width/2+10, height-200+a+15);
    textSize(15);
    a = a+textAscent();
    text("velocidad media: 97 km/h", width/2+10, height-200+a+20);
    strokeWeight(1);
    
  }
}

