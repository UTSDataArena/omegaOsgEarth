#download netcdf
set(NETCDF netcdf-4.3.0)
set(NETCDF_TGZ ${NETCDF}.tar.gz)


if(WIN32)
	# On windows we are lazy. Just download precompiled libs. 
	# This is specific to Visual Studio 2010, Win32.
	# for other versions of GDAL look at http://www.gisinternals.com/sdk/
	# and add a new section here.
	set(EXTLIB_NAME gdal)
	set(EXTLIB_TGZ ${CMAKE_BINARY_DIR}/3rdparty/gdal/${EXTLIB_NAME}.tar.gz)
	set(EXTLIB_DIR ${CMAKE_BINARY_DIR}/3rdparty/gdal)
	
	if(NOT EXISTS ${EXTLIB_DIR})
		message(STATUS "Downloading GDAL library")
		file(DOWNLOAD "https://omegalib.googlecode.com/files/gdal.tar.gz" ${EXTLIB_TGZ} SHOW_PROGRESS)
		execute_process(COMMAND ${CMAKE_COMMAND} -E tar xzf ${EXTLIB_TGZ} WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/3rdparty)
	endif(NOT EXISTS ${EXTLIB_DIR})
	
	set(GDAL_INCLUDE_DIR ${EXTLIB_DIR}/include CACHE INTERNAL "")
	set(GDAL_LIBRARY  ${EXTLIB_DIR}/lib/gdal_i.lib CACHE INTERNAL "")
	
	# create phony target gdal
	add_custom_target(gdal)
	# Copy the dlls into the target directories
	file(COPY ${EXTLIB_DIR}/bin/ DESTINATION ${CMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG} PATTERN "*.dll")
	file(COPY ${EXTLIB_DIR}/bin/ DESTINATION ${CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELEASE} PATTERN "*.dll")
else()
    set(GDAL_BASE_DIR ${CMAKE_BINARY_DIR}/3rdparty/gdal)
    if(APPLE)
        set(NETCDF_BASE_DIR ${CMAKE_BINARY_DIR}/3rdparty/netcdf)
        ExternalProject_Add(
            netcdf
            URL "https://omegalib.googlecode.com/files/${NETCDF_TGZ}"
            CONFIGURE_COMMAND ""
            BUILD_COMMAND ""
            INSTALL_COMMAND ""
            
            # directories
            TMP_DIR ${CMAKE_BINARY_DIR}/3rdparty/tmp
            STAMP_DIR ${CMAKE_BINARY_DIR}/3rdparty/stamp
            DOWNLOAD_DIR ${NETCDF_BASE_DIR}
            SOURCE_DIR ${NETCDF_BASE_DIR}/source
            BINARY_DIR ${NETCDF_BASE_DIR}/build
            INSTALL_DIR ${NETCDF_BASE_DIR}/install
        )
    else()
        set(HDF5_BASE_DIR ${CMAKE_BINARY_DIR}/3rdparty/hdf5)
        ExternalProject_Add(
            hdf5
            URL "http://www.hdfgroup.org/ftp/HDF5/releases/hdf5-1.8.14/src/hdf5-1.8.14.tar.gz"
            CMAKE_ARGS
                -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
                -DBUILD_SHARED_LIBS=ON
                -DHDF5_BUILD_HL_LIB=ON
                -DCMAKE_INSTALL_PREFIX:PATH=${HDF5_BASE_DIR}/install
                
            # directories
            TMP_DIR ${CMAKE_BINARY_DIR}/3rdparty/tmp
            STAMP_DIR ${CMAKE_BINARY_DIR}/3rdparty/stamp
            DOWNLOAD_DIR ${HDF5_BASE_DIR}
            SOURCE_DIR ${HDF5_BASE_DIR}/source
            BINARY_DIR ${HDF5_BASE_DIR}/build
            INSTALL_DIR ${HDF5_BASE_DIR}/install
        )

        ExternalProject_Get_Property(hdf5 SOURCE_DIR)

        set(ENV{CPPFLAGS} -I${HDF5_BASE_DIR}/install/include)
        set(ENV{LDFLAGS} -L${HDF5_BASE_DIR}/install/lib)
        set(ENV{LD_LIBRARY_PATH} ${HDF5_BASE_DIR}/install/lib)

        #file(COPY ${CMAKE_BINARY_DIR}/modules/omegaOsgEarth/hdf5-prefix/src/hdf5/hl/src/ DESTINATION ${CMAKE_BINARY_DIR}/modules/omegaOsgEarth/hdf5-prefix/src/hdf5-install/include PATTERN "*.h")

        set(PROJ4_BASE_DIR ${CMAKE_BINARY_DIR}/3rdparty/proj4)
        ExternalProject_Add(
            proj4
            URL "http://download.osgeo.org/proj/proj-4.8.0.tar.gz"
            #URL "http://download.osgeo.org/proj/proj-4.9.0b2.tar.gz"
            CONFIGURE_COMMAND <SOURCE_DIR>/configure --with-jni=no
            BUILD_IN_SOURCE 1
            INSTALL_COMMAND cp ${PROJ4_BASE_DIR}/source/src/.libs/libproj.so ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}
            # directories
            TMP_DIR ${CMAKE_BINARY_DIR}/3rdparty/tmp
            STAMP_DIR ${CMAKE_BINARY_DIR}/3rdparty/stamp
            DOWNLOAD_DIR ${PROJ4_BASE_DIR}
            SOURCE_DIR ${PROJ4_BASE_DIR}/source
            # Do not use this, since we are using BUILD_IN_SOURCE
            #BINARY_DIR ${PROJ4_BASE_DIR}/build
            INSTALL_DIR ${PROJ4_BASE_DIR}/install
        )

        set(NETCDF_BASE_DIR ${CMAKE_BINARY_DIR}/3rdparty/netcdf)
        ExternalProject_Add(
            netcdf
            DEPENDS hdf5 proj4
            URL "http://omegalib.googlecode.com/files/${NETCDF_TGZ}"
            CMAKE_ARGS
                -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
                -DBUILD_SHARED_LIBS=ON
                -DENABLE_DAP=OFF
                -DHDF5_DIR:PATH=${HDF5_BASE_DIR}/build
                -DHDF5_LIBRARIES:PATH=${HDF5_BASE_DIR}/install/lib/libhdf5.a
                -DHDF5_INCLUDE_DIR=${HDF5_BASE_DIR}/install/include
                -DHDF5_INCLUDE_DIRS=${HDF5_BASE_DIR}/install/include
                -DHDF5_LIB=${HDF5_BASE_DIR}/install/lib/libhdf5.so
                -DHDF5_HL_LIB=${HDF5_BASE_DIR}/install/lib/libhdf5_hl.so
                -DCMAKE_LIBRARY_OUTPUT_DIRECTORY:PATH=${CMAKE_RUNTIME_OUTPUT_DIRECTORY}
                -DCMAKE_LIBRARY_OUTPUT_DIRECTORY:PATH=${CMAKE_RUNTIME_OUTPUT_DIRECTORY}
            INSTALL_COMMAND ""
            # directories
            TMP_DIR ${CMAKE_BINARY_DIR}/3rdparty/tmp
            STAMP_DIR ${CMAKE_BINARY_DIR}/3rdparty/stamp
            DOWNLOAD_DIR ${NETCDF_BASE_DIR}
            SOURCE_DIR ${NETCDF_BASE_DIR}/source
            BINARY_DIR ${NETCDF_BASE_DIR}/build
            INSTALL_DIR ${NETCDF_BASE_DIR}/install
          )
    endif()

    set_target_properties(netcdf PROPERTIES FOLDER "3rdparty")

    ExternalProject_Get_Property(netcdf SOURCE_DIR)

    ExternalProject_Add(
        gdal
        DEPENDS netcdf
        URL "http://download.osgeo.org/gdal/1.10.0/gdal-1.10.0.tar.gz"
        CONFIGURE_COMMAND <SOURCE_DIR>/configure --with-netcdf=${CMAKE_BINARY_DIR}/3rdparty/netcdf/build/liblib --prefix=${GDAL_BASE_DIR}/install
        BUILD_IN_SOURCE 1
        INSTALL_COMMAND ${PLATFORM_INSTALL_COMMAND}
        # directories
        TMP_DIR ${CMAKE_BINARY_DIR}/3rdparty/tmp
        STAMP_DIR ${CMAKE_BINARY_DIR}/3rdparty/stamp
        DOWNLOAD_DIR ${GDAL_BASE_DIR}
        SOURCE_DIR ${GDAL_BASE_DIR}/source
        # Do not use this, since we are using BUILD_IN_SOURCE
        #BINARY_DIR ${GDAL_BASE_DIR}/build
        INSTALL_DIR ${GDAL_BASE_DIR}/install
    )
    #ExternalProject_Get_Property(gdal DOWNLOAD_DIR)
    set(GDAL_INCLUDE_DIR ${GDAL_BASE_DIR}/install/include CACHE INTERNAL "")
    # NOTE: setting the GDAL_INCLUDES as an internal cache variable, makes it accessible to other modules.
    if(APPLE)
        set(LIB_SUFFIX dylib)
    else()
        set(LIB_SUFFIX so)
    endif()

    set(GDAL_LIBRARY  ${GDAL_BASE_DIR}/install/lib/libgdal.${LIB_SUFFIX} CACHE INTERNAL "")
endif()


set_target_properties(gdal PROPERTIES FOLDER "3rdparty")
