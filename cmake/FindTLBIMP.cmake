# Redistribution and use is allowed under the OSI-approved 3-clause BSD license.
# Copyright (c) 2019 Apriorit Inc. All rights reserved.

file(GLOB TLBIMPv7_FILES "C:/Program Files*/Microsoft SDKs/Windows/v7*/bin/TlbImp.exe") 
file(GLOB TLBIMPv8_FILES "C:/Program Files*/Microsoft SDKs/Windows/v8*/bin/*/TlbImp.exe")
file(GLOB TLBIMPv10_FILES "C:/Program Files*/Microsoft SDKs/Windows/v10*/bin/*/TlbImp.exe")

list(APPEND TLBIMP_FILES ${TLBIMPv7_FILES} ${TLBIMPv8_FILES} ${TLBIMPv10_FILES})
    
if(TLBIMP_FILES)
    list(GET TLBIMP_FILES -1 TLBIMP_FILE)
endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(TLBIMP REQUIRED_VARS TLBIMP_FILE)

if (NOT TLBIMP_FILE)
    return()
endif()

message(STATUS "Found TlbImp: " ${TLBIMP_FILE})

set(PATH ${CMAKE_RUNTIME_OUTPUT_DIRECTORY})
if ("${PATH}" STREQUAL "")
    set(PATH ${CMAKE_BINARY_DIR})
endif()

function(add_tlbimp _target _tlbfile)
    add_custom_command(
       OUTPUT  ${PATH}/${_target}.dll
       COMMAND ${TLBIMP_FILE} "${_tlbfile}" "/out:${PATH}/${_target}.dll"
       DEPENDS ${_tlbfile}
       VERBATIM
       )

    add_custom_target(${_target} DEPENDS ${_target}.dll)
endfunction()