#!/bin/sh

myAdress=$(echo $(cat /sys/class/net/eth0/address) | cut -d: -f6-)

if [ $myAdress == "56" ] 
then
	./sender 57
	./sender 58
fi

if [ $myAdress == "57" ] 
then
	./sender 56
	./sender 58
fi

if [ $myAdress == "58" ] 
then
	./sender 56
	./sender 57
fi

# echo -e "$myAdress"