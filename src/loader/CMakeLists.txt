# Generated from MacroQuest.vcxproj
# This file is designed to work with add_subdirectory()

# ---------------------------------------------------------------------
# Props file includes
# ---------------------------------------------------------------------
include("../Common.cmake")

# ---------------------------------------------------------------------
# vcpkg dependencies
# ---------------------------------------------------------------------
# crashpad's config (crashpadConfig.cmake) does an unguarded
# add_library(crashpad INTERFACE), so calling find_package(crashpad) a second
# time (src/main already does) fails with "target already exists". Core targets
# are configured before the launcher, so reuse the crashpad target src/main
# created — which also carries the config-aware CRT fix applied there.
if(NOT TARGET crashpad)
    find_package(crashpad REQUIRED)
endif()
find_package(spdlog REQUIRED)
find_package(wil REQUIRED)
find_package(date REQUIRED)
find_package(curl REQUIRED)
find_package(cpr REQUIRED)
find_package(pe-parse REQUIRED)
find_package(protobuf REQUIRED)

# ---------------------------------------------------------------------
# Header files
# ---------------------------------------------------------------------
set(MacroQuest_HEADERS
    "../../include/mq/base/BuildInfo.h"
    "../../include/mq/utils/Markov.h"
    "../../include/mq/utils/Naming.h"
    "LoaderAutoLogin.h"
    "Crashpad.h"
    "ImGui.h"
    "imgui_backend/imgui_engine.h"
    "imgui_backend/imgui_impl_dx11.h"
    "imgui_backend/imgui_impl_win32.h"
    "MacroQuest.h"
    "PostOffice.h"
    "ProcessMonitor.h"
    "resource.h"
    "WinToastLib.h"
)

source_groups("Header Files" ${MacroQuest_HEADERS})

# ---------------------------------------------------------------------
# Other files
# ---------------------------------------------------------------------
set(MacroQuest_OTHERFILES
    "MacroQuest.rc"
)

source_group("Resource Files" FILES ${MacroQuest_OTHERFILES})

# ---------------------------------------------------------------------
# Source files
# ---------------------------------------------------------------------
set(MacroQuest_SOURCES
    "../common/HotKeys.cpp"
    "LoaderAutoLogin.cpp"
    "LoaderAutoLoginImGui.cpp"
    "Crashpad.cpp"
    "ImGui.cpp"
    "imgui_backend/imgui_engine.cpp"
    "imgui_backend/imgui_impl_dx11.cpp"
    "imgui_backend/imgui_impl_win32.cpp"
    "MacroQuest.cpp"
    "PostOffice.cpp"
    "PostOfficeImGui.cpp"
    "ProcessList.cpp"
    "ProcessMonitor.cpp"
    "RemoteOps.cpp"
    "Utility.cpp"
    "WinToastLib.cpp"
)

source_groups("Source Files" ${MacroQuest_SOURCES})

# ---------------------------------------------------------------------
# Target definition
# ---------------------------------------------------------------------
add_executable(MacroQuest
    ${MacroQuest_HEADERS}
    ${MacroQuest_OTHERFILES}
    ${MacroQuest_SOURCES}
)

set_target_properties(MacroQuest PROPERTIES FOLDER "core/applications")

# ---------------------------------------------------------------------
# Apply props file configurations
# ---------------------------------------------------------------------
target_Common_props(MacroQuest)

# ---------------------------------------------------------------------
# Link vcpkg dependencies
# ---------------------------------------------------------------------
target_link_libraries(MacroQuest PRIVATE
    crashpad::crashpad
    spdlog::spdlog
    WIL::WIL
    date::date
    CURL::libcurl
    cpr::cpr
    pe-parse::pe-parse
    protobuf::libprotobuf
)

# ---------------------------------------------------------------------
# Project dependencies
# ---------------------------------------------------------------------
add_dependencies(MacroQuest imgui login routing)

target_link_libraries(MacroQuest PRIVATE imgui login routing)

# ---------------------------------------------------------------------
# Include directories
# ---------------------------------------------------------------------
# crashpad headers come from the crashpad::crashpad target. The old
# ${VCPKG_IncludeStatic}/crashpad entry referenced a variable that no longer
# exists (commented out in Common.cmake), so it expanded to a bogus "/crashpad".
target_include_directories(MacroQuest PRIVATE
    "${CMAKE_SOURCE_DIR}/include"
)

# ---------------------------------------------------------------------
# Compiler options
# ---------------------------------------------------------------------
# NOTE: no /std flag here on purpose — Common.cmake (target_Common_props above)
# sets /std:c++20 for the whole project. A per-target /std:c++17 would override
# it (LanguageStandard wins) and break C++20 usage, as it did on other targets.
target_compile_options(MacroQuest PRIVATE
    "$<$<CONFIG:Release>:/O2>"
    "$<$<CONFIG:Release>:/Oi>"
    "$<$<CONFIG:Release>:/Gy>"
)

# ---------------------------------------------------------------------
# Link libraries
# ---------------------------------------------------------------------
# System libraries. The original vcxproj carried these via the MSBuild
# properties $(LoaderDependenciesDebug/Release); those are not CMake variables,
# so they expanded to empty here and dropped the system libs. The vcpkg/project
# libraries from that list (pe-parse, crashpad, curl, cpr, zlib, fmt, protobuf)
# are already provided by the find_package targets linked above, so only the
# Win32 system libs need to be restored.
target_link_libraries(MacroQuest PRIVATE
    "d3d11.lib"
    "Setupapi.lib"
    "imm32.lib"
    "Secur32.lib"
    "Ws2_32.lib"
    "Wldap32.lib"
    "version.lib"
)

# ---------------------------------------------------------------------
# Linker options
# ---------------------------------------------------------------------
target_link_options(MacroQuest PRIVATE
    "$<$<CONFIG:Release>:/OPT:ICF>"
    "$<$<CONFIG:Release>:/OPT:REF>"
)

# ---------------------------------------------------------------------
# Character set defines
# ---------------------------------------------------------------------
target_compile_definitions(MacroQuest PRIVATE
    "_MBCS"
)

# ============================================================================
# MANUAL CONVERSION NOTES
# ============================================================================
#
# - Review and adjust as needed
