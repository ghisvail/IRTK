#.rst:
# FindLibLBFGS
# ------------
#
# Find LibLBFGS
#
# Find the libLBFGS C library.
#
# This module defines the following CMake variables:
#
# ::
#
#   LibLBFGS_FOUND - whether the library has been found
#   LibLBFGS_INCLUDE_DIRS - location of the public headers
#   LibLBFGS_LIBRARIES - path to the library
#
# This modules accept the following CMake / environment variables:
#
# ::
#
#   LIBLBFGS_ROOT - install location of the library

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
pkg_check_modules(PC_LibLBFGS QUIET liblbfgs)

find_path(LibLBFGS_INCLUDE_DIR
          NAMES "lbfgs.h"
          HINTS ENV LIBLBFGS_ROOT
                ${LIBLBFGS_ROOT}
                ${PC_LibLBFGS_INCLUDEDIR}
                ${PC_LibLBFGS_INCLUDE_DIRS}
          PATH_SUFFIXES "include")

if(LibLBFGS_INCLUDE_DIR AND EXISTS "${LibLBFGS_INCLUDE_DIR}/lbfgs.h")
  file(STRINGS "${LibLBFGS_INCLUDE_DIR}/lbfgs.h" version_comments
       REGEX "^-[\t ]Version[\t ]")
  list(GET version_comments 0 version_comment_latest)
  if(${version_comment_latest} MATCHES "^-[\t ]Version[\t ](.*)[\t ]")
    set(LibLBFGS_VERSION_STRING ${CMAKE_MATCH_1})
  endif()
endif()

find_library(LibLBFGS_LIBRARY
             NAMES "lbfgs"
             HINTS ENV LIBLBFGS_ROOT
                   ${LIBLBFGS_ROOT}
                   ${PC_LibLBFGS_LIBDIR}
                   ${PC_LibLBFGS_LIBRARY_DIRS}
             PATH_SUFFIXES "lib"
                           "lib/${CMAKE_LIBRARY_ARCHITECTURE}")

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(LibLBFGS
                                  FOUND_VAR LibLBFGS_FOUND
                                  REQUIRED_VARS LibLBFGS_LIBRARY
                                                LibLBFGS_INCLUDE_DIR
                                  VERSION_VAR LibLBFGS_VERSION_STRING)

if(LibLBFGS_FOUND)
  set(LibLBFGS_INCLUDE_DIRS ${LibLBFGS_INCLUDE_DIR})
  set(LibLBFGS_LIBRARIES ${LibLBFGS_LIBRARY})
endif()

mark_as_advanced(LibLBFGS_INCLUDE_DIR
                 LibLBFGS_LIBRARY
                 LibLBFGS_VERSION_STRING)