# pybind11

- [pybind11](#pybind11)
  - [First steps](#first-steps)
    - [Compiling the test cases](#compiling-the-test-cases)
      - [Linux/macOS](#linuxmacos)
    - [Header and namespace conventions](#header-and-namespace-conventions)
    - [Creating bindings for a simple function](#creating-bindings-for-a-simple-function)
    - [Keyword arguments](#keyword-arguments)
    - [Default arguments](#default-arguments)
    - [Exporting variables](#exporting-variables)
    - [Supported data types](#supported-data-types)
  - [Object-oriented code](#object-oriented-code)
    - [Creating bindings for a custom type](#creating-bindings-for-a-custom-type)
    - [Binding lambda functions](#binding-lambda-functions)
    - [Instance and static fields](#instance-and-static-fields)
    - [Dynamic attributes](#dynamic-attributes)
    - [Inheritance and automatic downcasting](#inheritance-and-automatic-downcasting)

pybind11 is a lightweight header-only library that exposes C++ types in Python and vice versa, mainly to create Python bindings of existing C++ code.

## [First steps](https://pybind11.readthedocs.io/en/stable/basics.html)

### Compiling the test cases

#### Linux/macOS

On Linux you’ll need to install the python-dev or python3-dev packages as well as cmake.

### Header and namespace conventions

For brevity, all code examples assume that the following two lines are present:

    #include <pybind11/pybind11.h>

    namespace py = pybind11;

Some features may require additional headers, but those will be specified as needed.

### Creating bindings for a simple function

    #include <pybind11/pybind11.h>

    int add(int i, int j) {
        return i + j;
    }

    PYBIND11_MODULE(example, m) {
        m.doc() = "pybind11 example plugin"; // optional module docstring

        m.def("add", &add, "A function that adds two numbers");
    }

Assuming that the compiled module is located in the current directory, the following interactive Python session shows how to load and execute the example:

    $ python
    Python 3.9.10 (main, Jan 15 2022, 11:48:04)
    [Clang 13.0.0 (clang-1300.0.29.3)] on darwin
    Type "help", "copyright", "credits" or "license" for more information.
    import example
    example.add(1, 2)
    3
    >>>

### Keyword arguments

With a simple code modification, it is possible to inform Python about the names of the arguments ("i" and "j" in this case).

    m.def("add", &add, "A function which adds two numbers",
          py::arg("i"), py::arg("j"));

### Default arguments

Suppose now that the function to be bound has default arguments, e.g.:

    int add(int i = 1, int j = 2) {
        return i + j;
    }

Unfortunately, pybind11 cannot automatically extract these parameters, since they are not part of the function’s type information. However, they are simple to specify using an extension of arg:

    m.def("add", &add, "A function which adds two numbers",
          py::arg("i") = 1, py::arg("j") = 2);

### Exporting variables

To expose a value from C++, use the attr function to register it in a module as shown below. Built-in types and general objects (more on that later) are **automatically converted** when assigned as attributes, and can be **explicitly converted** using the function `py::cast`.

    PYBIND11_MODULE(example, m) {
        m.attr("the_answer") = 42;
        py::object world = py::cast("World");
        m.attr("what") = world;
    }

These are then accessible from Python:

    >>> import example
    >>> example.the_answer
    42
    >>> example.what
    'World'

### Supported data types

A large number of data types are supported out of the box and can be used seamlessly as functions arguments, return values or with `py::cast` in general. For a full overview, see the [Type conversions](https://pybind11.readthedocs.io/en/stable/advanced/cast/index.html) section.

## Object-oriented code

### Creating bindings for a custom type

Let's now look at a more complex example where we'll create bindings for a custom C++ data structure named `Pet`. Its definition is given below:

    struct Pet {
        Pet(const std::string &name) : name(name) { }
        void setName(const std::string &name_) { name = name_; }
        const std::string &getName() const { return name; }

        std::string name;
    };

The binding code for Pet looks as follows:

    #include <pybind11/pybind11.h>

    namespace py = pybind11;

    PYBIND11_MODULE(example, m) {
        py::class_<Pet>(m, "Pet")
            .def(py::init<const std::string &>())
            .def("setName", &Pet::setName)
            .def("getName", &Pet::getName);
    }

### Binding lambda functions

Note how print(p) produced a rather useless summary of our data structure in the example above:

    >>> print(p)
    <example.Pet object at 0x10cd98060>

To address this, we could bind a utility function that returns a human-readable summary to the special method slot named `__repr__`. Unfortunately, there is no suitable functionality in the `Pet` data structure, and it would be nice if we did not have to change it. This can easily be accomplished by binding a Lambda function instead:

    py::class_<Pet>(m, "Pet")
        .def(py::init<const std::string &>())
        .def("setName", &Pet::setName)
        .def("getName", &Pet::getName)
        .def("__repr__",
            [](const Pet &a) {
                return "<example.Pet named '" + a.name + "'>";
            }
        );

### Instance and static fields

We can also directly expose the `name` field using the `class_::def_readwrite()` method. A similar `class_::def_readonly()` method also exists for `const` fields.

    py::class_<Pet>(m, "Pet")
        .def(py::init<const std::string &>())
        .def_readwrite("name", &Pet::name)
        // ... remainder ...

This makes it possible to write

    >>> p = example.Pet("Molly")
    >>> p.name
    'Molly'
    >>> p.name = "Charly"
    >>> p.name
    'Charly'

Now suppose that `Pet::name` was a private internal variable that can only be accessed via setters and getters.

    class Pet {
    public:
        Pet(const std::string &name) : name(name) { }
        void setName(const std::string &name_) { name = name_; }
        const std::string &getName() const { return name; }
    private:
        std::string name;
    };

In this case, the method `class_::def_property()` (`class_::def_property_readonly()` for read-only data) can be used to provide a field-like interface within Python that will transparently call the setter and getter functions:

    py::class_<Pet>(m, "Pet")
        .def(py::init<const std::string &>())
        .def_property("name", &Pet::getName, &Pet::setName)
        // ... remainder ...

Write only properties can be defined by passing `nullptr` as the input for the read function.

### Dynamic attributes

Native Python classes can pick up new attributes dynamically:

    class Pet:
        name = "Molly"

    p = Pet()
    p.name = "Charly"  # overwrite existing
    p.age = 2  # dynamically add a new attribute

By default, classes exported from C++ do not support this and the only writable attributes are the ones explicitly defined using `class_::def_readwrite()` or `class_::def_property()`.

    py::class_<Pet>(m, "Pet")
        .def(py::init<>())
        .def_readwrite("name", &Pet::name);

Trying to set any other attribute results in an error:

    >>> p = example.Pet()
    >>> p.name = "Charly"  # OK, attribute defined in C++
    >>> p.age = 2  # fail
    AttributeError: 'Pet' object has no attribute 'age'

To enable dynamic attributes for C++ classes, the `py::dynamic_attr` tag must be added to the `py::class_ constructor`:

    py::class_<Pet>(m, "Pet", py::dynamic_attr())
        .def(py::init<>())
        .def_readwrite("name", &Pet::name);

Now everything works as expected:

    >>> p = example.Pet()
    >>> p.name = "Charly"  # OK, overwrite value in C++
    >>> p.age = 2  # OK, dynamically add a new attribute
    >>> p.__dict__  # just like a native Python class
    {'age': 2}

### Inheritance and automatic downcasting

Suppose now that the example consists of two data structures with an inheritance relationship:

    struct Pet {
        Pet(const std::string &name) : name(name) { }
        std::string name;
    };

    struct Dog : Pet {
        Dog(const std::string &name) : Pet(name) { }
        std::string bark() const { return "woof!"; }
    };









