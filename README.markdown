Remote Desktop Background Sync
============================

A script for gnome users to sync their desktop background image with a remote url.

Use it for:  
* Any image with a URL that changes over time....  
* Any of the images from the amazing lastfm.dontdrinkandroot.net (please donate to them, they do awesome work)  
* Yahoo weather images for your area etc  

Usage
-----
	OPTIONS:
	   -h      Show this message
	   -u      Url to get (mandatory)
	   -r      Rotate image (degrees clockwise)

Personally i have my recent Tag Cloud from lastfm.dontdrinkandroot.net updating via cron every couple of hours, as i listen to last.fm all day every day it makes for an interesting background.

(Don't forget to chmod +x it)  
	0 */2 * * * dougle bash "$HOME/.scripts/last_wallpaper/sync_last_wallpaper.sh" -r 90 -u "http://lastfm.dontdrinkandroot.net/tools/user/tagcloud/Dougle_/overall/lower_thumb.png"
	
Every two hours it goes and grabs my latest image, if it is sucessfull it rotates it ninety degrees and then sets it as my desktop, easy.


Contributing
------------
All comments and bug reports are welcome, this plugin will be kept up-to-date and improved with my new features as and when i stumble across them. Forks and pull requests are also welcome.