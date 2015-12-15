/* The Image Registration Toolkit (IRTK)
 *
 * Copyright 2008-2015 Imperial College London
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License. */

#ifndef _IRTKCXXLIBRARY_H
#define _IRTKCXXLIBRARY_H


// =============================================================================
// Common C/C++ includes
// =============================================================================

// C++ header files
#include <iostream>
#include <iomanip>
#include <fstream>
#include <complex>
#include <random>
#include <algorithm>
#include <string>
#include <limits>
#include <memory>
#include <map>
#include <set>
#include <vector>
#include <typeinfo>
#include <cctype>

// C header files
//#include <stdio.h>
//#include <stdlib.h>
//#include <limits.h>
//#include <float.h>
//#include <math.h>
//#include <string.h>
#include <cstring>
//#include <assert.h>

// C++11 standard
//#ifdef NULL
//#  undef NULL
//#endif
//#include "nullptr.h" // C++11 std::nullptr or own definition for C++03
//#define NULL nullptr


// Use standard namespace


// =============================================================================
// Swap bytes
// =============================================================================

void swap16(char *, char *, long);
void swap32(char *, char *, long);
void swap64(char *, char *, long);

// =============================================================================
// Custom string/stream functions
// =============================================================================

/// General routine to read float from a file stream
int ReadInt(std::ifstream &);

/// General routine to read float from a file stream
float ReadFloat(std::ifstream &);

/// General routine to read list of char (string) from a file stream
char *ReadString(std::ifstream &);

/// Convert string to numeric value
template <typename T>
bool FromString(const char *str, T &value)
{
  if (str == NULL || str[0] == '\0') return false;
  std::istringstream is(str);
  return !(is >> value).fail() && is.eof();
}

/// Convert string to numeric value
template <typename T>
bool FromString(const std::string &s, T &value)
{
  return FromString(s.c_str(), value);
}

/// Convert string to boolean value
template <>
inline bool FromString(const char *str, bool &value)
{
  if (std::strcmp(str, "yes") == 0 || std::strcmp(str, "Yes") == 0 || std::strcmp(str, "YES") == 0) {
    value = true;
    return true;
  } else if (std::strcmp(str, "no") == 0 || std::strcmp(str, "No") == 0 || std::strcmp(str, "NO") == 0) {
    value = false;
    return true;
  } else if (std::strcmp(str, "true") == 0 || std::strcmp(str, "True") == 0 || std::strcmp(str, "TRUE") == 0) {
    value = true;
    return true;
  } else if (std::strcmp(str, "false") == 0 || std::strcmp(str, "False") == 0 || std::strcmp(str, "FALSE") == 0) {
    value = false;
    return true;
  } else if (std::strcmp(str, "on") == 0 || std::strcmp(str, "On") == 0 || std::strcmp(str, "ON") == 0) {
    value = true;
    return true;
  } else if (std::strcmp(str, "off") == 0 || std::strcmp(str, "Off") == 0 || std::strcmp(str, "OFF") == 0) {
    value = false;
    return true;
  } else {
    std::istringstream is(str);
    return !(is >> value).fail() && is.eof();
  }
}

/// Convert string to float value
template <>
inline bool FromString(const char *str, float &value)
{
  if (std::strcmp(str, "nan") == 0 || std::strcmp(str, "NaN") == 0) {
    value = std::numeric_limits<float>::quiet_NaN();
    return true;
  } else if (std::strcmp(str, "-inf") == 0 || std::strcmp(str, "-Inf") == 0) {
    value = -std::numeric_limits<float>::infinity();
    return true;
  } else if (std::strcmp(str, "+inf") == 0 || std::strcmp(str, "inf") == 0 || std::strcmp(str, "+Inf") == 0 || std::strcmp(str, "Inf") == 0) {
    value = +std::numeric_limits<float>::infinity();
    return true;
  } else {
    std::istringstream is(str);
    return !(is >> value).fail() && is.eof();
  }
}

/// Convert string to double value
template <>
inline bool FromString(const char *str, double &value)
{
  if (std::strcmp(str, "nan") == 0 || std::strcmp(str, "NaN") == 0) {
    value = std::numeric_limits<double>::quiet_NaN();
    return true;
  } else if (std::strcmp(str, "-inf") == 0 || std::strcmp(str, "-Inf") == 0) {
    value = -std::numeric_limits<double>::infinity();
    return true;
  } else if (std::strcmp(str, "+inf") == 0 || std::strcmp(str, "inf") == 0 || std::strcmp(str, "+Inf") == 0 || std::strcmp(str, "Inf") == 0) {
    value = +std::numeric_limits<double>::infinity();
    return true;
  } else {
    std::istringstream is(str);
    return !(is >> value).fail() && is.eof();
  }
}

/// Convert numeric value to string
template <typename T>
std::string ToString(const T &value, int w = 0, char c = ' ', bool left = false)
{
  std::ostringstream os;
  os.fill(c);
  if (left) os << std::left;
  else      os << std::right;
  os << std::setw(w) << value;
  return os.str();
}

/// Convert boolean value to string
template <>
inline std::string ToString(const bool &value, int w, char c, bool left)
{
  std::ostringstream os;
  os.fill(c);
  if (left) os << std::left;
  else      os << std::right;
  os << std::setw(w) << (value ? "Yes" : "No");
  return os.str();
}

/// Write "<name> = <value>" configuration entry to output stream
template <class TValue>
inline void PrintParameter(std::ostream &os, const char *name, const TValue &value)
{
  const std::streamsize w = os.width(40);
  os << std::left << name << std::setw(0) << " = " << value << std::endl;
  os.width(w);
}

/// Write "<name> = <value>" configuration entry to output stream
template <class TValue>
inline void PrintParameter(std::ostream &os, const std::string &name, const TValue &value)
{
  PrintParameter(os, name.c_str(), value);
}

/// Split string into parts separated by specified delimiting sequence of characters
///
/// @param s String to be split.
/// @param d Delimiting sequence of characters.
/// @param n Maximum number of parts. If zero, all parts are returned,
///          if negative, the last n parts are returned, and if positive,
///          the first n parts are returned.
///
/// @returns Parts of the std::string.
std::vector<std::string> Split(std::string s, const char *d, int n = 0);


#endif
