#download netcdf
set(NETCDF netcdf-4.3.0)
set(NETCDF_TGZ ${NETCDF}.tar.gz)

if(NOT EXISTS ${CMAKE_BINARY_DIR}/modules/omegaOsgEarth/${NETCDF_TGZ})
  file(DOWNLOAD ftp://ftp.unidata.ucar.edu/pub/netcdf/${NETCDF_TGZ} ${CMAKE_BINARY_DIR}/modules/omegaOsgEarth/${NETCDF_TGZ} SHOW_PROGRESS)
endif()

if(NOT EXISTS ${CMAKE_BINARY_DIR}/modules/omegaOsgEarth/${NETCDF})
  execute_process(COMMAND ${CMAKE_COMMAND} -E tar xzvf ${NETCDF_TGZ} WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/modules/omegaOsgEarth)
endif()

ExternalProject_Add(
    gdal
    URL "http://download.osgeo.org/gdal/1.10.1/gdal-1.10.1.tar.gz"
    CONFIGURE_COMMAND <SOURCE_DIR>/configure --with-netcdf=${CMAKE_BINARY_DIR}/modules/omegaOsgEarth/${NETCDF} --prefix=${CMAKE_BINARY_DIR}/modules/omegaOsgEarth/gdal-prefix/src/gdal-install
    #PREFIX ${CMAKE_BINARY_DIR}/modules/omegaOsgEarth/gdal-prefix/src/gdal
    BUILD_IN_SOURCE 1
    BUILD_COMMAND make
    #BUILD_COMMAND make -C <SOURCE_DIR>
    INSTALL_COMMAND make install
)

#set_target_properties(osgearth PROPERTIES FOLDER "3rdparty")

set(GDAL_INCLUDE_DIR ${CMAKE_BINARY_DIR}/modules/omegaOsgEarth/gdal-prefix/src/gdal-install/include CACHE INTERNAL "")
# NOTE: setting the GDAL_INCLUDES as an internal cache variable, makes it accessible to other modules.
if(APPLE)
    set(LIB_SUFFIX dylib)
else()
    set(LIB_SUFFIX so)
endif()

set(GDAL_LIBRARY  ${CMAKE_BINARY_DIR}/modules/omegaOsgEarth/gdal-prefix/src/gdal-install/lib/libgdal.${LIB_SUFFIX} CACHE INTERNAL "")

#set(GDAL_LIB_DIR ${GDAL_BASE_DIR}/osgearth-build/lib)

#include_directories(${OSG_INCLUDES})
