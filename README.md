FreeSpace
===
#### FreeSpace is a command-line bash script that compresses files and directories to save disk space. It is designed to be used in Linux operating systems. 

The script uses the options -r, -t and file, and requires that you specify the file or directory you wish to compress. The -r option allows you to compress all files and directories within a directory recursively. The -t option allows you to specify the number of hours to keep files compressed before deleting them. 

The script works by first checking if the file or directory is older than the specified time (48 hours by default). If it is, it will be compressed and the file name changed to start with 'fc-'. If the file is already compressed (zipped, tgzed, bzipped or compressed), the file name is changed to start with 'fc-', and the file is touched to change the modified time. If the file is not compressed, it is zipped and the old file is deleted. 

To run the script, use the following command in the command-line: 

./freespace [-r] [-t ###] file [file...] 
