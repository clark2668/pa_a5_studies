#!/bin/bash

input_list=A5_raw_data_all_tar_list.txt
output_list=A5_raw_data_unique_tar_list.txt 

# overwrite the original file
# echo "" > $output_list

# debug_file=debug.txt
# echo "" > $debug_file
# total_trouble=0

while read line; do

	# get the run number
	flattar_file=`basename $line`
	val="${flattar_file%.flat.tar}"
	run_num="${val##*_}"

	# figure out if the number occurs more than once
	number_cases=`grep $run_num $input_list | wc -l`

	if [ "$number_cases" -eq 1 ]; then
		# if it only ocurrs once, take the one and only file we find
		echo $line >> $output_list
	
	elif [ "$number_cases" -gt 1 ]; then
		# otherwise, it occurs twice
		# in which case, if we are on the normal "SPS" one, print it to file
		# but, if we are on the "ukey" one, we should just skip it
		if grep -q 'ukey' <<< "$flattar_file"; then
			continue
		else
			echo $line >> $output_list
		fi
	fi

	# commented out code to sort out if they are the same size, not needed anymore
	# if [ "$number_cases" -gt 1 ]; then
	# 	echo "Run "$run_num" is duplicated!"
	# 	files=( $(grep $run_num $input_list) )
	# 	file1=${files[0]}
	# 	file2=${files[1]}

	# 	size1=`du $file1 | awk '{ print $1 }'`
	# 	size2=`du $file2 | awk '{ print $1 }'`

	# 	if [ "$size1" != "$size2" ]; then
	# 		total_trouble=$((total_trouble+1))
	# 		echo "run "$run_num >> $debug_file
	# 		echo `du $file1` >> $debug_file
	# 		echo `du $file2` >> $debug_file
	# 		diff $file1 $file2 >> $debug_file
	# 		echo "" >> $debug_file
	# 	fi
	# fi

done < $input_list

# echo "total number of trouble files is "$total_trouble
