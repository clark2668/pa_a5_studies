#!/bin/bash

out_dir=$1
in_file=$2

bash /home/brianclark/phased_array/pa_a5_studies/scripts/rootify_a5_data/run_rootify/rootify.sh $TMPDIR $out_dir $in_file
