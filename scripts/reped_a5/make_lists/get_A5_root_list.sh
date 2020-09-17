#!/bin/bash

dir=/data/wipac/ARA/2019/blinded/ARA05_PA/ARA05


find ${dir}/*/*/event*.root ! -name 'eventHk*.root' > A5_run_list.txt
