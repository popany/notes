# [Java Networking: JarURLConnection](http://tutorials.jenkov.com/java-networking/jarurlconnection.html)

- [Java Networking: JarURLConnection](#java-networking-jarurlconnection)

Java's `JarURLConnection` class is used to connect to a Java Jar file. Once connected you can obtain information about the contents of the Jar file. Here is a simple example:

    String urlString = "http://butterfly.jenkov.com/"
                    + "container/download/"
                    + "jenkov-butterfly-container-2.9.9-beta.jar";

    URL jarUrl = new URL(urlString);
    JarURLConnection connection = new JarURLConnection(jarUrl);

    Manifest manifest = connection.getManifest();


    JarFile jarFile = connection.getJarFile();

    //do something with Jar file...

    ...  
