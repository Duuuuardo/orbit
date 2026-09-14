set(po_files
    
)

set(trs_script "${CMAKE_SOURCE_DIR}/scripts/trs.fish")


set(mo_files)
file(MAKE_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/trs")

foreach(po IN LISTS po_files)
    cmake_path(GET po STEM lang)
    set(mo "${CMAKE_CURRENT_BINARY_DIR}/trs/${lang}.mo")

    add_custom_command(
        OUTPUT "${mo}"
        COMMAND "${trs_script}" compile "${lang}" "${mo}"
        DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/${po}" "${trs_script}"
        COMMENT "Compiling translations for ${lang}"
        VERBATIM
    )

    set_source_files_properties("${mo}" PROPERTIES QT_RESOURCE_ALIAS "${lang}.mo")
    list(APPEND mo_files "${mo}")
endforeach()

if(ORBIT_TEST_TRS)
    set(test_mo "${CMAKE_CURRENT_BINARY_DIR}/trs/test.mo")

    add_custom_command(
        OUTPUT "${test_mo}"
        COMMAND "${trs_script}" test "${test_mo}"
        DEPENDS "${trs_script}"
        COMMENT "Generating test translations"
        VERBATIM
    )

    set_source_files_properties("${test_mo}" PROPERTIES QT_RESOURCE_ALIAS "test.mo")
    list(APPEND mo_files "${test_mo}")
endif()

qml_module(orbit-i18n
    URI Orbit.I18n
    INCLUDE_PREFIX i18n
    SOURCES
        translator.cpp
        pluralrules.cpp
    QML_SINGLETONS
        Tr.qml
        Units.qml
    RESOURCES
        ${mo_files}
    LIBRARIES
        orbit-util
        orbit-config
    DEPENDENCIES
        Orbit.Config
)
