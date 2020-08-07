#!/bin/bash

job_file=dagman.dag
job_index=1

echo 'CONFIG dagman.config ' >> $job_file
echo '' >> $job_file

input_list=/home/brianclark/phased_array/pa_a5_studies/scripts/rootify_a5_data/make_lists/A5_0501_io_pairs.txt

while read line; do

	sa=($line)
	out=${sa[0]}
	in=${sa[1]}

	echo 'JOB job_'$job_index job.sub >> $job_file
	echo 'VARS job_'$job_index 'out_dir="'$out'"' 'in_file="'$in'"' >> $job_file
	echo '' >> $job_file

	job_index=$(($job_index+1))

done < $input_list