#!/bin/sh
/usr/bin/filebot -script fn:amc --output "/media/" --action $1 "/media/.tmp/complete" --conflict override -non-strict --def skipExtract=y --def pushbullet=o.95mRG3QXfokF9cMaefg3pY9xN2LXmXek  --def minLengthMS=0 --def clean=y --def artwork=y --def unsorted=y --def unsortedFormat="/media/.tmp/unsorted/{fn}" --def movieFormat="/media/.tmp/movies/{n} ({y})/{n} ({y})" --def seriesFormat="/media/.tmp/shows/{n} - {s00e00} - {t}"

if [ $1 = "move" ]; then
	#Time delay to allow filebot commands to complete
	/bin/sleep 5

	#Check for processed Movies
	echo Checking for processed Movies
        if [ $(/usr/bin/find /media/.tmp/movies/ -name "*.mkv" | wc -l) = 0 ]; then
                echo No movies found, skipping processing of Movies.
	else
		/bin/sed -i '/sorttitle/d' /media/.tmp/movies/*/movie.nfo
		/bin/mv /media/.tmp/movies/* /media/Movies/
	fi

	#Check for processed Shows
	echo Checking for processed Shows
	if [ $(/usr/bin/find /media/.tmp/shows/ -name "*.mkv" | wc -l) = 0 ]; then
		echo No shows found, skipping processing of Shows.
	else
		for f in /media/.tmp/shows/*.mkv ; do /usr/bin/curl http://localhost:8989/api/command -X POST -d '{"name": "downloadedepisodesscan", "importMode": "Move", "path": "'"$f"'"}' --header "X-Api-Key:43faeb6114be412eadeb6e04094f01a7" && /bin/sleep 3 ; done
		/bin/sleep 5
	fi
	#echo Sending call to Kodi to Update Library
	#kodi-send --action='UpdateLibrary(video)'
fi
