# [Implementation of distributed locks](https://www.alibabacloud.com/forum/read-453)

- [Implementation of distributed locks](#implementation-of-distributed-locks)
  - [1. Questions about distributed locks](#1-questions-about-distributed-locks)
  - [2. Implement distributed locks in databases](#2-implement-distributed-locks-in-databases)
    - [2.1 Case](#21-case)
    - [2.2 Issues](#22-issues)
  - [3. Implement distributed locks in Redis](#3-implement-distributed-locks-in-redis)
    - [3.1 Basic version](#31-basic-version)
    - [3.2 Enhanced version](#32-enhanced-version)
    - [3.3 Issues](#33-issues)
  - [4. Implement distributed locks in ZooKeeper](#4-implement-distributed-locks-in-zookeeper)
    - [4.1 Case](#41-case)
    - [4.2 Summary](#42-summary)
  - [5. Summary of principles for implementing distributed locks](#5-summary-of-principles-for-implementing-distributed-locks)
    - [5.1 Implementation of distributed locks](#51-implementation-of-distributed-locks)
      - [5.1.1 How to obtain locks](#511-how-to-obtain-locks)
      - [5.1.2 How to release locks](#512-how-to-release-locks)
      - [5.1.3 How to know the lock has been released](#513-how-to-know-the-lock-has-been-released)

## 1. Questions about distributed locks

Speaking of distributed locks, there are many implementation methods, such as databases, Redis and ZooKeeper. Here is a question:

- To implement distributed locks, what conditions should be met?

## 2. Implement distributed locks in databases

### 2.1 Case

If you want to use the lock in database transactions such as record lock to implement distributed locks, follow the steps below:

1. Obtain the lock

       public void lock(){
           connection.setAutoCommit(false)
           int count = 0;
           while(count < 4){
               try{
                   select * from lock where lock_name=xxx for update;
                   If (result is not empty){
                       //Indicates the lock is obtained
                       return;
                   }
               }catch(Exception e){
       
               }
               //If the result is empty or an exception is thrown out, it indicates the lock is not obtained
               sleep(1000);
               count++;
           }
           throw new LockException();
       }

2. Release the lock

       public void release(){
           connection.commit();
       }

The lock table of the database. The lock_name is the primary key. During for update operations, the database will add a record lock to the row of the record, blocking other operations on the record.

Once the lock is obtained, you can start to execute the business logic and release the lock through the connection.commit() operation.

The other requests that didn't obtain the lock will be congested on the select statement above. There may be two results: obtaining the lock before the timeout, or failing to obtain the lock before the timeout (in this case, an exception will be thrown out and the request will be retried)

There are other methods for databases, such as by inserting data with unique binding conditions. If the data is successfully inserted, it indicates the lock has been obtained. Releasing the lock means to delete the record. This solution also has many issues to solve.

### 2.2 Issues

First, its performance is not high.

Mutual exclusion between multiple processes can be implemented through the database locks. But it also has a problem: the SQL statement timeout exception.

JDBC timeout has three manifestations:

- Transaction timeout in the framework layer
- JDBC query timeout
- Socket reading timeout

Here only the latter two timeouts are involved. JDBC query timeout is easier to handle (MySQL JDBC drive will send a kill query command to the server to cancel the query). But if Socket reading timeout occurs, it means a failure of the socket connection for synchronous communication (the underlying connection may be for synchronous communication or for asynchronous communication). The connection needs to be shut down and a new connection needs to be established. Otherwise request and response issues may occur, such as type conversion exception in Jedis.

## 3. Implement distributed locks in Redis

In Redis, you usually can use the `SETNX` command to implement distributed locks.

### 3.1 Basic version

1. Obtain the lock

       public void lock(){
           for(){
               ret = setnx lock_ley (current_time + lock_timeout)
               if(ret){
                   //The lock is obtained
                   break;
               }
               //The lock is not obtained
               sleep(100);
           }
       }

2. Release the lock

       public void release(){
           del lock_ley
       }

Use the SETNX command to create a key. If the key does not exist, the creation will succeed and value 1 is returned; otherwise, value 0 is returned. This helps you determine whether the lock has been obtained.

Requests that have gained the lock will execute the business logic and delete lock_key after the execution is complete to release the lock.

Other requests that failed to obtain the lock will keep retrying until they obtain the lock.

### 3.2 Enhanced version

The logic above is okay under normal circumstances. But once the client that has obtained the lock fails before it releases the lock, other clients may not obtain the lock. In this case, there are two solutions as follows:

- Set an expiration time for the lock_key
- Judge the expiration status of the lock from the lock_key value

Taking the first solution for example: the expiration time will be added when the key value is set, so that even if the client goes down, other clients can continue competing to obtain the lock after the expiration time elapses.

    public void lock(){
        while(true){
            ret = set lock_key identify_value nx ex lock_timeout
            if(ret){
                //The lock is obtained
                return;
            }
            sleep(100);
        }
    }
    
    public void release(){
        value = get lock_key
        if(identify_value == value){
            del lock_key
        }
    }

Taking the second solution for example: when the lock_key value is smaller than the current time, it indicates the key has expired, and the key will be subject to getset. Once the getset returns a value of the original expiration value, it indicates the current client is the first to operate on it and obtained the lock. Once the getset returns a value other than the original expiration value, it indicates someone has modified it and the lock is not obtained. Modifications are as follows:

    # get lock
    lock = 0
    while lock != 1:
        timestamp = current_unix_time + lock_timeout
        lock = SETNX lock.foo timestamp
        if lock == 1 or (now() > (GET lock.foo) and now() > (GETSET lock.foo timestamp)):
            break;
        else:
            sleep(10ms)
    
    # do your job
    do_job()
    
    # release
    if now() < GET lock.foo:
        DEL lock.foo

From this, we can see the second solution is not superior to the first solution.

### 3.3 Issues

Issue 1: The existence of lock timeout weakens the purpose of the lock, that is, concurrency may exist. Once the lease period appears, it means the client that has obtained the lock must complete the business logic execution within the lease period. Otherwise, concurrency issues will emerge. So the lock timeout logic impairs the service reliability.

Issue 2: The above method only applies to single Redis servers, so the Redis SPOF issue also persists. If you use Redis sentinel or cluster solutions for solving SPOF, the case will be more complicated and involve more potential problems.

## 4. Implement distributed locks in ZooKeeper

### 4.1 Case

This is also distributed lock implementation on the ZooKeeper client curator.

1. Obtain the lock

       public void lock(){
           path = Create temporary sequence nodes under the parent node
           while(true){
               children = Obtain all the nodes under the parent node
               If (path is the smallest unit in children){
                   indicates the node is obtained
                   return;
               }else{
                   Add a watcher to monitor whether the previous node exists
                   wait();
               }
           }
       }
       
       Content in watcher {
           notifyAll();
       }

2. Release the lock

       public void release(){
           Delete the node created above.
       }

### 4.2 Summary

Distributed locks for ZooKeeper version involve comparatively fewer issues.

- Lock occupy time limit: Redis imposes a limit on the lock occupy time, but ZooKeeper does not. The major reason is that currently Redis has no way to know the status of the client that has obtained the lock, whether it has failed or is executing a time-consuming service logic. While ZooKeeper can know it clearly through the temporary nodes. If the temporary node exists, it means the execution of service logic is in progress. Otherwise, it means the execution has been complete and the lock has been released, or the client has failed. From this perspective, if some temporary keys bound to the client can be added in Redis like in ZooKeeper, it will be good.

- SPOF: Redis has many features, such as the consistency hash between clients, and sentinel or cluster solutions for servers. **It is hard to find one distributed lock mode that applies to all those features**. ZooKeeper, on the contrary, has only one method: data between multiple nodes is consistent, without so many troublesome elements to consider as Redis.

In general, ZooKeeper is easier to implement distributed locks with higher reliability.

## 5. Summary of principles for implementing distributed locks

From the above three implementation methods, we can summarize an answer to the question at the beginning.

### 5.1 Implementation of distributed locks

In my opinion, there are three aspects:

- How to obtain locks
- How to release locks
- How to know the lock has been released

#### 5.1.1 How to obtain locks

A method should be provided in which among the concurrent operations from multiple clients, only one client can meet the requirements.

For example, the for update SQL statement of databases, or inserting data with unique binding conditions such as the SETNX command of Redis and the calculation of the minimum node in ZooKeeper.

All these methods can guarantee that only one client gets the lock.

#### 5.1.2 How to release locks

There are two scenarios:

- 1. Release locks in normal circumstances
- 2. Release locks in exceptional circumstances (that is, the lock releasing operation is not executed because of reasons such as failed client or unsuccessful execution)

For example, in Redis, the lock releasing in normal circumstances means to delete the lock_key, and in exceptional circumstances has to rely on the lock_key timeout.

In ZooKeeper, the lock releasing in normal circumstances means to delete the temporary nodes, and in exceptional circumstances, the server will also automatically delete the temporary nodes (this mechanism is much simpler)

#### 5.1.3 How to know the lock has been released

There are two situations for implementation methods:

- 1. The clients that haven't obtained the lock keep trying to obtain it.

- 2. The server side notifies the clients that the lock has been released

Of course the second situation is better (with the fewest futile actions from the clients). For example, ZooKeeper gets the lock releasing notification through registering a watcher. But databases and Redis have no way to know that the clock has been released by a client, so the clients have to retry repeatedly to get the lock.
