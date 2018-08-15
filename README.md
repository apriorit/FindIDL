# FindIDL
cmake module for working with idl

## FindIDL


 This is cmake module which find midl.exe for using in your project
This module adds two functions for ease of use idl.

> function(add_idl idlproject idlfile)

**where** 
*idlproject* - The name of your new new project which will be generated from your idl file
*idlfile* - full path to your idl file

This function create INTERFACE library with name idlproject from idl file.
Look to the  sample below.
	
	find_package(IDL REQUIRED)
    add_executable(${PROJECT_NAME} "main.cpp")
    add_idl(MyCustomIdlProject  ${CMAKE_CURRENT_SOURCE_DIR}/idl/Custom.idl)
    target_link_libraries(${PROJECT_NAME} ${idl_file_name}_gen_idl)

The second function more friendly .
Sample below shows same logic to sample above.

> function(target_link_idl target idlfile)

**where** 
*target* - your own target  
*idlfile* - full path to you idl file

    find_package(IDL REQUIRED)
    add_executable(${PROJECT_NAME} "main.cpp")
    target_link_idl(${PROJECT_NAME} ${CMAKE_CURRENT_SOURCE_DIR}/idl/Custom.idl)






