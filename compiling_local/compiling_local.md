# Building Swiftest from source

First, clone the Swiftest repository and enter the directory:

```bash
git clone https://github.com/MintonGroup/swiftest.git
cd swiftest
```
## Installing Dependencies using the Buildscripts

The Swiftest project contains a set of build scripts that can be used to help build the dependencies required to build Swiftest. These scripts are used to build the official Swiftest Python wheels using cibuildwheel. In addition, we have also included a pair of scripts that will set environment variables for Linux or MacOS.

For Linux, ensure that the following dependencies are installed

- doxygen
- libxml2 (development version)
- libcurl (development version)
- fftw (static version)
- openblas (development version)
- lapack (development version)
- cmake
- ninja-build
- gfortran
- graphviz

These dependencies can be installed on a RedHat based system by running
the following commands from the command line.

``` bash
sudo yum install epel-release 
sudo yum install doxygen libxml2-devel libcurl-devel fftw-static openblas-static openmpi-devel lapack-devel cmake ninja-build gcc-gfortran openmpi-devel graphviz
```

On a Debian based system, the dependencies can be installed by running
the following commands from the command line

``` bash
sudo apt-get install doxygen libxml2-dev libcurl4-openssl-dev libfftw3-dev libopenblas-dev liblapack-dev cmake ninja-build gfortran libopenmpi-dev graphviz
```

On a MacOS system, be sure homebrew is installed.

``` bash
brew install coreutils
```

## Installing dependencies

The most important dependency needed by Swiftest is netcdf-fortran. However, netcdf-fortran requires netcdf (which requires HDF5, and so on). netcdf-fortran must be compiled using the same compiler that builds Swiftest in order that the `.mod` files are compatible. On MacOS systems, the version of netcdf-fortran available in Homebrew satisfies this condition, as long as you also use `gfortran` from homebrew. Therefore on MacOS systems, you can simply use the Homebrew versions of things:

```bash
brew install gfortran netcdf-fortran
```

However, if you need to build netcdf-fortran (and its chain of dependencies) manually, we provide a comprehensive dependency-building script called `build_dependencies.sh`. We also provide a script that can be used to set environment variables prior to building the dependencies called `set_environment.sh`. Building the dependencies can be done by running the following command from the command line

``` bash
. buildscripts/set_environment.sh
buildscripts/build_dependencies.sh
```

Note that the above scripts will use gfortran to build the dependencies.  If you wish to use the Intel Fortran Compiler, you will need to modify the build scripts to use the Intel Fortran Compiler.

## Building the Swiftest Python Package and Executable

Once dependencies are installed, you can install the Swiftest Python package and the Swiftest executable into an active Python environment by running the following command from the command line:

``` bash
pip install .
```

Or, alternatively, if you wish to install an editable version, be sure
that you have the build dependencies installed in your Python
environment:

``` bash
pip install scikit-build-core cython numpy setuptools setuptools_scm
```

Then build and install the editable version:

``` bash
pip install --no-build-isolation -ve .
```

You can test your installation using pytest. Be sure it is first
installed into your Python environment:

``` bash
pip install pytest
```

Then run the tests from the topmost directory in your Swiftest
repository:

``` bash
python -m pytest tests
```

## Building the executable using CMake

Although Swiftest is designed to be run from Python, it is also possible
to run Swiftest simulations from the command line using the `swiftest`
executable, provided it has an initial conditions file and a
configuration parameter file, which are typically generated using the
Python package.

The `swiftest` is compiled through [CMake](https://cmake.org/).
Compiling with CMake has a number of benefits that provide a streamlined
experience for the Swiftest user and developer. At compilation, CMake
will automatically select the set of flags that are compatible with the
local compiler. CMake also allows a Swiftest developer to re-compile
only the files that have been edited, instead of requiring the developer
to re-compile the entire Swiftest program. Please visit the CMake
website for more information on how to install CMake.

As mentioned in the **System Requirements** section, Swiftest requires
the NetCDF and NetCDF Fortran libraries to be installed prior to
compilation. If the libraries are installed in the standard library
location on your machine, CMake should be able to find the libraries
without specifying the path. However, if CMake struggles to find the
NetCDF libraries, there are two ways to set the path to these libraries.

1.  Create an environment variable called `NETCDF_FORTRAN_HOME` that
    contains the path to the location where the libraries are installed
2.  Set the path at the build step using
    `-CMAKE_PREFIX_PATH=/path/to/netcdf/`

CMake allows the user to specify a set of compiler flags to use during
compilation. We define five sets of compiler flags: release, testing,
profile, math, and debug. To view and/or edit the flags included in each
set, see `swiftest/cmake/Modules/SetFortranFlags.cmake`.

As a general rule, the release flags are fully optimized and best used
when running Swiftest with the goal of generating results. This is the
default set of flags. When making changes to the Swiftest source code,
it is best to compile Swiftest using the debug set of flags. You may
also define your own set of compiler flags.

Navigate to the topmost directory in your Swiftest repository. It is
best practice to create a `build` directory in your topmost directory
from which you will compile Swiftest. This way, temporary CMake files
will not clutter up the `swiftest/src/` sub-directories. The commands to
build the source code into a `build` directory and compile Swiftest are

``` bash
cmake -B build -S . -G Ninja
cmake --build build -j8
```

You may omit the `-G Ninja` flag if you do not have the Ninja build
system installed. The `-j8` flag is used to specify the number of
threads to use during compilation.

The [CMake Fortran
template](https://github.com/SethMMorton/cmake_fortran_template) comes
with a script that can be used to clean out any build artifacts and
start from scratch

``` bash
cmake -P distclean.cmake
```

The Swiftest CMake configuration comes with several customization
options:

| Option  | CMake command | Default value |
| ------- | ------------- | ------------- | 
| Build type                      | -DCMAKE_BUILD_TYPE=[RELEASE\|DEBUG\|TESTING\|PROFILE] | RELEASE   |
| Enable/Disable OpenMP support   | -DUSE_OPENMP=[ON\|OFF]                                | ON        | 
| Enable/Disable SIMD  directives | -DUSE_SIMD=[ON\|OFF]                                  | ON        |
| Enable/Disable Coarray support (experimental) | -DUSE_COARRAY=[ON\|OFF]                 | OFF       |
| Set Fortran compiler path       |  -DCMAKE_Fortran_COMPILER=/path/to/fortran/compiler   | ${FC}     |
| Set path to make program        |-DCMAKE_MAKE_PROGRAM=/path/to/make                     | ${PATH}   |
! Enable/Disable shared libraries (Intel only)  |      -DBUILD_SHARED_LIBS=[ON\|OFF]      | ON        |
| Add additional include path     |-DCMAKE_Fortran_FLAGS="-I/path/to/libraries"           | None      |
| Install prefix                  | -DCMAKE_INSTALL_PREFIX="/path/to/install"             | /usr/local |

To see a list of all possible options available to CMake

``` bash
cmake -B build -S . -LA
```

The Swiftest executable, called `swiftest` as well as the shared
library, either `libswiftest.so` or `libswiftest.dylib`, depending on
your platform, should now be created in the `build/bin/` directory. You
can also install the it into your system by running

``` bash
cmake --install build
```

You may need to run the above command as root or with sudo if you are installing into a system directory.

