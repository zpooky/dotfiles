#!/usr/bin/python

# open the keyrings
#

import gnomekeyring
import getpass  

pw = getpass.getpass("password: ");
gnomekeyring.unlock_sync(None, pw);
gnomekeyring.unlock_sync("offlineimap", pw);
gnomekeyring.unlock_sync("mail", pw);
