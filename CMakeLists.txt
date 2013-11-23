# Open Scene Graph configuration, libraries and applications

request_dependency(omegaOsg)

#set(_OMEGA_OSG_ENABLE_COLLADA_DOM true CACHE INTERNAL "")

#include(${CMAKE_SOURCE_DIR}/modules/omegaOsg/external/UseOpenSceneGraph.cmake)
include_directories(.)
include_directories(${OSG_INCLUDES})
#add_subdirectory(src)
#add_subdirectory(apps/osgviewer)

include(external/UseGDAL.cmake)
include(external/UseOsgEarth.cmake)
include_directories(${OSGEARTH_INCLUDES})

#add_subdirectory(apps/osgbCollision)
#add_subdirectory(apps/osgbBasicDemo)
#add_subdirectory(apps/osgbDice)
#add_subdirectory(apps/osgbSlider)

#if(OMEGA_USE_PORTHOLE)
#	add_subdirectory(${CMAKE_SOURCE_DIR}/examples/portholeCustomDraw ${CMAKE_BINARY_DIR}/examples/portholeCustomDraw)
#endif()

###############################################################################
# Install commands
# osgworks
if(${OMEGA_INSTALL_DEVLIBS})
    #install(DIRECTORY ${CMAKE_BINARY_DIR}/src/osgWorks-prefix/src/osgWorks-build/lib/ DESTINATION omegalib/lib)
endif()
