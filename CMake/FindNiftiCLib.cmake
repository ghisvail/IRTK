#.rst:
# FindNiftiCLib
# -------------
#
# Find NiftiCLib
#
# Find the Nifti C libraries.
#
# This module defines the following CMake variables:
#
# ::
#
#   NiftiCLib_FOUND - whether the libraries have been found
#   NiftiCLib_INCLUDE_DIRS - location of the public headers
#   NiftiCLib_LIBRARIES - path to the libraries
#
# This modules accept the following CMake / environment variables:
#
# ::
#
#   NIFTICLIB_ROOT - install location of the libraries

#=============================================================================
# Copyright 2015 Ghislain Antony Vaillant <ghisvail@gmail.com>
#
# Distributed under the OSI-approved BSD License (the "License");
# see accompanying file Copyright.txt for details.
#
# This software is distributed WITHOUT ANY WARRANTY; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the License for more information.
#=============================================================================
# (To distribute this file outside of CMake, substitute the full
#  License text for the above reference.)

find_package(PkgConfig)
pkg_check_modules(PC_NiftiCLib QUIET flann)

find_path(NiftiCLib_INCLUDE_DIR
          NAMES "nifti1.h"
          HINTS ENV NIFTICLIB_ROOT
                ${NIFTICLIB_ROOT}
                ${PC_NiftiCLib_INCLUDEDIR}
                ${PC_NiftiCLib_INCLUDE_DIRS}
          PATH_SUFFIXES "include"
                        "include/nifti")

find_library(NiftiCLib_CDF_LIBRARY
             NAMES "nifticdf"
             HINTS ENV NIFTICLIB_ROOT
                   ${NIFTICLIB_ROOT}
                   ${PC_NiftiCLib_LIBDIR}
                   ${PC_NiftiCLib_LIBRARY_DIRS}
             PATH_SUFFIXES "lib"
                           "lib/${CMAKE_LIBRARY_ARCHITECTURE}")

find_library(NiftiCLib_IO_LIBRARY
             NAMES "niftiio"
             HINTS ENV NIFTICLIB_ROOT
                   ${NIFTICLIB_ROOT}
                   ${PC_NiftiCLib_LIBDIR}
                   ${PC_NiftiCLib_LIBRARY_DIRS}
             PATH_SUFFIXES "lib"
                           "lib/${CMAKE_LIBRARY_ARCHITECTURE}")

find_library(NiftiCLib_ZNZ_LIBRARY
             NAMES "znz"
             HINTS ENV NIFTICLIB_ROOT
                   ${NIFTICLIB_ROOT}
                   ${PC_NiftiCLib_LIBDIR}
                   ${PC_NiftiCLib_LIBRARY_DIRS}
             PATH_SUFFIXES "lib"
                           "lib/${CMAKE_LIBRARY_ARCHITECTURE}")

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(NiftiCLib
                                  FOUND_VAR NiftiCLib_FOUND
                                  REQUIRED_VARS NiftiCLib_IO_LIBRARY
                                                NiftiCLib_CDF_LIBRARY
                                                NiftiCLib_ZNZ_LIBRARY
                                                NiftiCLib_INCLUDE_DIR)

if(NiftiCLib_FOUND)
  set(NiftiCLib_INCLUDE_DIRS ${NiftiCLib_INCLUDE_DIR})
  set(NiftiCLib_LIBRARIES ${NiftiCLib_CDF_LIBRARY}
                          ${NiftiCLib_IO_LIBRARY}
                          ${NiftiCLib_ZNZ_LIBRARY})
endif()

mark_as_advanced(NiftiCLib_INCLUDE_DIR
                 NiftiCLib_CDF_LIBRARY
                 NiftiCLib_IO_LIBRARY
                 NiftiCLib_ZNZ_LIBRARY)