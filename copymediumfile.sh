#!/bin/bash

# Copies mediumfile.txt to the DFS. Then distributes the blocks based on a dynamically
# calculated threshold value.

# See https://www.cloudera.com/documentation/enterprise/5-7-x/topics/admin_hdfs_balancer.html

echo -e "##################\nCopying file across"
hadoop dfs -copyFromLocal wordcountfiles/mediumfile.txt /mediumfile.txt

echo -e "##################\nObtaining balancer threshold"

blocksize=`sed -n '/block.size/{n;p}' /opt/hadoop/conf/hdfs-site.xml | sed -n 's/.*>\([0-9]\+\)<.*/\1/p'` # Obtain the blocksize
filesize=`df -B1 / | tail -n 1 | awk '{print $2;}'` # Obtain the partitions total size

percentage=`echo "$blocksize*50/$filesize" | bc -l`
percentage=`printf "%.3g" $percentage`  # Two significant figures
echo "Balancer threshold of $percentage"

echo -e "###################\nDistributing blocks"

hadoop balancer -threshold $percentage

echo -e "###################\nBalancer finished. Outputting new distribution..."

hadoop fsck /mediumfile.txt -files -blocks -racks

