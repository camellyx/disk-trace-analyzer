# DIXtrac - Automated Disk Extraction Tool
# Authors: Jiri Schindler, John Bucy, Greg Ganger
#
# Copyright (c) of Carnegie Mellon University, 1999-2005.
#
# Permission to reproduce, use, and prepare derivative works of
# this software for internal use is granted provided the copyright
# and "No Warranty" statements are included with all reproductions
# and derivative works. This software may also be redistributed
# without charge provided that the copyright and "No Warranty"
# statements are included in all redistributions.
#
# NO WARRANTY. THIS SOFTWARE IS FURNISHED ON AN "AS IS" BASIS.
# CARNEGIE MELLON UNIVERSITY MAKES NO WARRANTIES OF ANY KIND, EITHER
# EXPRESSED OR IMPLIED AS TO THE MATTER INCLUDING, BUT NOT LIMITED
# TO: WARRANTY OF FITNESS FOR PURPOSE OR MERCHANTABILITY, EXCLUSIVITY
# OF RESULTS OR RESULTS OBTAINED FROM USE OF THIS SOFTWARE. CARNEGIE
# MELLON UNIVERSITY DOES NOT MAKE ANY WARRANTY OF ANY KIND WITH RESPECT
# TO FREEDOM FROM PATENT, TRADEMARK, OR COPYRIGHT INFRINGEMENT.

AR     =  ar
CC     =  gcc -m32
RM     =  rm
WC     =  wc
PERL   =  perl

# -DWRITE_CHECK   - makes sure no writes occur on the disk
# -DSILENT        - silent mode which does not print so many messages
# -DMEASURE_TIME  - prints out the timings of parameter retrievals
# -DEDEBUG        - support for debug feature -d option to dixtrac
# -DDISKINFO_ONLY - when set, it does not use the diskmodel input files

DEFINES = -DMEASURE_TIME -DRAWLAYOUT_SUPPORT -DDEBUG #-DSILENT

# if -DDEBUG is used, add debug.c file into the SRCFILES list
# The use of this option is not advisable.

PROG     = dixtrac 
LIBNAME  = dxtools

LAYOUT   = dxlayout
IDLER    = dxidler
ALIGN    = dxalign
REPLAY   = dxreplay

ST_DIR   = st-1.7
STHREADS = $(ST_DIR)/obj

include .paths

LIBFILE  = lib$(LIBNAME).a

ST_LDFLAGS = -L$(STHREADS) -lst
ST_CFLAGS = -I$(ST_DIR)/obj

LDFLAGS  = -L. -l$(LIBNAME) -ldxtools \
	$(LIBDISKSIM_LDFLAGS) \
	$(MEMSMODEL_LDFLAGS) \
	$(DISKMODEL_LDFLAGS) \
	$(SSDMODEL_LDFLAGS) \
	$(LIBPARAM_LDFLAGS) \
	$(LIBDDBG_LDFLAGS) \
	$(ST_LDFLAGS) -lm

CFLAGS   = -Wall -g -MD -I. $(DEFINES) -I$(STHREADS) $(DMINCLUDES) \
	$(LIBDISKSIM_CFLAGS) \
	$(DISKMODEL_CFLAGS) $(LIBPARAM_CFLAGS) $(LIBDDBG_CFLAGS) \
	$(SSDMODEL_CFLAGS)


all: all-redirect


SRCFILES = dixtrac.c paramfile_gen.c debug.c 
OBJFILES = $(SRCFILES:%.c=%.o)

LIBSRCS  = build_scsi.c cache.c cache_modepage.c dxtools.c disksim_diskmap.c \
	   extract_layout.c extract_params.c linear_fit.c mechanics.c \
	   mtbrc.c print_bscsi.c raw_layout.c read_diskspec.c scsi_conv.c \
           trace_gen.c \
           inout.c ide_extract.c binsearch.c

all: $(STHREADS) $(TARGETS)


LIBOBJS  = $(LIBSRCS:%.c=%.o)

CONFIGFILES = config.cache config.status config.log configure \
                    ../include/config.h

-include *.d

TARGETS = dx_layout dx_mech dx_seeks dx_skews_simple dx_rest dx_stat \
	dx_skew_curve \
	dxcachectl dxreplay \

# set the ostype for building sthreads
OSTYPE = $(shell uname -s | awk '{print tolower($$1)}')

all-redirect: $(STHREADS) $(TARGETS)

$(PROG): $(OBJFILES) $(LIBFILE)
	$(CC)  -o $@ $(OBJFILES) $(LDFLAGS)

dx_stat: dx_stat.o libdxtools.a
	$(CC) -o $@ $< $(LDFLAGS)

dx_misc: dx_misc.o libdxtools.a
	$(CC) -o $@ $< $(LDFLAGS) 

dx_layout: dx_layout.o libdxtools.a
	$(CC) -o $@ dx_layout.o $(LDFLAGS)

dx_mech: dx_mech.o libdxtools.a
	$(CC) -o $@ dx_mech.o $(LDFLAGS)

dx_seeks: dx_seeks.o libdxtools.a
	$(CC) -o $@ $< $(LDFLAGS)

dx_skews_simple: dx_skews_simple.o libdxtools.a
	$(CC) -o $@ dx_skews_simple.o $(LDFLAGS)

dx_skew_curve: dx_skew_curve.o libdxtools.a
	$(CC) -o $@ $< $(LDFLAGS)


dx_rest: dx_rest.o libdxtools.a
	$(CC) -o $@ dx_rest.o $(LDFLAGS)

$(LAYOUT): $(LIBFILE) $(LAYOUT).o
#	$(CC) $(CFLAGS) $(CPPFLAGS) -c $(LAYOUT).c
	$(CC) $(LDFLAGS) -o $@ $(LAYOUT).o $(LIBS)

$(IDLER): $(LIBFILE) $(IDLER).o
#	$(CC) $(CFLAGS) $(CPPFLAGS) -c $(IDLER).c
	$(CC) $(LDFLAGS) -o $@ $(IDLER).o $(LIBS)

$(ALIGN): $(LIBFILE) $(ALIGN).o
	$(CC) $(LDFLAGS) -o $@ $(ALIGN).o $(LIBS)

$(REPLAY): $(LIBFILE) $(REPLAY).o
	$(CC) -o $@ $(REPLAY).o $(LDFLAGS) $(LIBS) $(RPLYLIBS) 

dxcachectl: $(LIBFILE) dxcachectl.o
	$(CC) -o $@ dxcachectl.o $(LDFLAGS) $(LIBS) $(RPLYLIBS)	 

lib $(LIBFILE): $(LIBOBJS)
	$(AR) -crs $(LIBFILE) $(LIBOBJS)

$(STHREADS):
	make -C $(ST_DIR) STATIC_ONLY=yes $(OSTYPE)-debug

.c.o:
	$(CC) $(CFLAGS) $(CPPFLAGS) -c $<

clean:
	$(RM) -f core *.o $(PROG) $(LIBFILE) $(LAYOUT) $(ALIGN) $(REPLAY) $(TARGETS)

distclean: clean
	$(RM) -f *.d
	make -C $(ST_DIR) clean

clean_config: clean distclean
	$(RM) -f $(CONFIGFILES)

count:
	$(WC) $(SRCFILES)

