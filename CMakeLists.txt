# Open Scene Graph configuration, libraries and applications

request_dependency(omegaOsg)

include_directories(.)
include_directories(${OSG_INCLUDES})
include_directories(${OSGEARTH_INCLUDES})

include(external/UseGDAL.cmake)
include(external/UseOsgEarth.cmake)

###############################################################################
# Install commands
install(DIRECTORY examples/ DESTINATION omegalib/examples/omegaOsgEarth)
