# [Singlethreaded Server in Java](http://tutorials.jenkov.com/java-multithreaded-servers/singlethreaded-server.html)

- [Singlethreaded Server in Java](#singlethreaded-server-in-java)
  - [The Server Loop](#the-server-loop)

This text will show how to implement a singlethreaded server in Java. A singlethreaded server is not the most optimal design for a server, but the code **illustrates the life cycle of a server** very well. The following texts on multithreaded servers will built upon this code template.

Here is a simple singlethreaded server:

    package servers;

    import java.net.ServerSocket;
    import java.net.Socket;
    import java.io.IOException;
    import java.io.InputStream;
    import java.io.OutputStream;

    public class SingleThreadedServer implements Runnable{

        protected int          serverPort   = 8080;
        protected ServerSocket serverSocket = null;
        protected boolean      isStopped    = false;
        protected Thread       runningThread= null;

        public SingleThreadedServer(int port){
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
                try {
                    processClientRequest(clientSocket);
                } catch (Exception e) {
                    //log exception and go on to next request.
                }
            }
            
            System.out.println("Server Stopped.");
        }

        private void processClientRequest(Socket clientSocket)
        throws Exception {
            InputStream  input  = clientSocket.getInputStream();
            OutputStream output = clientSocket.getOutputStream();
            long time = System.currentTimeMillis();

            byte[] responseDocument = "<html><body>" +
                    "Singlethreaded Server: " +
                    time +
                    "</body></html>".getBytes("UTF-8");

            byte[] responseHeader =
                "HTTP/1.1 200 OK\r\n" +
                "Content-Type: text/html; charset=UTF-8\r\n" +
                "Content-Length: " + responseDocument.length +
                "\r\n\r\n".getBytes("UTF-8");

            output.write(responseHeader);
            output.write(responseDocument);
            output.close();
            input.close();
            System.out.println("Request processed: " + time);
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

    SingleThreadedServer server = new SingleThreadedServer(9000);
    new Thread(server).start();

    try {
        Thread.sleep(10 * 1000);
    } catch (InterruptedException e) {
        e.printStackTrace();  
    }
    System.out.println("Stopping Server");
    server.stop();

When the server is running you can access it using an ordinary web browser. Use the address http://localhost:9000/

## The Server Loop

The most interesting part of the singlethreaded server is its main loop marked in bold in the code above. The loop is repeated here:

    while(! isStopped()){
        Socket clientSocket = null;
        try {
            clientSocket = this.serverSocket.accept();
        } catch (IOException e) {
            if(isStopped()) {
                System.out.println("Server Stopped.") ;
                return;
            }
        throw new RuntimeException("Error accepting client connection", e);
        }
        try {
            processClientRequest(clientSocket);
        } catch (IOException e) {
            //log exception and go on to next request.
        }
    }

In short what the server does is this:

1. Wait for a client request
2. Process client request
3. Repeat from 1.

This loop is pretty much the same for most servers implemented in Java. What separates the single threaded server from a multithreaded server is that the single threaded server processes the incoming requests in the same thread that accepts the client connection. A multithreaded server passes the connection on to a worker thread that processes the request.

Processing the incoming requests in the same thread that accepts the client connections is not a good idea. Clients can only connect to the server while the server is inside the `serverSocket.accept()` method call. The longer time the listening thread spends outside the `serverSocket.accept()` call, the higher the probability that the client will be denied access to the server. This is the reason that multithreaded servers pass the incoming connections on to worker threads, who will process the request. That way the listening thread spends as little time as possible outside the `serverSocket.accept()` call.
