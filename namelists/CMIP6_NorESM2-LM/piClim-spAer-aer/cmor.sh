#!/bin/bash

source ../scripts/runcmor_single.sh

#version=v20190920
version=v20191108b

if [ $# -eq 1 ]
then
    echo $#
    version=$1
fi

# initialize
login0=false
login1=false
login2=false
login3=false

# set active
login0=true
login1=true
login2=true
login3=true


expid=piClim-spAer-aer
echo "--------------------"
echo "EXPID: $expid     "
echo "--------------------"

echo "                    "
echo "START CMOR..."
echo "                    "

if $login0
then
#----------------
# piClim-ghg
#----------------
#CaseName=piClim-SpAer2014
expid=piClim-spAer-aer
#login0
years1=($(seq 1 10 21))
years2=($(seq 10 10 30))

runcmor -c=$CaseName -e=$expid -v=$version -r=$real -yrs1="${years1[*]}" -yrs2="${years2[*]}" -mpi=DMPI
#---
fi
#---

wait
echo "         "
echo "CMOR DONE"
echo "~~~~~~~~~"

# PrePARE QC check
source ../scripts/cmorQC.sh
cmorQC -e=$expid -v=$version

# Create links and sha256sum
../../../scripts/create_CMIP6_links_sha256sum.sh $version ".cmorout/NorESM2-LM/${expid}/${version}" false

# zip log files
gzip ../../../logs/CMIP6_NorESM2-LM/${expid}/${version}/{*.log,*.err}