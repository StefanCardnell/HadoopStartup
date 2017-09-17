Some simple start-up scripts for hadoop multi-node raspberry pi setup since I got sick of writing the same commands over and over again.

This is very basic to my own system, but tweakable if using it yourself.

hadooprestart.sh stops hadoop, reformats the file system and starts up again.

copymediumfile.sh copies a specific file across to the DFS and distributes block based on a dynamically calculated threshold. 
