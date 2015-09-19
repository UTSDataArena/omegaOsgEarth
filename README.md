omegaOsgEarth
=============

Module for osgEarth in omegalib

## Building Instruction on Linux / Windows
Required dependencies (gdal, proj4 etc) are included in the build process, so omegaOsgEarth will build everything out of the box.

## Building Instruction on  Mac OSX
You will need [HomeBrew](http://mxcl.github.io/homebrew/).

After HomeBrew is installed, run:
```shell
brew install boost pcre proj
```

## Kml/Kmz loading
To add kml/kmz models to your map, you need to register the Kml model loader provided in this module with the scene manager:
```
from KmlLoader import *
getSceneManager().addLoader(KmlLoader())
```

**NOTE** kmz file loading is supported only if zlib/minizip libraries are available on your system.

## Troubleshooting
If running the basic example `examples/chicago_flat.py` does not display a planar map of the Windy City, the osgEarth plugins have not been found or have failed loading. You can set the environment variable `OSG_NOTIFY_LEVEL=DEBUG` and run the example again to get detailed information on the plugin loading process.

### (Linux) Loading fails with message ERROR 6: Unable to load PROJ.4 library
This happens if you already have a PROJ.4 installed on your system and the version is incompatible with the use used by omegaOsgEarth. You can force omegaOsgEarth to load its internal PROJ.4 library by setting the `PROJSO` environment variable. For instance, in a bash shell or in .bashrc:
```
export PROJSO=<path to omegalib build>/bin/libproj.so
```

## Examples
This module contains one basic python example. The cyclops module contains a C++ earth example (see code here: https://github.com/omega-hub/cyclops/tree/master/examples/helloEarth)
If you have the cyclops module installed, that example will build automatically the first time you build omegaOsgEarth.
