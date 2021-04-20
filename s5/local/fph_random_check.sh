#!/usr/bin/env bash

TRNPATH=$1

shuf $TRNPATH/segments | head -n10 | awk '{print $0}'
