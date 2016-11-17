#!/usr/bin/python2

import gnomekeyring as gkey
import sys

def get_password(keyring_name, key):
	ids = gkey.list_item_ids_sync(keyring_name)
	for id in ids:
		display_name = gkey.item_get_info_sync(keyring_name,id).get_display_name()
		if display_name == key:
			secret = gkey.item_get_info_sync(keyring_name,id).get_secret()
			return secret
	raise Exception("no credential found")



#def main(keyring_name, info):
#    (username, password) =get_password(keyring_name 
#		print(username)

if __name__ == '__main__':
    keyring_name = sys.argv[1]
    key = sys.argv[2]
    print get_password(keyring_name, key)
