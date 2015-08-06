#!/bin/bash

#var
price=$1
desc=$2
img="prix.png"
img_display="prix_display.png"

cp $img $img_display

#MEM
mem=`free -m | awk {'print $2'} | head -n 2| tail -1 | cut -d'M' -f1 | cut -d'G' -f1`
#echo $mem
if [ "$mem" -lt "600" ]
then
	memory="512Mo"
elif [ "$mem" -lt "1000" ]
then
	memory="1 Giga"
elif [ "$mem" -lt "2000" ]
then
	memory="2 Gigas"
elif [ "$mem" -lt "2000" ]
then
	memory="2 Gigas"
elif [ "$mem" -lt "3000" ]
then
	memory="3 Gigas"
elif [ "$mem" -lt "4000" ]
then
	memory="4 Gigas"
elif [ "$mem" -lt "5000" ]
then
	memory="5 Gigas"
elif [ "$mem" -lt "6000" ]
then
	memory="6 Gigas"
elif [ "$mem" -lt "7000" ]
then
	memory="7 Gigas"
elif [ "$mem" -lt "8000" ]
then
	memory="8 Gigas"
elif [ "$mem" -lt "8000" ]
then
	memory="8 Gigas"
fi
#Type Memoire
type_memory=`dmidecode  | grep DDR | cut -d":" -f2 | sed 's/ //g' | head -1`

#PROC
proc=`cat /proc/cpuinfo | grep -i "model name" | cut -d":" -f2 | head -1`
model_cpu=`echo $proc | head -1`

proc_freq=`cat /proc/cpuinfo | grep -i "cpu Mhz" | cut -d":" -f2 | head -1 | cut -d'.' -f1`
nb_cores=`cat /proc/cpuinfo  | grep -i "cpu cores" | head -1 | cut -d":" -f2 | sed 's/ //'`

#ESPACE DISQUE
#disk=`df -h`
disk=`fdisk -l | grep "^Dis" | cut -d" " -f3 | cut -d"." -f1 | head -1`



#Affichage
echo "CPU : " $model_cpu > /tmp/prix_emmaus.html
echo "Mémoire :" $memory $type_memory >> /tmp/prix_emmaus.html
echo "Disque dur :" $disk" Gigas" >> /tmp/prix_emmaus.html
echo "Prix :" $price"€" >> /tmp/prix_emmaus.html

cat /tmp/prix_emmaus.html

mogrify -fill black -pointsize 26 -annotate +65+59 "$desc $price €" $img_display
mogrify -fill black -pointsize 16 -annotate +65+89 "CPU : $model_cpu" $img_display
mogrify -fill black -pointsize 16 -annotate +65+119 "Mémoire : $memory" $img_display
mogrify -fill black -pointsize 16 -annotate +65+149 "Disque dur : $disk Gigas" $img_display

display $img_display
