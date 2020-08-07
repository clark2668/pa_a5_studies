#!/bin/bash

input_list=A5_0501_raw_tar_list.txt
final_root_output_location=/data/user/brianclark/phased_array/A5_data/root_files
out_file=A5_0501_io_pairs.txt

while read line; do
	thedir=`dirname $line`
	themonth=`basename $thedir`
	echo $final_root_output_location/$themonth $line >> $out_file
done < $input_list
