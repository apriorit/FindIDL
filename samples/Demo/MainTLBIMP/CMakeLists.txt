add_executable(MainTLBIMP "main.cs")

add_dependencies(MainTLBIMP GreeterDLL)

set_property(TARGET MainTLBIMP PROPERTY VS_DOTNET_REFERENCES
    #GreeterDLL
    "${CMAKE_BINARY_DIR}/GreeterDLL.dll"
    "System"
    )