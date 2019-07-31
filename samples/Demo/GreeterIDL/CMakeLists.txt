add_idl(GreeterIDL Greeter.idl)

add_tlbimp(GreeterDLL ${CMAKE_CURRENT_BINARY_DIR}/Generated/Greeter.tlb)
add_dependencies(GreeterDLL GreeterIDL)
#add_dependencies(GreeterDLL ${CMAKE_BINARY_DIR}/GreeterDLL.dll)
#set(GreeterDllLib ${CMAKE_BINARY_DIR}/GreeterDLL.dll)
