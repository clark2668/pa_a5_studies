#!/bin/bash

data_dir=/data/user/cdeaconu/nuphase-root-data/*
out_file="pa_runlist.txt"

for dir in $data_dir
do
	dir=${dir##*/} # result is runXXXX
	run_no=${dir:(-4)}
	echo $run_no >> $out_file
done
