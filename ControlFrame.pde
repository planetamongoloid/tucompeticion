// the ControlFrame class extends PApplet, so we 
// are creating a new processing applet inside a
// new frame with a controlP5 object loaded
public class ControlFrame extends PApplet {

  int w, h;

  int abc = 0;
  String pantalla = "INICIO";
  JSONObject[] jsonJugadores = new JSONObject[4];
  CheckBox checkbox;
  Slider pru;
  int actuadores = 3;
  public void setup() {
    size(w, h);
    frameRate(25);
    cp5 = new ControlP5(this);
    //cp5.addSlider("easing").plugTo(parent, "easing_max").setValue(easing_max).setRange(0, 0.9).setPosition(10, 10).setWidth(300);
    //cp5.addBang("reiniciar").setSize(40, 40).setPosition(290, 180).setId(1);
    cp5.addBang("terminar").setSize(30, 30).setPosition(360, 325).setId(2);
    //cp5.addBang("actuadores").setSize(30, 30).setPosition(300, 325).setId(2);
    cp5.addBang("jugadores").setSize(20, 20).setPosition(10, 10).setId(3);
    cp5.addButton("eliminar0").setPosition(10,100).setSize(43,19);
    cp5.addButton("eliminar1").setPosition(110,100).setSize(43,19);
    cp5.addButton("eliminar2").setPosition(210,100).setSize(43,19);
    cp5.addButton("eliminar3").setPosition(310,100).setSize(43,19);
    cp5.addButton("anonimo0").setLabel("+").setPosition(60,100).setSize(13,19);
    cp5.addButton("anonimo1").setLabel("+").setPosition(160,100).setSize(13,19);
    cp5.addButton("anonimo2").setLabel("+").setPosition(260,100).setSize(13,19);
    cp5.addButton("anonimo3").setLabel("+").setPosition(360,100).setSize(13,19);
    cp5.addToggle("ACTUADORES").plugTo(parent, "ACTUADORES").setValue(ACTUADORES).setPosition(10, 325).setMode(ControlP5.SWITCH);
    cp5.addSlider("actuadores")
     .setPosition(60,325)
     .setWidth(100)
     .setRange(5,1)     
     .setValue(5)
     .setNumberOfTickMarks(5)
     .setSliderMode(Slider.FLEXIBLE)
     ;
    jugadores();
     
  }

  public void draw() {
    background(abc);
    dibujoCuadrado();
    // SI HAY JUGADORES LOS MUESTRO
    fill(0);
    for (int i=0;i<4;i++) {
      if (jsonJugadores[i] != null) {
        if (jsonJugadores[i].getInt("estado")>0) {
          text(jsonJugadores[i].getInt("id"), 10+(i*100), 80);
          text(jsonJugadores[i].getString("nombre"), 10+(i*100), 90);
          //println(jsonJugadores[i].getString("nombre"));
          
        }
      }
    }
    // MUESTRO VALORES DE ACTUADORES
    for (int i=0;i<4;i++) {
      text("actuador"+i, 10+(i*100), 260);
      //text(valuesArduinoActuador[i], 10+(i*100), 270);
      rect(10+(i*100),265,50,10);
      fill(0,255,0);
      rect(10+(i*100),265,map(valuesArduinoActuador[i],20,700,10,50),10);
      fill(0);
    }
    // MUESTRO VALORES DE SENSORES
    for (int i=0;i<4;i++) {
      text("sensor"+i, 10+(i*100), 290);
      text(valuesArduino[i], 10+(i*100), 300);
    }

    switch(gameState) {
    case INICIO:
      pantalla = "INICIO";
      break;
    case FOTO:
      pantalla = "FOTO";
      break;
    case COUNTDOWN:
      pantalla = "CUENTA ATRAS";
      break;
    case JUGANDO:
      pantalla = "JUGANDO";
      break;
    case PODIO:
      pantalla = "PODIO";
      break;
    case RANKING:
      pantalla = "RANKING";
      break;
    case VIDEO:
      pantalla = "VIDEO";
      break;
    }
    fill(0);
    noStroke();
    rect(280, 0, 150, 20);
    fill(255);
    text(pantalla, 290, 10);
    if (gameState == VIDEO) {
      if (keyPressed) {  
        timeIniVideo = millis();
        gameState = INICIO;
      }
    }
    if (gameState == INICIO) {
      if (keyPressed) {
        switch(key) {
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
    if (gameState == JUGANDO) {
      for (int i=0;i<jugadoresList.size()-1;i++) {
        //text(str(int(map(int(jugadoresList.get(i).pendiente*100), -100, 100, 1, 5))), 10+(i*90), 320);
        //text(jugadoresList.get(i).id, 10+(i*90), 340);
        //text(jugadoresList.get(i).nombre, 10+(i*90), 350);
        //text((millis()-jugadoresList.get(i).start)/1000, 10+(i*90), 360);
        //text(jugadoresList.get(i).pendiente, 10+(i*90), 360);
      }
    }
  }

  private ControlFrame() {
  }

  public ControlFrame(Object theParent, int theWidth, int theHeight) {
    parent = theParent;
    w = theWidth;
    h = theHeight;
  }


  public ControlP5 control() {
    return cp5;
  }
  public void reiniciar() {
    if (gameState == JUGANDO || gameState == PODIO || gameState == RANKING) {
      for (int i=0;i<jugadoresList.size()-1;i++) {
        jugadoresList.get(i).reset();
      }
    }
    // SETEO EL RANKING CADA VEZ QUE EMPIEZA EL JUEGO
    loadRanking = true;
    // SETEO LOS RESULTADOS
    resul = 1;
    gameState = INICIO;
    println("### bang(). a bang event. ");
  }
  public void terminar() {
    println("bang terminado");
    for (int i=0;i<jugadoresList.size();i++) {
      println(jugadoresList.get(i).nombre);
      if (jugadoresList.get(i).stop == 0) {
        jugadoresList.get(i).stop = millis()+60000;
      }  
      jugadoresList.get(i).fin = true;   
      terminado = true;
    }
  }
  public void actuadores(int valor_) {
    println("evento slider "+valor_);
    if(valor_ > 0 && ACTUADORES){
      udp_actuador.send(int(valor_)+","+int(valor_)+","+int(valor_)+","+int(valor_),ip_actuador,port_actuador);
    }
  }
  public void eliminar0(int theValue) {
    println("elimino: "+theValue);
    loadStrings(URL+"/setEstado/0");
    jugadores();
  }
  public void eliminar1(int theValue) {
    println("elimino: "+theValue);
    loadStrings(URL+"/setEstado/1");
    jugadores();
  }
  public void eliminar2(int theValue) {
    println("elimino: "+theValue);
    loadStrings(URL+"/setEstado/2");
    jugadores();
  }
  public void eliminar3(int theValue) {
    println("elimino: "+theValue);
    loadStrings(URL+"/setEstado/3");
    jugadores();
  }
  public void anonimo0(int theValue) {
    loadStrings(URL+"/setEstadoAnonimo/0");
    jugadores();
  }
  public void anonimo1(int theValue) {
    println("elimino: "+theValue);
    loadStrings(URL+"/setEstadoAnonimo/1");
    jugadores();
  }
  public void anonimo2(int theValue) {
    println("elimino: "+theValue);
    loadStrings(URL+"/setEstadoAnonimo/2");
    jugadores();
  }
  public void anonimo3(int theValue) {
    println("elimino: "+theValue);
    loadStrings(URL+"/setEstadoAnonimo/3");
    jugadores();
  }
  public void jugadores() {
    for (int i=0;i<4;i++) {
      jsonJugadores[i] = loadJSONObject(URL+"/getEstado/"+i);
    }
  }
  public void dibujoCuadrado(){
    fill(255);
    rect(0,70,width/4,250);
    fill(153,233,255);
    rect(width/4,70,width/4,250);
    fill(110,182,202);
    rect(width/2,70,width/4,250);
    fill(13,147,184);
    rect(width-width/4,70,width/4,250);
  }
  void controlEvent(ControlEvent theEvent) {
    //println(tipoTEAM);
  }

  ControlP5 cp5;

  Object parent;
}

