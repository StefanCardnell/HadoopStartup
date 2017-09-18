#!/bin/bash

# Copies mediumfile.txt to the DFS. Then distributes the blocks based on a dynamically
# calculated threshold value.

# See https://www.cloudera.com/documentation/enterprise/5-7-x/topics/admin_hdfs_balancer.html

if [ -z "$1" ]
then
    echo "No file to copy supplied"
    exit 1
fi

filename=`basename $1`

echo -e "##################\nDeleting existing file"
hadoop dfs -rmr /$filename

echo -e "##################\nCopying file across"
hadoop dfs -copyFromLocal $1 /$filename || exit 1

echo -e "##################\nObtaining balancer threshold"

blocksize=`hadoop dfs -stat %o /$filename` # Obtain the blocksize
filesize=`df -B1 / | tail -n 1 | awk '{print $2;}'` # Obtain the partition's total size

percentage=`echo "scale=20;$blocksize*50/$filesize" | bc`
percentage=`printf "%.6f" $percentage`  # Two significant figures
echo "Balancer threshold of $percentage"

echo -e "###################\nDistributing blocks"

hadoop balancer -threshold $percentage

echo -e "###################\nBalancer finished. Outputting new distribution..."

hadoop fsck /$filename -files -blocks -racks
