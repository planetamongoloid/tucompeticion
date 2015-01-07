/*
*****************************
 PANTALLA INICIO
 *****************************
 */
void pantallaInicio() {
  tengoFotos = true;
  tengoFb = true;
  nextScreen(timeIniVideo, TIME_VIDEO, VIDEO);
  background(100);
  image(home, 0, 0);
  fill(gris_oscuro);
  textAlign(RIGHT);
  textSize(10);
  //text("Pulsa s para empezar", width-100, height/3);
  if (keyPressed) {
    switch(key) {
    case '0':
      modoJuego = NORM;
      break;
    case '1':
      modoJuego = GHOST;
      break;
    case 'S':
      gameState = ETAPA;
      timeIniEtapa = millis();
      break;
    case 's':
      gameState = ETAPA;
      timeIniEtapa = millis();
      break;
    }
  }
}
/*
*****************************
 PANTALLA MOSTRAR ETAPA
 *****************************
 */
void pantallaMostrarEtapa() {
  /*if (millis() - timeIniEtapa > TIME_PODIO) {
   initJugadores();
   initJugadoresTiempos();
   gameState = JUGANDO;
   }
   EL NEXT SCREEN TIENE QUE SER FOTO
   */
  nextScreen(timeIniEtapa, TIME_ETAPA,FOTO);
  background(gris);
  image(etapa, 0, 0, width, height);
}
/*
*****************************
 PANTALLA JUEGO
 *****************************
 */
void pantallaJuego() {
  background(fondo);
  image(fondo_imagen,0,0);
  // ESTO ES PARA DEBUGGIN CUANDO NO HAY SENSORES
  //jugadoresList.get(0).easing = map(mouseX, 0, width, 0.0, 1.0);
  //jugadoresList.get(1).easing = map(mouseY, 0, height, 0.0, 1.0);

  // VARIABLE A TRUE CUANDO TODOS LLEGAN
  terminado = true;
  dibujarEtapa();
  ranking = jugadoresList.toArray(new Jugador[num_jugadores]);
  //arrayCopy(jugadores, ranking);
  Arrays.sort(ranking);
  if (!ranking[0].ghost) {
    ranking[0].bandera.corona =true;
  }
  else {
    ranking[1].bandera.corona =true;
  }
  //ranking[0].bandera.offset =20;
  //CHECK SI HAN TERMINADO
  for (int i=0;i<jugadoresList.size();i++) {

    // CHECK SI HAN TERMINADO TODOS
    if (!jugadoresList.get(i).fin) {

      terminado = false;
    }
    // LES PONGO EL RANKING A CADA UNO
    else {
      if (jugadoresList.get(i).resultado == 0) {
        if (!jugadoresList.get(i).ghost) {
          jugadoresList.get(i).resultado = resul;
          resul = resul+1;
        }
      }
    }
    // ACTUALIZO MARCADORES Y JUGADORES;
    jugadoresList.get(i).move();
    jugadoresList.get(i).display();
  }
  //Collections.sort(jugadoresList);
  //println(jugadoresList);
  // SI TERMINAN SE VAN A LA PANTALLA DE INICIO (CAMBIARÉ A RANKING)
  gameState = (terminado)? PODIO:JUGANDO;
  // PONEMOS EL TIEMPO PARA LA CUENTA ATRAS DEL PODIO
  timeIniPodio = millis();
  // MUESTRO LAS DISTANCIAS ARRIBA Y PONGO LAS CORONAS BIEN
  for (int i= 0;i< jugadoresList.size();i++) {
    if (!ranking[i].fin) {
      ranking[i].bandera.corona =false;
      ranking[i].marcador.puesto = i;
      if (!ranking[i].ghost) {
        ranking[i].bandera.offset = map(i, 0, num_jugadores, 50, 15);
      }
      else {
        ranking[i].bandera.offset = -30;
      }
    }
  }
}
/*
*****************************
 PANTALLA MOSTRAR FOTO
 *****************************
 */
void pantallaMostrarFoto() {
  nextScreen(timeIniFoto, TIME_FOTO, COUNTDOWN);
  background(fondo);
  if (tipoTEAM) {
    image(foto, 0, 0);
  }
  else {
    image(foto_single, 0, 0);
  }
  // MUESTRO LAS CAMARITAS PARA QUE SE PREPAREN PARA LA FOTO DURANTE 3 SEGUNDOS
  /*if (!tengoFotos && millis() - timeIniFoto > 3000) {
    if (tipoTEAM) {
      for (int i=0;i<num_jugadores;i++) {
        image(fotoJugadores[i], 28+(i*209), 118, 150, 125);
        //image(fotoJugadores[1], 236, 118, 150, 125);
        //image(fotoJugadores[2], 445, 118, 150, 125);
        //image(fotoJugadores[3], 654, 118, 150, 125);
      }
      image(foto_mask, 0, 0);
    }
    else {
      image(fotoJugadores[0], 313, 138, 203, 133);
      image(foto_mask_single, 0, 0);
    }
  }*/
  if (tengoFotos) {
    println("saco foto");
    for (int i=0;i<num_jugadores;i++) {
      //fotoJugadores[i] = requestImage("http://"+CAMARA[i]+"/image?res=half&x0=0&y0=[object%20Window]&x1=1920&y1=1200&quality=21&doublescan=0&ssn=1397662550171&id=1397662551858", "jpg");
      // ESTO HABRIA QUE HACERLO CON THREADS
      fotoThreads[i] = new FotoThread(jugadoresList.get(i).id, CAMARA[i]);
      fotoThreads[i].start();
      // aqui pillo la foto y la subo al ftp andtonic assets/uploads
      //loadStrings(URL+"/getImageCam/"+jugadoresList.get(i).id+"?cam="+CAMARA[i]);
    }
    tengoFotos=false;

    /*while (fotoJugadores[0].width == 0) {
      // image is not loaded yet
      if (frameCount % 5 == 0) {
        print(".");
      }
      //noLoop();
    }
    if (fotoJugadores[0].width == -1) {
      // da error
      println("error foto width");
    }
    else {
      //image(fotoJugadores[0], 0, 0);
      //loop();
      println(".ok");
      tengoFotos = false;
    }*/
  }
}
/*
*****************************
 PANTALLA MOSTRAR COUNTDOWN
 *****************************
 */
void pantallaCountdown() {
  background(fondo);
  if (tipoTEAM) image(tres, 0, 0);
  else image(tres_single, 0, 0);
  textSize(70);
  if (floor(timeIniCountdown-(millis()/1000)) <= 0) {
    //  INICIO JUGADORES Y TIEMPOS DE JUGADOR
    //initJugadores();
    initJugadoresTiempos();
    gameState = JUGANDO;
  }
  switch(floor(timeIniCountdown-(millis()/1000))) {
  case 3:
    if (tipoTEAM) image(tres, 0, 0);
    else image(tres_single, 0, 0);
    break;
  case 2:
    if (tipoTEAM) image(dos, 0, 0);
    else image(dos_single, 0, 0);
    break;
  case 1:
    if (tipoTEAM) image(uno, 0, 0);
    else image(uno_single, 0, 0);
    break;
  }
  //text(str(floor(timeIniEtapa-(millis()/1000))),width/2,height/2);
}
/*
*******************************
 PANTALLA VIDEO
 ******************************
 */
void pantallaVideo() {
  //background(255);
  movie.loop();
  image(movie, 0, 0, width, height);
  if (keyPressed) {
    timeIniVideo = millis();
    gameState = INICIO;
  }
}

