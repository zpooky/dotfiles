#!/usr/bin/python

# open the keyrings
#

import gnomekeyring
import getpass  

pw = getpass.getpass("password: ");
gnomekeyring.unlock_sync("personal", pw);
gnomekeyring.unlock_sync(None, pw);
gnomekeyring.unlock_sync("work", pw);
