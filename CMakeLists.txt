# Open Scene Graph configuration, libraries and applications
request_dependency(omegaOsg)
module_version(1.0.1)

module_version(2.0)

include_directories(.)
include_directories(${OSG_INCLUDES})
include_directories(${OSGEARTH_INCLUDES})

include(external/UseGDAL.cmake)
include(external/UseOsgEarth.cmake)

# Kml loader for the cyclops module
add_library(KmlLoader MODULE KmlLoader.cpp)
target_link_libraries(KmlLoader cyclops ${OSGEARTH_LIBS})
declare_native_module(KmlLoader)

###############################################################################
# Install commands
install(DIRECTORY examples/ DESTINATION omegalib/examples/omegaOsgEarth)
