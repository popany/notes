# SQL

- [SQL](#sql)
  - [left join](#left-join)
  - [Oracle](#oracle)
    - [show tables](#show-tables)
    - [show users](#show-users)
    - [drop current schema objects](#drop-current-schema-objects)
    - [drop user](#drop-user)
    - [Viewing Information about Tablespaces and Datafiles](#viewing-information-about-tablespaces-and-datafiles)
    - [Drop the Whole Tablespace with All Datafiles](#drop-the-whole-tablespace-with-all-datafiles)
    - [Check How Many Datafiles a Tablespace Has](#check-how-many-datafiles-a-tablespace-has)
    - [Resize a Datafile to Minimum Size](#resize-a-datafile-to-minimum-size)
    - [Determine the Extents inside Datafile](#determine-the-extents-inside-datafile)
    - [List all the roles](#list-all-the-roles)
    - [Drop role](#drop-role)
    - [Show the structure of the table](#show-the-structure-of-the-table)

## left join

[sql之left join、right join、inner join的区别](https://www.cnblogs.com/pcjim/articles/799302.html)

## Oracle

### show tables

    select table_name from all_tables;

### show users

- List all users that are visible to the current user:

      select * from all_users;

- List all users in the Oracle Database:

      select * from dba_users;

- Show the information of the current user:

      select * from user_users;

### drop current schema objects

produce a series of drop statments:

    select 'drop '||object_type||' '|| object_name|| DECODE(OBJECT_TYPE,'TABLE',' CASCADE CONSTRAINTS','') || ';'  from user_objects

### drop user

- If user's schema contains no objects

      DROP USER user_name; 

- If user's schema contains no objects

      DROP USER user_name CASCADE; 

### [Viewing Information about Tablespaces and Datafiles](https://oracle-dba-online.com/renaming-or-relocating-datafiles.htm)

- View information about Tablespaces

      select * from dba_tablespaces 
      select * from v$tablespace;

- View information about Datafiles

      select * from dba_data_files;
      select * from v$datafile;

- View information about Tempfiles

      select * from dba_temp_files;
      select * from v$tempfile;

- View information about free space in datafiles

      select * from dba_free_space;

- View information about free space in tempfiles

      select * from V$TEMP_SPACE_HEADER;

### Drop the Whole Tablespace with All Datafiles

    DROP TABLESPACE <tablespace name> INCLUDING CONTENTS AND DATAFILES;

### Check How Many Datafiles a Tablespace Has

    SELECT file_name, tablespace_name 
    FROM dba_data_files 
    WHERE tablespace_name ='<tablespace name>';

### Resize a Datafile to Minimum Size

    alter database datafile '<datafile name>' resize 8M;

### Determine the Extents inside Datafile

    SELECT owner, segment_name
    FROM dba_extents a, dba_data_files b
    WHERE a.file_id = b.file_id 
    AND b.file_name = '<datafile name>'

### List all the roles

    select * from dba_roles;

### Drop role

    drop role role_name; 

### Show the structure of the table

    SELECT COLUMN_NAME, DATA_TYPE FROM ALL_TAB_COLUMNS WHERE TABLE_NAME='your_table_name';

