# Redistribution and use is allowed under the OSI-approved 3-clause BSD license.
# Copyright (c) 2018 Apriorit Inc. All rights reserved.

if(MINGW)
    set(COM_IDL_COMPILER_NAME "widl")
    set(CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH};${CMAKE_CURRENT_LIST_DIR}/thirdparty/cmakeProcessCrashWorkaround")
    include(cmakeProcessCrashWorkaround)
    programCrashWorkaroundInit(widlCrashWorkaround)
else()
    set(COM_IDL_COMPILER_NAME "midl")
    set(COM_IDL_COMPILER_NAME_PATH_HINTS "C:/Program Files*/Microsoft SDKs/Windows/v*/bin/")
endif()

if(NOT DEFINED COM_IDL_COMPILER_PATH OR NOT CACHE{COM_IDL_COMPILER_PATH})
    message(STATUS "Searching for ${COM_IDL_COMPILER_NAME}")
    find_program (
        COM_IDL_COMPILER_PATH
        NAMES "${COM_IDL_COMPILER_NAME}"
        HINTS ${COM_IDL_COMPILER_NAME_PATH_HINTS}
        DOC "COM IDL compiler executable"
        CACHE
        REQUIRED
    )
    set(COM_IDL_COMPILER_PATH "${COM_IDL_COMPILER_PATH}" CACHE FILEPATH "COM IDL compiler executable")
endif()

if(NOT MINGW)
    if(NOT DEFINED CACHE{COM_TLB_COMPILER_PATH})
        find_program (
            COM_TLB_COMPILER_PATH
            NAMES "tlbimp"
            HINTS ${COM_IDL_COMPILER_NAME_PATH_HINTS}
            DOC "COM Type Library compiler executable"
        )
        set(COM_TLB_COMPILER_PATH "${COM_IDL_COMPILER_PATH}" CACHE FILEPATH "COM Type Library compiler executable")
    endif()
endif()

if(NOT COM_IDL_COMPILER_PATH EQUAL "COM_IDL_COMPILER_PATH-NOTFOUND")
    set(IDL_COMPILER_FOUND ON)
else()
    set(IDL_COMPILER_FOUND OFF)
endif()
if(NOT COM_TLB_COMPILER_PATH EQUAL "COM_TLB_COMPILER_PATH-NOTFOUND")
    set(TLB_COMPILER_FOUND ON)
else()
    set(TLB_COMPILER_FOUND OFF)
endif()


function(compile_widl_target_lowlevel file2compile outPath includes enableWinRt additionalFlags varForArtifacts varForBaseName)
    # may crash for some IDLs, https://bugs.winehq.org/show_bug.cgi?id=49772
    get_filename_component(fileDir "${file2compile}" DIRECTORY)
    get_filename_component(fileName "${fileName}" NAME)
    get_filename_component(fileBaseName "${file2compile}" NAME_WLE)
    set(HEADER_NAME "${fileBaseName}.h")
    set(TYPE_LIB_NAME "${fileBaseName}.tbl")
    set(artifacts "${fileDir}/${HEADER_NAME}" "${fileDir}/${TYPE_LIB_NAME}" "${fileDir}/${fileBaseName}_i.c" "${fileDir}/${fileBaseName}_p.c" "${fileDir}/${fileBaseName}_r.rgs")
    file(RELATIVE_PATH idlRelativePath "${CMAKE_CURRENT_BINARY_DIR}" "${file2compile}")
    set(argz "")
    if(enableWinRt)
        list(APPEND argz "--winrt")
    endif()
    if(includes)
        list(JOIN includes ";-I;" otherHeadersDirs)
        list(APPEND argz "-I;${otherHeadersDirs}")
    endif()
    if(outPath)
        list(APPEND argz "--output=${outPath}")
    endif()

    if("${CMAKE_SIZEOF_VOID_P}" EQUAL 4)
        set(bitness "32")
    else()
        set(bitness "64")
    endif()
    list(APPEND argz "-m${bitness}")
    list(APPEND argz "--win${bitness}")

    list(APPEND argz "${additionalFlags}")
    list(APPEND argz "${file2compile}")
    #message(STATUS "argz ${argz}")
    add_custom_command(
        OUTPUT ${artifacts}
        #COMMAND "${COM_IDL_COMPILER_PATH}" ARGS ${argz}  # for now, as a workaround for WIDL crashes
        COMMAND "$<TARGET_FILE:widlCrashWorkaround>" ARGS "${COM_IDL_COMPILER_PATH}" ${argz}
        MAIN_DEPENDENCY "${file2compile}"
        DEPENDS "${file2compile}"
        WORKING_DIRECTORY "${WDK_IDLS_COMPILED}"
        COMMENT "Compiling ${idlRelativePath} with WIDL"
    )
    set("${varForArtifacts}" "${artifacts}" PARENT_SCOPE)
    set("${varForBaseName}" "${fileBaseName}" PARENT_SCOPE)
endfunction()


function(compile_midl_target_lowlevel file2compile outPath includes enableWinRt additionalFlags varForArtifacts varForBaseName)
    get_filename_component(IDL_FILE_NAME_WE "${file2compile}" NAME_WE)
    set(MIDL_OUTPUT "${IDL_FILE_NAME_WE}_i.h")
    add_custom_command(
       OUTPUT "${MIDL_OUTPUT}"
       COMMAND "${COM_IDL_COMPILER_PATH}" ARGS "/${MIDL_ARCH}" "/env" "${MIDL_ARCH}" "/nologo" "${file2compile}" "/out" "${outPath}" ${additionalFlags} "/h" "${MIDL_OUTPUT}"
       DEPENDS "${file2compile}"
       VERBATIM
   )
endfunction()

function(add_idl _target _idlfile)
    get_filename_component(IDL_FILE_NAME_WE "${_idlfile}" NAME_WE)
    set(MIDL_OUTPUT_PATH "${CMAKE_CURRENT_BINARY_DIR}/Generated")
    set(MIDL_OUTPUT "${MIDL_OUTPUT_PATH}/${IDL_FILE_NAME_WE}_i.h")

    if("${CMAKE_SIZEOF_VOID_P}" EQUAL 4)
        set(MIDL_ARCH win32)
    else()
        set(MIDL_ARCH x64)
    endif()

    compile_midl_lowlevel("${_idlfile}" "${MIDL_OUTPUT_PATH}" "" OFF "" varForArtifacts varForBaseName)

    set(FINDIDL_TARGET "${_target}_gen")

    cmake_parse_arguments(FINDIDL "" "TLBIMP" "" "${ARGN}")
 
    if(FINDIDL_TLBIMP)
        
        message(STATUS "Found tlbimp.exe: " "${COM_TLB_COMPILER_PATH}")

        set(TLBIMP_OUTPUT_PATH "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}")

        if("${TLBIMP_OUTPUT_PATH}" STREQUAL "")
            set(TLBIMP_OUTPUT_PATH "${CMAKE_CURRENT_BINARY_DIR}")
        endif()
        
        set(TLBIMP_OUTPUT "${TLBIMP_OUTPUT_PATH}/${FINDIDL_TLBIMP}.dll")

        add_custom_command(
            OUTPUT  "${TLBIMP_OUTPUT}"
            COMMAND "${COM_TLB_COMPILER_PATH}" "${MIDL_OUTPUT_PATH}/${IDL_FILE_NAME_WE}.tlb" "/out:${TLBIMP_OUTPUT}" "${TLBIMP_FLAGS}"
            DEPENDS "${MIDL_OUTPUT_PATH}/${IDL_FILE_NAME_WE}.tlb"
            VERBATIM
            )

        add_custom_target("${FINDIDL_TARGET}" DEPENDS "${MIDL_OUTPUT}" "${TLBIMP_OUTPUT}" SOURCES "${_idlfile}")

        add_library("${FINDIDL_TLBIMP}" SHARED IMPORTED GLOBAL)
        add_dependencies("${FINDIDL_TLBIMP}" "${FINDIDL_TARGET}")

        set_target_properties("${FINDIDL_TLBIMP}"
            PROPERTIES
            IMPORTED_LOCATION "${TLBIMP_OUTPUT}"
            IMPORTED_COMMON_LANGUAGE_RUNTIME "CSharp"
            )
    else()
        add_custom_target("${FINDIDL_TARGET}" DEPENDS "${MIDL_OUTPUT}" SOURCES "${_idlfile}")
    endif()
    
    add_library("${_target}" INTERFACE)
    add_dependencies("${_target}" "${FINDIDL_TARGET}")
    target_include_directories("${_target}" INTERFACE "${MIDL_OUTPUT_PATH}")
endfunction()
