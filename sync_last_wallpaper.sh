#!/bin/bash

usage()
{
cat << EOF
usage: $0 options

This script takes a url and sets it as your desktop background
Run me every x minutes to sync your wallpaper

OPTIONS:
   -h      Show this message
   -u      Url to get (mandatory)
   -r      Rotate image (degrees clockwise)
   
EOF
}


WALLPAPER_REPO="$HOME/.last_wallpaper"
WALLPAPER_FILENAME="wallpaper.dat"
WALLPAPER_PATH="$WALLPAPER_REPO/$WALLPAPER_FILENAME"
TEMP_PATH=`mktemp`
URL=""
ROTATE=0

while getopts "hu:r:" OPTION
do
     case $OPTION in
         h)
             usage
             exit 1
             ;;
         u)
             URL=$OPTARG
             ;;
         r)  ROTATE=$OPTARG
             ;;
         ?)
             usage
             exit
             ;;
     esac
done

# create image repository
if [[ ! -d "$WALLPAPER_REPO" ]];then
	mkdir -p "$WALLPAPER_REPO"
fi

# grab image
wget -o /dev/null -q -O "$TEMP_PATH" -t 5 "$URL"

if [[ $? -eq 0 && -s "$TEMP_PATH" ]];then
	convert -rotate $ROTATE "$TEMP_PATH" "$WALLPAPER_PATH"
	# reset background with a non-existent image
	gconftool -s -t string /desktop/gnome/background/picture_filename /usr/share/backgrounds/dummy.jpg
	# load newly downloaded desktop background
	gconftool -s -t string /desktop/gnome/background/picture_filename "$WALLPAPER_PATH"
fi

exit 0