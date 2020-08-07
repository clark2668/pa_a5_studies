#!/bin/bash

working_path=$1
output_directory=$2
full_path_to_orig_file=$3

local_file_name=`basename $full_path_to_orig_file`
val="${local_file_name%.root}"
the_run="${val##*event}"

echo 'Run number : ' $the_run
echo ''

pedfile=reped_run${the_run}.dat
echo 'Reped file : ' $pedfile
echo ''

echo 'About to run repeder'
cd $working_path
source /cvmfs/ara.opensciencegrid.org/trunk/centos7/setup.sh 
${ARA_UTIL_INSTALL_DIR}/bin/repeder $full_path_to_orig_file $pedfile
echo 'Done running repeder'
echo ''

mv $pedfile $output_directory/.
echo 'File move complete'