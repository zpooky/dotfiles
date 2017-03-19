#!/usr/bin/python2

# open the keyrings
#

import gnomekeyring
import getpass

pw = getpass.getpass("password: ");
gnomekeyring.unlock_sync("work", pw);
gnomekeyring.unlock_sync("personal", pw);
gnomekeyring.unlock_sync("personal2", pw);
gnomekeyring.unlock_sync(None, pw);
