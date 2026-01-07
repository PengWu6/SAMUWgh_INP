# Makefile to compile conversion utilities. You need to set include and library paths for NETCDF
#
 
PLATFORM := $(shell uname -s)
 
# uncomment line for your platform or add your own:
#---------------------------------------------------------
# Cori Intel
ifeq ($(PLATFORM),Linux)
INC_NETCDF := $(NETCDF_DIR)/include
LIB_NETCDF := $(NETCDF_DIR)/lib
INC_MPI    := $(CRAY_MPICH_DIR)/include
LIB_MPI    := $(CRAY_MPICH_DIR)/lib
 
CC          = cc -c -DLINUX
FF77        = ftn -c
FF90        = ftn -c
FF          = ftn -O3 -N 255 -e E -I${INC_NETCDF} -DNETCDF
LD          = ftn
 
LDFLAGS     = -L${LIB_MPI} -L${LIB_NETCDF} -lnetcdf -lnetcdff
endif
 
#---------------------------------------------------------
# Cray (Fan Yang, BNL)
 
#ifeq ($(PLATFORM),Linux)
#NETCDF_DIR = /home/fanyang/usr
#INC_NETCDF := $(NETCDF_DIR)/include
#LIB_NETCDF := $(NETCDF_DIR)/lib
 
#FF = ifort -O3 -fixed -extend_source -I${INC_NETCDF}
#LD = ifort
 
#LDFLAGS = -L${LIB_NETCDF} -lnetcdf -lnetcdff
#endif
#---------------------------------------------------------
#
# Linux Cluster (seawulf@sunysb)
#
 
#INC_NETCDF = /nfs/user04/marat/local/include
#LIB_NETCDF = /nfs/user04/marat/local/lib
 

#FF = ifort -O3 -fixed -extend_source -I${INC_NETCDF}
#LDFLAGS = -L${LIB_NETCDF} -lnetcdf
#---------------------------------------------------------
 
VPATH = ./SRC
 
# all: 2Dbin2nc bin2D2nc bin3D2nc bin3D2nc_micro stat2nc
all: bin2D2nc bin3D2nc 2Dbin2nc 2Dbin2nc_mean bin3D2nc_mean com3D2bin 2Dcom2nc 2Dcom2nc_mean com3D2nc com3D2nc_mean com2D2nc stat2nc isccp2nc modis2nc misr2nc com3D2nc_sep 2Dbin2nc_sep 2Dcom_sep2one 2Dbin_sep2one com3D_sep2one bin3D_sep2one glue_movie_raw

.f:   
	$(FF) -o $@ -I./SRC $< ./SRC/hbuf_lib.f ./SRC/cape.f ./SRC/cin.f $(LDFLAGS) 

clean: 
	rm bin* com* stat* 2* isccp* modis* misr* *.o glue*
 
#  VPATH = ./SRC

# all: bin2D2nc bin3D2nc bin3D2nc_micro stat2nc
# # all: bin2D2nc bin3D2nc 2Dbin2nc 2Dbin2nc_mean bin3D2nc_mean com3D2bin 2Dcom2nc 2Dcom2nc_mean com3D2nc com3D2nc_mean com2D2nc stat2nc isccp2nc modis2nc misr2nc com3D2nc_sep 2Dbin2nc_sep 2Dcom_sep2one 2Dbin_sep2one com3D_sep2one bin3D_sep2one glue_movie_raw

# .f:   
# 	$(FF) -o $@ -I./SRC $< ./SRC/hbuf_lib.f ./SRC/cape.f ./SRC/cin.f $(LDFLAGS) 

# clean: 
# 	rm bin* com* stat* 2* isccp* modis* misr* *.o glue*