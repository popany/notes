# [Grpc Api](https://grpc.github.io/grpc/cpp/)

- [Grpc Api](#grpc-api)
  - [C++ Performance Notes](#c-performance-notes)
    - [Completion Queues and Threading in the Async API](#completion-queues-and-threading-in-the-async-api)
  - [Async Api](#async-api)
    - [`grpc::ClientAsyncResponseReader<R>`](#grpcclientasyncresponsereaderr)
    - [`grpc::ClientAsyncReader<R>`](#grpcclientasyncreaderr)
    - [`grpc::CompletionQueue`](#grpccompletionqueue)
    - [`grpc::ClientWriteReactor<Request>`](#grpcclientwritereactorrequest)
    - [`grpc::ServerWriteReactor<Response>`](#grpcserverwritereactorresponse)

## [C++ Performance Notes](https://grpc.github.io/grpc/cpp/md_doc_cpp_perf_notes.html)

### Completion Queues and Threading in the Async API

Right now, the best performance trade-off is having numcpu's threads and one completion queue per thread.

## Async Api

### [`grpc::ClientAsyncResponseReader<R>`](https://grpc.github.io/grpc/cpp/classgrpc_1_1_client_async_response_reader.html)

`Finish()`

    template<class R>
    void grpc::ClientAsyncResponseReader<R>::Finish(R *msg,
        ::grpc::Status *status,
        void *tag 
    )

### [`grpc::ClientAsyncReader<R>`](https://grpc.github.io/grpc/cpp/classgrpc_1_1_client_async_reader.html)

`Read()`

    template<class R>
    void grpc::ClientAsyncReader<R>::Read(R *msg,
        void *tag 
    )

`Finish()`

    template<class R>
    void grpc::ClientAsyncReader<R>::Finish(::grpc::Status *status,
        void *tag 
    )

### [`grpc::CompletionQueue`](https://grpc.github.io/grpc/cpp/classgrpc_1_1_completion_queue.html)

`Next()`

    bool grpc::CompletionQueue::Next(void **tag,
        bool *ok 
    )

### [`grpc::ClientWriteReactor<Request>`](https://grpc.github.io/grpc/cpp/classgrpc_1_1_client_write_reactor.html)


### [`grpc::ServerWriteReactor<Response>`](https://grpc.github.io/grpc/cpp/classgrpc_1_1_server_write_reactor.html)





