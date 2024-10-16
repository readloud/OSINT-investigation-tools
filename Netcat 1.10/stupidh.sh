#! /bin/sh
##
## Find stupid system include dependencies and account for them.  Squirts
## a sample .h file to stdout containing [too many of] the right things.
## If you hose the output into "stupid.h", you will get MORE information.
## This takes a while to run, because it checks so many things.
##
## IF YOU HAVE a system/arch/compiler/whatever that is NOT one of:
##   msdos-msc6.x  ultrix-vax ultrix-mips  sunos4.1.x-sparc  solaris2.x-sparc
##   aix-rs6k  linux1.[01].x-x86  freebsd-x86  netbsd-x86 hpux
##   [... hopefully this list will grow very large]
## or even if you aren't sure, you would be doing me and the net in general
## a wonderful service by running this and MAILING me the "full" output, e.g.
##
##    chmod +x stupidh
##    ./stupidh > stupid.h
##    mail hobbit@avian.org < stupid.h
##
## WARNING: You may have to change "cc" to "gcc" below if you don't have
## "cc" [e.g. solaris, thank you very fucking much, Sun].
## Please note any errors this generates, too...
##
## *Hobbit*, 941122 and previous.  VERSION: 1.3 951107
##
## edits: Use a consistent naming scheme, for easier identification and cleanup.
## accomodate gcc's BOGUS assumptions based on input filename.
## added a few more include-names and try-predefines; some swiped from autoconf.
## added a couple of things commonly done as #defines so we can SEE 'em

## Here is where to change "cc" to "gcc" if needed:
CC=cc

if test -z "${INCLUDE}" ; then
  INCLUDE=/usr/include
fi

echo '/* STUPIDH run:'
uname -a
echo '*/'
echo ''

echo "/* Includes, from ${INCLUDE} */"
for xx in \
assert ctype cdefs errno file fcntl ioctl malloc stdio stdlib stdarg iostdio \
stddef dirent direct dir ndir utmp wtmp utmpx wtmpx lastlog login paths \
getopt string strings signal setjmp io param stat types time timeb utime \
dos msdos unistd socket netdb varargs sysinfo systeminfo resource ulimit \
stream stropts pstat sysmacros termio termios sgtty tty ttyent lstat select \
sockio wait vfork bsdtypes mkdev utsname sysexits \
; do

  XX=''
  if test -f ${INCLUDE}/${xx}.h ; then
    echo "#include <${xx}.h>"
    XX=`echo $xx | tr '[a-z]' '[A-Z]'`
  fi
  if test -f ${INCLUDE}/sys/${xx}.h ; then
    echo "#include <sys/${xx}.h>"
    XX=`echo $xx | tr '[a-z]' '[A-Z]'`
  fi

# everyone seems to have their own conventions; this may not be complete.
# thats why this is so STUPID.
# HAS_xx and USE_xx might indicate functions and available library calls,
# not includes.  Deal...

  if test "${XX}" ; then
    echo "#define USE_${XX}_H"
    echo "#define HAS_${XX}_H"
    echo "#define HAS_${XX}"
    echo "#define HAS${XX}"
    echo "#define HAVE_${XX}_H"
    echo "#define HAVE_${XX}"
    echo "#define HAVE${XX}H"
    echo "#define ${XX}H"
    echo ''
  fi
# Stupid hack: "dir" and "dirent" might mutually exclusive, a la GNU
# includes.  This is to prevent it from biting us.
  if test "${xx}" =  "dirent" ; then
    echo "#ifdef _SYS_DIRENT_H"
    echo "#undef _SYS_DIRENT_H"
    echo "#endif"
  fi

### To make a DOS batchfile instead, do this [on a unix box!], xfer results,
### and have "xxx.bat" that types out all the cruft for %INCLUDE%\%1.
### WARNING: I might not have gotten the superquoting exactly right here...
# echo "if exist %INCLUDE%\\${xx}.h call xxx ${xx}"
# echo "if exist %INCLUDE%\\sys\\${xx}.h call xxx sys/${xx}"
### You also need to save and manually run the CPP input file, below.
### I've done this for msc6 and would appreciate results for other compilers.

done
sync
sleep 1

### Note: if all the previous output went to "stupid.h", it will be
### reincluded in the second part of this.

sed -e '/^#/d' -e '/^[	 ]*$/d' > st00pid.in << 'EOF'

### More recently, some of this was swiped from the "gcc" doc.  Autoconf is
### worth a harder look for more ideas; havent gotten around to it yet.
# architectures
alpha
dec
ibm
i370
i960
i860
ibm032
a29k
indigo
iris
mips
mipsel
sparc
sparclite
ncr
sh
harris
apple
vax
x86
ix86
i286
i386
i486
i586
pentium
intel
smp
mpu
mpu8080
mpu8086
amiga
hp
hppa
hp400
hp9000
snake
decmips
mc68000
mc68010
mc68020
mc68030
m68000
m68010
m68020
m68030
m68k
m88k
u3b15
u3b
u3b2
u3b5
u3b15
u3b20d
we32k
ppc
powerpc
arm
aviion
ns32000
iapx286
# minor exception to lc-vs-uc thing?
iAPX286
rs6000
rs6k
risc
sun
sun3
sun4
sun4c
sun4m
sequent
apollo
solbourne
pyr
pyramid
interdata
intertec
pdp11
u370
next
mac
macintosh

# for completeness; ya never know ... yes, found it!! -- solaris inet/common.h
big_endian
little_endian
lsbfirst
msbfirst

# vendors/OSes
unix
munix
m_unix
gcos
os
gssc
tss
isc
# *This* pair of imbeciles does *caseified defines*.  Pinheads.  One of
# these might trigger before the "tr" step.
NetBSD
netbsd
freebsd
FreeBSD
# cant do 386bsd, I dont think, but ...
_386bsd
bsd386
bsdunix
bsd_2
bsd_20
bsd
bsdi
bsd4
bsd42
bsd43
bsd44
bsd4_2
bsd4_3
bsd4_4
linux
minix
ultrix
ult3
ult4
bull
convex
convex_source
res
rt
esix
dg
dgux
encore
osf
osf1
osf2
# oops:
# osf/1
mach
mach386
mach_386
nextstep
tahoe
reno
sunos
sunos3
sunos4
sunos5
solaris
sun_src_compat
svr3
svr4
svr3_style
svr4_style
sysv
hpux
hp_ux
irix
sgi
sony
news
newsos
news_os
luna
lynxos
riscos
microport
ewsux
ews_ux
mport
dynix
genix
unicos
unixware
msdos
dos
os2
novell
univel
plan9
att
att_unix
sco
odt
aix
aux
a_ux
rsx
vms

# compiler cruft??
ansi
ansi_source
ansic
stdc
lint
sccs
libc_sccs
ms
msc
microsoft
gcc
gnu
gnuc
gnucc
gnu_source
sabre
saber
cygnus
source
all_source
gprof
prof
posix
posix_source
posix_sources
posix_c_source
xopen_source
args
p
proto
no_proto
prototype
prototypes
reentrant
kernel
str
trace
asm
libcpp
athena
athena_compat
# some preprocessors cant deal with this
# c++
cxx
cplusplus
borland
turbo
turboc
lattice
highc

# various defines that pop out of other .h files that we need to know about
index
strchr
rindex
strrchr
bcopy
memcpy
bzero
memset
path_login
path_lastlog
path_utmp
path_utmpx

EOF

# FL must be named something.c, so STUPID gcc recognized it as a non-object!!
( FL=st00pid.c
  if test -f stupid.h ; then
    cp stupid.h $FL
    sync
    echo '/* Re-including stupid.h */'
    sleep 1
  else
    echo '/* Skipping stupid.h */'
  fi
  while read xx ; do
    XX=`echo $xx | tr '[a-z]' '[A-Z]'`
    echo "#ifdef ${xx}" >> $FL
    echo "\"${xx}\" = ${xx}" >> $FL
    echo "#endif" >> $FL
    echo "#ifdef _${xx}" >> $FL
    echo "\"_${xx}\" = _${xx}" >> $FL
    echo "#endif" >> $FL
    echo "#ifdef _${xx}_" >> $FL
    echo "\"_${xx}_\" = _${xx}_" >> $FL
    echo "#endif" >> $FL
    echo "#ifdef __${xx}" >> $FL
    echo "\"__${xx}\" = __${xx}" >> $FL
    echo "#endif" >> $FL
    echo "#ifdef __${xx}__" >> $FL
    echo "\"__${xx}__\" = __${xx}__" >> $FL
    echo "#endif" >> $FL
    echo "#ifdef ${XX}" >> $FL
    echo "\"${XX}\" = ${XX}" >> $FL
    echo "#endif" >> $FL
    echo "#ifdef _${XX}" >> $FL
    echo "\"_${XX}\" = _${XX}" >> $FL
    echo "#endif" >> $FL
    echo "#ifdef _${XX}_" >> $FL
    echo "\"_${XX}_\" = _${XX}_" >> $FL
    echo "#endif" >> $FL
    echo "#ifdef __${XX}" >> $FL
    echo "\"__${XX}\" = __${XX}" >> $FL
    echo "#endif" >> $FL
    echo "#ifdef __${XX}__" >> $FL
    echo "\"__${XX}__\" = __${XX}__" >> $FL
    echo "#endif" >> $FL
  done
# and pick up a few specials
  echo "#ifdef major" >> $FL
  echo "\"major\" = major (x)" >> $FL
  echo "\"minor\" = minor (x)" >> $FL
  echo "#endif" >> $FL
  echo "#ifdef FD_SETSIZE" >> $FL
  echo "\"FD_SETSIZE\" = FD_SETSIZE" >> $FL
  echo "#endif" >> $FL
) < st00pid.in
sync

echo '/* Compiler predefines:'
${CC} -E st00pid.c | sed -e '/^#/d' -e '/^[	 ]*$/d'
echo '*/'
sync

cat > st00pid.c << 'EOF'
#include <stdio.h>
main() {
union {
  char *bletch;
  int *i;
} yow;
static char orig[16];
  strcpy (orig, "ABCDEFGHIJK");
  yow.bletch = orig;
  printf ("endian thing: %s = 0x%lx, addrbyte = %x -- ",
    yow.bletch, *yow.i, *yow.i & 0xFF);
  printf (((*yow.i & 0xff) == 0x41) ? "LITTLE\n" : "BIG\n");
  printf ("short %d;  int %d;  long %d\n",
    sizeof (short), sizeof (int), sizeof (long));
}
EOF

${CC} -o st00pid.x st00pid.c
echo '/* Architecture:'
./st00pid.x
echo '*/'

### dont nuke if generating DOS batchfiles
rm -f st00pid.*
sync
exit 0

### stuff remaining to deal with:
# maybe take out the slew of HAS_* and HAS* excess predefines, and only use
#   our "standardized" scheme [like we were going to generate a real includible
#   file outa this??]
# various POSIX_ME_HARDERisms:
#   vfork
#   lockf/flock/fcntl/euuugh
#   signal stuff
#   termio/termios/sgtty hair
# strdup and related
# ifdef HAVE_STD_LIB and such nonsense
# auto-sniff cc-vs-gcc somehow?  maybe a straight OR with exit statii..
