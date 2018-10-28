//
// CDDL HEADER START
//
// The contents of this file are subject to the terms of the Common Development
// and Distribution License Version 1.0 (the "License").
//
// You can obtain a copy of the license at
// http://www.opensource.org/licenses/CDDL-1.0.  See the License for the
// specific language governing permissions and limitations under the License.
//
// When distributing Covered Code, include this CDDL HEADER in each file and
// include the License file in a prominent location with the name LICENSE.CDDL.
// If applicable, add the following below this CDDL HEADER, with the fields
// enclosed by brackets "[]" replaced with your own identifying information:
//
// Portions Copyright (c) [yyyy] [name of copyright owner]. All rights reserved.
//
// CDDL HEADER END
//

//
// Copyright (c) 2016--2018, Regents of the University of Minnesota.
// All rights reserved.
//
// Contributors:
//    Ryan S. Elliott
//

//
// Release: This file is part of the kim-api-v2.0.0-beta.2 package.
//


#ifndef KIM_LOG_IMPLEMENTATION_HPP_
#define KIM_LOG_IMPLEMENTATION_HPP_

#include <fstream>
#include <stack>
#include <string>

#ifndef KIM_LOG_VERBOSITY_HPP_
#include "KIM_LogVerbosity.hpp"
#endif

namespace KIM
{
// Forward declarations

class LogImplementation
{
 public:
  static int Create(LogImplementation ** const logImplementation);
  static void Destroy(LogImplementation ** const logImplementation);

  std::string const & GetID() const;
  void SetID(std::string const & id);

  void PushVerbosity(LogVerbosity const logVerbosity);
  void PopVerbosity();

  void LogEntry(LogVerbosity const logVerbosity,
                std::string const & message,
                int const lineNumber,
                std::string const & fileName) const;

 private:
  // do not allow copy constructor or operator=
  LogImplementation(LogImplementation const &);
  void operator=(LogImplementation const &);

  LogImplementation();
  ~LogImplementation();

  static std::string EntryString(std::string const & logVerbosity,
                                 std::string const & date,
                                 int const sequence,
                                 std::string const & idString,
                                 std::string const & message,
                                 int const lineNumberString,
                                 std::string const & fileName);

  std::string GetTimeStamp() const;

  std::string idString_;
  std::stack<LogVerbosity> verbosity_;

  mutable std::string latestTimeStamp_;
  mutable unsigned sequence_;

};  // class LogImplementation
}  // namespace KIM
#endif  // KIM_LOG_IMPLEMENTATION_HPP_
