echo " what is bad:"
echo "   * vertical pictures are resize to height 1080 :("
echo "   * spaces/special characters break the script :("

#! /usr/bin/env bash

BACKUP_DIRECTORY=backup

if [ -a ${BACKUP_DIRECTORY} ]
then
	echo "backup directory: \"${BACKUP_DIRECTORY}\" already exists. aborting."
	exit -1
fi

mkdir ${BACKUP_DIRECTORY}
cp -r * ${BACKUP_DIRECTORY}/

for i in $(ls | grep -v "\.avi$")
do
	if [ ${i} == ${BACKUP_DIRECTORY} ]
	then
		continue
	fi

	convert -quality 80 -resize 1920x1080 ${i} ${i}.jpg

	rm ${i}
done
