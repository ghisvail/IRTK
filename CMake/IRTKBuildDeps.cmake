# The Image Registration Toolkit (IRTK)
#
# Copyright 2008-2015 Imperial College London
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

find_package(Boost 1.48 REQUIRED COMPONENTS math_c99)
include_directories(${Boost_INCLUDE_DIRS})
link_libraries(${Boost_LIBRARIES})

option(WITH_ZLIB "Build with optional support for ZLIB." ON)
if(WITH_ZLIB)
  find_package(ZLIB REQUIRED)
  include_directories(${ZLIB_INCLUDE_DIRS})
  link_libraries(${ZLIB_LIBRARIES})
  add_definitions(-DHAS_ZLIB -DHAVE_ZLIB)
endif()

option(WITH_MATLAB "Build with optional support for MATLAB." OFF)
if(WITH_MATLAB)
  find_package(Matlab REQUIRED)
  include_directories(${MATLAB_LIBRARIES})
  add_definitions(-DHAS_MATLAB -DHAVE_MATLAB)
endif()

option(WITH_VTK "Build with optional support for VTK." OFF)
if(WITH_VTK)
  set(VTK_COMPONENTS vtkCommonCore
                     vtkCommonDataModel
                     vtkCommonExecutionModel
                     vtkFiltersCore
                     vtkFiltersFlowPaths
                     vtkFiltersGeneral
                     vtkFiltersGeometry
                     vtkFiltersParallel
                     vtkImagingStencil
                     vtkIOGeometry
                     vtkIOLegacy
                     vtkIOPLY
                     vtkIOXML)
  find_package(VTK COMPONENTS ${VTK_COMPONENTS} NO_MODULE REQUIRED)
  if("${VTK_VERSION_MAJOR}.${VTK_VERSION_MINOR}" VERSION_LESS 6.0)
    message(FATAL_ERROR "IRTK requires VTK version 6 or later.")
  endif()
  include_directories(${VTK_INCLUDE_DIRS})
  link_libraries(${VTK_LIBRARIES})
  add_definitions(-DHAS_VTK -DHAVE_VTK)
endif()

option(WITH_EIGEN "Build with optional support for Eigen." ON)
if(WITH_EIGEN)
  find_package(Eigen3 REQUIRED)
  if(DEFINED EIGEN3_USE_FILE)
    include(${EIGEN3_USE_FILE})
  else()
    include_directories(${EIGEN3_INCLUDE_DIR})
  endif()
  add_definitions(-DHAS_EIGEN -DHAVE_EIGEN)
endif()

option(WITH_FLANN "Build with optional support for FLANN." OFF)
if(WITH_FLANN)
  find_package(FLANN)
  if(NOT FLANN_FOUND)
    message(STATUS "Optional support for FLANN was requested but the"
            " library was not found. Please verify whether the library is"
            " installed on the system, or specify its location manually using"
            " the FLANN_ROOT CMake or environment variable.")
  endif()
  include_directories(${FLANN_INCLUDE_DIRS})
  link_libraries(${FLANN_LIBRARIES})
  add_definitions(-DHAS_FLANN -DHAVE_FLANN)
endif()

option(WITH_LBFGS "Build with optional support for LBFGS." OFF)
if(WITH_LBFGS)
  find_package(LibLBFGS)
  if(NOT LibLBFGS_FOUND)
    message(STATUS "Optional support for LBFGS was requested but the"
            " library was not found. Please verify whether the library is"
            " installed on the system, or specify its location manually using"
            " the LIBLBFGS_ROOT CMake or environment variable.")
  endif()
  include_directories(${LibLBFGS_INCLUDE_DIRS})
  link_libraries(${LibLBFGS_LIBRARIES})
  add_definitions(-DHAS_LBFGS -DHAVE_LBFGS)
endif()

option(WITH_PNG "Build with optional support for PNG." OFF)
if(WITH_PNG)
  find_package(PNG REQUIRED)
  include_directories(${PNG_INCLUDE_DIRS})
  link_libraries(${PNG_LIBRARIES})
  add_definitions(-DHAS_PNG -DHAVE_PNG)
endif()

option(WITH_NIFTI "Build with optional support for NIFTI." ON)
if(WITH_NIFTI)
  find_package(NiftiCLib)
  if(NOT NiftiCLib_FOUND)
    message(STATUS "Optional support for Nifti was requested but the"
            " library was not found. Please verify whether the library is"
            " installed on the system, or specify its location manually using"
            " the NIFTICLIB_ROOT CMake or environment variable.")
  endif()
  include_directories(${NiftiCLib_INCLUDE_DIRS})
  link_libraries(${NiftiCLib_LIBRARIES})
  add_definitions(-DHAS_NIFTI -DHAVE_NIFTI)
endif()

option(WITH_TBB "Build with optional support for TBB." ON)
if(WITH_TBB)
  find_package(TBB REQUIRED)
  include_directories(${TBB_INCLUDE_DIRS})
  link_directories(${TBB_LIBRARY_DIRS})
  link_libraries(${TBB_LIBRARIES})
  add_definitions(-DHAS_TBB -DHAVE_TBB)
endif()
