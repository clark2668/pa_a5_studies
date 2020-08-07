#!/bin/bash

input_list=A5_run_list.txt
out_file=A5_root_io_pairs.txt

while read line; do
	thedir=`dirname $line`
	echo $thedir $line >> $out_file
done < $input_list