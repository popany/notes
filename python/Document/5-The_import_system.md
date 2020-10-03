# [5. The import system](https://docs.python.org/3/reference/import.html)

- [5. The import system](#5-the-import-system)
  - [5.1. importlib](#51-importlib)
  - [5.2. Packages](#52-packages)
    - [5.2.1. Regular packages](#521-regular-packages)
    - [5.2.2. Namespace packages](#522-namespace-packages)
  - [5.3. Searching](#53-searching)
    - [5.3.1. The module cache](#531-the-module-cache)

Python code in one [module](https://docs.python.org/3/glossary.html#term-module) gains access to the code in another module by the process of [importing](https://docs.python.org/3/glossary.html#term-importing) it. The [import](https://docs.python.org/3/reference/simple_stmts.html#import) statement is the most common way of invoking the import machinery, but it is not the only way. Functions such as [`importlib.import_module()`](https://docs.python.org/3/library/importlib.html#importlib.import_module) and built-in [`__import__()`](https://docs.python.org/3/library/functions.html#__import__) can also be used to invoke the import machinery.

The [import](https://docs.python.org/3/reference/simple_stmts.html#import) statement combines two operations; it searches for the named module, then it binds the results of that search to a name in the local scope. The search operation of the `import` statement is defined as a call to the [`__import__()`](https://docs.python.org/3/library/functions.html#__import__) function, with the appropriate arguments. The return value of [`__import__()`](https://docs.python.org/3/library/functions.html#__import__) is used to perform the name binding operation of the `import` statement. See the `import` statement for the exact details of that name binding operation.

A direct call to [`__import__()`](https://docs.python.org/3/library/functions.html#__import__) performs only the module search and, if found, the module creation operation. While certain side-effects may occur, such as the importing of parent packages, and the updating of various caches (including [`sys.modules`](https://docs.python.org/3/library/sys.html#sys.modules)), only the [`import`](https://docs.python.org/3/reference/simple_stmts.html#import) statement performs a **name binding operation**.

When an [`import`](https://docs.python.org/3/reference/simple_stmts.html#import) statement is executed, the standard builtin [`__import__()`](https://docs.python.org/3/library/functions.html#__import__) function is called. Other mechanisms for invoking the import system (such as [`importlib.import_module()`](https://docs.python.org/3/library/importlib.html#importlib.import_module)) may choose to bypass [`__import__()`](https://docs.python.org/3/library/functions.html#__import__) and use their own solutions to implement import semantics.

When a module is first imported, Python searches for the module and if found, it creates a module object, initializing it. If the named module cannot be found, a [`ModuleNotFoundError`](https://docs.python.org/3/library/exceptions.html#ModuleNotFoundError) is raised. Python implements various strategies to search for the named module when the import machinery is invoked. These strategies can be modified and extended by using various hooks described in the sections below.

## 5.1. [importlib](https://docs.python.org/3/library/importlib.html#module-importlib)

The [importlib](https://docs.python.org/3/library/importlib.html#module-importlib) module provides a rich API for interacting with the import system. For example [`importlib.import_module()`](https://docs.python.org/3/library/importlib.html#importlib.import_module) provides a recommended, simpler API than built-in [`__import__()`](https://docs.python.org/3/library/functions.html#__import__) for invoking the import machinery. Refer to the [`importlib`](https://docs.python.org/3/library/importlib.html#module-importlib) library documentation for additional detail.

## 5.2. Packages

Python has only one type of module object, and all modules are of this type, regardless of whether the module is implemented in Python, C, or something else. To help organize modules and provide a naming hierarchy, Python has a concept of [packages](https://docs.python.org/3/glossary.html#term-package).

You can think of **packages as the directories** on a file system and **modules as files** within directories, but don’t take this analogy too literally since packages and modules need not originate from the file system. For the purposes of this documentation, we’ll use this convenient analogy of directories and files. Like file system directories, packages are organized hierarchically, and packages may themselves contain subpackages, as well as regular modules.

It’s important to keep in mind that all packages are modules, but not all modules are packages. Or put another way, **packages are just a special kind of module**. Specifically, any module that contains a `__path__` attribute is considered a package.

All modules have a name. Subpackage names are separated from their parent package name by dots, akin to Python’s standard attribute access syntax. Thus you might have a module called `sys` and a package called `email`, which in turn has a subpackage called `email.mime` and a module within that subpackage called `email.mime.text`.

### 5.2.1. Regular packages

Python defines two types of packages, [regular packages](https://docs.python.org/3/glossary.html#term-regular-package) and [namespace packages](https://docs.python.org/3/glossary.html#term-namespace-package). Regular packages are traditional packages as they existed in Python 3.2 and earlier. A regular package is typically implemented as a directory containing an `__init__.py` file. When a regular package is imported, this `__init__.py` file is **implicitly executed**, and the **objects it defines are bound to names in the package’s namespace**. The `__init__.py` file can contain the same Python code that any other module can contain, and Python will add some **additional attributes** to the module when it is imported.

For example, the following file system layout defines a top level parent package with three subpackages:

    parent/
        __init__.py
        one/
            __init__.py
        two/
            __init__.py
        three/
            __init__.py

Importing `parent.one` will implicitly execute `parent/__init__.py` and `parent/one/__init__.py`. Subsequent imports of `parent.two` or `parent.three` will execute `parent/two/__init__.py` and `parent/three/__init__.py` respectively.

### 5.2.2. Namespace packages

A namespace package is a composite of various [portions](https://docs.python.org/3/glossary.html#term-portion), where each portion contributes a subpackage to the parent package. Portions may reside in different locations on the file system. Portions may also be found in zip files, on the network, or anywhere else that Python searches during import. Namespace packages may or may not correspond directly to objects on the file system; they may be virtual modules that have no concrete representation.

Namespace packages do not use an ordinary list for their `__path__` attribute. They instead use a custom iterable type which will automatically perform a new search for package portions on the next import attempt within that package if the path of their parent package (or [sys.path](https://docs.python.org/3/library/sys.html#sys.path) for a top level package) changes.

With namespace packages, there is no `parent/__init__.py` file. In fact, there may be multiple `parent` directories found during import search, where each one is provided by a different portion. Thus `parent/one` may not be physically located next to `parent/two`. In this case, Python will create a namespace package for the top-level `parent` package whenever it or one of its subpackages is imported.

## 5.3. Searching

To begin the search, Python needs the fully qualified name of the module (or package, but for the purposes of this discussion, the difference is immaterial) being imported. This name may come from various arguments to the [`import`](https://docs.python.org/3/reference/simple_stmts.html#import) statement, or from the parameters to the [`importlib.import_module()`](https://docs.python.org/3/library/importlib.html#importlib.import_module) or [`__import__()`](https://docs.python.org/3/library/functions.html#__import__) functions.

This name will be used in various phases of the import search, and it may be the dotted path to a submodule, e.g. `foo.bar.baz`. In this case, Python first tries to import `foo`, then `foo.bar`, and finally `foo.bar.baz`. If any of the intermediate imports fail, a [`ModuleNotFoundError`](https://docs.python.org/3/library/exceptions.html#ModuleNotFoundError) is raised.

### 5.3.1. The module cache

The first place checked during import search is [`sys.modules`](https://docs.python.org/3/library/sys.html#sys.modules). This mapping serves as a cache of all modules that have been previously imported, including the intermediate paths. So if `foo.bar.baz` was previously imported, [`sys.modules`](https://docs.python.org/3/library/sys.html#sys.modules) will contain entries for `foo`, `foo.bar`, and `foo.bar.baz`. Each key will have as its value the corresponding module object.

During import, the module name is looked up in [`sys.modules`](https://docs.python.org/3/library/sys.html#sys.modules) and if present, the associated value is the module satisfying the import, and the process completes. However, if the value is `None`, then a [`ModuleNotFoundError`](https://docs.python.org/3/library/exceptions.html#ModuleNotFoundError) is raised. If the module name is missing, Python will continue searching for the module.

[`sys.modules`](https://docs.python.org/3/library/sys.html#sys.modules) is writable. Deleting a key may not destroy the associated module (as other modules may hold references to it), but it will invalidate the cache entry for the named module, causing Python to search anew for the named module upon its next import. The key can also be assigned to None, forcing the next import of the module to result in a [`ModuleNotFoundError`](https://docs.python.org/3/library/exceptions.html#ModuleNotFoundError).

Beware though, as if you keep a reference to the module object, invalidate its cache entry in sys.modules, and then re-import the named module, the two module objects will not be the same. By contrast, importlib.reload() will reuse the same module object, and simply reinitialise the module contents by rerunning the module’s code.






