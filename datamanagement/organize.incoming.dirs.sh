#!/bin/bash

# this script will divide the directories downloaded from the DKIST Globus endpoint into subdirectories
# based on the name of the instrument with which they were acquired.
#
# It asssumes the data have been downloaded into a directory called "incoming/" that is in the directory
# from which the user is running this script. It then movies each directory into the appropriate 
# "incoming/vbi/" or "incoming/visp/" subdirectory.
#
# this program will be expanded to also treat data from other instruments as they become available.

# the name of the directory into which the DKIST data have been downloaded.
# this can either be a relative or absolute path
source_dir="incoming"

verbose="1"
if [[ $verbose == "1" ]] ; then echo $source_dir ; fi

mkdir $source_dir/visp
mkdir $source_dir/vbi

# make a list of all the directories in the source_dir directory
# currently, all those subdirectories names are comprised of a sequence of capital letters
for dir in `cd $source_dir ; ls -d [A-Z]*[A-Z] `
    do

    # pick out first FITS file and see if filename includes "VBI" or "VISP" string
    isvbi=`find $source_dir/$dir/ -name '*fits' -type f | head -1 | grep VBI | wc -l`
    isvisp=`find $source_dir/$dir/ -name '*fits' -type f | head -1 | grep VISP | wc -l`

    if [[ $isvbi == "1" ]]
        then
        if [[ $verbose == "1" ]] ; then echo $dir " - VBI" ; fi
        echo "mv $source_dir/$dir $source_dir/vbi/"
        mv $source_dir/$dir $source_dir/vbi/
    fi

    if [[ $isvisp == "1" ]]
        then
        if [[ $verbose == "1" ]] ; then echo $dir " - VISP" ; fi
        echo "mv $source_dir/$dir $source_dir/visp/"
        mv $source_dir/$dir $source_dir/visp/
    fi

done
