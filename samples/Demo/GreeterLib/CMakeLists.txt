file(GLOB src "*.h" "*.cpp" "*.def" "*.rc" "*.rgs")

add_library(GreeterLib SHARED ${src})
target_link_libraries(GreeterLib GreeterIDL)

set_target_properties(GreeterLib PROPERTIES COMPILE_FLAGS "/Yustdafx.h")
set_source_files_properties(stdafx.cpp PROPERTIES COMPILE_FLAGS "/Ycstdafx.h")