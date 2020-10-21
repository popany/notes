# [How to create Datasource in Spring Boot application](https://www.roytuts.com/how-to-create-datasource-in-spring-boot-application/)

- [How to create Datasource in Spring Boot application](#how-to-create-datasource-in-spring-boot-application)

In this tutorial we will see how to create `Datasource` in Spring Boot application in different ways. We need to create datasource in our applicationin order to interact with database and perform database operations in Spring or Spring Boot applications.

You can use database vendor as per your project’s requirement but the underlying concept is same for creating the `Datasource`. If you are using Spring JDBC API then you can use this `Datasource` object to create `JdbcTemplate` object. This `Datasource` object is also useful for working with Spring Data JPA or Spring JPA API.

Let’s say you have the following `application.properties` file under the classpath folder `src/main/resources`.

    jdbc.driverClassName=com.mysql.cj.jdbc.Driver
    jdbc.url=jdbc:mysql://localhost:3306/jeejava
    jdbc.username=root
    jdbc.password=root

Now you can create the Datasource in Spring configuration class as follows:

    @Configuration
    public class DatabaseConfig {

        @Autowired
        private Environment environment;

        @Bean
        public DataSource dataSource() {
            DriverManagerDataSource dataSource = new DriverManagerDataSource();

            dataSource.setDriverClassName(environment.getProperty("jdbc.driverClassName"));
            dataSource.setUrl(environment.getProperty("jdbc.url"));
            dataSource.setUsername(environment.getProperty("jdbc.username"));
            dataSource.setPassword(environment.getProperty("jdbc.password"));

            return dataSource;
        }
    }

The Environment is required in order to access the key/value pairs from properties file.

You can also use the below approach.

    @Configuration
    public class DatabaseConfig {

        @Autowired
        private Environment environment;

        @Bean
        public DataSource dataSource() {
            return DataSourceBuilder.create().driverClassName(environment.getProperty("jdbc.driverClassName"))
                    .url(environment.getProperty("jdbc.url")).username(environment.getProperty("jdbc.username"))
                    .password(environment.getProperty("jdbc.password")).build();
        }
    }

Another approach would be to create a class of key/value pairs from the properties file using annotation @ConfigurationProperties.

Notice in the below class we have put prefix value. So prefix value indicates the substring of the key up to the last dot in properties file. For example, we have jdbc.driverClassname as a key in the properties file and key is the jdbc and last part (driverClassname) of the key string will be written as attribute in the Java class. If you had db.jdbc.driverClassName then you would have given the prefix value as prefix="db.jdbc".

    @ConfigurationProperties(prefix = "jdbc")
    public class DbProps {

        private String driverClassName;
        private String url;
        private String username;
        private String password;

        public String getDriverClassName() {
            return driverClassName;
        }

        public void setDriverClassName(String driverClassName) {
            this.driverClassName = driverClassName;
        }

        public String getUrl() {
            return url;
        }

        public void setUrl(String url) {
            this.url = url;
        }

        public String getUsername() {
            return username;
        }

        public void setUsername(String username) {
            this.username = username;
        }

        public String getPassword() {
            return password;
        }

        public void setPassword(String password) {
            this.password = password;
        }
    }

Now you will be able to access the property value using Java attribute in the following way to create Datasource and in this case we don’t need Environment variable.

    @Bean
    public DataSource dataSource() {
            return DataSourceBuilder.create().driverClassName(dbProps().getDriverClassName()).url(dbProps().getUrl())
                    .username(dbProps().getUsername()).password(dbProps().getPassword()).build();
    }

Another way to create Datasource is given below:

    @Bean
    public DataSource dataSource() {
        DriverManagerDataSource dataSource = new DriverManagerDataSource();

        dataSource.setDriverClassName(dbProps().getDriverClassName());
        dataSource.setUrl(dbProps().getUrl());
        dataSource.setUsername(dbProps().getUsername());
        dataSource.setPassword(dbProps().getPassword());

        return dataSource;
    }

If you are using Spring Data JPA and if you are declaring the database settings in application.properties file as follows:

    spring.datasource.driverClassName=com.mysql.cj.spring.datasource.Driver
    spring.datasource.url=jdbc:mysql://localhost:3306/jeejava
    spring.datasource.username=root
    spring.datasource.password=root

Then you don’t need to create any Datasource and Spring Boot framework will automatically create for you.
