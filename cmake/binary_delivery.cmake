include(CMakeParseArguments)

function(binary_delivery)
    set(options QUIET)

    set(oneValueArgs
        PROJ
        URL
        PREFIX
        DOWNLOAD_DIR
        # Prevent it
        INSTALL_DIR
        CMAKE_ARGS
        CONFIGURE_COMMAND
        PATCH_COMMAND
        BUILD_COMMAND
        INSTALL_COMMAND
        UPDATE_COMMAND
        TEST_COMMAND
        )
    set(multiValueArgs "")
    cmake_parse_arguments(BIN_DELIVERY_ARGS "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    if (NOT BIN_DELIVERY_ARGS_PREFIX)
        set(BIN_DELIVERY_ARGS_PREFIX "${CMAKE_BINARY_DIR}")
    endif()

    if (NOT BIN_DELIVERY_ARGS_DOWNLOAD_DIR)
        set(BIN_DELIVERY_ARGS_DOWNLOAD_DIR "${BIN_DELIVERY_ARGS_PREFIX}/${BIN_DELIVERY_ARGS_PROJ}")
    endif()

	get_filename_component(PATH_SELF "${CMAKE_CURRENT_LIST_FILE}" PATH)
	get_filename_component(PATH_SELF "${PATH_SELF}" PATH)

	if (NOT EXISTS "${BIN_DELIVERY_ARGS_PREFIX}/${BIN_DELIVERY_ARGS_PROJ}/cmake")
        configure_file("${PATH_SELF}/cmake/external.CMakeLists.in"
                "${BIN_DELIVERY_ARGS_DOWNLOAD_DIR}.tmp/CMakeLists.txt")

        execute_process(COMMAND ${CMAKE_COMMAND} -G "${CMAKE_GENERATOR}" .
                WORKING_DIRECTORY "${BIN_DELIVERY_ARGS_DOWNLOAD_DIR}.tmp"
                )
        execute_process(COMMAND ${CMAKE_COMMAND} --build .
                WORKING_DIRECTORY "${BIN_DELIVERY_ARGS_DOWNLOAD_DIR}.tmp"
                )

        message(STATUS "${PROJ} dir: ${BIN_DELIVERY_ARGS_PREFIX}/${BIN_DELIVERY_ARGS_PROJ}")
    else()
        message(STATUS "${PROJ} dir: ${BIN_DELIVERY_ARGS_PREFIX}/${BIN_DELIVERY_ARGS_PROJ} already exists")
	endif()
    
    set(${BIN_DELIVERY_ARGS_PROJ}_DIR "${BIN_DELIVERY_ARGS_PREFIX}/${BIN_DELIVERY_ARGS_PROJ}/cmake" PARENT_SCOPE)
endfunction()