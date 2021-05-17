# mysql

- [mysql](#mysql)
  - [user](#user)
    - [create user](#create-user)
    - [show users](#show-users)
  - [privilege](#privilege)
    - [GRANT ALL privileges to a user](#grant-all-privileges-to-a-user)

## user

### create user

    CREATE USER 'username' IDENTIFIED BY 'password';

### show users

    SELECT user FROM mysql.user;

## privilege

### GRANT ALL privileges to a user

    GRANT ALL PRIVILEGES ON database_name.* TO 'username'@'localhost';
