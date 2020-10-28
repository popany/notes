# [Java Networking: URL + URLConnection](http://tutorials.jenkov.com/java-networking/url-urlconnection.html)

- [Java Networking: URL + URLConnection](#java-networking-url--urlconnection)
  - [HTTP GET and POST](#http-get-and-post)
  - [URLs to Local Files](#urls-to-local-files)

The `java.net` package contains two interesting classes: The `URL` class and the `URLConnection` class. These classes can be used to create client connections to web servers (HTTP servers). Here is a simple code example:

    URL url = new URL("http://jenkov.com");

    URLConnection urlConnection = url.openConnection();
    InputStream input = urlConnection.getInputStream();

    int data = input.read();
    while(data != -1){
        System.out.print((char) data);
        data = input.read();
    }
    input.close();

## HTTP GET and POST

By default the `URLConnection` sends an HTTP GET request to the webserver. If you want to send an HTTP POST request instead, call the `URLConnection`.`setDoOutput(true)` method, like this:

    URL url = new URL("http://jenkov.com");

    URLConnection urlConnection = url.openConnection();
    urlConnection.setDoOutput(true);

Once you have set called `setDoOutput(true)` you can open the `URLConnection`'s `OutputStream` like this:

    OutputStream output = urlConnection.getOutputStream();

Using this `OutputStream` you can write any data you want in the **body of the HTTP request**. Remember to URL encode it (search Google for an explanation of URL encoding).

Remember to close the `OutputStream` when you are done writing data to it.

## URLs to Local Files

The URL class can also be used to access files in the local file system. Thus the URL class can be a handy way to open a file, if you need your code to **not know** whether the file came from the **network or local** file system.

Here is an example of how to open a file in the local file system using the URL class:

    URL url = new URL("file:/c:/data/test.txt");

    URLConnection urlConnection = url.openConnection();
    InputStream input = urlConnection.getInputStream();

    int data = input.read();
    while(data != -1){
        System.out.print((char) data);
        data = input.read();
    }
    input.close();

Notice how the only difference from accessing a file on a web server via HTTP is the the URL: "`file:/c:/data/test.txt`".
