# [Language Guide (proto3)](https://developers.google.com/protocol-buffers/docs/proto3)

- [Language Guide (proto3)](#language-guide-proto3)
  - [Defining A Message Type](#defining-a-message-type)
    - [Specifying Field Types](#specifying-field-types)
    - [Assigning Field Numbers](#assigning-field-numbers)
    - [Specifying Field Rules](#specifying-field-rules)
    - [Adding More Message Types](#adding-more-message-types)
    - [Adding Comments](#adding-comments)
    - [Reserved Fields](#reserved-fields)
    - [What's Generated From Your `.proto`?](#whats-generated-from-your-proto)
  - [Scalar Value Types](#scalar-value-types)
  - [Default Values](#default-values)
  - [Enumerations](#enumerations)
    - [Reserved Values](#reserved-values)
  - [Using Other Message Types](#using-other-message-types)
    - [Importing Definitions](#importing-definitions)
    - [Using proto2 Message Types](#using-proto2-message-types)
  - [Nested Types](#nested-types)

This guide describes how to use the protocol buffer language to structure your protocol buffer data, including `.proto` file syntax and how to generate data access classes from your `.proto` files. It covers the **proto3** version of the protocol buffers language: for information on the **proto2** syntax, see the [Proto2 Language Guide](https://developers.google.com/protocol-buffers/docs/proto).

This is a reference guide – for a step by step example that uses many of the features described in this document, see the [tutorial](https://developers.google.com/protocol-buffers/docs/tutorials) for your chosen language (currently proto2 only; more proto3 documentation is coming soon).

## Defining A Message Type

First let's look at a very simple example. Let's say you want to define a search request message format, where each search request has a query string, the particular page of results you are interested in, and a number of results per page. Here's the `.proto` file you use to define the message type.

    syntax = "proto3";
    
    message SearchRequest {
      string query = 1;
      int32 page_number = 2;
      int32 result_per_page = 3;
    }

- The first line of the file specifies that you're using proto3 syntax: if you don't do this the protocol buffer compiler will assume you are using [proto2](https://developers.google.com/protocol-buffers/docs/proto). This must be the **first non-empty, non-comment line of the file.

- The `SearchRequest` message definition specifies three fields (name/value pairs), one for each piece of data that you want to include in this type of message. Each field has a **name** and a **type**.

### Specifying Field Types

In the above example, all the fields are [scalar types](https://developers.google.com/protocol-buffers/docs/proto3#scalar): two integers (`page_number` and `result_per_page`) and a string (`query`). However, you can also specify composite types for your fields, including [enumerations](https://developers.google.com/protocol-buffers/docs/proto3#enum) and other message types.

### Assigning Field Numbers

As you can see, each field in the message definition has a **unique number**. These field numbers are used to identify your fields in the [message binary format](https://developers.google.com/protocol-buffers/docs/encoding), and should not be changed once your message type is in use. Note that field numbers in the range 1 through 15 take one byte to encode, including the field number and the field's type (you can find out more about this in [Protocol Buffer Encoding](https://developers.google.com/protocol-buffers/docs/encoding#structure)). Field numbers in the range 16 through 2047 take two bytes. So you should reserve the numbers 1 through 15 for very frequently occurring message elements. Remember to leave some room for frequently occurring elements that might be added in the future.

The smallest field number you can specify is 1, and the largest is 229 - 1, or 536,870,911. You also cannot use the numbers 19000 through 19999 (`FieldDescriptor::kFirstReservedNumber` through `FieldDescriptor::kLastReservedNumber`), as they are reserved for the Protocol Buffers implementation - the protocol buffer compiler will complain if you use one of these reserved numbers in your `.proto`. Similarly, you cannot use any previously [reserved](https://developers.google.com/protocol-buffers/docs/proto3#reserved) field numbers.

### Specifying Field Rules

Message fields can be one of the following:

- `singular`: a well-formed message can have zero or one of this field (but not more than one). And this is the default field rule for proto3 syntax.

- `repeated`: this field can be repeated any number of times (including zero) in a well-formed message. The order of the repeated values will be preserved.

In proto3, `repeated` fields of scalar numeric types use `packed` encoding by default.

You can find out more about `packed` encoding in [Protocol Buffer Encoding](https://developers.google.com/protocol-buffers/docs/encoding#packed).

### Adding More Message Types

Multiple message types can be defined in a single `.proto` file. This is useful if you are defining multiple related messages – so, for example, if you wanted to define the reply message format that corresponds to your `SearchResponse` message type, you could add it to the same `.proto`:

    message SearchRequest {
      string query = 1;
      int32 page_number = 2;
      int32 result_per_page = 3;
    }
    
    message SearchResponse {
     ...
    }

### Adding Comments

To add comments to your `.proto` files, use C/C++-style `//` and `/* ... */` syntax.

    /* SearchRequest represents a search query, with pagination options to
     * indicate which results to include in the response. */
    
    message SearchRequest {
      string query = 1;
      int32 page_number = 2;  // Which page number do we want?
      int32 result_per_page = 3;  // Number of results to return per page.
    }

### Reserved Fields

If you [update](https://developers.google.com/protocol-buffers/docs/proto3#updating) a message type by entirely removing a field, or commenting it out, future users can reuse the field number when making their own updates to the type. This can cause severe issues if they later load old versions of the same `.proto`, including data corruption, privacy bugs, and so on. One way to make sure this doesn't happen is to specify that the field numbers (and/or names, which can also cause issues for JSON serialization) of your deleted fields are `reserved`. The protocol buffer compiler will complain if any future users try to use these field identifiers.

    message Foo {
      reserved 2, 15, 9 to 11;
      reserved "foo", "bar";
    }

Note that you can't mix field names and field numbers in the same `reserved` statement.

### What's Generated From Your `.proto`?

When you run the [protocol buffer compiler](https://developers.google.com/protocol-buffers/docs/proto3#generating) on a `.proto`, the compiler generates the code in your chosen language you'll need to work with the message types you've described in the file, including **getting** and **setting** field values, serializing your messages to an **output stream**, and parsing your messages from an **input stream**.

- For `C++`, the compiler generates a `.h` and `.cc` **file from each `.proto`**, with a **class for each message type** described in your file.

- For `Java`, the compiler generates a `.java` file with a class for each message type, as well as a special `Builder` classes for creating message class instances.

- `Python` is a little different – the Python compiler generates a module with a static descriptor of each message type in your `.proto`, which is then used with a metaclass to create the necessary Python data access class at runtime.

- For `Go`, the compiler generates a `.pb.go` file with a type for each message type in your file.

- For `Ruby`, the compiler generates a `.rb` file with a Ruby module containing your message types.

- For `Objective-C`, the compiler generates a `pbobjc.h` and `pbobjc.m` file from each `.proto`, with a class for each message type described in your file.

- For `C#`, the compiler generates a `.cs` file from each `.proto`, with a class for each message type described in your file.

- For `Dart`, the compiler generates a `.pb.dart` file with a class for each message type in your file.

You can find out more about using the APIs for each language by following the tutorial for your chosen language (proto3 versions coming soon). For even more API details, see the relevant [API reference](https://developers.google.com/protocol-buffers/docs/reference/overview) (proto3 versions also coming soon).

## Scalar Value Types

A scalar message field can have one of the following types – the table shows the type specified in the .proto file, and the corresponding type in the automatically generated class:

|.proto Type |Notes |C++ Type |Java Type |Python Type[2] |Go Type |Ruby Type |C# Type |PHP Type |Dart Type|
|-|-|-|-|-|-|-|-|-|-|
double ||double |double |float |float64 |Float |double |float |double
float || float |float |float |float32 |Float |float |float |double
int32 |Uses variable-length encoding. Inefficient for encoding negative numbers – if your field is likely to have negative values, use sint32 instead. |int32 |int |int |int32 |Fixnum or Bignum (as required) |int |integer |int
int64 |Uses variable-length encoding. Inefficient for encoding negative numbers – if your field is likely to have negative values, use sint64 instead. |int64 |long |int/long[3] |int64 |Bignum |long |integer/string[5] |Int64
uint32 |Uses variable-length encoding. |uint32 |int[1] |int/long[3] |uint32 |Fixnum or Bignum (as required) |uint |integer |int
uint64 |Uses variable-length encoding. |uint64 |long[1] |int/long[3] |uint64 |Bignum |ulong |integer/string[5] |Int64
sint32 |Uses variable-length encoding. Signed int value. These more efficiently encode negative numbers than regular int32s. |int32 |int |int |int32 |Fixnum or Bignum (as required) |int |integer |int
sint64 |Uses variable-length encoding. Signed int value. These more efficiently encode negative numbers than regular int64s. |int64 |long |int/long[3] |int64 |Bignum |long |integer/string[5] |Int64
fixed32 |Always four bytes. More efficient than uint32 if values are often greater than 228. |uint32 |int[1] |int/long[3] |uint32 |Fixnum or Bignum (as required) |uint |integer |int
fixed64 |Always eight bytes. More efficient than uint64 if values are often greater than 256. |uint64 |long[1] |int/long[3] |uint64 |Bignum |ulong |integer/string[5] |Int64
sfixed32 |Always four bytes. |int32 |int |int |int32 |Fixnum or Bignum (as required) |int |integer |int
sfixed64 |Always eight bytes. |int64 |long |int/long[3] |int64 |Bignum |long |integer/string[5] |Int64
bool ||bool |boolean |bool |bool |TrueClass/FalseClass |bool |boolean |bool
string |A string must always contain UTF-8 encoded or 7-bit ASCII text, and cannot be longer than 232. |string |String |str/unicode[4] |string |String (UTF-8) |string |string |String
bytes |May contain any arbitrary sequence of bytes no longer than 232. |string |ByteString |str |[]byte |String (ASCII-8BIT) |ByteString |string |List
|

You can find out more about how these types are encoded when you serialize your message in [Protocol Buffer Encoding](https://developers.google.com/protocol-buffers/docs/encoding).

- [1] In Java, unsigned 32-bit and 64-bit integers are represented using their signed counterparts, with the top bit simply being stored in the sign bit.

- [2] In all cases, setting values to a field will perform type checking to make sure it is valid.

- [3] 64-bit or unsigned 32-bit integers are always represented as long when decoded, but can be an int if an int is given when setting the field. In all cases, the value must fit in the type represented when set. See [2].

- [4] Python strings are represented as unicode on decode but can be str if an ASCII string is given (this is subject to change).

- [5] Integer is used on 64-bit machines and string is used on 32-bit machines.

## Default Values

When a message is parsed, if the encoded message does not contain a particular singular element, the corresponding field in the parsed object is set to the default value for that field. These defaults are type-specific:

- For strings, the default value is the empty string.
- For bytes, the default value is empty bytes.
- For bools, the default value is false.
- For numeric types, the default value is zero.
- For [enums](https://developers.google.com/protocol-buffers/docs/proto3#enum), the default value is the first defined enum value, which must be 0.
- For message fields, the field is not set. Its exact value is language-dependent. See the [generated code guide](https://developers.google.com/protocol-buffers/docs/reference/overview) for details.

The default value for repeated fields is empty (generally an empty list in the appropriate language).

Note that for scalar message fields, once a message is parsed there's no way of telling whether a field was explicitly set to the default value (for example whether a boolean was set to `false`) or just not set at all: you should bear this in mind when defining your message types. For example, don't have a boolean that switches on some behaviour when set to `false` if you don't want that behaviour to also happen by default. Also note that if a scalar message field is set to its default, the value will not be serialized on the wire.

See the [generated code guide](https://developers.google.com/protocol-buffers/docs/reference/overview) for your chosen language for more details about how defaults work in generated code.

## Enumerations

When you're defining a message type, you might want one of its fields to only have one of a pre-defined list of values. For example, let's say you want to add a corpus field for each `SearchRequest`, where the corpus can be `UNIVERSAL`, `WEB`, `IMAGES`, `LOCAL`, `NEWS`, `PRODUCTS` or `VIDEO`. You can do this very simply by adding an `enum` to your message definition with a constant for each possible value.

In the following example we've added an `enum` called `Corpus` with all the possible values, and a field of type `Corpus`:

    message SearchRequest {
      string query = 1;
      int32 page_number = 2;
      int32 result_per_page = 3;
      enum Corpus {
        UNIVERSAL = 0;
        WEB = 1;
        IMAGES = 2;
        LOCAL = 3;
        NEWS = 4;
        PRODUCTS = 5;
        VIDEO = 6;
      }
      Corpus corpus = 4;
    }

As you can see, the `Corpus` enum's first constant maps to zero: every enum definition **must** contain a constant that maps to zero as its first element. This is because:

- There must be a zero value, so that we can use 0 as a numeric [default value](https://developers.google.com/protocol-buffers/docs/proto3#default).

- The zero value needs to be the first element, for compatibility with the [proto2](https://developers.google.com/protocol-buffers/docs/proto) semantics where the first enum value is always the default.

You can define aliases by assigning the same value to different enum constants. To do this you need to set the `allow_alias` option to true, otherwise the protocol compiler will generate an error message when aliases are found.

    message MyMessage1 {
      enum EnumAllowingAlias {
        option allow_alias = true;
        UNKNOWN = 0;
        STARTED = 1;
        RUNNING = 1;
      }
    }
    message MyMessage2 {
      enum EnumNotAllowingAlias {
        UNKNOWN = 0;
        STARTED = 1;
        // RUNNING = 1;  // Uncommenting this line will cause a compile error inside Google and a warning message outside.
      }
    }

Enumerator constants must be in the range of a 32-bit integer. Since `enum` values use [varint encoding](https://developers.google.com/protocol-buffers/docs/encoding) on the wire, negative values are inefficient and thus not recommended. You can define `enum`s **within a message definition**, as in the above example, **or outside** – these enums can be reused in any message definition in your `.proto` file. You can also use an `enum` type declared in one message as the type of a field in a different message, using the syntax `_MessageType_._EnumType_`.

When you run the protocol buffer compiler on a `.proto` that uses an `enum`, the generated code will have a corresponding `enum` for Java or C++, a special `EnumDescriptor` class for Python that's used to create a set of symbolic constants with integer values in the runtime-generated class.

**Caution:** the generated code may be subject to language-specific limitations on the number of enumerators (low thousands for one language). Please review the limitations for the languages you plan to use.

During deserialization, unrecognized enum values will be preserved in the message, though how this is represented when the message is deserialized is language-dependent. In languages that support open enum types with values outside the range of specified symbols, such as C++ and Go, the unknown enum value is simply stored as its underlying integer representation. In languages with closed enum types such as Java, a case in the enum is used to represent an unrecognized value, and the underlying integer can be accessed with special accessors. In either case, if the message is serialized the unrecognized value will still be serialized with the message.

For more information about how to work with message `enum`s in your applications, see the [generated code guide](https://developers.google.com/protocol-buffers/docs/reference/overview) for your chosen language.

### Reserved Values

If you [update](https://developers.google.com/protocol-buffers/docs/proto3#updating) an enum type by entirely removing an enum entry, or commenting it out, future users can reuse the numeric value when making their own updates to the type. This can cause severe issues if they later load old versions of the same `.proto`, including data corruption, privacy bugs, and so on. One way to make sure this doesn't happen is to specify that the numeric values (and/or names, which can also cause issues for JSON serialization) of your deleted entries are `reserved`. The protocol buffer compiler will complain if any future users try to use these identifiers. You can specify that your reserved numeric value range goes up to the maximum possible value using the `max` keyword.

    enum Foo {
      reserved 2, 15, 9 to 11, 40 to max;
      reserved "FOO", "BAR";
    }

Note that you can't mix field names and numeric values in the same `reserved` statement.

## Using Other Message Types

You can use other message types as field types. For example, let's say you wanted to include `Result` messages in each `SearchResponse` message – to do this, you can define a `Result` message type in the same `.proto` and then specify a field of type `Result` in `SearchResponse`:

    message SearchResponse {
      repeated Result results = 1;
    }
    
    message Result {
      string url = 1;
      string title = 2;
      repeated string snippets = 3;
    }

### Importing Definitions

Note that this feature is **not available in Java**.

In the above example, the `Result` message type is defined in the same file as `SearchResponse` – what if the message type you want to use as a field type is already defined in another `.proto` file?

You can use definitions from other `.proto` files by importing them. To import another `.proto`'s definitions, you add an import statement to the top of your file:

    import "myproject/other_protos.proto";

By default you can only use definitions from directly imported `.proto` files. However, sometimes you may need to move a `.proto` file to a new location. Instead of moving the .proto file directly and updating all the call sites in a single change, now you can put a dummy `.proto` file in the old location to forward all the imports to the new location using the `import public` notion. `import public` dependencies can be **transitively relied upon** by anyone importing the proto containing the `import public` statement. For example:

    // new.proto
    // All definitions are moved here

    // old.proto
    // This is the proto that all clients are importing.
    import public "new.proto";
    import "other.proto";

    // client.proto
    import "old.proto";
    // You use definitions from old.proto and new.proto, but not other.proto

The protocol compiler searches for imported files in a set of directories specified on the protocol compiler command line using the `-I/--proto_path` flag. If no flag was given, it looks in the directory in which the compiler was invoked. In general you should set the `--proto_path` flag to the root of your project and use fully qualified names for all imports.

### Using proto2 Message Types

It's possible to import [proto2](https://developers.google.com/protocol-buffers/docs/proto) message types and use them in your proto3 messages, and vice versa. However, proto2 enums cannot be used directly in proto3 syntax (it's okay if an imported proto2 message uses them).

## Nested Types










