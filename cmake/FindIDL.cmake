# Redistribution and use is allowed under the OSI-approved 3-clause BSD license.
# Copyright (c) 2018 Apriorit Inc. All rights reserved.

file(GLOB MIDL_FILES
    "C:/Program Files*/Windows Kits/*/bin/x86/midl.exe"
)

if(MIDL_FILES)
    list(GET MIDL_FILES -1 MIDL_LATEST_FILE)
endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(IDL DEFAULT_MSG MIDL_LATEST_FILE)
mark_as_advanced(IDL)

if (NOT MIDL_LATEST_FILE)
    return()
endif()

message(STATUS "MIDL: " ${MIDL_LATEST_FILE})

function(get_target_platform_flag flag)
if(${CMAKE_SIZEOF_VOID_P} EQUAL 4)
    set(${flag} win32 PARENT_SCOPE)
else()
    set(${flag} x64 PARENT_SCOPE)
endif()
endfunction()

function(add_idl idlproject idlfile)
    get_filename_component(IDL_FILE_NAME ${idlfile} NAME_WE)
    set(BINARY_PATH ${CMAKE_BINARY_DIR}/${IDL_FILE_NAME}_idl)

    if(NOT (EXISTS ${BINARY_PATH} AND IS_DIRECTORY ${BINARY_PATH}))
        file(MAKE_DIRECTORY ${BINARY_PATH})
    endif()

    set(MIDL_OUTPUT ${BINARY_PATH}/${IDL_FILE_NAME}_i.h)

    get_target_platform_flag(ARCH_FLAG)

    add_custom_command(
       OUTPUT ${MIDL_OUTPUT}
       COMMAND midl ARGS /${ARCH_FLAG} /env ${ARCH_FLAG} /nologo ${CMAKE_CURRENT_LIST_DIR}/${idlfile} /out ${BINARY_PATH} ${MIDL_FLAGS} /h ${MIDL_OUTPUT}
       DEPENDS ${CMAKE_CURRENT_LIST_DIR}/${idlfile}
       VERBATIM
       )

    add_custom_target(${idlproject}_gen DEPENDS ${MIDL_OUTPUT} SOURCES ${idlfile})
    add_library(${idlproject} INTERFACE  )
    add_dependencies(${idlproject} ${idlproject}_gen)
    target_include_directories(${idlproject} INTERFACE ${BINARY_PATH})
endfunction()