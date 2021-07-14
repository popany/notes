# Add Properties to an Application Context

- [Add Properties to an Application Context](#add-properties-to-an-application-context)
  - [How to add Properties to an Application Context](#how-to-add-properties-to-an-application-context)

## [How to add Properties to an Application Context](https://stackoverflow.com/questions/9294187/how-to-add-properties-to-an-application-context)

In Spring 3.1 you can implement your own `PropertySource`, see: [Spring 3.1 M1: Unified Property Management](http://blog.springsource.org/2011/02/15/spring-3-1-m1-unified-property-management/).

First, create your own `PropertySource` implementation:

    private static class CustomPropertySource extends PropertySource<String> {

        public CustomPropertySource() {super("custom");}

        @Override
        public String getProperty(String name) {
            if (name.equals("myCalculatedProperty")) {
                return magicFunction();  //you might cache it at will
            }
            return null;
        }
    }

Now add this `PropertySource` before refreshing the application context:

    AbstractApplicationContext appContext =
        new ClassPathXmlApplicationContext(
            new String[] {"applicationContext.xml"}, false
        );
    ((AbstractEnvironment)appContext.getEnvironment()).getPropertySources().addLast(new CustomPropertySource());
    appContext.refresh();

From now on you can reference your new property in Spring:

    <context:property-placeholder/>

    <bean class="com.example.Process">
        <constructor-arg value="${myCalculatedProperty}"/>
    </bean>

Also works with annotations (remember to add `<context:annotation-config/>`):

    @Value("${myCalculatedProperty}")
    private String magic;

    @PostConstruct
    public void init() {
        System.out.println("Magic: " + magic);
    }
