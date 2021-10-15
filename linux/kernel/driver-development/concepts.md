# Linux Driver Concepts

- [Linux Driver Concepts](#linux-driver-concepts)
  - [Major / Minor number](#major--minor-number)
  - [I/O Port](#io-port)
    - [Memory-mapped I/O and port-mapped I/O on peripherals](#memory-mapped-io-and-port-mapped-io-on-peripherals)

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

## I/O Port

### Memory-mapped I/O and port-mapped I/O on peripherals

- memory-mapped I/O

  - maps device registers into regular data space.

  - There is no difference between accessing it and accessing system memory space.

  - To store data in the memory-mapped device register is to send instructions or data to the device.

  - Reading data from the memory-mapped I/O register is to obtain the device status or data.

  - The device address space is a part of the system memory space;

  - the **control register** and **status register** after memory mapping can be regarded as ordinary variables, just declare a pointer variable pointing to this register or a group of registers, and the declaration to be displayed The value of this pointer variable.

  - the device address is part of the system memory address space. Any machine instruction that is encoded to transfer data between a memory location and the processor or between two memory locations can potentially be used to access the I/O device. The I/O device is treated as if it were another memory location. Because the I/O address space occupies a range in the system memory address space, this region of the memory address space is not available for an application to use.

- port-mapped I/O

  - maps control and data registers to a separate data space.

  - The devices are programmed to occupy a range in the I/O address space.

  - Each device is on a different I/O port.

  - The I/O ports are accessed through special processor instructions, and actual physical access is accomplished through special hardware circuitry.

  - The **I/O device address** is referred to as the port number when specified for these special instructions

  - This I/O method is also called isolated I/O because the memory space is isolated from the I/O space, thus the entire memory address space is available for application use.




































