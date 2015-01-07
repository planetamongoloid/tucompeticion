int margenIzq = 10;
float anchoCaja = 146;
float altoCaja = 33;
float padCaja = 5;
int posTitulo = 55;
int posNombres = 85;
color colorCaja = negro; 
int num_linea, num_columna;
JSONArray values;
int minutes, segundos;
String centesimas;
JSONObject[] todos = new JSONObject[num_jugadores];
// ESTOS ids SE RELLENAN EN EL NEXTSCREEN RANKING
int []ids = new int[num_jugadores];
boolean loadRanking = true;

int posx_rank = 28;
void pantallaRanking() {
  if (loadRanking) {
    for (int i=0;i<num_jugadores;i++) {
      if (!jugadoresList.get(i).id.equals("x")) {
        println(URL+"/getRankSexo/"+ids[i]+"?sexo="+jugadoresList.get(i).sexo);
        todos[i] = loadJSONObject(URL+"/getRankSexo/"+jugadoresList.get(i).id+"?sexo="+jugadoresList.get(i).sexo);
      }
      else {
        String jsonFragment = "{\"id\": \"0\", \"nombre\": \"Foo\"}";
        JSONObject jo = JSONObject.parse(jsonFragment);
        todos[i] = jo;
      }
    }
    println(todos);
    loadRanking = false;
  }
  // CHECK TIEMPO Y CAMBIO A SIGUIENTE PANTALLA
  nextScreen(timeIniRanking, TIME_RANKING, INICIO);
  background(fondo);
  image(fondo_imagen,0,0);
  fill(255);
  stroke(100);
  textFont(mvBold);
  textSize(39);
  textAlign(LEFT);
  //println(todos[0].getString("nombre"));
  // CAMBIAR PARA FEEL GOOD
  if (num_jugadores > 1 ) {
    text("Ránkings globales", margenIzq, posTitulo);
  }
  else {
    text("Tu posicion en los ranking", margenIzq, posTitulo);
  }
  float a = textAscent();
  float b = textDescent();
  float altText = a+b;
  /*println(a+" "+b);
   line(0,posTitulo-a,width,posTitulo-a);
   line(0,posTitulo+b,width,posTitulo+b);*/
  stroke(255);
  strokeWeight(2);
  line(margenIzq, posTitulo+15, width-margenIzq, posTitulo+15);
  // si hay mas de un jugador
  if (num_jugadores > 1) {
    for (int i=0;i<num_jugadores;i++) {
      posx_rank = 28+(i*width/4);
      cuadroRank(posx_rank, 74, i);
      
    }
  }
  // si es solo un jugador
  else {
    shape(icon_female_single, 104, 100, 623, 91);
    textAlign(LEFT, TOP);
    // FEEL GOOD
    //textAlign(CENTER, TOP); 
    textSize(112);
    fill(blanco);
    if(!jugadoresList.get(0).id.equals("x")){
    text("#"+nf(todos[0].getInt("position"), 3), 104, 210);
    text("#"+nf(todos[0].getInt("position_mall"), 3), 460, 210);
    }
    // FEEL GOOD
    //text("#"+nf(todos[0].getInt("position_mall"), 3), width/2, 210);
  }
}
void cuadroRank(int x, int y, int i) {
  //println(x);
  pushMatrix();
  translate(x, y);
  noStroke();
  fill(gris_oscuro);
  rect(0, 0, anchoCaja, altoCaja);
  if (todos[i].getInt("id") > 1) {
    fill(blanco);
    rect(0, 92, anchoCaja, 2);
    // FEEL GOOG
    fill(verde);
    // UNIBIKE
    rect(0, 97, anchoCaja, 60);
    fill(blanco);
    rect(0, 213, anchoCaja, 2);
    fill(azul);
    rect(0, 218, anchoCaja, 60);
    // iconos
    if (todos[i].getInt("sexo") > 0) {
      shape(icon_male, 0, 50, 53, 39);
      shape(icon_male, 0, 170, 53, 39);
    }
    else {
      shape(icon_female, 0, 50, 53, 39); 
      shape(icon_female, 0, 170, 53, 39);
    }
    fill(blanco);

    textFont(mvBold);
    textAlign(RIGHT, CENTER);
    textSize(20);
    // NOMBRE 
    if (textWidth(todos[i].getString("nombre")) > anchoCaja) {
      text(todos[i].getString("nombre").substring(0, 10)+"...", anchoCaja-5, altoCaja/2);
    }
    else {
      text(todos[i].getString("nombre"), anchoCaja-5, altoCaja/2);
    }
    //textSize(63);
    if (todos[i].getInt("position") < 1000) {
      textSize(63);
    }
    else {
      textSize(50);
    }
    textAlign(RIGHT, TOP);
    // POSICION NACIONAL
    text("#"+nf(todos[i].getInt("position"), 3), anchoCaja, 100);
    //text("221",40,100);
    // POSICION CENTRO COMERCIAL  
    text("#"+nf(todos[i].getInt("position_mall"), 3), anchoCaja, 220);
    // FEEL GOOD 
    //text("#"+nf(todos[i].getInt("position_mall"), 3), anchoCaja, 100);
    textFont(mvTextRegular);
    textAlign(RIGHT, BOTTOM);
    textSize(15);
    text("Nacional", anchoCaja, 90);
    text("C.Comercial", anchoCaja, 213);
    //text("UNIBIKE", anchoCaja, 213);
  }// SI ES ANONIMO
  else {
    fill(blanco);
    textFont(mvBold);
    textAlign(RIGHT, CENTER);
    textSize(20);
    text("Anónimo", anchoCaja-5, altoCaja/2);
    fill(gris_oscuro);
    rect(0, altoCaja+5, anchoCaja, 177);
    fill(azul);
    textSize(150);
    text("?", 105, 120);
    fill(blanco);
    rect(0, 220, anchoCaja, 2);
    String s = "Al jugar en modo anónimo, tus tiempos no son registrados en los rankings.";
    textFont(mvTextRegular);
    textAlign(LEFT, TOP);
    textSize(12);
    text(s, 0, 230, anchoCaja, 50);
  }
  popMatrix();
}

