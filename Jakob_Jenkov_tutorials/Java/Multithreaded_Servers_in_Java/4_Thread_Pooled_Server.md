# [Thread Pooled Server](http://tutorials.jenkov.com/java-multithreaded-servers/thread-pooled-server.html)

- [Thread Pooled Server](#thread-pooled-server)
  - [Thread Pooled Server Advantages](#thread-pooled-server-advantages)
  - [Thread Pooled Server Code](#thread-pooled-server-code)

This text describes a simple thread pooled server implemented in Java. The code is based on the multithreaded server desbribed in the text on [Multithreaded Servers](http://tutorials.jenkov.com/java-multithreaded-servers/multithreaded-server.html). The main difference is the server loop. Rather than starting a new thread per incoming connection, the connection is wrapped in a `Runnable` and handed off to a thread poool with a **fixed number of threads**. The `Runnable`'s are kept in a **queue** in the thread pool. When a thread in the thread pool is idle it will take a `Runnable` from the queue and execute it.

Note: Thread pools are discussed in more detail in the text [Thread Pools](http://tutorials.jenkov.com/java-concurrency/thread-pools.html).

Here is how the server loop looks in the thread pooled edition (the full code is shown at the bottom of this text):

    while(! isStopped()){
         Socket clientSocket = null;
         try {
             clientSocket = this.serverSocket.accept();
         } catch (IOException e) {
             if(isStopped()) {
                 System.out.println("Server Stopped.") ;
                 break;
             }
             throw new RuntimeException(
                "Error accepting client connection", e);
         }
        
        this.threadPool.execute(
            new WorkerRunnable(clientSocket, "Thread Pooled Server"));
     }
 
The only change in the loop from the multithreaded server to here is the code in bold:

    this.threadPool.execute(
        new WorkerRunnable(clientSocket, "Thread Pooled Server"));

Rather than starting a new thread per incoming connection, the `WorkerRunnable` is passed to the thread pool for execution when a thread in the pool becomes idle.

Here is the code for the `WorkerRunnable` class, which is passed to the worker thread constructor:

    package servers;

    import java.io.InputStream;
    import java.io.OutputStream;
    import java.io.IOException;
    import java.net.Socket;

    public class WorkerRunnable implements Runnable{

        protected Socket clientSocket = null;
        protected String serverText   = null;

        public WorkerRunnable(Socket clientSocket, String serverText) {
            this.clientSocket = clientSocket;
            this.serverText   = serverText;
        }

        public void run() {
            try {
                InputStream input  = clientSocket.getInputStream();
                OutputStream output = clientSocket.getOutputStream();
                long time = System.currentTimeMillis();
                output.write(("HTTP/1.1 200 OK\n\nWorkerRunnable: " +
                    this.serverText + " - " +
                    time +
                    "").getBytes());
                output.close();
                input.close();
                System.out.println("Request processed: " + time);
            } catch (IOException e) {
                //report exception somewhere.
                e.printStackTrace();
            }
        }
    }

## Thread Pooled Server Advantages

The advantages of a thread pooled server compared to a multithreaded server is that you can **control the maximum number of threads** running at the same time. This has certain advantages.

First of all if the requests require a lot of CPU time, RAM or network bandwidth, this may slow down the server if many requests are processed at the same time. For instance, if memory consumption causes the server to swap memory in and out of disk, this will result in a serious performance penalty. By controlling the maximum number of threads you can **minimize the risk of resource depletion**, both due to limiting the memory taken by the processing of the requests, but also due to the limitation and **reuse of the threads**. Each thread take up a certain amount of memory too, just to represent the thread itself.

Additionally, **executing many requests concurrently will slow down all requests processed**. For instance, if you process 1000 requests concurrently and each request takes 1 second, then all requests will take 1000 seconds to complete. If you instead queue the requests up and process them say 10 at a time, the first 10 requests will complete after 10 seconds, the next 10 will complete after 20 seconds etc. Only the last 10 requests will complete after 1000 seconds. This gives a better service to the clients.

## Thread Pooled Server Code

Thread Pooled Server Code
Here is the full code for the ThreadPooledServer:

    package servers;

    import java.net.ServerSocket;
    import java.net.Socket;
    import java.io.IOException;
    import java.util.concurrent.ExecutorService;
    import java.util.concurrent.Executors;

    public class ThreadPooledServer implements Runnable{

        protected int          serverPort   = 8080;
        protected ServerSocket serverSocket = null;
        protected boolean      isStopped    = false;
        protected Thread       runningThread= null;
        protected ExecutorService threadPool =
            Executors.newFixedThreadPool(10);

        public ThreadPooledServer(int port){
            this.serverPort = port;
        }

        public void run(){
            synchronized(this){
                this.runningThread = Thread.currentThread();
            }
            openServerSocket();
            while(! isStopped()){
                Socket clientSocket = null;
                try {
                    clientSocket = this.serverSocket.accept();
                } catch (IOException e) {
                    if(isStopped()) {
                        System.out.println("Server Stopped.") ;
                        break;
                    }
                    throw new RuntimeException(
                        "Error accepting client connection", e);
                }
                this.threadPool.execute(
                    new WorkerRunnable(clientSocket,
                        "Thread Pooled Server"));
            }
            this.threadPool.shutdown();
            System.out.println("Server Stopped.") ;
        }

        private synchronized boolean isStopped() {
            return this.isStopped;
        }

        public synchronized void stop(){
            this.isStopped = true;
            try {
                this.serverSocket.close();
            } catch (IOException e) {
                throw new RuntimeException("Error closing server", e);
            }
        }

        private void openServerSocket() {
            try {
                this.serverSocket = new ServerSocket(this.serverPort);
            } catch (IOException e) {
                throw new RuntimeException("Cannot open port 8080", e);
            }
        }
    }

And here is the code to run it:

    ThreadPooledServer server = new ThreadPooledServer(9000);
    new Thread(server).start();

    try {
        Thread.sleep(20 * 1000);
    } catch (InterruptedException e) {
        e.printStackTrace();
    }
    System.out.println("Stopping Server");
    server.stop();

When the server is running you can access it using an ordinary web browser. Use the address http://localhost:9000/
