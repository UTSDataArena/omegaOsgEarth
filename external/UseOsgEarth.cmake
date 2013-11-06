# Add external project osgBullet
# Pro Trick here: we can't pass the string directly as a CMAKE_ARG in 
# ExternalProject_Add, because it would keep the double quotes, and we
# do not want them. Passing it as a variable removes the dobule quotes.
#set(BulletInstallType "Source And Build Tree")
#set(OsgInstallType "Source And Build Tree")

# The OSGWORKS_STATIC preprocessor definition tells osgBullet that
# we are using the static version of osgWorks.
set(OSGEARTH_GENERATOR ${CMAKE_GENERATOR})

set(OSGEARTH_ARGS
     -DCMAKE_CXX_FLAGS:STRING=${OSGEARTH_CXX_FLAGS}
	   -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
     -DCMAKE_RUNTIME_OUTPUT_DIRECTORY:PATH=${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/osg/osgPlugins-3.3.0
     -DCMAKE_RUNTIME_OUTPUT_DIRECTORY:PATH=${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/osg/osgPlugins-3.3.0
     -DCMAKE_LIBRARY_OUTPUT_DIRECTORY:PATH=${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/osg/osgPlugins-3.3.0
     -DCMAKE_LIBRARY_OUTPUT_DIRECTORY:PATH=${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/osg/osgPlugins-3.3.0
     -DCMAKE_ARCHIVE_OUTPUT_DIRECTORY:PATH=${CMAKE_ARCHIVE_OUTPUT_DIRECTORY}/osg/osgPlugins-3.3.0
     -DCMAKE_ARCHIVE_OUTPUT_DIRECTORY:PATH=${CMAKE_ARCHIVE_OUTPUT_DIRECTORY}/osg/osgPlugins-3.3.0
     -DOSGEARTH_USE_QT=OFF
     -DOSG_DIR:PATH=${OSG_INSTALL_DIR}
     -DGDAL_INCLUDE_DIR=${GDAL_INCLUDE_DIR}
     -DGDAL_LIBRARY=${GDAL_LIBRARY}
)
   
if(WIN32)
    set(OSGEARTH_ARGS
        -DCMAKE_SHARED_LINKER_FLAGS:STRING="${CMAKE_SHARED_LINKER_FLAGS} /NODEFAULTLIB:msvcprt.lib /NODEFAULTLIB:libcpmt.lib"
		-DCMAKE_LINKER_FLAGS:STRING="${CMAKE_LINKER_FLAGS} /NODEFAULTLIB:libcpmt.lib /NODEFAULTLIB:msvcprt.lib"
        ${OSGEARTH_ARGS}
    )
endif(WIN32)

ExternalProject_Add(
    osgearth
    DEPENDS osg gdal
    GIT_REPOSITORY https://github.com/gwaldron/osgearth.git
    CMAKE_GENERATOR ${OSGEARTH_GENERATOR}
    CMAKE_ARGS
        ${OSGEARTH_ARGS}
    INSTALL_COMMAND ""
)

set_target_properties(osgearth PROPERTIES FOLDER "3rdparty")

#set(OSGEARTH_BASE_DIR ${CMAKE_BINARY_DIR}/modules/omegaOsgEarth/osgearth-prefix/src)
# NOTE: setting the OSGEARTH_INCLUDES as an internal cache variable, makes it accessible to other modules.
#set(OSGEARTH_INCLUDES ${OSGEARTH_INCLUDES} ${OSGEARTH_BASE_DIR}/osgEarth/include CACHE INTERNAL "")

#set(OSGEARTH_LIB_DIR ${OSGEARTH_BASE_DIR}/osgearth-build/lib)

#include_directories(${OSG_INCLUDES})
