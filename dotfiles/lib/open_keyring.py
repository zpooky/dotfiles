#!/usr/bin/python2

# open the keyrings
#

import gnomekeyring
import getpass


def has_keyring(name):
  for keyring in gnomekeyring.list_keyring_names_sync():
    if keyring == name:
      return True
  return False

pw = getpass.getpass("password: ");

if has_keyring("work"):
  gnomekeyring.unlock_sync("work", pw);

if has_keyring("personal"):
  gnomekeyring.unlock_sync("personal", pw);

if has_keyring("personal2"):
  gnomekeyring.unlock_sync("personal2", pw);

# gnomekeyring.unlock_sync(None, pw);
