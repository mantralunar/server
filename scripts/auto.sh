#!/bin/sh
/usr/bin/filebot -script fn:amc --output "/media/" --action $1 "/media/.tmp/complete" --conflict override -non-strict --def skipExtract=y --def pushbullet=o.95mRG3QXfokF9cMaefg3pY9xN2LXmXek  --def minLengthMS=0 --def clean=y --def artwork=y --def unsorted=y --def unsortedFormat="/media/.tmp/unsorted/{fn}" --def movieFormat="Movies/{n} ({y})/{n} ({y})" --def seriesFormat="/media/.tmp/shows/{n} - {s00e00} - {t}"

if [ $1 = "move" ]; then
	/bin/sleep 5
	/bin/sed -i '/sorttitle/d' /media/Movies/*/movie.nfo
	/usr/bin/find /media/ -type f -size 0 -delete
	if [ $(/usr/bin/find /media/.tmp/shows/ -name "*.mkv" | wc -l) = 0 ]; then
		echo No shows found, skipping Sonarr API calls.
	else
		for f in /media/.tmp/shows/*.mkv ; do /usr/bin/curl http://localhost:8989/api/command -X POST -d '{"name": "downloadedepisodesscan", "importMode": "Move", "path": "'"$f"'"}' --header "X-Api-Key:43faeb6114be412eadeb6e04094f01a7" && /bin/sleep 3 ; done
		/bin/sleep 5
	fi
	echo Sending call to Kodi to Update Library
	kodi-send --action='UpdateLibrary(video)'
fi
