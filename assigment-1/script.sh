#!/bin/bash

### sprawdzam, czy nie ma już istniejącego katalogu tmp, jesli istnieje to usuwam go
if [ -d ./tmp ];
  then rm -rf ./tmp
fi

### tworze katalog tmp oraz rozpakowuje do niego zawartosc archiwum
mkdir ./tmp
tar -xf logs.tar.bz2 -C ./tmp

### wyciagam z logow warosci zawierajace wpis client_ip, biore tylko wpisy zaiweierajace wartosc ip, zliczam unikalne wartosci oraz sortuje
awk  '/client_ip: / {if(length($14) > 3 )  print$14 } ' ./tmp/logs/logs.log | uniq -c | sort

### usuwam katalog tmp
rm -rf ./tmp


