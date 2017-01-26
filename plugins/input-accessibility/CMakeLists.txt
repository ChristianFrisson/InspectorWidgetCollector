project(input-accessibility)

if(APPLE)
        set(BUILD_CLI OFF)
        set(BUILD_GUI OFF)
        include_directories(AXRecord)
        add_subdirectory(AXRecord)
        set(input-accessibility_PLATFORM_SOURCES
                platform-osx.m)

        find_package(AppKit REQUIRED)
        set(input-accessibility_PLATFORM_LIBRARIES ${APPKIT_LIBRARIES} libAXRecord)

        add_definitions(-fobjc-arc)
else()
# Currently only Apple is supported
message(FATAL_ERROR "Currently ${PROJECT_NAME} is only supported on macOS")
if(WIN32)
	set(input-accessibility_PLATFORM_SOURCES
		platform-windows.c
)
elseif(UNIX)
	set(input-accessibility_PLATFORM_SOURCES
		platform-x11.c)

	find_package(XCB COMPONENTS XCB REQUIRED RANDR REQUIRED XINERAMA REQUIRED)
	
	include_directories(
		${XCB_INCLUDE_DIRS}
		${X11_XCB_INCLUDE_DIRS})
		
	add_definitions(
		${XCB_DEFINITIONS}
		${X11_XCB_DEFINITIONS})

	set(input-accessibility_PLATFORM_LIBRARIES
		${XCB_LIBRARIES}
		${X11_XCB_LIBRARIES}
                )
endif()
endif()


set(input-accessibility_SOURCES
	${input-accessibility_PLATFORM_SOURCES}
        platform.h
	input-accessibility.c)

add_library(input-accessibility MODULE
	${input-accessibility_SOURCES})
target_link_libraries(input-accessibility
	${input-accessibility_PLATFORM_LIBRARIES}
	libobs)

install_obs_plugin_with_data(input-accessibility data)
