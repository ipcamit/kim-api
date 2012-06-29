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


#
# This make file needs to be included by the makefiles in
# the KIM_API, MODELs/*/, MODEL_DRIVERs/*/ and TESTs/*/ directories.
# It loads definitions for the GNU and Intel compiler sets.
# It also contains definitions for patern compilation rules.
#

ifndef KIM_DIR
   $(error The environment variable KIM_DIR is not defined.)
endif

# The openkim-api subdirectories:
ifndef KIM_API_DIR
   KIM_API_DIR :=$(KIM_DIR)/KIM_API
endif
ifndef KIM_MODELS_DIR
   KIM_MODELS_DIR:=$(KIM_DIR)/MODELs
endif
ifndef KIM_MODEL_DRIVERS_DIR
   KIM_MODEL_DRIVERS_DIR:=$(KIM_DIR)/MODEL_DRIVERs
endif
ifndef KIM_TESTS_DIR
   KIM_TESTS_DIR:=$(KIM_DIR)/TESTs
endif


# All Model .o files and library definitions

# setup list of available models
MODELLST = $(patsubst .%.make-temp,%,$(notdir $(wildcard $(KIM_API_DIR)/.*.make-temp)))
MODELDRIVERLST = $(notdir $(filter-out $(shell if test -e "$(KIM_MODEL_DRIVERS_DIR)/.kimignore"; then cat "$(KIM_MODEL_DRIVERS_DIR)/.kimignore";fi;),$(filter-out .%,$(shell find "$(KIM_MODEL_DRIVERS_DIR)/" -maxdepth 1 -mindepth 1 -type d -exec basename {} \;))))
MODELOBJ = $(addprefix $(KIM_MODELS_DIR)/, $(join $(addsuffix /,$(MODELLST)), $(addsuffix .a, $(MODELLST)))) \
           $(addprefix $(KIM_MODEL_DRIVERS_DIR)/, $(join $(addsuffix /,$(MODELDRIVERLST)), $(addsuffix .a, $(MODELDRIVERLST))))

# Determine whether a 32 bit or 64 bit compile should be use
ifdef KIM_SYSTEM32
   MACHINESYSTEM=SYSTEM32
else
   MACHINESYSTEM=SYSTEM64
endif

# Set compiler flag and define lists
COMMONFLAGS = -I$(KIM_API_DIR)                                      \
              -D $(MACHINESYSTEM)                                   \
              -D KIM_DIR_API=\"$(KIM_API_DIR)\"                     \
              -D KIM_DIR_MODELS=\"$(KIM_MODELS_DIR)\"               \
              -D KIM_DIR_TESTS=\"$(KIM_TESTS_DIR)\"                 \
              -D KIM_DIR_MODEL_DRIVERS=\"$(KIM_MODEL_DRIVERS_DIR)\"
# directory where the kim.log file should be created
#              -D KIM_DIR=\"$(KIM_DIR)/\"

ifdef KIM_INTEL
 include $(KIM_API_DIR)/Intel_compiler_settings.mk
else
 include $(KIM_API_DIR)/GNU_compiler_settings.mk
endif

# Set common compiler flags for dynamic linking
ifdef KIM_DYNAMIC
   CPPFLAG     += -D KIM_DYNAMIC=\"$(KIM_DYNAMIC)\" -fPIC
   CFLAG       += -D KIM_DYNAMIC=\"$(KIM_DYNAMIC)\" -fPIC
   FORTRANFLAG += -fPIC
endif

# Set correct lib file name depending on type of compilation
ifdef KIM_DYNAMIC
   KIM_LIB_FILE = $(KIM_API_DIR)/libkim.so
else
   KIM_LIB_FILE = $(KIM_API_DIR)/libkim.a
endif
KIM_LIB = -L$(KIM_API_DIR)/ -lkim

ifndef OSTYPE
  OSTYPE := $(shell echo $$OSTYPE)
endif

#set default goals allways all
.DEFAULT_GOAL := all

#build target .a or .so for models
ifdef KIM_DYNAMIC
   MODEL_BUILD_TARGET        += $(patsubst %.a,%.so, $(MODEL_BUILD_TARGET))
   MODEL_DRIVER_BUILD_TARGET += $(patsubst %.a,%.so, $(MODEL_DRIVER_BUILD_TARGET))
   SHARED_LIB_FLAG = -shared
   ifeq ($(OSTYPE),FreeBSD)
      SHARED_LIB_FLAG = -dynamiclib
   endif
   LINKSONAME = -Wl,-soname=
   ifeq ($(findstring darwin,$(OSTYPE)),darwin)
      LINKSONAME = -Wl,-install_name,
   endif
else
   ifneq ("1","$(MAKELEVEL)")
     MODEL_BUILD_TARGET += STATIC_COMP_WARNING
     MODEL_DRIVER_BUILD_TARGET += STATIC_COMP_WARNING
   endif
endif

.PHONY: STATIC_COMP_WARNING
STATIC_COMP_WARNING:
	@echo ''; \
        echo '*************************************************************************'; \
        echo '*******               Compiling in static link mode               *******'; \
        echo '*******         You probably want to execute make from the        *******'; \
        echo '*******                     $$KIM_DIR directory                    *******'; \
        echo '*************************************************************************'; \

# Definition of c and fortran .o file list
OBJC = KIM_API.o KIM_API_C.o standard_kim_str.o Unit_Handling.o KIM_AUX.o
OBJF90 = KIM_API_F.o

#fortran on/of
ifdef KIM_NO_FORTRAN
   ALLOBJ = $(OBJC)
else
   ALLOBJ = $(OBJC) $(OBJF90)
endif


# C/C++ Compiler pattern rules
%.o:%.c    # C with preprocessing
	$(CCOMPILER) $(CPFLAG) $(COMMONFLAGS) $(OBJONLY) $<
%.o:%.i    # C without preprocessing
	$(CCOMPILER) $(CPFLAG) $(COMMONFLAGS) $(OBJONLY) $<
%.o:%.cpp  # C++ with preprocessing
	$(CPPCOMPILER) $(CPPFLAG) $(COMMONFLAGS) $(OBJONLY) $<
%.o:%.ii   # C++ without preprocessing
	$(CPPCOMPILER) $(CPPFLAG) $(COMMONFLAGS) $(OBJONLY) $<
%.o:%.cc   # C++ with preprocessing
	$(CPPCOMPILER) $(CPPFLAG) $(COMMONFLAGS) $(OBJONLY) $<
%.o:%.cxx  # C++ with preprocessing
	$(CPPCOMPILER) $(CPPFLAG) $(COMMONFLAGS) $(OBJONLY) $<
%.o:%.cpp  # C++ with preprocessing
	$(CPPCOMPILER) $(CPPFLAG) $(COMMONFLAGS) $(OBJONLY) $<
%.o:%.C    # C++ with preprocessing
	$(CPPCOMPILER) $(CPPFLAG) $(COMMONFLAGS) $(OBJONLY) $<

# Fortran Compiler pattern rules
# Fixed form code
%.o:%.f    # FORTRAN 77 without preprocessing
	$(FORTRANCOMPILER) $(FORTRANFLAG) $(COMMONFLAGS) $(OBJONLY) $<
%.o:%.for  # FORTRAN 77 without preprocessing
	$(FORTRANCOMPILER) $(FORTRANFLAG) $(COMMONFLAGS) $(OBJONLY) $<
%.o:%.ftn  # FORTRAN 77 without preprocessing
	$(FORTRANCOMPILER) $(FORTRANFLAG) $(COMMONFLAGS) $(OBJONLY) $<
%.o:%.fpp  # FORTRAN 77 with preprocessing
	$(FORTRANCOMPILER) $(FORTRANFLAG) $(COMMONFLAGS) $(OBJONLY) $<
%.o:%.F    # FORTRAN 77 with preprocessing
	$(FORTRANCOMPILER) $(FORTRANFLAG) $(COMMONFLAGS) $(OBJONLY) $<
%.o:%.FOR  # FORTRAN 77 with preprocessing
	$(FORTRANCOMPILER) $(FORTRANFLAG) $(COMMONFLAGS) $(OBJONLY) $<
%.o:%.FTN  # FORTRAN 77 with preprocessing
	$(FORTRANCOMPILER) $(FORTRANFLAG) $(COMMONFLAGS) $(OBJONLY) $<
%.o:%.FPP  # FORTRAN 77 with preprocessing
	$(FORTRANCOMPILER) $(FORTRANFLAG) $(COMMONFLAGS) $(OBJONLY) $<
# Free form code
%.o:%.f90  # Fortran 90 without preprocessing
	$(FORTRANCOMPILER) $(FORTRANFLAG) $(COMMONFLAGS) $(OBJONLY) $<
%.o:%.f95  # Fortran 95 without preprocessing
	$(FORTRANCOMPILER) $(FORTRANFLAG) $(COMMONFLAGS) $(OBJONLY) $<
%.o:%.f03  # Fortran 2003 without preprocessing
	$(FORTRANCOMPILER) $(FORTRANFLAG) $(COMMONFLAGS) $(OBJONLY) $<
%.o:%.f08  # Fortran 2008 without preprocessing
	$(FORTRANCOMPILER) $(FORTRANFLAG) $(COMMONFLAGS) $(OBJONLY) $<
%.o:%.F90  # Fortran 90 without preprocessing
	$(FORTRANCOMPILER) $(FORTRANFLAG) $(COMMONFLAGS) $(OBJONLY) $<
%.o:%.F95  # Fortran 95 without preprocessing
	$(FORTRANCOMPILER) $(FORTRANFLAG) $(COMMONFLAGS) $(OBJONLY) $<
%.o:%.F03  # Fortran 2003 without preprocessing
	$(FORTRANCOMPILER) $(FORTRANFLAG) $(COMMONFLAGS) $(OBJONLY) $<
%.o:%.F08  # Fortran 2008 without preprocessing
	$(FORTRANCOMPILER) $(FORTRANFLAG) $(COMMONFLAGS) $(OBJONLY) $<


#
MODEL_NAME_KIM_STR_H = char* $(strip $(MODEL_NAME))_kim_str'('')'';'
MODEL_NAME_KIM_STR_CPP = char* $(strip $(MODEL_NAME))_kim_str'('')''{'
%_kim_str.cpp: %.kim
	echo "extern \"C\" {"           > $*_kim_str.cpp
	echo $(MODEL_NAME_KIM_STR_H)   >> $*_kim_str.cpp
	echo "}"                       >> $*_kim_str.cpp
	echo $(MODEL_NAME_KIM_STR_CPP) >> $*_kim_str.cpp
	echo "static char kimstr[] ="  >> $*_kim_str.cpp
	cat $(strip $(MODEL_NAME)).kim | tr -d '\r' | \
	sed -e 's,\\,\\\\,g'     \
            -e 's,",\\",g'       \
            -e 's,^,      ",g'   \
            -e 's,$$,\\n",g'           >> $*_kim_str.cpp
	echo "   ;"                    >> $*_kim_str.cpp
	echo "return &kimstr[0];"      >> $*_kim_str.cpp
	echo ""                        >> $*_kim_str.cpp
	echo "}"                       >> $*_kim_str.cpp

# Library pattern rule
%.so: %.a
	$(LINKCOMPILER) $(SHARED_LIB_FLAG) $(LINKLIBFLAG) -o $@  *.o -L$(KIM_API_DIR)/ -lkim
