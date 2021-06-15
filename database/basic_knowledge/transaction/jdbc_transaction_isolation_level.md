# [jdbc transaction isolation level](https://programmer.ink/think/jdbc-transaction-isolation-level.html)

- [jdbc transaction isolation level](#jdbc-transaction-isolation-level)
  - [1. Transaction isolation level](#1-transaction-isolation-level)
    - [1.1 transaction-induced concurrency problems](#11-transaction-induced-concurrency-problems)
    - [1.2 Transaction isolation level](#12-transaction-isolation-level)
    - [1.3 Concurrency issues at different isolation levels](#13-concurrency-issues-at-different-isolation-levels)
  - [2. Transaction isolation test](#2-transaction-isolation-test)
    - [2.1 Create User Table Operating Tool Class](#21-create-user-table-operating-tool-class)
    - [2.2 Test dirty reading](#22-test-dirty-reading)
    - [2.3 Non-repeatable Tests](#23-non-repeatable-tests)
    - [2.4 Test Illusion Reading](#24-test-illusion-reading)

## 1. Transaction isolation level

### 1.1 transaction-induced concurrency problems

When multiple transactions run concurrently, if multiple transactions operate on the same data in the database at the same time, it is easy to cause concurrency problems.

- Dirty reading: If transaction T1 performs an update field but has not yet performed a commit operation, then it will be called dirty reading if field T1 has not yet been submitted is read by T2. Because T1 may not necessarily perform a commit operation, but it may also perform a rollback operation.

- Non-repeatable reading: If a field is read in T1 and updated in T2, the value of the same field changes when the field is retrieved again in T1.

- Illusion reading: In the case of unique id, if the data with ID 10 does not exist in transaction T1, the data with ID 10 is first queried from the data table, and then the data with ID 10 is inserted into T2, while T1 thinks that the data with ID 10 does not exist, and the data with ID 10 is inserted into the transaction T1, an exception will occur.

### 1.2 Transaction isolation level

The database provides four isolation levels.

- mysql supports four transaction isolation levels, the default level being REPEATABLE READ (repeatable read)

- oracle supports only two transaction isolation levels: READ COMMITED and SERIA LIZABLE, and the default level is READ COMMITED (read submitted)

|Isolation level|Isolation level|describe|
|-|-|-|
READ UNCOMMITTED|Read uncommitted|Transaction isolation is the lowest when transactions are allowed to read uncommitted changes from other transactions.
READ COMMITED|Read submitted|Dirty reading can be avoided by only allowing transactions to read submitted data changes.
REPEATABLE READ|Repeatable reading|Ensure that the same value can be obtained from a field many times in a transaction. <br> That is to say, other transactions prohibit changes to this field during this transaction.
SERIALIZABLE|Serialization|Ensure that transactions can only be executed one by one for the same table, and concurrent transactions are not allowed to run. <br> That is to say, during the next transaction, no transaction is allowed to add, delete and modify the table. Concurrent problems can be avoided, but the performance is low.
||||

### 1.3 Concurrency issues at different isolation levels

Partial concurrency problems can be avoided at different isolation levels. The higher isolation, the worse performance.

Isolation level|Dirty reading|Non-repeatable reading|phantom read|describe
|-|-|-|-|-|
READ UNCOMMITTED|√|√|√|The highest performance and the worst isolation. Dirty reading, unrepeatable reading and hallucination may occur when transactions are concurrent.
READ COMMITED|x|√|√|The most widely used, can effectively avoid dirty reading, but may produce unrepeatable reading, hallucination phenomenon
REPEATABLE READ|x|x|√|It can avoid dirty reading and can't repeat reading. But it may cause hallucination.
SERIALIZABLE|x|x|x|The performance is the lowest and the isolation line is the strongest. When transactions are concurrent, dirty reading, unrepeatable reading and hallucination can be effectively avoided.
||||||

## 2. Transaction isolation test

### 2.1 Create User Table Operating Tool Class

    public class UserDaoUtil {
    
        // Save User objects
        public static void save(Connection connection, UserPO userPO) {
    
            String sql = "insert t_user(id, name, password) values (?, ?, ?)";
    
            try {
                // Get PreparedStatement and set the backfill key
                PreparedStatement preparedStatement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
    
                // Setting parameters
                preparedStatement.setInt(1, userPO.getId());
                preparedStatement.setString(2, userPO.getName());
                preparedStatement.setString(3, userPO.getPassword());
    
                preparedStatement.executeUpdate();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    
        // Query objects by id
        public static UserPO findById(Connection connection, Integer id) {
            String sql = "select  * from t_user where id = ?";
    
            UserPO userPO = null;
            try {
                // Get PreparedStatement and set parameters
                PreparedStatement preparedStatement = connection.prepareStatement(sql);
                preparedStatement.setInt(1, id);
    
                // Execute the query and parse the results
                ResultSet resultSet = preparedStatement.executeQuery();
    
                while (resultSet.next()) {
                    userPO = new UserPO();
                    userPO.setId(resultSet.getObject("id", Integer.class));
                    userPO.setName(resultSet.getObject("name", String.class));
                    userPO.setPassword(resultSet.getObject("password", String.class));
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
    
            return userPO;
        }
    
        // Update password with id
        public static void updatePassword(Connection connection, Integer id) {
            String sql = "update t_user set password = ? where id = ?";
    
            try {
    
                // Get PreparedStatement and set parameters
                PreparedStatement preparedStatement = connection.prepareStatement(sql);
                preparedStatement.setString(1, LocalTime.now().toString());
                preparedStatement.setInt(2, id);
    
                preparedStatement.executeUpdate();
    
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

### 2.2 Test dirty reading

- Testing emphasis: Can sub-threads read uncommitted data from the main thread?

- Dirty reading refers to that the current connection reads data submitted by other transactions. It should be noted that the author's test case is in the first person of the sub-thread, so the isolation level of the transaction is set in the sub-thread.

  - When the isolation level of sub-threads is set to TRANSACTION_READ_UNCOMMITTED, uncommitted data from the main thread can be read.

  - The uncommitted data of the main thread can not be read when the isolation ridge of the sub-thread is set to TRANSACTION_READ_COMMITTED and the level of TRANSACTION_REPEATABLE_READ.

.

    // Test dirty reading
    @Test
    public void test1() throws Exception{
    
        // 1. Getting database connections
        Connection connection = DbConnUtil.getConnection();
    
        // 2. Turn off automatic commit transactions
        connection.setAutoCommit(false);
    
        // 3. Execute insert statements
        UserDaoUtil.save(connection, new UserPO(1, "zhangsan", "123456"));
    
        // 4. Open sub-threads to simulate concurrent transactions. Set isolation level in sub-transactions
        new Thread(){
    
            @Override
            public void run() {
                try {
                    // Get a new database connection in the subthread and automatically commit transactions by default
                    Connection subConn = DbConnUtil.getConnection();
    
                    // Setting the transaction isolation level for subthreads
                    subConn.setTransactionIsolation(Connection.TRANSACTION_READ_UNCOMMITTED);
    
                    UserPO user = UserDaoUtil.findById(subConn, 1);
                    System.out.println("Subthread Query:" + user);
                } catch (Exception ex) {
                    ex.printStackTrace();
                }
    
            }
        }.run();
    
        // Hibernation of main thread
        Thread.sleep(3000l);
        // Commit transaction rollback
        connection.rollback();
    }

### 2.3 Non-repeatable Tests

- Testing focus: non-repeatable reading, mainly testing in a transaction, two different query results, whether consistent

- Transaction isolation level is managed by main thread

  - When set to TRANSACTION_READ_COMMITTED and TRANSACTION_READ_UNCOMMITTED, the results of two queries are inconsistent.

  - When set to TRANSACTION_REPEATABLE_READ, the results of the two queries are identical.

.

    @Test
    public void test2() throws Exception{
    
        // 1. Getting database connections
        Connection connection = DbConnUtil.getConnection(false);
    
        // 2. Setting repeatable reads
        connection.setTransactionIsolation(Connection.TRANSACTION_REPEATABLE_READ);
    
        UserPO user1 = UserDaoUtil.findById(connection, 1);
        System.out.println("First query:" + user1);
    
        new Thread(){
    
            @Override
            public void run() {
    
                // Get the database connection
                Connection subConn = DbConnUtil.getConnection(true);
    
                UserDaoUtil.updatePassword(subConn, 1);
            }
        }.run();
    
        Thread.sleep(3000);
    
        UserPO user2 = UserDaoUtil.findById(connection, 1);
        System.out.println("Second query:" + user2);
    }

### 2.4 Test Illusion Reading

- Testing emphasis: The main thread queries the record with id 10 does not exist. When the main thread is ready to insert the record with id 10, the sub-thread inserts the record with id 10, so the main thread inserts failure.

- Test results:

  - When the isolation level of the main thread is set to TRANSACTION_READ_UNCOMMITTED, TRANSACTION_READ_COMMITTED, TRANSACTION_REPEATABLE_READ, they cannot be controlled.

  - When the main thread is set to TRANSACTION_SERIALIZABLE, the test case will be deadlocked. Because the main thread starts a transaction on the t_user table, the sub-thread will wait until the end of the main thread transaction. If the sub-thread operates on other tables, no deadlock will occur, but this has nothing to do with hallucination reading.

.

    // Test hallucination
    @Test
    public void test3() throws Exception{
        // 1. Getting database connections
        Connection connection = DbConnUtil.getConnection();
    
        // 2. Turn off automatic commit transactions
        connection.setAutoCommit(false);
    
        // 3. Setting the isolation level
        connection.setTransactionIsolation(Connection.TRANSACTION_REPEATABLE_READ);
    
        // 4. First inquiry
        UserPO user10 = UserDaoUtil.findById(connection, 10);
    
        // 5. Open sub-threads to simulate concurrent transactions. Set isolation level in sub-transactions
        new Thread(){
    
            @Override
            public void run() {
                Connection subConn = DbConnUtil.getConnection();
                UserDaoUtil.save(subConn, new UserPO(10, "lisi","123456"));
                DbConnUtil.release(subConn);
            }
        }.run();
    
        // Hibernation of main thread
        Thread.sleep(3000l);
    
        if (user10 == null) {
            System.out.println("The main thread starts inserting data...");
            UserDaoUtil.save(connection,  new UserPO(10, "lisi","123456"));
            connection.commit();
        }
    
    }
