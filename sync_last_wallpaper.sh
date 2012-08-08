#!/bin/bash

usage()
{
cat << EOF
usage: $0 options

This script takes a url and sets it as your desktop background
Run me every x minutes to sync your wallpaper

options:
   -h      Show this message
   -u      Url to get (mandatory)
   -r      Rotate image (degrees clockwise)
   -o      Set the placement option (scaled, zoom, stretched, centered)
   -d      Resize the image to a specified size string e.g. 300x200^:
			http://www.imagemagick.org/script/command-line-processing.php#geometry

EOF
}


wallpaper_repo="$HOME/.last_wallpaper"
wallpaper_filename="wallpaper.dat"
wallpaper_path="$wallpaper_repo/$wallpaper_filename"
temp_path=`mktemp`
url=""
rotate=0
options=""
dimensions=""

while getopts "hu:r:o:d:" option
do
	 case $option in
		 h)
			 usage
			 exit 1
			 ;;
		 u)
			 url=$OPTARG
			 ;;
		 r)  rotate=$OPTARG
			 ;;
		 o)  options=$OPTARG
			 ;;
		 d)  dimensions=$OPTARG
			 ;;
		 ?)
			 usage
			 exit
			 ;;
	 esac
done

# create image repository
if [[ ! -d "$wallpaper_repo" ]];then
	mkdir -p "$wallpaper_repo"
fi

# grab image
wget -o /dev/null -q -O "$temp_path" -t 5 "$url"

if [[ $? -eq 0 && -s "$temp_path" ]];then

	resize_command_frag=""
	if [[ -n $dimensions ]];then
		resize_command_frag="-resize $dimensions"
	fi
	convert -rotate $rotate $resize_command_frag "$temp_path" "$wallpaper_path"

	if [[ `gnome-shell --version` =~ "GNOME Shell 3" ]];then
		gsettings set org.gnome.desktop.background picture-uri "file:///$wallpaper_path"

		if [[ -n $options ]];then
			gsettings set org.gnome.desktop.background picture-options "$options"
		fi

	else
		# reset background with a non-existent image
		gconftool -s -t string /desktop/gnome/background/picture_filename /usr/share/backgrounds/dummy.jpg
		# load newly downloaded desktop background
		gconftool -s -t string /desktop/gnome/background/picture_filename "$wallpaper_path"
	fi
fi

exit 0