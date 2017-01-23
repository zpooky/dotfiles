#!/bin/bash
source $HOME/.Xdbus 
OUT=/tmp/sync_offlineimap


# sync
offlineimap > $OUT 

#
new_mail_dirs=("$HOME/.mail/*/*/new/")
MSG=""
ANY_NEW=false
for dir in ${new_mail_dirs[@]}; do
	#count new mails
	new_mails=`find "$dir" -type f | wc -l`
	if [[ new_mails -gt 0 ]]; then
		box=`echo $dir | sed -re "s/^.*\/(.*)\/new.*/\1/"`
		MSG="${MSG}$box($new_mails)"
		if [[ $ANY_NEW = true ]];then
			MSG="${MSG}/"
		fi
		ANY_NEW=true
	fi
done

if [[ $ANY_NEW = true ]];then
	#--hint=STRING:body:11 --hint=STRING:body:"$MSG"
	if [ ! -e ~/.nonotify ]; then
    notify-send --urgency=critical "$MSG" --expire-time=10
  fi
fi


# log
whoami >> $OUT
date >> $OUT 
