#!/bin/bash

# print output on directories being used (verbose=1) and progress (verbose=2)
verbose="1"
# if do_link=1 then create links to define data classification
do_link="1"
# if do_move=1 then actually move the directories to the new directory hierarchy
do_move="0"
# if do_copy=1 then copy the data directories to the new directory hierarchy
do_copy="0"
# if execute=1 then actually perform the desired actions (link/move/copy), 
# otherwise just output the commands that would have been performed
execute="1"

# define which filter and wavelength to process
#filt='cak'   ; wave=3933
#filt='gband' ; wave=4305
filt='hbeta' ; wave=4861
# define which day of month to process
day='02'
#day='03'

wave_match="00${wave}"
date_match="2022-06-${day}T"
target_dir="${day}Jun2022/vbi/${filt}"

source_dir="incoming/vbi"
if [[ $verbose == "1" ]] ; then echo $source_dir ; fi
data_dirs=$source_dir"/*"
if [[ $verbose == "2" ]] ; then echo $data_dirs ; fi

dir_relative='../../../'
#dir_relative='./'
target_base='series'

for dir in `ls -d $data_dirs `
    do
    testfile=`find $dir -name '*fits' | sort | head -1`
    if [[ $verbose == "2" ]] ; then echo $dir ; echo $testfile ; fi

    if [[ "$testfile" =~ $wave_match ]]
    then
    if [[ $verbose == "2" ]] ; then echo "found matching wavelength - $wave" ; fi
    dateobs=`listhead $testfile[1]     | grep DATE-BEG=`
    starttime=`listhead $testfile[1]   | grep DKIST011=`
    obstype=`listhead $testfile[1]     | grep DKIST003=`

    pac002=`listhead $testfile[1] | grep PAC__002=`
    lightsource=`echo $pac002 | awk -F\' '{print $2}' `

    if [[ "$dateobs" =~ $date_match ]]
    then
    if [[ $verbose == "1" ]] ; then echo "----------" ; echo $dir ; echo $testfile ; echo $dateobs ; fi
    timeobs=`echo $dateobs | awk -F\' '{print $2}' | cut -c 12-19 | sed s/://g`
    if [[ $verbose == "1" ]] ; then echo $timeobs ; fi
    obsmod=`echo $obstype | awk -F\' '{print $2}'`

    #linkname=visp_${timeobs}_${obsmod}
    target_name=${target_dir}/${target_base}_${timeobs}
    if [[ $do_link == "1" ]] ; then target_name=${target_dir}/${target_base}_${timeobs} ; fi
    target_name=`echo $target_name | sed s/[[:blank:]]//`
    if [[ "$lightsource" =~ lamp* ]] ; then target_name=${target_name}_lamp ; fi

    if [[ $do_link == "1" ]]
        then echo "ln -s $dir_relative/$dir $target_name" 
        if [[ $execute == "1" ]] ; then ln -s $dir_relative/$dir $target_name ; fi
    fi

    if [[ $do_copy == "1" ]]
        then echo "cp -piR $dir $target_name" 
        if [[ $execute == "1" ]] ; then cp -piR $dir $target_name ; fi
    fi

    if [[ $do_move == "1" ]]
        then echo "mv -i $dir $target_name" 
        if [[ $execute == "1" ]] ; then mv -i $dir $target_name ; fi
    fi
    
    fi

    fi
done

echo 'done'
                      
