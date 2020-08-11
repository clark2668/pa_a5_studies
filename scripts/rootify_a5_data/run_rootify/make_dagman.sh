#!/bin/bash

job_file=dagman.dag
job_index=1

echo 'CONFIG dagman.config ' >> $job_file
echo '' >> $job_file

input_list=/home/brianclark/phased_array/pa_a5_studies/scripts/rootify_a5_data/make_lists/A5_0502_io_pairs.txt

while read line; do

	sa=($line)
	out=${sa[0]}
	in=${sa[1]}

	# get the run number
	local_file_name=`basename $in`
	val="${local_file_name%.flat.tar}"
	therun="${val##*_}"

	echo 'JOB job_'$job_index job.sub >> $job_file
	echo 'VARS job_'$job_index 'out_dir="'$out'"' 'in_file="'$in'"'  'therun="'$therun'"'>> $job_file
	echo '' >> $job_file

	job_index=$(($job_index+1))

done < $input_list
