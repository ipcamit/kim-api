#
# CDDL HEADER START
#
# The contents of this file are subject to the terms of the Common Development
# and Distribution License Version 1.0 (the "License").
#
# You can obtain a copy of the license at
# http://www.opensource.org/licenses/CDDL-1.0.  See the License for the
# specific language governing permissions and limitations under the License.
#
# When distributing Covered Code, include this CDDL HEADER in each file and
# include the License file in a prominent location with the name LICENSE.CDDL.
# If applicable, add the following below this CDDL HEADER, with the fields
# enclosed by brackets "[]" replaced with your own identifying information:
#
# Portions Copyright (c) [yyyy] [name of copyright owner]. All rights reserved.
#
# CDDL HEADER END
#

#
# Copyright (c) 2012, Regents of the University of Minnesota.  All rights reserved.
#
# Contributors:
#    Valeriu Smirichinski
#    Ryan S. Elliott
#    Ellad B. Tadmor
#

#
# Release: This file is part of the openkim-api.git repository.
#


# Define Intel compiler switches
CCOMPILER       = icc
CPPCOMPILER     = icpc
FORTRANCOMPILER = ifort
LINKCOMPILER    = $(FORTRANCOMPILER)

# Define the names for typical compiler options
OBJONLY=-c
OUTPUTIN=-o

# Define compiler flag lists
FORTRANFLAG = -O3
CFLAG       = -O3
CPPFLAG     = -O3

# Define linking options for using $(LIKNCOMPILER) to link other language objects
LINKLIBFLAG = -nofor_main -cxxlib
