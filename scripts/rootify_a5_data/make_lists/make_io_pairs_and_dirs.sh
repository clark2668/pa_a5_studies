#!/bin/bash

# make the output directory for each file
# and also, write a txt file that has the output directory to tar file pairing

input_list=A5_raw_data_unique_tar_list.txt
final_root_output_location=/data/wipac/ARA/2019/blinded/ARA05_PA/ARA05
out_file=A5_io_pairs.txt

while read line; do
	thedir=`dirname $line`
	themonth=`basename $thedir`
	mkdir -p $final_root_output_location/$themonth
	echo $final_root_output_location/$themonth $line >> $out_file
done < $input_list
