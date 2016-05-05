#! /usr/bin/env bash

# Simple image resizing script
#
#  * Creates a backup of the images
#  * Renames all files to number.extension, e.g. 001.jpg
#  * Transforms extensions to lower case. JPG and JPEG become jpg e.g.
#  * Resizes to 1920 pixels and reduces image quality to 80%
#
# Usage: Execute it in the directory containing the images to-be-converted

set -e

backup_directory=backup

if [ -e "$backup_directory" ]; then
	echo "Backup directory: \"$backup_directory\" already exists. Aborting."
	exit 1
fi

mkdir "$backup_directory"
find . ! -name "$backup_directory" ! -name "." -exec cp -t "$backup_directory/" {} +

n=1
file_count=$(expr $(ls -l | grep -v "\.avi$" | grep -v "\.mp4$" | grep -v "$backup_directory$" | wc -l) - 1)

for file in *; do

	if [ -d "$file" ]; then continue; fi

	file_name=$(basename "$file")
	ext="${file_name##*.}"
	ext_lower_case="${ext,,}"

	if [ "$ext_lower_case" = "avi" ] || [ "$ext_lower_case" = "mp4" ]; then continue; fi
	if [ "$ext_lower_case" = "jpeg" ]; then ext_lower_case="jpg"; fi

	new_file_name="$(printf "%03d" $n).$ext_lower_case"

	# Convert fails if source and target file are the same.
	# Therefore we rename the file beforehand.
	mv "$file" "_$file_name"
	file="_$file_name"

	# Convert -resize uses the smallest dimension of the image for resizing.
	# Choosing 1920x1080 would reduce 4:3 images to height 1080 but width would be a lot smaller than 1920
	# Also vertical images would be much smaller.
	# Therefore we use -resize 1920x1920
	convert -quality 80 -resize 1920x1920 "$file" "$new_file_name"

	rm "$file"

	printf "$n/$file_count, "

	((n+=1))
done

echo
