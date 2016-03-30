# Open Scene Graph configuration, libraries and applications
request_dependency(omegaOsg)
module_version(3.1)

include(external/UseGDAL.cmake)
include(external/UseOsgEarth.cmake)

include_directories(.)
include_directories(${OSG_INCLUDES})
include_directories(${OSGEARTH_INCLUDES})

# Kml loader for the cyclops module
if(MODULES_cyclops)
    add_library(KmlLoader MODULE KmlLoader.cpp)
    target_link_libraries(KmlLoader cyclops ${OSGEARTH_LIBS})
    declare_native_module(KmlLoader)
endif()

###############################################################################
# Install commands
install(DIRECTORY examples/ DESTINATION omegalib/examples/omegaOsgEarth)
