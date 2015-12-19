#.rst:
# FindFLANN
# ---------
#
# Find FLANN
#
# Find the FLANN C++ library.
#
# This module defines the following CMake variables:
#
# ::
#
#   FLANN_FOUND - whether the library has been found
#   FLANN_INCLUDE_DIRS - location of the public headers
#   FLANN_LIBRARIES - path to the library
#
# This modules accept the following CMake / environment variables:
#
# ::
#
#   FLANN_ROOT - install location of the library

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
pkg_check_modules(PC_FLANN QUIET flann)

find_path(FLANN_INCLUDE_DIR
          NAMES "flann.hpp"
          HINTS ENV FLANN_ROOT
                ${FLANN_ROOT}
                ${PC_FLANN_INCLUDEDIR}
                ${PC_FLANN_INCLUDE_DIRS}
          PATH_SUFFIXES "include"
                        "include/flann")

if(FLANN_INCLUDE_DIR AND EXISTS "${FLANN_INCLUDE_DIR}/config.h")
  file(STRINGS "${FLANN_INCLUDE_DIR}/config.h" version_define_str
       REGEX "^#[\t ]*define[\t ]+FLANN_VERSION")
  if(${version_define_str} MATCHES "^#[\t ]*define[\t ]+FLANN_VERSION_[\t ]\"(.*)\"")
    set(FLANN_VERSION_STRING ${CMAKE_MATCH_1})
  endif()
endif()

find_library(FLANN_LIBRARY
             NAMES "flann_cpp"
             HINTS ENV FLANN_ROOT
                   ${FLANN_ROOT}
                   ${PC_FLANN_LIBDIR}
                   ${PC_FLANN_LIBRARY_DIRS}
             PATH_SUFFIXES "lib"
                           "lib/${CMAKE_LIBRARY_ARCHITECTURE}")

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(FLANN
                                  REQUIRED_VARS FLANN_LIBRARY
                                                FLANN_INCLUDE_DIR
                                  VERSION_VAR FLANN_VERSION_STRING)

if(FLANN_FOUND)
  set(FLANN_INCLUDE_DIRS ${FLANN_INCLUDE_DIR})
  set(FLANN_LIBRARIES ${FLANN_LIBRARY})
endif()

mark_as_advanced(FLANN_INCLUDE_DIR
                 FLANN_LIBRARY
                 FLANN_VERSION_STRING)