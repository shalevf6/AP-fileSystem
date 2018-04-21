#!/bin/bash
while true; do
	clear;
	read -p 'Insert path:' path
	if ! [ -d $path ]; then
		echo "Folder doesn't exist" ; sleep 1
	else
		break
	fi
done

echo "Dashboard is ON"

folderNum=`ls -p $path | grep / | wc -l`
fileNum=`ls -ap $path | grep -v / | wc -l`
sum=`ls -al $path | grep ^- | awk '{print $5}' | awk 'BEGIN {total=0;}{total+=$1;}END {print total}'`

touch logFile
oldPath=`sed '1q;d' logFile`

checkAgain() {
	if [ $4 -gt $1 ]; then
		let difference1=$4-$1
		echo "$difference1 sub-folders added"
	elif [ $1 -gt $4 ]; then
		let difference1=$1-$4
		echo "$difference1 sub-folders deleted"
	else
		echo "Number of sub-folder didn't change"
	fi

	if [ $5 -gt $2 ]; then
		let difference2=$5-$2
		echo "$difference2 files added"
	elif [ $2 -gt $5 ]; then
		let difference2=$2-$5
		echo "$difference2 files deleted"
	else
		echo "Number of files didn't change"
	fi

	if [ $6 -gt $3 ]; then
		let difference3=$6-$3
		echo "$difference3 bytes added"
	elif [ $3 -gt $6 ]; then
		let difference3=$3-$6
		echo "$difference3 bytes deleted"
	else
		echo "Files size didn't change"
	fi
}

if [ -s .logFile/logFile ] && [ "$oldPath" == "$path" ]; then
	oldFolderNum=`sed '2q;d' logFile`
	oldFileNum=`sed '3q;d' logFile`
	oldSum=`sed '4q;d' logFile`
	echo "$path
$folderNum
$fileNum
$sum" > logFile
	checkAgain $oldFolderNum $oldFileNum $oldSum $folderNum $fileNum $sum
else
	echo "$folderNum sub-folders"
	echo "$fileNum files"
	echo "$sum bytes"
	echo "$path
$folderNum
$fileNum
$sum" > logFile
fi

