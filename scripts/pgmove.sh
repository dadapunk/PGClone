#!/bin/bash
#
# Title:      PGBlitz (Reference Title File)
# Author(s):  Admin9705
# URL:        https://pgblitz.com - http://github.pgblitz.com
# GNU:        General Public License v3.0
################################################################################
# NOTES
# Variables come from what's being called from deploymove.sh under functions
################################################################################
if pidof -o %PPID -x "$0"; then
   exit 1
fi

sleep 10
while true
do

dlpath=$(cat /var/plexguide/server.hd.path)

## BWLIMIT 9 and Lower Prevents Google 750GB Google Upload Ban

rclone moveto "$hdpath/downloads/" "$hdpath/move/" \
--config /opt/appdata/plexguide/rclone.conf \
--log-file=/var/plexguide/logs/pgmove.log \
--log-level ERROR --stats 5s --stats-file-name-length 0 \
--min-age 2m \
--exclude="**_HIDDEN~" --exclude=".unionfs/**" \
--exclude='**partial~' --exclude=".unionfs-fuse/**" \
--exclude="**sabnzbd**" --exclude="**nzbget**" \
--exclude="**qbittorrent**" --exclude="**rutorrent**" \
--exclude="**deluge**" --exclude="**transmission**" \
--exclude="**jdownloader**" --exclude="**makemkv**" \
--exclude="**handbrake**" --exclude="**bazarr**" \
--exclude="**ignore**"  --exclude="**inProgress**"

rclone move "$hdpath/move/" "{{type}}:/" \
--config /opt/appdata/plexguide/rclone.conf \
--log-file=/var/plexguide/logs/pgmove.log \
--log-level INFO --stats 5s --stats-file-name-length 0 \
--bwlimit {{bandwidth.stdout}}M \
--tpslimit 6 \
--checkers=16 \
--max-size=300G \
--exclude="**_HIDDEN~" --exclude=".unionfs/**" \
--exclude="**partial~" --exclude=".unionfs-fuse/**"

sleep 5

# Remove empty directories
find "$hdpath/downloads" -mindepth 2 -mmin +5 -type d -empty -exec rm -rf {} \;
find "$hdpath/downloads" -mindepth 3 -mmin +360 -type d -size -100M -exec rm -rf {} \;
find "$hdpath/move" -mindepth 2 -mmin +5 -type d -empty -delete

done