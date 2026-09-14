qml_module(orbit-components
    URI Orbit.Components
    SOURCES
        lazylistview.cpp
        wavyline.cpp
        buttonrow.cpp
        circularindicatormanager.cpp
        linearindicatormanager.cpp
        sparklineitem.cpp
        visualiserbars.cpp
    LIBRARIES
        Qt::Gui
        Qt::Quick
        orbit-core
    DEPENDENCIES
        Orbit
)
