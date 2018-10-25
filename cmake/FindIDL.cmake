file(GLOB MIDL_FILES
    "C:/Program Files*/Windows Kits/*/bin/x86/midl.exe"
)

if(MIDL_FILES)
    list(GET MIDL_FILES -1 MIDL_LATEST_FILE)
endif()

message(STATUS "MIDL_FILES :" ${MIDL_FILES})

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(IDL DEFAULT_MSG MIDL_LATEST_FILE)
mark_as_advanced(IDL)

if (NOT MIDL_LATEST_FILE)
    return()
endif()

function(getTargetPlatformFlag flag)
if(${CMAKE_SIZEOF_VOID_P} EQUAL 4)
    set(${flag} win32 PARENT_SCOPE)
else()
    set(${flag} x64 PARENT_SCOPE)
endif()
endfunction()

function(add_idl idlproject idlfile)
    get_filename_component(idl_file_name ${idlfile} NAME_WE)
    get_filename_component(WorkDir ${idlfile} DIRECTORY)
    set(BinaryPath ${CMAKE_BINARY_DIR}/${idl_file_name}_idl)

    if(NOT (EXISTS ${BinaryPath}  AND IS_DIRECTORY ${BinaryPath}) )
            file(MAKE_DIRECTORY ${BinaryPath})
    endif()

    set(MIDL_OUTPUT ${BinaryPath}/${idl_file_name}_i.h)

    string(REPLACE "/" "\\" BinaryPath ${BinaryPath})
    string(REPLACE "/" "\\" idlfile ${idlfile})

    getTargetPlatformFlag(archflag)

    add_custom_command(
       OUTPUT ${MIDL_OUTPUT}
       COMMAND midl ARGS /${archflag} /env ${archflag} /nologo ${CMAKE_CURRENT_LIST_DIR}/${idlfile} /out ${BinaryPath} ${MIDL_FLAGS} /h ${MIDL_OUTPUT}
       DEPENDS ${CMAKE_CURRENT_LIST_DIR}/${idlfile}
       VERBATIM
       )
     add_custom_target(${idlproject}_gen DEPENDS ${MIDL_OUTPUT} SOURCES ${idlfile})
     add_library(${idlproject} INTERFACE  )
     add_dependencies(${idlproject} ${idlproject}_gen)
     target_include_directories(${idlproject} INTERFACE ${BinaryPath})
endfunction()