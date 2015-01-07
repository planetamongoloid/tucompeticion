public class FotoThread extends Thread {
  String id;
  String camara;
  boolean running;
  FotoThread(String id_, String camara_) {
    running = false;
    id=id_;
    camara=camara_;
  }
  
  void start() {
    running = true;
    println("empiezo thread "+id);
    super.start();
  }
  void run() {
    loadStrings(URL+"/getImageCam/"+id+"?cam="+camara);
    println(id+" subido");
  }
  void quit() {
    System.out.println("Quitting."); 
    running = false;  // Setting running to false ends the loop in run()
    // IUn case the thread is waiting. . .
    interrupt();
  }
}


