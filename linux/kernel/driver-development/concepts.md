# Linux Driver Concepts

- [Linux Driver Concepts](#linux-driver-concepts)
  - [Major / Minor number](#major--minor-number)

## Major / Minor number

- device file

  - Every Device in Linux is represented as a regular file.

  - These files are called device files.

  - These device files are located under /dev directory. 

- device

  - can be accessed by opening its respective device file 

- device driver

  - A **single device driver** can handle **multiple devices or controllers**.

    - For example:

      - a single USB driver handles multiple USB ports in your PC

      - same hard disk driver can manage multiple hard disk

- major number and minor number

  - Each device file in Linux has two unique number associated with it.

    - These two numbers are major number and minor number.

  - Major number

    - is a unique number which specifies a particular driver

    - Every Device driver has their unique major number which helps kernel to identify the driver 
 
    - When any application in user space open any device file, kernel check major number associated with that device file and identify which driver is responsible for handling this request.

  - minor number

    - To differentiate between devices, every device in linux system provided a unique number which is called minor device number.

  - We can say that minor number represents a device and major number specify a driver.

    - Two or more device of same type can have same major number but not minor number.







































