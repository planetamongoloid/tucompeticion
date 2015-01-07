public class FbThread extends Thread {
  String id;
  boolean running;
  FbThread(String id_) {
    running = false;
    id=id_;
  }
  
  void start() {
    running = true;
    println("empiezo thread "+id);
    super.start();
  }
  void run() {
    loadStrings(URL+"/postImage/"+id);
    println(id+" subido");
  }
  void quit() {
    System.out.println("Quitting fb."); 
    running = false;  // Setting running to false ends the loop in run()
    // IUn case the thread is waiting. . .
    interrupt();
  }
}


