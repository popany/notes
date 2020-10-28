# [Multithreaded Server in Java](http://tutorials.jenkov.com/java-multithreaded-servers/multithreaded-server.html)

- [Multithreaded Server in Java](#multithreaded-server-in-java)
  - [Multithreaded Server Advantages](#multithreaded-server-advantages)
  - [Multithreaded Server Code](#multithreaded-server-code)

This text describes a simple multithreaded server implemented in Java. The code is based on the singlethreaded server desbribed in the text on [Singlethreaded Servers](http://tutorials.jenkov.com/java-multithreaded-servers/singlethreaded-server.html). The main difference is the server loop. Rather than processing the incoming requests in the same thread that accepts the client connection, the connection is handed off to a worker thread that will process the request.

Note: This code uses a "**thread per connection**" design which most of us originally thought less efficient than a [thread pooled server](http://tutorials.jenkov.com/java-multithreaded-servers/thread-pooled-server.html). But read this blog post and think again:

[Writing Java Multithreaded Servers - whats old is new](http://paultyma.blogspot.com/2008/03/writing-java-multithreaded-servers.html)

Here is how the server loop looks in the multithreaded edition:

    while(! isStopped()){
        Socket clientSocket = null;
        try {
            clientSocket = this.serverSocket.accept();
        } catch (IOException e) {
            if(isStopped()) {
                System.out.println("Server Stopped.") ;
                return;
            }
            throw new RuntimeException(
                "Error accepting client connection", e);
        }
        new Thread(
        new WorkerRunnable(
            clientSocket, "Multithreaded Server")
            ).start();
    }

The only change in the loop from the singlethreaded server to here is the code in bold:

    new Thread(
        new WorkerRunnable(
            clientSocket, "Multithreaded Server")
    ).start();

Rather than processing the incoming requests in the same thread that accepts the client connection, the connection is handed off to a worker thread that processes the request. That way the thread listening for incoming requests spends as much time as possible in the `serverSocket.accept()` call. That way the risk is minimized for clients being denied access to the server because the listening thread is not inside the `accept()` call.

Here is the code for the `WorkerRunnable` class, which is passed to the worker thread constructor:

    package servers;

    import java.io.InputStream;
    import java.io.OutputStream;
    import java.io.IOException;
    import java.net.Socket;

    /**

    */
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

## Multithreaded Server Advantages

The advantages of a multithreaded server compared to a singlethreaded server are summed up below:

1. Less time is spent outside the `accept()` call.
2. Long running client requests do not block the whole server

As mentioned earlier the more time the thread calling `serverSocket.accept()` spends inside this method call, the more responsive the server will be. Only when the listening thread is inside the `accept()` call can clients connect to the server. Otherwise the clients just get an error.

In a singlethreaded server long running requests may make the server unresponsive for a long period. This is not true for a multithreaded server, unless the long-running request takes up all CPU time time and/or network bandwidth.


## Multithreaded Server Code

Here is the full code for the `MultiThreadedServer`:

    package servers;

    import java.net.ServerSocket;
    import java.net.Socket;
    import java.io.IOException;

    public class MultiThreadedServer implements Runnable{

        protected int          serverPort   = 8080;
        protected ServerSocket serverSocket = null;
        protected boolean      isStopped    = false;
        protected Thread       runningThread= null;

        public MultiThreadedServer(int port){
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
                        return;
                    }
                    throw new RuntimeException(
                        "Error accepting client connection", e);
                }
                new Thread(
                    new WorkerRunnable(
                        clientSocket, "Multithreaded Server")
                ).start();
            }
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

    MultiThreadedServer server = new MultiThreadedServer(9000);
    new Thread(server).start();

    try {
        Thread.sleep(20 * 1000);
    } catch (InterruptedException e) {
        e.printStackTrace();
    }
    System.out.println("Stopping Server");
    server.stop();

When the server is running you can access it using an ordinary web browser. Use the address http://localhost:9000/
