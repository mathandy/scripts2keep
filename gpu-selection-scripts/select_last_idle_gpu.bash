#!/bin/bash
select_last_idle_gpu(){
	gpu_id=3
	while read -r gpu_status; do
	    if [[ "${gpu_status}" == *"0MiB / 10989MiB"* ]]; then
		  		export CUDA_VISIBLE_DEVICES=${gpu_id}
		  		echo "Successfully set CUDA_VISIBLE_DEVICES=${CUDA_VISIBLE_DEVICES} :)"
		  		return ${gpu_id}
		fi
		let gpu_id-=1
	done <<< "$(nvidia-smi | grep -n Default |  sort -rn)"
	echo "No idle GPUs found."
	return -1
}
select_last_idle_gpu
