# Makefile for various platforms
# Execute using Build csh-script only!
# Used together with Perl scripts in SRC/SCRIPT 
# (C) 2005 Marat Khairoutdinov
# $Id: Makefile 1595 2014-10-30 21:36:30Z dschanen@uwm.edu $
#------------------------------------------------------------------
# uncomment to disable timers:
#
#NOTIMERS=-DDISABLE_TIMERS
#-----------------------------------------------------------------

SAM = SAM_$(ADV_DIR)_$(SGS_DIR)_$(RAD_DIR)_$(MICRO_DIR)

# Determine platform 
PLATFORM := $(shell uname -s)

#------------------------------------------------------------------------
# This Makefile is for SAM running on Perlmutter Cray at NERSC
#
ifeq ($(PLATFORM),Linux)
CC          = cc -c -DLINUX
FF77        = ftn -c
FF90        = ftn -c
LD          = ftn

INC_NETCDF := $(NETCDF_DIR)/include
LIB_NETCDF := $(NETCDF_DIR)/lib
INC_MPI    := $(CRAY_MPICH_DIR)/include
LIB_MPI    := $(CRAY_MPICH_DIR)/lib

# FFLAGS = -debug full -CB -g  -extend-source 132 -init=snan,arrays -traceback -check bounds -check uninit -ftrapuv
#FFLAGS = -O0 -N 255 -e E -R abc -K trap=fp -h bounds -g
FFLAGS = -O3 -N 255 -e E # -O0 -N 255 -e E -R abc -K trap=fp -h bounds -g 
# FFLAGS = -O3 -ffree-line-length-none -fallow-argument-mismatch 
# FFLAGS     += -fdefault-real-8 
FFLAGS     += -s real64
FFLAGS     += -I${INC_MPI} -I${INC_NETCDF} -DNETCDF
# FFLAGS     += -mcmodel=large


##CFFLAGS     = -I${INC_MPI} -I${INC_NETCDF} -DNETCDF
LDFLAGS     = -L${LIB_MPI} -L${LIB_NETCDF} -lnetcdf -lnetcdff 
##LDFLAGS    += -mkl


# INC_NETCDF := /usr/local/include
# LIB_NETCDF := /usr/local/lib

# FF77 = gfortran -c -ffixed-form -ffixed-line-length-0
# FF90 = gfortran -c -ffree-form -ffree-line-length-0
# CC = gcc -c -DLINUX


# FFLAGS = -O3
# #FFLAGS = -g -fcheck=all

# FFLAGS += -I${INC_NETCDF}
# LD = gfortran
# LDFLAGS = -L${LIB_NETCDF} -lnetcdf

endif

#----------------------------------
#----------------------------------------------
# you don't need to edit below this line


#compute the search path
dirs := . $(shell cat Filepath)
VPATH    := $(foreach dir,$(dirs),$(wildcard $(dir))) 

.SUFFIXES:
.SUFFIXES: .f .f90 .F90 .F .c .o



all: $(SAM_DIR)/$(SAM)

SOURCES   := $(shell cat Srcfiles)

Depends: Srcfiles Filepath
	$(SAM_SRC)/SCRIPT/mkDepends Filepath Srcfiles > $@

Srcfiles: Filepath
	$(SAM_SRC)/SCRIPT/mkSrcfiles > $@

OBJS      := $(addsuffix .o, $(basename $(SOURCES))) 

$(SAM_DIR)/$(SAM): $(OBJS)
	$(LD) -o $@ $(OBJS) $(LDFLAGS)

.F90.o:
	${FF90}  ${FFLAGS} $(if $(filter $@, $(WARNABLE) ), $(WARNINGS) ) $<;
.f90.o:
	${FF90}  ${FFLAGS} $(if $(filter $@, $(WARNABLE) ), $(WARNINGS) ) $<;
.f.o:
	${FF77}  ${FFLAGS} $<
.F.o:
	${FF77}  ${FFLAGS} $<
.c.o:
	${CC}  ${CFLAGS} -I$(SAM_SRC)/TIMING $(NOTIMERS) $<

include Depends

