#!/bin/bash
#This script will append trace the user activities
NOW=`date +%F" "%T`

echo "${NOW} $@" >> ../logs/trace_action.log

