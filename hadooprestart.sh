#!/bin/bash

# Stops all processes, formats namenodes, deletes temporary directories
# across nodes and starts processes agian

echo "#####################################"
echo "Stopping all processes"
stop-all.sh

echo "#####################################"
echo "Deleting filesystems across nodes"

for node in node1 node2 node3 node4;
do
    ssh pi@$node "sudo rm -rf /hdfs/tmp/*";
done

echo "#####################################"
echo "Reformatting Namenode"

hadoop namenode -format

echo "#####################################"
echo "Starting Hadoop services"

if start-dfs.sh && start-mapred.sh;
then
    echo "Hadoop services started. Listening for ports.."
    while ! netstat -l 2>/dev/null | grep -q "node1:54310";
    do
        echo "DFS LISTENING PORT NOT DETECTED, WAITING 10 SECONDS."
        sleep 10s
    done
    echo "DFS UP"

    while ! netstat -lp 2>/dev/null | grep -q "node1:54311";
    do
        echo "MAPRED LISTENING PORT NOT DETECTED, WAITING 10 SECONDS."
        sleep 10s
    done
    echo "MAPRED UP"
else
    echo "HADOOP SERVICES FAILED TO START."
    stop-all.sh
    exit 1
fi
