#!/bin/bash

input_list=A5_raw_data_unique_tar_list.txt
final_root_output_location=/data/wipac/ARA/2019/blinded/ARA05_PA/ARA05
out_file=A5_io_pairs.txt

while read line; do
	thedir=`dirname $line`
	themonth=`basename $thedir`
	echo $final_root_output_location/$themonth $line >> $out_file
done < $input_list
