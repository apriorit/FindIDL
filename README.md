# FindIDL [![Build status](https://ci.appveyor.com/api/projects/status/github/apriorit/FindIDL?svg=true)](https://ci.appveyor.com/project/apriorit/findidl)
Cmake module for working with idl through MIDL

* [Introduction](#introduction)
  * [Requirements](#requirements)
* [Usage](#usage)
  * [find_package()](#find_package)
  * [add_idl()](#add_idl)
  * [MIDL flags](#midl-flags)
* [Samples](#samples) 
* [License](#license) 
* [Version History](#version-history)

# Introduction
FindIDL makes it possible to use MIDL abilities inside CMake.

## Requirements
- [CMake 3.0](https://cmake.org/download/) or higher
- MIDL Compiler

# Usage
## find_package()
Add [FindIDL](https://github.com/apriorit/FindIDL) to the module search path and call `find_package`:
```cmake
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/../cmake")
find_package(IDL REQUIRED)
```
[FindIDL](https://github.com/apriorit/FindIDL) will search for midl.exe

## add_idl()
Takes two arguments: the name of the target project and idl file, possible with full path specified.
```cmake
add_idl(<name> source)
```
Where:
- `<name>` - name of the target project
- `source` - full path to idl file

Example:
```cmake
add_idl(GreeterIDL Greeter.idl)
```

The function makes the same work as MIDL, specifically generates files:
- Greeter_i.h
- Greeter_i.c
- Greeter_p.c
- Greeter.tlb

To use the generated files the idl project should be linked as following
```cmake
target_link_libraries(Main GreeterIDL)
```

## MIDL flags
It is possible to specify MIDL flags, such as midl command line keys.
```cmake
set(MIDL_FLAGS /target NT60)
```
Current can be useful to avoid MIDL2455 error. 

# Samples 
Take a look at the [samples](samples/) folder to see how to use [FindIDL](https://github.com/apriorit/FindIDL).

# License
[Apriorit](http://www.apriorit.com/) released [FindIDL](https://github.com/apriorit/FindIDL) under the OSI-approved 3-clause BSD license. You can freely use it in your commercial or opensource software.

# Version History