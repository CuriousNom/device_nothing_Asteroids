#=============================================================================
# Copyright (c) 2024 Qualcomm Technologies, Inc.
# All Rights Reserved.
# Confidential and Proprietary - Qualcomm Technologies, Inc.
#=============================================================================

get_num_logical_cores_in_physical_cluster()
{
	i=0
	logical_cores=(0 0 0 0 0 0)
	if [ -f /sys/devices/system/cpu/cpu0/topology/cluster_id ] ; then
		physical_cluster="cluster_id"
	else
		physical_cluster="physical_package_id"
	fi
	for i in `ls -d /sys/devices/system/cpu/cpufreq/policy[0-9]*`
	do
		if [ -e $i ] ; then
			num_cores=$(cat $i/related_cpus | wc -w)
			first_cpu=$(echo "$i" | sed 's/[^0-9]*//g')
			cluster_id=$(cat /sys/devices/system/cpu/cpu$first_cpu/topology/$physical_cluster)
			logical_cores[cluster_id]=$num_cores
		fi
	done
	cpu_topology=""
	j=0
	physical_cluster_count=$1
	while [[ $j -lt $physical_cluster_count ]]; do
		cpu_topology+=${logical_cores[$j]}
		if [ $j -lt $physical_cluster_count-1 ]; then
			cpu_topology+="_"
		fi
		j=$((j+1))
	done
	echo $cpu_topology
}

#Implementing this mechanism to jump to powersave governor if the script is not running
#as it would be an indication for devs for debug purposes.
fallback_setting()
{
	governor="powersave"
	for i in `ls -d /sys/devices/system/cpu/cpufreq/policy[0-9]*`
	do
		if [ -f $i/scaling_governor ] ; then
			echo $governor > $i/scaling_governor
		fi
	done
	exit
}

variant=$(get_num_logical_cores_in_physical_cluster "$1")
echo "CPU topology: ${variant}"
case "$variant" in
	"4_3_1")
	/vendor/bin/sh /vendor/bin/init.kernel.post_boot-volcano_default_4_3_1.sh
	;;
	"3_2_1")
	/vendor/bin/sh /vendor/bin/init.kernel.post_boot-volcano_3_2_1.sh
	;;
	"2_2_1")
	/vendor/bin/sh /vendor/bin/init.kernel.post_boot-volcano_2_2_1.sh
	;;
	"4_3_0")
	/vendor/bin/sh /vendor/bin/init.kernel.post_boot-volcano_4_3_0.sh
	;;
	*)
	echo "***WARNING***: Postboot script not present for the variant ${variant}"
	fallback_setting
	;;
esac

setprop vendor.post_boot.parsed 1
