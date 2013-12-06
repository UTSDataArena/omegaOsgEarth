#download netcdf
set(NETCDF netcdf-4.3.0)
set(NETCDF_TGZ ${NETCDF}.tar.gz)


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
	# Copy the dlls into the target directories
	file(COPY ${EXTLIB_DIR}/bin/ DESTINATION ${CMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG} PATTERN "*.dll")
	file(COPY ${EXTLIB_DIR}/bin/ DESTINATION ${CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELEASE} PATTERN "*.dll")
else()
  if(APPLE)
    ExternalProject_Add(
      netcdf
      URL "https://omegalib.googlecode.com/files/${NETCDF_TGZ}"
      CONFIGURE_COMMAND ""
      BUILD_COMMAND ""
      INSTALL_COMMAND ""
    )
  else()
    ExternalProject_Add(
      hdf5
      URL "http://www.hdfgroup.org/ftp/HDF5/current/src/hdf5-1.8.12.tar.gz"
      CMAKE_ARGS
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DBUILD_SHARED_LIBS=ON
        -DHDF5_BUILD_HL_LIB=ON
        -DCMAKE_INSTALL_PREFIX:PATH=${CMAKE_BINARY_DIR}/modules/omegaOsgEarth/hdf5-prefix/src/hdf5-install
    )

    ExternalProject_Get_Property(hdf5 SOURCE_DIR)

    set(ENV{CPPFLAGS} -I${CMAKE_BINARY_DIR}/modules/omegaOsgEarth/hdf5-prefix/src/hdf5-install/include)
    set(ENV{LDFLAGS} -L${CMAKE_BINARY_DIR}/modules/omegaOsgEarth/hdf5-prefix/src/hdf5-install/lib)
    set(ENV{LD_LIBRARY_PATH} ${CMAKE_BINARY_DIR}/modules/omegaOsgEarth/hdf5-prefix/src/hdf5-install/lib)

    #file(COPY ${CMAKE_BINARY_DIR}/modules/omegaOsgEarth/hdf5-prefix/src/hdf5/hl/src/ DESTINATION ${CMAKE_BINARY_DIR}/modules/omegaOsgEarth/hdf5-prefix/src/hdf5-install/include PATTERN "*.h")

    ExternalProject_Add(
      proj4
      URL "http://download.osgeo.org/proj/proj-4.8.0.tar.gz"
      CONFIGURE_COMMAND <SOURCE_DIR>/configure
      BUILD_IN_SOURCE 1
      INSTALL_COMMAND cp ${CMAKE_BINARY_DIR}/modules/omegaOsgEarth/proj4-prefix/src/proj4/src/.libs/libproj.so ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}
    )

    ExternalProject_Add(
        netcdf
        DEPENDS hdf5 proj4
        URL "http://omegalib.googlecode.com/files/${NETCDF_TGZ}"
        CMAKE_ARGS
          -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
          -DBUILD_SHARED_LIBS=ON
          -DHDF5_DIR:PATH=${CMAKE_BINARY_DIR}/modules/omegaOsgEarth/hdf5-prefix/src/hdf5-build
          -DHDF5_LIBRARIES:PATH=${CMAKE_BINARY_DIR}/modules/omegaOsgEarth/hdf5-prefix/src/hdf5-install/lib/libhdf5.a
          -DHDF5_INCLUDE_DIR=${CMAKE_BINARY_DIR}/modules/omegaOsgEarth/hdf5-prefix/src/hdf5-install/include
          -DHDF5_INCLUDE_DIRS=${CMAKE_BINARY_DIR}/modules/omegaOsgEarth/hdf5-prefix/src/hdf5-install/include
          -DHDF5_LIB=${CMAKE_BINARY_DIR}/modules/omegaOsgEarth/hdf5-prefix/src/hdf5-install/lib/libhdf5.so
          -DHDF5_HL_LIB=${CMAKE_BINARY_DIR}/modules/omegaOsgEarth/hdf5-prefix/src/hdf5-install/lib/libhdf5_hl.so
          -DCMAKE_LIBRARY_OUTPUT_DIRECTORY:PATH=${CMAKE_RUNTIME_OUTPUT_DIRECTORY}
          -DCMAKE_LIBRARY_OUTPUT_DIRECTORY:PATH=${CMAKE_RUNTIME_OUTPUT_DIRECTORY}
        INSTALL_COMMAND ""
      )
  endif()

  set_target_properties(netcdf PROPERTIES FOLDER "modules/omegaOsgEarth")

  ExternalProject_Get_Property(netcdf SOURCE_DIR)
	
  ExternalProject_Add(
		gdal
		DEPENDS netcdf
		URL "http://download.osgeo.org/gdal/1.10.0/gdal-1.10.0.tar.gz"
		CONFIGURE_COMMAND <SOURCE_DIR>/configure --with-netcdf=${CMAKE_BINARY_DIR}/modules/omegaOsgEarth/netcdf-prefix/src/netcdf-build/liblib --prefix=${CMAKE_BINARY_DIR}/modules/omegaOsgEarth/gdal-prefix/src/gdal-install
		BUILD_IN_SOURCE 1
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
