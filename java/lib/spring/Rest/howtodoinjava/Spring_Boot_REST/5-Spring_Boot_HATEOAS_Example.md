# [Spring Boot HATEOAS Example](https://howtodoinjava.com/spring-boot/rest-with-spring-hateoas-example/)

- [Spring Boot HATEOAS Example](#spring-boot-hateoas-example)
  - [Project Structure](#project-structure)
  - [Create REST APIs](#create-rest-apis)
    - [REST Resource Model](#rest-resource-model)
    - [REST Controller](#rest-controller)
    - [DAO layer](#dao-layer)
    - [Launch Class](#launch-class)
    - [Maven – pom.xml](#maven--pomxml)
    - [API Outputs](#api-outputs)
  - [Add HATEOAS Links to REST resources](#add-hateoas-links-to-rest-resources)
    - [Step 1) Extend resource models with ResourceSupport class](#step-1-extend-resource-models-with-resourcesupport-class)
    - [Step 2) Build and add links in REST controller](#step-2-build-and-add-links-in-rest-controller)
      - [Adding links to collection resource](#adding-links-to-collection-resource)
      - [Adding links to singular resource](#adding-links-to-singular-resource)
  - [Summary](#summary)

In this Spring HATEOAS example, we will learn to add [HATEOAS](https://restfulapi.net/hateoas/) links to existing REST APIs created in a spring boot project. We will use the class `ResourceSupport` along with `ControllerLinkBuilder` and `org.springframework.hateoas.Link` classes provided by spring HATEOAS module.

To demo the creation of links, we will first create few REST APIs and see their output. Then we will apply the HATEOAS links to REST resources and then we will compare the output with and without links.

## Project Structure

..

## Create REST APIs

In this example, I have created three REST APIs with endpoints as below:

1. /employees
2. /employees/{id}
3. /employees/{id}/report

### REST Resource Model

EmployeeListVO - Employee collection resource

    @XmlRootElement (name="employees")
    public class EmployeeListVO implements Serializable
    {
        private static final long serialVersionUID = 1L;
          
        private List<EmployeeVO> employees = new ArrayList<EmployeeVO>();
      
        public List<EmployeeVO> getEmployees() {
            return employees;
        }
      
        public void setEmployees(List<EmployeeVO> employees) {
            this.employees = employees;
        }
    }

EmployeeListVO - Single employee resource

    @XmlRootElement(name = "employee")
    @XmlAccessorType(XmlAccessType.NONE)
    public class EmployeeVO implements Serializable
    {
        private static final long serialVersionUID = 1L;
         
        public EmployeeVO(Integer id, String firstName, String lastName, String email) {
            super();
            this.employeeId = id;
            this.firstName = firstName;
            this.lastName = lastName;
            this.email = email;
        }
     
        public EmployeeVO() {
     
        }
     
        @XmlAttribute
        private Integer employeeId;
     
        @XmlElement
        private String firstName;
     
        @XmlElement
        private String lastName;
     
        @XmlElement
        private String email;
     
        //removed getters and setters for readability
     
        @Override
        public String toString() {
            return "EmployeeVO [id=" + employeeId + ", firstName=" + firstName + ", lastName=" + lastName + ", email=" + email
                    + "]";
        }
    }

EmployeeReport - Employee report resource

    @XmlRootElement(name="employee-report")
    public class EmployeeReport implements Serializable {
    
        private static final long serialVersionUID = 1L;
    
        //You can add field as needed
    }

### REST Controller

EmployeeRESTController

    @RestController
    public class EmployeeRESTController {
         
        @RequestMapping(value = "/employees")
        public EmployeeListVO getAllEmployees()
        {
            EmployeeListVO employeesList  = new EmployeeListVO();
     
            for (EmployeeVO employee : EmployeeDB.getEmployeeList()) 
            {
                employeesList.getEmployees().add(employee);
            }
     
            return employeesList;
        }
          
        @RequestMapping(value = "/employees/{id}")
        public ResponseEntity<EmployeeVO> getEmployeeById (@PathVariable("id") int id)
        {
            if (id <= 3) {
                EmployeeVO employee = EmployeeDB.getEmployeeList().get(id-1);
                return new ResponseEntity<EmployeeVO>(employee, HttpStatus.OK);
            }
            return new ResponseEntity<EmployeeVO>(HttpStatus.NOT_FOUND);
        }
         
        @RequestMapping(value = "/employees/{id}/report")
        public ResponseEntity<EmployeeReport> getReportByEmployeeById (@PathVariable("id") int id)
        {
            //Do some operation and return report
            return null;
        }
    }

### DAO layer

I have created `EmployeeDB` class to simulate the DAO layer. In real application, it will be more complex code to fetch data from data source.

EmployeeDB

    public class EmployeeDB {
     
        public static List<EmployeeVO> getEmployeeList() 
        {
            List<EmployeeVO> list = new ArrayList<>();
     
            EmployeeVO empOne = new EmployeeVO(1, "Lokesh", "Gupta", "howtodoinjava@gmail.com");
            EmployeeVO empTwo = new EmployeeVO(2, "Amit", "Singhal", "asinghal@yahoo.com");
            EmployeeVO empThree = new EmployeeVO(3, "Kirti", "Mishra", "kmishra@gmail.com");
     
            list.add(empOne);
            list.add(empTwo);
            list.add(empThree);
     
            return list;
        }
    }

### Launch Class

    @SpringBootApplication
    public class Application 
    {
        public static void main(String[] args) 
        {
            ApplicationContext ctx = SpringApplication.run(Application.class, args);
        }
    }

### Maven – pom.xml

Let’s look at pom.xml file used for this project.

    <project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd;
        <modelVersion>4.0.0</modelVersion>
     
        <groupId>com.howtodoinjava</groupId>
        <artifactId>springbootdemo</artifactId>
        <version>0.0.1-SNAPSHOT</version>
        <packaging>jar</packaging>
     
        <name>springbootdemo</name>
        <url>http://maven.apache.org</url>
     
        <parent>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-parent</artifactId>
            <version>2.0.0.RELEASE</version>
        </parent>
     
        <properties>
            <java.version>1.8</java.version>
            <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
        </properties>
     
        <dependencies>
            <dependency>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-starter-web</artifactId>
            </dependency>
            <dependency>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-starter-hateoas</artifactId>
            </dependency>
        </dependencies>
     
        <build>
            <plugins>
                <plugin>
                    <groupId>org.springframework.boot</groupId>
                    <artifactId>spring-boot-maven-plugin</artifactId>
                </plugin>
            </plugins>
        </build>
     
        <repositories>
            <repository>
                <id>repository.spring.release</id>
                <name>Spring GA Repository</name>
                <url>http://repo.spring.io/release</url>
            </repository>
        </repositories>
    </project>

### API Outputs

/employees

    {
        "employees": [
            {
                "employeeId": 1,
                "firstName": "Lokesh",
                "lastName": "Gupta",
                "email": "howtodoinjava@gmail.com"
            },
            {
                "employeeId": 2,
                "firstName": "Amit",
                "lastName": "Singhal",
                "email": "asinghal@yahoo.com"
            },
            {
                "employeeId": 3,
                "firstName": "Kirti",
                "lastName": "Mishra",
                "email": "kmishra@gmail.com"
            }
        ]
    }

/employees/{id}

    {
        "employeeId": 1,
        "firstName": "Lokesh",
        "lastName": "Gupta",
        "email": "howtodoinjava@gmail.com"
    }

## Add HATEOAS Links to REST resources

### Step 1) Extend resource models with ResourceSupport class

Extend all model classes where you want to add HATEOAS links – with `org.springframework.hateoas.ResourceSupport` class.

    @XmlRootElement(name = "employee")
    @XmlAccessorType(XmlAccessType.NONE)
    public class EmployeeVO extends ResourceSupport implements Serializable
    {
        //rest all code is same
    }
     
    //...
     
    @XmlRootElement (name="employees")
    public class EmployeeListVO extends ResourceSupport implements Serializable
    {
        //rest all code is same
    }
     
    //...
     
    @XmlRootElement(name="employee-report")
    public class EmployeeReport extends ResourceSupport implements Serializable {
     
        //rest all code is same
    }

### Step 2) Build and add links in REST controller

To add links, you will need `ControllerLinkBuilder` and `Link` classes. `Link` is the final representation of link to be added in REST resource. Whereas `ControllerLinkBuilder` helps in building the links using it’s various method based on [builder pattern](https://howtodoinjava.com/design-patterns/creational/builder-pattern-in-java/).

#### Adding links to collection resource

Here we will add two type of links. In first link, the collection resource will point to itself. In second type of links, each resource inside collection will point to it’s URI location where complete representation is available. Also, each resource will have method links which can be followed to perform some operations on individual resource.

    @RequestMapping(value = "/employees")
    public EmployeeListVO getAllEmployees()
    {
        EmployeeListVO employeesList  = new EmployeeListVO();
     
        for (EmployeeVO employee : EmployeeDB.getEmployeeList()) 
        {
            //Adding self link employee 'singular' resource
            Link link = ControllerLinkBuilder
                    .linkTo(EmployeeRESTController.class)
                    .slash(employee.getEmployeeId())
                    .withSelfRel();
     
            //Add link to singular resource
            employee.add(link);
             
          //Adding method link employee 'singular' resource
            ResponseEntity<EmployeeReport> methodLinkBuilder = ControllerLinkBuilder
                    .methodOn(EmployeeRESTController.class).getReportByEmployeeById(employee.getEmployeeId());
            Link reportLink = ControllerLinkBuilder
                    .linkTo(methodLinkBuilder)
                    .withRel("employee-report");
     
            //Add link to singular resource
            employee.add(reportLink);
       
            employeesList.getEmployees().add(employee);
        }
         
        //Adding self link employee collection resource
        Link selfLink = ControllerLinkBuilder
                .linkTo(ControllerLinkBuilder
                .methodOn(EmployeeRESTController.class).getAllEmployees())
                .withSelfRel();
     
        //Add link to collection resource
        employeesList.add(selfLink);
          
        return employeesList;
    }

Output:

    {
        "employees": [
            {
                "employeeId": 1,
                "firstName": "Lokesh",
                "lastName": "Gupta",
                "email": "howtodoinjava@gmail.com",
                "_links": {
                    "self": {
                        "href": "http://localhost:8080/1"
                    },
                    "employee-report": {
                        "href": "http://localhost:8080/employees/1/report"
                    }
                }
            },
            {
                "employeeId": 2,
                "firstName": "Amit",
                "lastName": "Singhal",
                "email": "asinghal@yahoo.com",
                "_links": {
                    "self": {
                        "href": "http://localhost:8080/2"
                    },
                    "employee-report": {
                        "href": "http://localhost:8080/employees/2/report"
                    }
                }
            },
            {
                "employeeId": 3,
                "firstName": "Kirti",
                "lastName": "Mishra",
                "email": "kmishra@gmail.com",
                "_links": {
                    "self": {
                        "href": "http://localhost:8080/3"
                    },
                    "employee-report": {
                        "href": "http://localhost:8080/employees/3/report"
                    }
                }
            }
        ],
        "_links": {
            "self": {
                "href": "http://localhost:8080/employees"
            }
        }
    }

#### Adding links to singular resource

Adding links to singular resource is exactly same as what we saw in earlier section. Singular resource representations typically have more information/fields plus additional links.

    @RequestMapping(value = "/employees/{id}")
    public ResponseEntity<EmployeeVO> getEmployeeById (@PathVariable("id") int id)
    {
        if (id <= 3) {
            EmployeeVO employee = EmployeeDB.getEmployeeList().get(id-1);
             
            //Self link
            Link selfLink = ControllerLinkBuilder
                    .linkTo(EmployeeRESTController.class)
                    .slash(employee.getEmployeeId())
                    .withSelfRel();
             
            //Method link
            Link reportLink = ControllerLinkBuilder
                    .linkTo(ControllerLinkBuilder.methodOn(EmployeeRESTController.class)
                    .getReportByEmployeeById(employee.getEmployeeId()))
                    .withRel("report");
             
            employee.add(selfLink);
            employee.add(reportLink);
            return new ResponseEntity<EmployeeVO>(employee, HttpStatus.OK);
        }
        return new ResponseEntity<EmployeeVO>(HttpStatus.NOT_FOUND);
    }

Output:

    {
        "employeeId": 1,
        "firstName": "Lokesh",
        "lastName": "Gupta",
        "email": "howtodoinjava@gmail.com",
        "_links": {
            "self": {
                "href": "http://localhost:8080/1"
            },
            "report": {
                "href": "http://localhost:8080/employees/1/report"
            }
        }
    }

## Summary

As you saw the demo above that adding HATEOAS links using spring hateoas module is very much easy and one time effort. It will greatly increase the discoverability and usefulness of APIs by many folds.
