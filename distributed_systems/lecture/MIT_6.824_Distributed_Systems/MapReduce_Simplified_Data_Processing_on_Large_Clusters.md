# [MapReduce: Simplified Data Processing on Large Clusters](http://nil.csail.mit.edu/6.824/2020/papers/mapreduce.pdf)

- [MapReduce: Simplified Data Processing on Large Clusters](#mapreduce-simplified-data-processing-on-large-clusters)
  - [Abstract](#abstract)
  - [1 Introduction](#1-introduction)
  - [2 Programming Model](#2-programming-model)
    - [2.1 Example](#21-example)
    - [2.2 Types](#22-types)
    - [2.3 More Examples](#23-more-examples)
  - [3 Implementation](#3-implementation)
    - [3.1 Execution Overview](#31-execution-overview)
    - [3.2 Master Data Structures](#32-master-data-structures)
    - [3.3 Fault Tolerance](#33-fault-tolerance)
  - [TODO map reduce xxxxxxxxxxxxxxxxxxxxxxxxxx](#todo-map-reduce-xxxxxxxxxxxxxxxxxxxxxxxxxx)

## Abstract

MapReduce is a programming model and an associated implementation for processing and generating large data sets. Users specify a `map` function that processes a key/value pair to generate a set of intermediate key/value pairs, and a `reduce` function that merges all intermediate values associated with the same intermediate key. Many real world tasks are expressible in this model, as shown in the paper.

## 1 Introduction

Our abstraction is inspired by the map and reduce primitives present in Lisp and many other functional languages.

Our use of a functional model with userspecified map and reduce operations allows us to parallelize large computations easily and to use re-execution as the primary mechanism for fault tolerance

## 2 Programming Model

The computation takes a set of `input` key/value pairs, and produces a set of `output` key/value pairs. The user of the MapReduce library expresses the computation as two functions: `Map` and `Reduce`.

`Map`, written by the user, takes an input pair and produces a set of `intermediate` key/value pairs. The MapReduce library groups together all intermediate values associated with the same intermediate key `I` and passes them to the `Reduce` function.

The `Reduce` function, also written by the user, accepts an intermediate key `I` and a set of values for that key. It merges together these values to form a possibly smaller set of values. Typically just zero or one output value is produced per `Reduce` invocation. The intermediate values are supplied to the user’s reduce function via an iterator. This allows us to handle lists of values that are too large to fit in memory.

### 2.1 Example

Consider the problem of counting the number of occurrences of each word in a large collection of documents.

Appendix A contains the full program text for this example:

    #include "mapreduce/mapreduce.h"
    // User’s map function
    class WordCounter : public Mapper {
    public:
        virtual void Map(const MapInput& input) {
        const string& text = input.value();
        const int n = text.size();
        for (int i = 0; i < n; ) {
        // Skip past leading whitespace
        while ((i < n) && isspace(text[i]))
        i++;
        // Find word end
        int start = i;
        while ((i < n) && !isspace(text[i]))
        i++;
    
        if (start < i)
        Emit(text.substr(start,i-start),"1");
        }
        }
    };
    REGISTER_MAPPER(WordCounter);
    // User’s reduce function
    class Adder : public Reducer {
        virtual void Reduce(ReduceInput* input) {
        // Iterate over all entries with the
        // same key and add the values
        int64 value = 0;
        while (!input->done()) {
        value += StringToInt(input->value());
        input->NextValue();
        }
        // Emit sum for input->key()
        Emit(IntToString(value));
        }
    };
    REGISTER_REDUCER(Adder);
    int main(int argc, char** argv) {
        ParseCommandLineFlags(argc, argv);
        MapReduceSpecification spec;
        // Store list of input files into "spec"
        for (int i = 1; i < argc; i++) {
        MapReduceInput* input = spec.add_input();
        input->set_format("text");
        input->set_filepattern(argv[i]);
        input->set_mapper_class("WordCounter");
        }
        // Specify the output files:
        // /gfs/test/freq-00000-of-00100
        // /gfs/test/freq-00001-of-00100
        // ...
        MapReduceOutput* out = spec.output();
        out->set_filebase("/gfs/test/freq");
        out->set_num_tasks(100);
        out->set_format("text");
        out->set_reducer_class("Adder");
        // Optional: do partial sums within map
        // tasks to save network bandwidth
        out->set_combiner_class("Adder");
        // Tuning parameters: use at most 2000
        // machines and 100 MB of memory per task
        spec.set_machines(2000);
        spec.set_map_megabytes(100);
        spec.set_reduce_megabytes(100);
        // Now run it
        MapReduceResult result;
        if (!MapReduce(spec, &result)) abort();
        // Done: ’result’ structure contains info
        // about counters, time taken, number of
        // machines used, etc.
        return 0;
    }

### 2.2 Types

Even though the previous pseudo-code is written in terms of string inputs and outputs, conceptually the map and reduce functions supplied by the user have associated types:

    map (k1,v1) → list(k2,v2)
    reduce (k2,list(v2)) → list(v2)

I.e., the input keys and values are drawn from a different domain than the output keys and values. Furthermore, the intermediate keys and values are from the same domain as the output keys and values.

Our C++ implementation passes strings to and from the user-defined functions and leaves it to the user code to convert between strings and appropriate types.

### 2.3 More Examples

**Distributed Grep**: The map function emits a line if it matches a supplied pattern. The reduce function is an identity function that just copies the supplied intermediate data to the output.

**Count of URL Access Frequency**: The map function processes logs of web page requests and outputs `<URL, 1>`. The reduce function adds together all values for the same URL and emits a `<URL, total count>` pair.

**Reverse Web-Link Graph**: The map function outputs `<target, source>` pairs for each link to a `target` URL found in a page named `source`. The reduce function concatenates the list of all source URLs associated with a given target URL and emits the pair: `<target, list(source)>`

**Term-Vector per Host**: A term vector summarizes the most important words that occur in a document or a set of documents as a list of `<word, frequency>` pairs. The map function emits a `<hostname, term vector>` pair for each input document (where the hostname is extracted from the URL of the document). The reduce function is passed all per-document term vectors for a given host. It adds these term vectors together, throwing away infrequent terms, and then emits a final `<hostname, term vector>` pair.

**Inverted Index**: The map function parses each document, and emits a sequence of `<word, document ID>` pairs. The reduce function accepts all pairs for a given word, sorts the corresponding document IDs and emits a `<word, list(document ID)>` pair. The set of all output pairs forms a simple inverted index. It is easy to augment this computation to keep track of word positions.

**Distributed Sort**: The map function extracts the key from each record, and emits a `<key, record>` pair. The reduce function emits all pairs unchanged. This computation depends on the partitioning facilities described in Section 4.1 and the ordering properties described in Section 4.2.

## 3 Implementation

Many different implementations of the MapReduce interface are possible. The right choice depends on the environment. For example, one implementation may be suitable for a small shared-memory machine, another for a large NUMA multi-processor, and yet another for an even larger collection of networked machines.

### 3.1 Execution Overview

The `Map` invocations are distributed across multiple machines by automatically partitioning the input data into a set of `M splits`. The input splits can be processed in parallel by different machines. `Reduce` invocations are distributed by partitioning the intermediate key
space into `R` pieces using a partitioning function (e.g., `hash(key) mod R`). The number of partitions (`R`) and the partitioning function are specified by the user.

Figure 1 shows the overall flow of a MapReduce operation in our implementation. When the user program calls the `MapReduce` function, the following sequence of actions occurs (the numbered labels in Figure 1 correspond to the numbers in the list below):

1. The MapReduce library in the user program first
splits the input files into `M` pieces of typically 16 megabytes to 64 megabytes (MB) per piece (controllable by the user via an optional parameter). It then starts up many copies of the program on a cluster of machines.

2. One of the copies of the program is special – the master. The rest are workers that are assigned work by the master. There are `M` map tasks and `R` reduce tasks to assign. The master picks idle workers and assigns each one a map task or a reduce task.

3. A worker who is assigned a map task reads the
contents of the corresponding input split. It parses key/value pairs out of the input data and passes each pair to the user-defined `Map` function. The intermediate key/value pairs produced by the `Map` function are buffered in memory.

4. Periodically, the buffered pairs are written to local disk, partitioned into `R` regions by the partitioning function. The locations of these buffered pairs on the local disk are passed back to the master, who is responsible for forwarding these locations to the reduce workers.

5. When a reduce worker is notified by the master
about these locations, it uses remote procedure calls to read the buffered data from the local disks of the map workers. When a reduce worker has **read all** intermediate data, it sorts it by the intermediate keys so that all occurrences of the same key are grouped together. The sorting is needed because typically many different keys map to the same reduce task. If the amount of intermediate data is too large to fit in memory, an external sort is used.

6. The reduce worker iterates over the sorted intermediate data and for each unique intermediate key encountered, it passes the key and the corresponding set of intermediate values to the user's `Reduce` function. The output of the `Reduce` function is appended to a final output file for this reduce partition.

7. When all map tasks and reduce tasks have been
completed, the master wakes up the user program.
At this point, the `MapReduce` call in the user program returns back to the user code.

After successful completion, the output of the mapreduce execution is available in the `R` output files (one per reduce task, with file names as specified by the user). Typically, users do not need to combine these `R` output files into one file – they often pass these files as input to another MapReduce call, or use them from another distributed application that is able to deal with input that is partitioned into multiple files.

### 3.2 Master Data Structures

The master keeps several data structures. For each map task and reduce task, it stores the state (`idle`, `in-progress`, or `completed`), and the identity of the worker machine (for non-idle tasks).

The master is the conduit through which the location of intermediate file regions is propagated from map tasks to reduce tasks. Therefore, for each completed map task, the master stores the locations and sizes of the `R` intermediate file regions produced by the map task. Updates to this location and size information are received as map tasks are completed. The information is pushed incrementally to workers that have `in-progress` reduce tasks.

### 3.3 Fault Tolerance















## TODO map reduce xxxxxxxxxxxxxxxxxxxxxxxxxx