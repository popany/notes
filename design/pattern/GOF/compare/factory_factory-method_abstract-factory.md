# Factory vs Factory method vs Abstract Factory

- [Factory vs Factory method vs Abstract Factory](#factory-vs-factory-method-vs-abstract-factory)
  - [Design Patterns: Factory vs Factory method vs Abstract Factory](#design-patterns-factory-vs-factory-method-vs-abstract-factory)
    - [Anders Johansen](#anders-johansen)
      - [Factory](#factory)
      - [Factory Method](#factory-method)
      - [Abstract Factory](#abstract-factory)
    - [Ravindra babu](#ravindra-babu)
      - [How are these three patterns different from each other?](#how-are-these-three-patterns-different-from-each-other)
      - [When to use which?](#when-to-use-which)

## [Design Patterns: Factory vs Factory method vs Abstract Factory](https://stackoverflow.com/questions/13029261/design-patterns-factory-vs-factory-method-vs-abstract-factory)

### Anders Johansen

All three Factory types do the same thing: They are a "smart constructor".

Let's say you want to be able to create two kinds of Fruit: Apple and Orange.

#### Factory

Factory is **"fixed"**, in that you have just one implementation with no subclassing. In this case, you will have a class like this:

    class FruitFactory {

        public Apple makeApple() {
            // Code for creating an Apple here.
        }

        public Orange makeOrange() {
            // Code for creating an orange here.
        }
    }

Use case: Constructing an Apple or an Orange is a bit too complex to handle in the constructor for either.

#### Factory Method

Factory method is generally used when you have **some generic processing** in a class, but want to vary which kind of fruit you actually use. So:

    abstract class FruitPicker {

        protected abstract Fruit makeFruit();

        public void pickFruit() {
            private final Fruit f = makeFruit(); // The fruit we will work on..
            <bla bla bla>
        }
    }

...then you can **reuse the common functionality** in `FruitPicker.pickFruit()` by implementing a factory method in **subclasses**:

    class OrangePicker extends FruitPicker {

        @Override
        protected Fruit makeFruit() {
            return new Orange();
        }
    }

#### Abstract Factory

Abstract factory is normally used for things like dependency injection/strategy, when you want to be able to create **a whole family of objects** that need to be of "the same kind", and have some common base classes. Here's a vaguely fruit-related example. The use case here is that we want to make sure that we don't accidentally use an `OrangePicker` on an `Apple`. As long at we get our `Fruit` and `Picker` from the same factory, they will match.

    interface PlantFactory {

        Plant makePlant();

        Picker makePicker(); 

    }

    public class AppleFactory implements PlantFactory {
        Plant makePlant() {
            return new Apple();
        }

        Picker makePicker() {
            return new ApplePicker();
        }
    }

    public class OrangeFactory implements PlantFactory {
        Plant makePlant() {
            return new Orange();
        }

        Picker makePicker() {
            return new OrangePicker();
        }
    }

### Ravindra babu

#### How are these three patterns different from each other?

- Factory: Creates objects **without exposing the instantiation logic** to the client.

- Factory Method: Define an interface for creating an object, but let the subclasses decide which class to instantiate. The Factory method lets a class **defer instantiation to subclasses**.

- Abstract Factory: Provides an interface for **creating families of related or dependent objects** without specifying their concrete classes.

AbstractFactory pattern uses composition to delegate responsibility of creating object to another class while Factory method design pattern uses inheritance and relies on derived class or sub class to create object

#### When to use which?

- Factory: Client just need a class and does not care about which concrete implementation it is getting.

- Factory Method: Client doesn't know what concrete classes it will be required to create at runtime, but just wants to get a class that will do the job.

- AbstactFactory: When your system has to create multiple families of products or you want to provide a library of products without exposing the implementation details.

Abstract Factory classes are often implemented with Factory Method. Factory Methods are usually called within Template Methods.
