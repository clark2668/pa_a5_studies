#!/bin/bash

working_path=$1
output_directory=$2
full_path_to_orig_file=$3

echo ''
# make sure the file exists
if test -f "$full_path_to_orig_file"; then
	echo 'File              : '$full_path_to_orig_file
else
	echo 'File '$full_path_to_orig_file'does not exist! Exit!'
	exit
fi

# make sure the directory we want to do work in exists
if test -d "$working_path"; then
	echo 'Working directory : '$working_path
else
	echo 'Working directory '$working_path'does not exist! Exit!'
	exit
fi

# get just the filename
flattar_file=`basename $full_path_to_orig_file`
echo 'Basename          : '$flattar_file

# get the run number
val="${flattar_file%.flat.tar}"
run_num="${val##*_}"
echo 'Run number           : '$run_num
echo ''

# copy the original file to our playground, where we can untar and such
cd $working_path
cp $full_path_to_orig_file .
echo 'Copy complete'
echo ''

# protect the original at all costs, so destroy our record of it
full_path_to_orig_file=""

# untar the flattar file
echo 'Start untarring '$flattar_file
tar -xf $flattar_file
echo 'Untarring complete'
echo ''

# now we clean up the *.flat.tar file, which is now junk
rm $flattar_file

# and we clean up the *.xml file, which is also junk
rm *.xml

dattar_file=`ls *$run_num*.dat.tar`


# and, we untar the .dat.tar file
echo 'Start untarring '$dattar_file
tar -xf $dattar_file
echo 'Untarring complete'
echo ''

# and now we remove the .dat.tar file, because it is excess now
rm $dattar_file

# okay, and finally we can start rootifying

raw_dir=${working_path}/run_${run_num}

# make a place for the ROOT output
rootfile_name=run${run_num}
mkdir -p $rootfile_name
EVENT_FILE=${working_path}/${rootfile_name}/event${run_num}.root
SENSOR_HK_FILE=${working_path}/${rootfile_name}/sensorHk${run_num}.root
EVENT_HK_FILE=${working_path}/${rootfile_name}/eventHk${run_num}.root

# and get the ARA tools active
source /cvmfs/ara.opensciencegrid.org/trunk/centos7/setup.sh 


# first, the data events

echo 'Make event list for '$raw_dir
EVENT_FILE_LIST=`mktemp event.XXXX`
for file in ${raw_dir}/event/ev_*/*;
do
	if [[ -f $file ]]; then
		echo $file >> ${EVENT_FILE_LIST}
	fi
done
echo 'Making event list done'
echo ''


echo 'About to rootify the events'
if test `cat ${EVENT_FILE_LIST} | wc -l` -gt 0; then
	${ARA_UTIL_INSTALL_DIR}/bin/makeAtriEventTree ${EVENT_FILE_LIST} ${EVENT_FILE} ${run_num}
	rm ${EVENT_FILE_LIST}
	echo "Done rootifying events :    "${EVENT_FILE}
else
	rm ${EVENT_FILE_LIST}
	echo "No event files     :"${EVENT_FILE}
fi
echo ''


# now, sensor hk data

echo 'Make sensorHk list for '$raw_dir
SENSOR_HK_FILE_LIST=`mktemp sensor.XXXX`
for file in ${raw_dir}/sensorHk/sensorHk_*/*;
do
	if [[ -f $file ]]; then
		echo $file >> ${SENSOR_HK_FILE_LIST}
	fi
done
echo 'Making sensorhk list done'
echo ''


echo 'About to rootify the sensorHk'
if test `cat ${SENSOR_HK_FILE_LIST} | wc -l` -gt 0; then
	${ARA_UTIL_INSTALL_DIR}/bin/makeAtriSensorHkTree ${SENSOR_HK_FILE_LIST} ${SENSOR_HK_FILE} ${run_num}
	rm ${SENSOR_HK_FILE_LIST}
	echo "Done rootifying sensorHk :    "${SENSOR_HK_FILE}
else
	rm ${SENSOR_HK_FILE_LIST}
	echo "No sensorHk files     :"${SENSOR_HK_FILE}
fi
echo ''



# now, sensor hk data

echo 'Make eventHk list for '$raw_dir
EVENT_HK_FILE_LIST=`mktemp sensor.XXXX`
for file in ${raw_dir}/eventHk/eventHk_*/*;
do
	if [[ -f $file ]]; then
		echo $file >> ${EVENT_HK_FILE_LIST}
	fi
done
echo 'Making eventHk list done'
echo ''


echo 'About to rootify the eventHk'
if test `cat ${EVENT_HK_FILE_LIST} | wc -l` -gt 0; then
	${ARA_UTIL_INSTALL_DIR}/bin/makeAtriSensorHkTree ${EVENT_HK_FILE_LIST} ${EVENT_HK_FILE} ${run_num}
	rm ${EVENT_HK_FILE_LIST}
	echo "Done rootifying eventHk :    "${EVENT_HK_FILE}
else
	rm ${EVENT_HK_FILE_LIST}
	echo "No eventHk files     :"${EVENT_HK_FILE}
fi
echo ''

# now, we move the results
echo 'Moving output root files to final home'
mv $rootfile_name $output_directory/.
echo 'Moving done'
echo ''
