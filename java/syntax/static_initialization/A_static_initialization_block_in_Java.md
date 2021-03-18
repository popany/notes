# [A static initialization block in Java](https://www.tutorialspoint.com/a-static-initialization-block-in-java)

- [A static initialization block in Java](#a-static-initialization-block-in-java)

Instance variables are initialized using initialization blocks. However, the static initialization blocks **can only initialize the static instance variables**. These blocks are only **executed once** when the class is loaded. There **can be multiple static initialization blocks** in a class that is called in the **order they appear** in the program.

A program that demonstrates a static initialization block in Java is given as follows:

Example

    public class Demo {
       static int[] numArray = new int[10];
       static {
          System.out.println("Running static initialization block.");
          for (int i = 0; i < numArray.length; i++) {
             numArray[i] = (int) (100.0 * Math.random());
          }
       }
       void printArray() {
          System.out.println("The initialized values are:");
          for (int i = 0; i < numArray.length; i++) {
             System.out.print(numArray[i] + " ");
          }
          System.out.println();
       }
       public static void main(String[] args) {
          Demo obj1 = new Demo();
          System.out.println("For obj1:");
          obj1.printArray();
          Demo obj2 = new Demo();
          System.out.println("\nFor obj2:");
          obj2.printArray();
       }
    }

Output

    Running static initialization block.
    For obj1:
    The initialized values are:
    40 75 88 51 44 50 34 79 22 21

    For obj2:
    The initialized values are:
    40 75 88 51 44 50 34 79 22 21
