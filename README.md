Some simple start-up scripts for hadoop multi-node raspberry pi setup since I got sick of writing the same commands over and over again.

This is very basic to my own system, but tweakable if using it yourself.

hadooprestart.sh stops hadoop, reformats the file system and starts up again.

copyfile.sh copies a supplied file to the DFS and distributes blocks based on a dynamically calculated threshold. 
