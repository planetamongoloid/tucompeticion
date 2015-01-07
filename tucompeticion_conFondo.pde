import processing.serial.*;
import java.util.Arrays;
import java.util.Collections;
import java.awt.Frame;
import java.awt.BorderLayout;
import controlP5.*;
import processing.video.*;
import hypermedia.net.*;

UDP udp;  // define the UDP object
UDP udp_actuador;
String ip       = "192.168.1.177";     // the remote IP address
String ip_actuador = "192.168.1.176";
int port        = 8888;
int port_actuador = 9999;
private ControlP5 cp5;
String valor,valorActuador;

Movie movie;
ControlFrame cf;
// constante
final String URL = "http://tucompeticion.homelinux.com/competicion";
final String[] CAMARA = {
  "192.168.1.100", "192.168.1.101", "192.168.1.102", "192.168.1.103"
};
final int INICIO = 0;
final int JUGANDO = 1;
final int PODIO = 2;
final int RANKING = 3;
final int ETAPA = 4;
final int CUENTATRAS = 5;
final int FOTO = 6;
final int COUNTDOWN = 7;
final int FIN = 8;
final int VIDEO = 9;
final int TIME_PODIO = 15000;
final int TIME_FOTO = 5000;
final int TIME_ETAPA = 3000;
final int TIME_RANKING = 20000;
final int TIME_VIDEO = 60000;
//VAMOS A USAR NORMAL->0,MODO GHOST->1,MODO TEAM->2
final int NORM = 0;
final int GHOST = 1;
final int TEAM = 2;
final int SOLO = 3;
//OscP5 oscP5;
//NetAddress myRemoteLocation;

int[] puntoX = {
  22, 78, 137, 184, 199, 291, 354, 382, 413, 437, 451, 475, 521, 586, 612, 634, 677, 720, 750, 810
};
int[] puntoY = {
  85, 75, 76, 47, 46, 74, 77, 67, 66, 56, 42, 40, 55, 55, 39, 41, 73, 81, 82, 54
};
color gris = color(60, 60, 60);
color gris_oscuro = color(43, 43, 43);
color azul = color(95, 193, 218);
color verde = color(120, 182, 41);
color blanco = color(255, 255, 255);
color negro = color(0);
color fondo = gris;
PFont mvBold, mvRegular, mvTextRegular, mvTextBold;

int resul = 1;
int num_jugadores = 4;
String[] nombres ;
int sizeBolaEtapa = 13;
PImage home, etapa, foto, foto_mask, camarita, tres, dos, uno, foto_single, foto_mask_single, tres_single, dos_single, uno_single,fondo_imagen;
PImage[] fotoJugadores = new PImage[4];
PShape mvIcon, icon_female, icon_female_single, icon_male;
String movistar = "M.Team";
Jugador[] jugadores;
ArrayList<Jugador> jugadoresList;
Marcador[] marcadores = new Marcador[num_jugadores];
Serial myPort, actuadorPort;
int gameState = 0;
int modoJuego = GHOST;
// tipoJuego solo es TEAM o SOLO
int tipoJuego = TEAM;
boolean tipoTEAM = true;
boolean ACTUADORES =  false;
float valor1 = 0;
float valor2 = 0;
Jugador[] ranking;
int[] valuesArduino= {0,0,0,0};
int[] valuesArduinoActuador= {0,0,0,0};

boolean tengoFotos = true;
boolean tengoFb = true;
boolean hasFinished = false;
boolean terminado;
int timeIni, timeIniPodio, timeIniEtapa, timeIniRanking, timeIniFoto, timeIniCountdown, timeIniVideo;
String myString = null;
float easing_max = 0.5;
FotoThread[] fotoThreads = new FotoThread[num_jugadores];
FbThread[] fbThread = new FbThread[num_jugadores];
boolean hayjugadores = false;

void setup() {
  size(832, 390);
  frameRate(35);
  for (int i=0;i<puntoY.length;i++) {
    puntoY[i] = puntoY[i];
  }
  

  //myRemoteLocation = new NetAddress("127.0.0.1",12000);
  smooth();
  //randomSeed(7);
  home = loadImage("home.jpg");
  fondo_imagen = loadImage("fondo.jpg");
  etapa = loadImage("etapa_fondo.jpg");
  foto = loadImage("foto_fondo.jpg");
  foto_single = loadImage("foto_single.png");
  foto_mask = loadImage("foto_mask.png");
  foto_mask_single = loadImage("foto_mask_single.png");
  tres = loadImage("3_fondo.jpg");
  tres_single = loadImage("3_single_fondo.jpg");
  dos = loadImage("2_fondo.jpg");
  dos_single = loadImage("2_single_fondo.jpg");
  uno = loadImage("1_fondo.jpg");
  uno_single = loadImage("1_single_fondo.jpg");
  mvIcon = loadShape("mvIcon.svg");
  mvBold = createFont("MovistarHeadline-Bold.otf", 100);
  mvRegular = createFont("MovistarHeadline-Regular.otf", 100);
  mvTextBold = createFont("MovistarText-Bold.otf", 100);
  mvTextRegular = createFont("MovistarText-Regular.otf", 100);
  icon_female = loadShape("icon_female.svg");
  icon_male = loadShape("icon_male.svg");
  icon_female_single = loadShape("icon_female_single.svg");
  movie = new Movie(this, "flag.mp4");

  textFont(mvBold);
  //arrayCopy(jugadores, ranking);
  gameInit();
  timeIniVideo = millis();
  //String ip       = "192.168.1.177";     // the remote IP address
  //int port        = 8888;   
  udp = new UDP( this, 6000 );  // create datagram connection on port 6000
  udp_actuador = new UDP( this, 6666);
  udp.log( true );            // <-- print out the connection activity
  //udp_actuador.log( true);
  udp.setReceiveHandler("receiveSensor");
  udp_actuador.setReceiveHandler("receiveActuador");
  udp.listen( true );           // and wait for incoming message
  udp_actuador.listen( true );
  //println(Serial.list());
  //myPort = new Serial(this, "/dev/ttyACM0", 9600);
  //
  //actuadorPort = new Serial(this, "/dev/ttyACM0", 9600);
  //myPort = new Serial(this, "/dev/tty.usbmodem1431", 9600);
   //myPort = new Serial(this, Serial.list()[0], 9600); 
   //actuadorPort = new Serial(this, "/dev/tty.usbmodem1431", 9600);
   //myPort.clear();
   //myPort.bufferUntil('\n');
   //myString = null;
   /* start oscP5, listening for incoming messages at port 12000 */
  //oscP5 = new OscP5(this, 12000);
  // controlP5
  cp5 = new ControlP5(this);

  // by calling function addControlFrame() a
  // new frame is created and an instance of class
  // ControlFrame is instanziated.
  cf = addControlFrame("extra", 400, 400);
}
void gameInit() {
  gameState = INICIO;
}
void draw() {
  switch(gameState) {
  case INICIO:
    pantallaInicio();
    break;
  case JUGANDO:
    pantallaJuego();
    break;
  case PODIO:
    pantallaPodio();
    break;
  case RANKING:
    pantallaRanking();
    break;
  case ETAPA:
    pantallaMostrarEtapa();
    break;
  case FOTO:
    pantallaMostrarFoto();
    break;
  case COUNTDOWN:
    pantallaCountdown();
    break;
  case VIDEO:
    pantallaVideo();
    break;
  }
}

//void receiveSensor( byte[] data ) {           // <-- default handler
  void receiveSensor( byte[] data, String ip, int port ) { // extended handler

  for (int i=0; i < data.length; i++) {
    //print(char(data[i]));
    valor+=char(data[i]);
    //println();
    //println(valor);
  }
  valuesArduino = int(split(valor, ","));
    /*int val3 = values[2];
    int val2 = values[1];
    values[2] = val2;
    values[1] = val3;*/
  //println(valor);
    // LEO DATOS DE SERIAL SOLO SI ESTAN JUGANDO
    if (gameState == JUGANDO) {
      for (int i=0;i<jugadoresList.size()-1;i++) {
        jugadoresList.get(i).easing = map(float(valuesArduino[i]), 0, 455, 0.0, easing_max);
        jugadoresList.get(i).marcador.velocidad = int(valuesArduino[i]*0.1323);
      }
      //println(jugadoresList.get(2).nombre +values[2]);
    }
  valor="";
}
void receiveActuador( byte[] data ,String ip_actuador,int port_actuador) {           // <-- default handler
  //void receive( byte[] data, String ip, int port ) { // extended handler

  for (int i=0; i < data.length; i++) {
    //print(char(data[i]));
    valorActuador+=char(data[i]);
    //println();
    //println(valor);
  }
  valuesArduinoActuador = int(split(valorActuador, ","));
    /*int val3 = values[2];
    int val2 = values[1];
    values[2] = val2;
    values[1] = val3;*/
  //println(valorActuador);
    // LEO DATOS DE SERIAL SOLO SI ESTAN JUGANDO
   
  valorActuador="";
}
void serialEvent(Serial myPort) { 
  myString = myPort.readStringUntil('\n');
  if (myString != null) {
    myString = trim(myString);
    int[] values = int(split(myString, ","));
    //int val3 = values[2];
    //int val2 = values[1];
    //values[2] = val2;
    //values[1] = val3;
    if( gameState == INICIO || gameState == VIDEO){
      println(values[0]+","+values[1]+","+values[2]+","+values[3]);
    }
    // LEO DATOS DE SERIAL SOLO SI ESTAN JUGANDO
    if (gameState == JUGANDO) {
      for (int i=0;i<jugadoresList.size()-1;i++) {
        jugadoresList.get(i).easing = map(float(values[i]), 0, 455, 0.0, easing_max);
        jugadoresList.get(i).marcador.velocidad = int(values[i]*0.1323);
      }
      //println(jugadoresList.get(2).nombre +values[2]);
    }
  }
}
void initJugadores() {
  nombres = loadStrings(URL+"/getData2");
  println("nombreeee s "+nombres.length);
  if (nombres.length > 0) {
    hayjugadores = true;
    switch(modoJuego) {
    case GHOST:
      num_jugadores = nombres.length;
      if (num_jugadores == 1) {
        tipoTEAM = false;
      }
      else {
        tipoTEAM = true;
      }
      //jugadores = new Jugador[num_jugadores];
      jugadoresList = new ArrayList<Jugador>();
      //jugadores[4] = new Jugador("MOVISTAR", "0", 0.95, color(120, 182, 41), 500, puntoX, puntoY, 60, true);
      ranking = new Jugador[num_jugadores];
      for (int i=0;i<num_jugadores;i++) {
        String[] list = split(nombres[i], ','); 
        // 
          jugadoresList.add(new Jugador(list[0], list[1], list[2], random(0.3, 0.48), azul, i, puntoX, puntoY, 60, false));
        //jugadoresList.add(new Jugador(list[0], list[1], 0, azul, i, puntoX, puntoY, 60, false));
      }
      jugadoresList.add(new Jugador("Nairo Quintana", "0", "0", 0.99, color(120, 182, 41), 500, puntoX, puntoY, 60, true));
      break;
    case NORM:
      num_jugadores = nombres.length;
      jugadores = new Jugador[num_jugadores];
      jugadoresList = new ArrayList<Jugador>();
      ranking = new Jugador[num_jugadores];
      for (int i=0;i<num_jugadores;i++) {
        String[] list = split(nombres[i], ','); 
        jugadoresList.add(new Jugador(list[0], list[1], list[2], random(0.3, 0.5), azul, i, puntoX, puntoY, 60, false));
      }
      break;
    }
  }
  else {
    gameState = INICIO;
  }
}
void initJugadoresTiempos() {
  for (int i=0;i<num_jugadores;i++) {
    jugadoresList.get(i).start = millis();
  }
}
void dibujarEtapa() {
  // DIBUJO LA ETAPA
  fill(gris_oscuro);
  noStroke();
  //rect(0, 0, width, height/3);

  noFill();
  stroke(255);
  strokeWeight(3);

  beginShape();

  for (int i=0; i<puntoX.length;i++) {
    vertex(puntoX[i], puntoY[i]);
    //println(puntoX[i]+" "+ puntoY[i]);
  }
  endShape();
  fill(255);
  ellipse(puntoX[0], puntoY[0], sizeBolaEtapa, sizeBolaEtapa);
  ellipse(puntoX[puntoX.length-1], puntoY[puntoX.length-1], sizeBolaEtapa, sizeBolaEtapa);
  noFill();
  strokeWeight(1);
}

void nextScreen(int tiempo_, int time_count_, int ESTADO) {
  if (millis() - tiempo_ > time_count_) {
    switch(ESTADO) {
      // EL CASE JUGANDO NO LLAMA NUNCA
    case JUGANDO:
      initJugadores();
      initJugadoresTiempos();
      gameState = ESTADO;
      break;
    case RANKING:
      timeIniVideo = millis();
      // RESETEO JUGADORES Y AL INICIO
      
      for (int i=0;i<num_jugadores;i++) {
        // GUARDO DATOS DE TIEMPOS DE JUGADORES EN BBDD
        if (jugadoresList.get(i).id != "x") {
          loadStrings(URL+"/setTiempo/"+str((jugadoresList.get(i).stop - jugadoresList.get(i).start)/1000)+"/"+jugadoresList.get(i).id);
        }
        resul = 1;
        // RELLENO LOS ids DE LOS JUGADORES PARA EL RANKING
        if (jugadoresList.get(i).id != "x") {
          ids[i] = int(jugadoresList.get(i).id);
        }
        jugadoresList.get(i).reset();
      }
      timeIniRanking = millis();
      gameState = RANKING;
      break;
    case INICIO:
      // SETEO EL RANKING CADA VEZ QUE EMPIEZA EL JUEGO
      loadRanking = true;
      gameState = INICIO;
      break;
    case FOTO:
      timeIniFoto = millis();
      // INICIO LOS JUGADORES, LOS TIEMPOS DE JUGADOR SE INICIAN EN pantallas->pantallaMostrarFoto
      initJugadores();
      if(nombres.length > 0){
      gameState = FOTO;
      }else{
      gameState = INICIO;
      }
      break;
    case VIDEO:
      //timeIniFoto = millis();
      // INICIO LOS JUGADORES, LOS TIEMPOS DE JUGADOR SE INICIAN EN pantallas->pantallaMostrarFoto
      gameState = VIDEO;
      break;
    case COUNTDOWN:
      initJugadores();
      timeIniCountdown = millis()/1000+ 4;
      // BORRAMOS EL ARCHIVO DE NOMBRES PARA QUE PUEDAN LOGEARSE LOS SIGUIENTES
      loadStrings(URL+"/clear");
      hayjugadores = false;
      gameState = COUNTDOWN;
      break;
    }
  }
}
void mousePressed() {
  println(mouseX, mouseY);
}
void movieEvent(Movie m) {
  m.read();
}

/* Mando los datos de pendiente al arduino */
void sendPendiente() {
  String[] pendientes = new String[num_jugadores];
  for (int i=0;i<num_jugadores;i++) {
    if (jugadoresList.get(i).pendiente < 0) {
      pendientes[i] =  str(int(map(int(jugadoresList.get(i).pendiente*100), -78, 0, 5, 2)));
    }
    else {
      pendientes[i] = "1";
    }
//actuadorPort.write(pendientes[i]);
  }
  if(ACTUADORES){
  udp_actuador.send(pendientes[0]+","+pendientes[1]+","+pendientes[2]+","+pendientes[3],ip_actuador,port_actuador);
  }
  /*pendientes[0] = str(int(map(int(jugadoresList.get(0).pendiente*100), -100, 100, 1, 5)));
   myPort.write(pendientes[0]);
   println(pendientes[0]);
   myPort.write("2");
   myPort.write("2");
   myPort.write("2");*/
  //myPort.write(pendientes);
}
/* PARA SALIR DEL VIDEO CUANDO MUEVES RATON */
void mouseMoved() {
  // vuelvo a setear el tiempo
  if (gameState == VIDEO) {
    movie.stop();
    timeIniVideo = millis();
    gameState = INICIO;
  }
}

ControlFrame addControlFrame(String theName, int theWidth, int theHeight) {
  Frame f = new Frame(theName);
  ControlFrame p = new ControlFrame(this, theWidth, theHeight);
  f.add(p);
  p.init();
  f.setTitle(theName);
  f.setSize(p.w, p.h);
  f.setLocation(100, 100);
  f.setResizable(false);
  f.setVisible(true);
  return p;
}

