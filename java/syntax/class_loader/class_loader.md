# class loader

- [class loader](#class-loader)
  - [How to load Classes at runtime from a folder or JAR?](#how-to-load-classes-at-runtime-from-a-folder-or-jar)
  - [Loading Spring context with specific classloader](#loading-spring-context-with-specific-classloader)

## [How to load Classes at runtime from a folder or JAR?](https://stackoverflow.com/questions/11016092/how-to-load-classes-at-runtime-from-a-folder-or-jar)

The following code loads all classes from a JAR file. It does not need to know anything about the classes. The names of the classes are extracted from the JarEntry.

    JarFile jarFile = new JarFile(pathToJar);
    Enumeration<JarEntry> e = jarFile.entries();

    URL[] urls = { new URL("jar:file:" + pathToJar+"!/") };
    URLClassLoader cl = URLClassLoader.newInstance(urls);

    while (e.hasMoreElements()) {
        JarEntry je = e.nextElement();
        if(je.isDirectory() || !je.getName().endsWith(".class")){
            continue;
        }
        // -6 because of .class
        String className = je.getName().substring(0,je.getName().length()-6);
        className = className.replace('/', '.');
        Class c = cl.loadClass(className);

    }

## [Loading Spring context with specific classloader](https://stackoverflow.com/questions/5660115/loading-spring-context-with-specific-classloader)

    ApplicationContext ctx = new ClassPathXmlApplicationContext(myCtxPath)
    {
        protected void initBeanDefinitionReader(XmlBeanDefinitionReader reader)
        {
            super.initBeanDefinitionReader(reader);
            reader.setValidationMode(XmlBeanDefinitionReader.VALIDATION_NONE);
            reader.setBeanClassLoader(getClassLoader());
        }
    }

See here if you are doing this for OSGI purposes: [How do I use a Spring bean inside an OSGi bundle?](https://stackoverflow.com/questions/8039931/how-do-i-use-a-spring-bean-inside-an-osgi-bundle)
