file(GLOB src "*.h" "*.cpp" "*.def" "*.rc" "*.rgs")

add_library(GreeterLib SHARED ${src})
target_link_libraries(GreeterLib IdlProject)