#!/bin/sh
#==============================================================================
#
#  This script defines how to run CTest on the Argonne Leadership Computing
#  Facility systems (mira/cetus/vesta/cooley).
#
#  This assumes the CTest model name (e.g., "Nightly") is passed to it when
#  run.
#
#==============================================================================

# Get the CTest model name
model=$1

# Write QSUB submission script with the test execution command
echo "#!/bin/sh" > runctest.sh
echo "CTESTCMD=`which ctest`" >> runctest.sh
echo "\$CTESTCMD -S ctest/CTestScript-Test.cmake,${model} -V" >> runctest.sh

# Make the QSUB script executable
chmod +x runctest.sh

# Submit the job to the queue
jobid=`qsub -t 20 -n 4 --proccount 4 --mode script runctest.sh`

# Wait for the job to complete before exiting
while true; do
	status=`qstat $jobid`
	if [ "$status" == "" ]; then
		break
	else
		sleep 10
	fi
done