#! /bin/bash


mapfile -t keeps < batch.keep
mapfile -t discards < batch.dcrd

if [ ! -d "songs" ]
then
    mkdir songs
fi

if [ ! -d "not_songs" ]
then
    mkdir not_songs
fi


for f in "${keeps[@]}"
do
    cp $f songs
    cp ${f%.cbin}.rec songs
done

for f in "${discards[@]}"
do
    cp $f not_songs
    cp ${f%.cbin}.rec not_songs
done
