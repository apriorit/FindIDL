add_executable(MainWithTLBIMP "main.cs")

add_dependencies(MainWithTLBIMP GreeterDLLWithTLBIMP)
#target_link_libraries(MainWithTLBIMP GreeterDLLWithTLBIMP)

set_property(TARGET MainWithTLBIMP PROPERTY VS_DOTNET_REFERENCES
    #GreeterDLL
    #GreeterDLLWithTLBIMP
    "${CMAKE_BINARY_DIR}/GreeterDLLWithTLBIMP.dll"
    #"System"
    ) 