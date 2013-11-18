#download netcdf
set(NETCDF netcdf-4.3.0)
set(NETCDF_TGZ ${NETCDF}.tar.gz)


ExternalProject_Add(
  netcdf
  URL "ftp://ftp.unidata.ucar.edu/pub/netcdf/${NETCDF_TGZ}"
  CONFIGURE_COMMAND ""
  BUILD_COMMAND ""
  INSTALL_COMMAND ""
)

set_target_properties(netcdf PROPERTIES FOLDER "modules/omegaOsgEarth")

ExternalProject_Get_Property(netcdf SOURCE_DIR)

if(WIN32)
	# On windows we are lazy. Just download precompiled libs. 
	# This is specific to Visual Studio 2010, Win32.
	# for other versions of GDAL look at http://www.gisinternals.com/sdk/
	# and add a new section here.
	set(EXTLIB_NAME gdal)
	set(EXTLIB_TGZ ${CMAKE_BINARY_DIR}/${EXTLIB_NAME}.tar.gz)
	set(EXTLIB_DIR ${CMAKE_BINARY_DIR}/gdal)
	
	if(NOT EXISTS ${EXTLIB_DIR})
		message(STATUS "Downloading GDAL library")
		file(DOWNLOAD "https://omegalib.googlecode.com/files/gdal.tar.gz" ${EXTLIB_TGZ} SHOW_PROGRESS)
		execute_process(COMMAND ${CMAKE_COMMAND} -E tar xzf ${EXTLIB_TGZ} WORKING_DIRECTORY ${CMAKE_BINARY_DIR})
	endif(NOT EXISTS ${EXTLIB_DIR})
	
	set(GDAL_INCLUDE_DIR ${EXTLIB_DIR}/include CACHE INTERNAL "")
	set(GDAL_LIBRARY  ${EXTLIB_DIR}/lib/gdal_i.lib CACHE INTERNAL "")
	
	# create phony target gdal
	add_custom_target(gdal)
else()
	ExternalProject_Add(
		gdal
		DEPENDS netcdf
		URL "http://download.osgeo.org/gdal/1.10.0/gdal-1.10.0.tar.gz"
		CONFIGURE_COMMAND <SOURCE_DIR>/configure --with-netcdf=${SOURCE_DIR} --prefix=${CMAKE_BINARY_DIR}/modules/omegaOsgEarth/gdal-prefix/src/gdal-install
		BUILD_IN_SOURCE 1
		#    BUILD_COMMAND make
		INSTALL_COMMAND ${PLATFORM_INSTALL_COMMAND}
	)
	ExternalProject_Get_Property(gdal DOWNLOAD_DIR)
	set(GDAL_INCLUDE_DIR ${DOWNLOAD_DIR}/gdal-install/include CACHE INTERNAL "")
	# NOTE: setting the GDAL_INCLUDES as an internal cache variable, makes it accessible to other modules.
	if(APPLE)
		set(LIB_SUFFIX dylib)
	else()
		set(LIB_SUFFIX so)
	endif()

	set(GDAL_LIBRARY  ${DOWNLOAD_DIR}/gdal-install/lib/libgdal.${LIB_SUFFIX} CACHE INTERNAL "")
endif()


set_target_properties(gdal PROPERTIES FOLDER "modules/omegaOsgEarth")
