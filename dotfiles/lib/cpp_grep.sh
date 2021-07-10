#!/usr/bin/env bash

ack-grep "$1" --cpp #| grep -v "^[^/]"
