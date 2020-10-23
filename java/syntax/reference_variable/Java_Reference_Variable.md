# [Java Reference Variable](https://www.thejavaprogrammer.com/java-reference-variable/)

- [Java Reference Variable](#java-reference-variable)
  - [What do we mean by Reference Variable?](#what-do-we-mean-by-reference-variable)
  - [Primitive Variable vs Reference Variable](#primitive-variable-vs-reference-variable)
  - [Types of Java Reference Variable](#types-of-java-reference-variable)
    - [Example of Reference Variable Being Created](#example-of-reference-variable-being-created)

## What do we mean by Reference Variable?

A reference variable is used to access the object of a class. Reference variables are created at the program compilation time.

    Employee e;   // e here is a reference variable

## Primitive Variable vs Reference Variable

Having seen about reference variable above, let’s have basic understanding about the types of variables, i.e. **Primitive Variables** and **Reference Variables**. All the variables created using **Primitive data types** (`char`, `int`, `boolean`, `float`, `double`, `short` and `long`) are treated a bit differently by [JVM](https://www.thejavaprogrammer.com/java-virtual-machine-jvm-architecture/) in comparison to the ones which are used to point objects like the famous `String` class, `File` Objects, `Thread` objects and so on. If we talk about in terms of memory allocation, Reference Variables are the objects handles to the class references which are created in the **Heap Memory**.

## Types of Java Reference Variable

Java has 4 types of Reference Variables available:

- Local Variable – Block Specific Or Method Specific Variables
- Static Variable – The class Variables
- Instance Variable – The Non Static Variables
- Method Parameter

### Example of Reference Variable Being Created

In the below example we will take the case of an Employee class which has few primitive variables and we would take the reference of the Employee Class as “emp” and then explain its further working:

    class Employee{
        int empID;
        int empSal;
        String empName;

        // Getters & Setter Member Functions 
        // Constructors 
        // otherMethods();
    }

Now, we can create the reference variable of Employee class as:

    Employee emp;

This reference variable has nothing in it as it points to no physical location of main memory. If that’s complicating, in simple terms this reference object has no space being allocated in the memory and it is “**null**”.

Now if we print out this emp variable, it would result in an error if we don’t initialise the variable, if we set the object to null, it give output as “null”.

Now to make this reference actually work, for that the reference should have been allocated memory space. Below code helps us to achieve that:

    Employee emp = new Employee ();

Let’s understand this piece of code to understand how reference objects works, here **`new`** is Java keyword which is used to **allocate memory** to the `Employee` Object “emp”, this object is allocated memory based on the memory needed. The `Employee()` is the constructor of the `Employee` class which is used to assign any default values needed for the object created of the `Employee` class.

If the case above we reuse the “emp” reference to assign a new value we can do it by, simply calling the constructor with new keyword as under:

    emp = new Employee();

The above code would create a new reference. If you don’t want to allow references to be reassigned that can be done using the **`final` keyword** like below:

    final Employee employeeFinalObject = new Employe();

So, `final` is keyword which we use to define a variable which we don’t want to reassign.

    employeeFinalObject = new Employe(); // This statement would give an error since it is final

Lets take an example program to understand reference varaible in Java.

    public class EmployeeMain {
        public static void main(String[] args) {
            
            Employee emp1, emp2;	  //Declaration of Employee Class Variables
            
            final Employee emp3;      // empp3 is declared as final, emp3 can't be reassigned or refer to different object
    
            emp1 = new Employee("Employee 1", 1);	// assign ref1 with object Reference
    
            int eID = emp1.getEmpId(); //access method getEmpId() of Employee Class through reference variable emp1
            System.out.println("Employee Id = " + eID);
        
            emp2 = new Employee("Employee 2", 2); //assign emp2 with Employee Reference
    
            printText(emp2);      // passing emp2 as method parameter of printText() method
    
            
            emp3 = new Employee("Final Employee 3", 3);// assign emp3 with object Reference
    
            // try to reassign emp3 will cause a compile-time error
            //emp3 = new Employee("Try to reassign", 3);
    
        }
    
        public static void printText(Employee employee) {
            String employeeName = employee.getEmpName();
            System.out.println(employeeName);
        }
    }
    
    public class Employee {
        private int empId;
        private String empName;
    
        Employee(String empName, int empId) {
            this.empName = empName;
            this.empId = empId;
        }
    
        public String getEmpName() {
            return empName;
        }
    
        public int getEmpId() {
            return empId;
        }
    }
