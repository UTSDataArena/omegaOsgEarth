if(OMEGA_OS_WIN)
    file(INSTALL DESTINATION ${PACKAGE_DIR}/bin
        TYPE FILE
        FILES
            ${BIN_DIR}/cairo.dll
            ${BIN_DIR}/cfitsio.dll
            ${BIN_DIR}/freexl.dll
            ${BIN_DIR}/fribidi.dll
            ${BIN_DIR}/ftgl.dll
            ${BIN_DIR}/gdal110.dll
            ${BIN_DIR}/geos_c.dll
            ${BIN_DIR}/hdf5dll.dll
            ${BIN_DIR}/iconv.dll
            ${BIN_DIR}/libcurl.dll
            ${BIN_DIR}/libeay32.dll
            ${BIN_DIR}/libecwj2.dll
            ${BIN_DIR}/libexpat.dll
            ${BIN_DIR}/libfcgi.dll
            ${BIN_DIR}/libmysql.dll
            ${BIN_DIR}/libpq.dll
            ${BIN_DIR}/libtiff.dll
            ${BIN_DIR}/libxml2.dll
            ${BIN_DIR}/lti_dsdk.dll
            ${BIN_DIR}/lti_lidar_dsdk.dll
            ${BIN_DIR}/mapserver.dll
            ${BIN_DIR}/msvcp100.dll
            ${BIN_DIR}/msvcr100.dll
            ${BIN_DIR}/netcdf.dll
            ${BIN_DIR}/openjp2.dll
            ${BIN_DIR}/openjpeg.dll
            ${BIN_DIR}/osgEarth.dll
            ${BIN_DIR}/osgEarthAnnotation.dll
            ${BIN_DIR}/osgEarthFeatures.dll
            ${BIN_DIR}/osgEarthSymbology.dll
            ${BIN_DIR}/osgEarthUtil.dll
            ${BIN_DIR}/proj.dll
            ${BIN_DIR}/spatialite.dll
            ${BIN_DIR}/sqlite3.dll
            ${BIN_DIR}/ssleay32.dll
            ${BIN_DIR}/xerves_c_2_8.dll
            ${BIN_DIR}/zlib1.dll
        )
        
        # NOTE: we do not copy the osgEarth plugins in the plugin directory because
        # they are already included in the omegaOsg package.
endif()

file(INSTALL DESTINATION ${PACKAGE_DIR}/bin
    TYPE DIRECTORY
    FILES
        ${BIN_DIR}/curl
        ${BIN_DIR}/gdal-data
        ${BIN_DIR}/proj/SHARE
    )
    