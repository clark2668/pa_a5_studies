#!/bin/bash

dir=/data/user/brianclark/phased_array/A5_data/root_files


find ${dir}/*/*/event*.root ! -name 'eventHk*.root' > A5_run_list.txt
