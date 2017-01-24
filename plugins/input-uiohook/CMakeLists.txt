project(input-uiohook)

# libuiohook

if(APPLE)
        #TODO: Force CLANG for OS X because it is required as of OS X 10.10.

        option(USE_COREFOUNDATION "Enable CoreFoundation framework" ON)
        if(USE_COREFOUNDATION)
            find_library(APPLICATIONSERVICES_LIBRARY ApplicationServices)
            if(APPLICATIONSERVICES_LIBRARY)
                    message(STATUS "Found ApplicationServices: ${APPLICATIONSERVICES_LIBRARY}")
                    add_definitions(-DUSE_COREFOUNDATION)
            else()
                    message(FATAL_ERROR "ApplicationServices not found")
            endif()
        endif()

        option(USE_IOKIT "Enable IOKit framework" ON)
        if(USE_IOKIT)
            find_library(IOKIT_LIBRARY IOKit)
            if(IOKIT_LIBRARY)
                    message(STATUS "Found IOKit: ${IOKIT_LIBRARY}")
                    add_definitions(-DUSE_IOKIT)
            else()
                    message(FATAL_ERROR "IOKit not found")
            endif()
        endif()

        option(USE_OBJC "Enable objective-c" ON)
        if(USE_OBJC)
            message(STATUS "Enable objective-c")
            add_definitions(-DUSE_OBJC)
            link_libraries(objc)
        else()
            message(STATUS "Disable objective-c")
        endif()

        option(USE_WEAK_IMPORT "Enable support for weakly-linked symbols" OFF)
        if(USE_WEAK_IMPORT)
            message(STATUS "Enable support for weakly-linked symbols")
            set(CMAKE_SHARED_LIBRARY_CREATE_C_FLAGS "${CMAKE_SHARED_LIBRARY_CREATE_C_FLAGS} -Wl -flat_namespace -undefined dynamic_lookup")
            set(CMAKE_SHARED_LIBRARY_CREATE_CXX_FLAGS "${CMAKE_SHARED_LIBRARY_CREATE_CXX_FLAGS} -Wl -flat_namespace -undefined dynamic_lookup")
            add_definitions(-DUSE_WEAK_IMPORT)
        else()
            message(STATUS "Disable support for weakly-linked symbols")
        endif()

        option(USE_CARBON_LEGACY "Enable Carbon framework legacy functionality" OFF)
        if(USE_CARBON_LEGACY)
            message(STATUS "Enable Carbon framework legacy functionality")
            # FIXME Return error if this is a 64 bit target.
            # Carbon legacy functionality is required for OS X version 10.4 and should only be used on 32-bit targets.
            #add_definitions(-DUSE_CARBON_LEGACY)
        endif()

        # Always add Carbon due to non-deprecated #define's
        find_library(CARBON_LIBRARY Carbon)
        if(CARBON_LIBRARY)
                message(STATUS "Found Carbon: ${CARBON_LIBRARY}")
        else()
                message(FATAL_ERROR "Carbon not found")
        endif()

        set(CMAKE_SHARED_LIBRARY_CREATE_C_FLAGS "${CMAKE_SHARED_LIBRARY_CREATE_C_FLAGS} -Wl -undefined error")
        set(CMAKE_SHARED_LIBRARY_CREATE_CXX_FLAGS "${CMAKE_SHARED_LIBRARY_CREATE_CXX_FLAGS} -Wl -undefined error")

        #find_library(COCOA_LIBRARY Cocoa)
        #if(COCOA_LIBRARY)
        #        message(STATUS "Found Cocoa: ${COCOA_LIBRARY}")
        #else()
        #        message(FATAL_ERROR "Cocoa not found")
        #endif()
endif()

include_directories(libuiohook/include)
include_directories(libuiohook/src)

set(ARCHDIR "")
if(APPLE)
	set(ARCHDIR "darwin")
elseif(WIN32 OR WIN64)
	set(ARCHDIR "windows")
elseif(UNIX)
	set(ARCHDIR "x11")
else()
	message(FATAL_ERROR "Architecture not supported")
endif()

include_directories(src/${ARCHDIR})

file(GLOB LIBUIOHOOK_SOURCES 
    libuiohook/src/logger.c 
    libuiohook/src/${ARCHDIR}/*.c)
file(GLOB LIBUIOHOOK_HEADERS 
    libuiohook/src/*.h 
    libuiohook/src/${ARCHDIR}/*.h 
    libuiohook/include/uiohook.h)
add_library(libuiohook 
    ${LIBUIOHOOK_SOURCES} 
    ${LIBUIOHOOK_HEADERS})

if(APPLE)
    target_link_libraries(libuiohook 
        ${APPLICATIONSERVICES_LIBRARY} 
        ${IOKIT_LIBRARY}
        ${COCOA_LIBRARY}
        ${CARBON_LIBRARY}
)
endif()

# input-uiohook

if(WIN32)
	set(input-uiohook_PLATFORM_SOURCES
		platform-windows.c
)
elseif(APPLE)
	set(input-uiohook_PLATFORM_SOURCES
		platform-osx.m)

	find_package(AppKit REQUIRED)
	set(input-uiohook_PLATFORM_LIBRARIES ${APPKIT_LIBRARIES})

	add_definitions(-fobjc-arc)

elseif(UNIX)
	set(input-uiohook_PLATFORM_SOURCES
		platform-x11.c)

	find_package(XCB COMPONENTS XCB REQUIRED RANDR REQUIRED XINERAMA REQUIRED)
	
	include_directories(
		${XCB_INCLUDE_DIRS}
		${X11_XCB_INCLUDE_DIRS})
		
	add_definitions(
		${XCB_DEFINITIONS}
		${X11_XCB_DEFINITIONS})

	set(input-uiohook_PLATFORM_LIBRARIES
		${XCB_LIBRARIES}
		${X11_XCB_LIBRARIES}
                )
endif()


set(input-uiohook_SOURCES
	${input-uiohook_PLATFORM_SOURCES}
        platform.h
        libuiohook-async-logger.h
        libuiohook-async-logger.c
	input-uiohook.c)

add_library(input-uiohook MODULE
	${input-uiohook_SOURCES})
target_link_libraries(input-uiohook
	${input-uiohook_PLATFORM_LIBRARIES}
	libobs
	libuiohook)

install_obs_plugin_with_data(input-uiohook data)
