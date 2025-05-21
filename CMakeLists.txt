cmake_minimum_required(VERSION 3.16)

project(swarm_gcs VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTORCC ON)

# ✅ Include required Qt modules
find_package(Qt6 REQUIRED COMPONENTS Quick Network)

qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(appswarm_gcs
    main.cpp
)

# ✅ Clean and correct QML module definition
qt_add_qml_module(appswarm_gcs
    URI swarm_gcs
    VERSION 1.0
    QML_FILES
        Main.qml
        MapView.qml
        SurveillanceLogs.qml
    RESOURCES
        resources.qrc
    SOURCES
        TelemetryReceiver.h
        TelemetryReceiver.cpp
        TelemetryModel.h
        TelemetryModel.cpp
)

# ✅ Target properties for bundle/platform specifics
set_target_properties(appswarm_gcs PROPERTIES
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

# ✅ Link against Quick and Network
target_link_libraries(appswarm_gcs
    PRIVATE Qt6::Quick Qt6::Network
)

include(GNUInstallDirs)
install(TARGETS appswarm_gcs
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
