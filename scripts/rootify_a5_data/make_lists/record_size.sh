#!/bin/bash

# record size for every file

input_list=A5_raw_data_unique_tar_list.txt
out_file=size_list.txt

while read line; do
	du $line >> $out_file
done < $input_list
