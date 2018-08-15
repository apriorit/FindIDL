find_program(MSIDL
    NAMES midl
    DOC "The midl executable"
)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(IDL DEFAULT_MSG MSIDL)
mark_as_advanced(IDL)

function(getTargetPlatformFlag flag)
if(${CMAKE_SIZEOF_VOID_P} EQUAL 4)
    set(${flag} win32 PARENT_SCOPE)
else()
    set(${flag} x64 PARENT_SCOPE)
endif()
endfunction()

# idlproject     project name for INTERFACE library which will be generateding from idl file
# idlfile        the file which use for code generation

function(add_idl idlproject idlfile)
    get_filename_component(idl_file_name ${idlfile} NAME_WE)
    get_filename_component(WorkDir ${idlfile} DIRECTORY)
    set(BinaryPath ${CMAKE_BINARY_DIR}/${idl_file_name}_idl)

    if(NOT (EXISTS ${BinaryPath}  AND IS_DIRECTORY ${BinaryPath}) )
            file(MAKE_DIRECTORY ${BinaryPath})
    endif()

    set(InterfaceDir ${BinaryPath})
    set(filenamePrefix ${BinaryPath}/${idl_file_name})
    set(output_files ${filenamePrefix}.h)

    string(REPLACE "/" "\\" BinaryPath ${BinaryPath})
    string(REPLACE "/" "\\" idlfile ${idlfile})

    set(output_h ${filenamePrefix}.h)


    getTargetPlatformFlag(archflag)

    message(STATUS "${CommandParams}")
    add_custom_command(
       OUTPUT ${output_files}
       COMMAND midl ARGS /${archflag} /env ${archflag} /nologo ${idlfile} /out ${BinaryPath} /h ${output_h}
       WORKING_DIRECTORY ${WorkDir}
       DEPENDS ${idlfile}
       VERBATIM
       )
     add_custom_target(${idlproject}_gen DEPENDS ${output_files})
     add_library(${idlproject} INTERFACE  )
     add_dependencies(${idlproject} ${idlproject}_gen)
     target_include_directories(${idlproject} INTERFACE ${InterfaceDir})
endfunction()

# target the target which depend on this idl file
# idlfile the file which use for code generation

function(target_link_idl target idlfile)
    get_filename_component(idl_file_name ${idlfile} NAME_WE)
    add_idl(${idl_file_name}_gen_idl ${idlfile})
    add_dependencies(${target} ${idl_file_name}_gen_idl)
    target_link_libraries(${target} ${idl_file_name}_gen_idl)
endfunction()
