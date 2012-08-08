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
   -o      Set the placement option (scaled, zoom, stretched, centered)
   -d      Resize the image to a specified size string e.g. 300x200^:
            http://www.imagemagick.org/script/command-line-processing.php#geometry
EOF
}


WALLPAPER_REPO="$HOME/.last_wallpaper"
WALLPAPER_FILENAME="wallpaper.dat"
WALLPAPER_PATH="$WALLPAPER_REPO/$WALLPAPER_FILENAME"
TEMP_PATH=`mktemp`
URL=""
ROTATE=0
OPTIONS=""
DIMENSIONS=""

while getopts "hu:r:o:d:" OPTION
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
         o)  OPTIONS=$OPTARG
             ;;
         d)  DIMENSIONS=$OPTARG
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

    resize_command_frag=""
    if [[ -n $DIMENSIONS ]];then
        resize_command_frag="-resize $DIMENSIONS"
    fi
	convert -rotate $ROTATE $resize_command_frag "$TEMP_PATH" "$WALLPAPER_PATH"

    if [[ `gnome-shell --version` =~ "GNOME Shell 3" ]];then
        gsettings set org.gnome.desktop.background picture-uri "file:///$WALLPAPER_PATH"

        if [[ -n $OPTIONS ]];then
            gsettings set org.gnome.desktop.background picture-options "$OPTIONS"
        fi

    else
    	# reset background with a non-existent image
    	gconftool -s -t string /desktop/gnome/background/picture_filename /usr/share/backgrounds/dummy.jpg
    	# load newly downloaded desktop background
    	gconftool -s -t string /desktop/gnome/background/picture_filename "$WALLPAPER_PATH"
    fi
fi

exit 0