# Avoid Multiple Instances of Application

- [Avoid Multiple Instances of Application](#avoid-multiple-instances-of-application)
  - [How to Avoid Multiple Instances of Different Users but Allow Multiple Instances on Single User Session](#how-to-avoid-multiple-instances-of-different-users-but-allow-multiple-instances-on-single-user-session)
  - [Single-instance applications](#single-instance-applications)
  - [Not able to prevent multiple instances of the same program from different users](#not-able-to-prevent-multiple-instances-of-the-same-program-from-different-users)

## [How to Avoid Multiple Instances of Different Users but Allow Multiple Instances on Single User Session](https://stackoverflow.com/questions/28240354/how-to-avoid-multiple-instances-of-different-users-but-allow-multiple-instances)

This requirement can be accomplished using a named [Mutex Object](https://msdn.microsoft.com/en-us/library/windows/desktop/ms684266.aspx) in the global [Kernel Object Namespace](https://msdn.microsoft.com/en-us/library/windows/desktop/aa382954.aspx). A mutex object is created using the [CreateMutex function](https://msdn.microsoft.com/en-us/library/windows/desktop/ms682411.aspx). Here is a small program to illustrate its usage:

    int _tmain(int argc, _TCHAR* argv[]) {
        if ( ::CreateMutexW( NULL,
                             FALSE,
                             L"Global\\5BDC0675-2318-404A-96CA-DBDE9BC2F71D" ) != NULL ) {
            auto const err{ GetLastError() };
            std::wcout << L"Mutex acquired. GLE = " << err << std::endl;
            // Continue execution
        } else {
            auto const err{ GetLastError() };
            std::wcout << L"Mutex not acquired. GLE = " << err << std::endl;
            // Exit application
        }
        _getch();
        return 0;
    }

The first application instance will create the mutex object, and [GetLastError](https://msdn.microsoft.com/en-us/library/windows/desktop/ms679360.aspx) returns ERROR_SUCCESS (0). Subsequent instances will acquire a reference to the existing mutex object, and `GetLastError` returns `ERROR_ALREADY_EXISTS` (183). **Instances started from another client session** will not acquire a reference to the mutex object, and `GetLastError` returns `ERROR_ACCESS_DENIED` (5).

A few notes on the implementation:

- A mutex object is created in the global kernel object namespace by prepending the "Global\" prefix.

- The mutex object must have a unique name to have a means of referring to it from anywhere. The easiest way to create a unique name is to use the string representation of a GUID (GUIDs can be generated using the guidgen.exe tool part of Visual Studio). Don't use the GUID from the sample code, because someone else will, too.

- There is no call to [CloseHandle](https://msdn.microsoft.com/en-us/library/windows/desktop/ms724211.aspx) to release the mutex object. This is intentional. (See [CreateMutex](https://msdn.microsoft.com/en-us/library/windows/desktop/ms682411.aspx): The system closes the handle automatically when the process terminates. The mutex object is destroyed when its last handle has been closed.)

- The mutex object is created using the default security descriptor. The ACLs in the default security descriptor come from the primary or impersonation token of the creator. If processes in different client sessions run with the same primary/impersonation token, the mutex can still be acquired from both sessions. In this situation the proposed solution potentially doesn't meet the requirements. It is unclear what should happen, if a user runs the application impersonating the user of a different client session.

- The mutex object is used purely as a sentinel, and doesn't participate in synchronization.

## [Single-instance applications](http://www.bcbjournal.org/articles/vol3/9911/Single-instance_applications.htm)

## [Not able to prevent multiple instances of the same program from different users](https://stackoverflow.com/questions/55502262/not-able-to-prevent-multiple-instances-of-the-same-program-from-different-users)
