# [Lvalue Reference Declarator: &](https://docs.microsoft.com/en-us/cpp/cpp/lvalue-reference-declarator-amp?view=msvc-170)

Holds the address of an object but behaves syntactically like an object.

## Syntax

    type-id & cast-expression

## Remarks

You can think of an lvalue reference as **another name for an object**. An lvalue reference declaration consists of an **optional list of specifiers** followed by a reference declarator. A reference must be initialized and **cannot be changed**.

Any object whose address can be converted to a given pointer type can also be converted to the similar reference type. For example, any object whose address can be converted to type `char *` can also be converted to type `char &`.

Do not confuse reference declarations with use of the [address-of operator](https://docs.microsoft.com/en-us/cpp/cpp/address-of-operator-amp?view=msvc-170). When the `&` identifier is preceded by a type, such as `int` or `char`, identifier is declared as a reference to the type. When `&` identifier is not preceded by a type, the usage is that of the address-of operator.

## Example

The following example demonstrates the reference declarator by declaring a `Person` object and a reference to that object. Because `rFriend` is a reference to `myFriend`, updating either variable changes the same object.

    // reference_declarator.cpp
    // compile with: /EHsc
    // Demonstrates the reference declarator.
    #include <iostream>
    using namespace std;

    struct Person
    {
        char* Name;
        short Age;
    };

    int main()
    {
        // Declare a Person object.
        Person myFriend;

        // Declare a reference to the Person object.
        Person& rFriend = myFriend;

        // Set the fields of the Person object.
        // Updating either variable changes the same object.
        myFriend.Name = "Bill";
        rFriend.Age = 40;

        // Print the fields of the Person object to the console.
        cout << rFriend.Name << " is " << myFriend.Age << endl;
    }

Output

    Bill is 40
