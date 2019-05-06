#! /bin/bash

#Скрипт для создания raid10.
#Выполняем его, если файл /dev/md0 не существует.

if [ ! -f "/dev/md0" ]
then
	#Зануляем суперблоки
	mdadm --zero-superblock --force /dev/sd{b,c,d,e}

	#Создаем рейд	
	mdadm --create --verbose /dev/md0 --level=10 --raid-devices=4 /dev/sd{b,c,d,e}
	cat /proc/mdstat

	#Сохраняем конфигурацию
	mkdir /etc/mdadm
	mdadm --detail --scan --verbose | awk '/ARRAY/ {print}' >> /etc/mdadm/mdadm.conf

	#Создаем разделы и файловые системы на нашем массиве 
	parted -s /dev/md0 mklabel gpt

	parted /dev/md0 mkpart primary ext4 0% 10%
	parted /dev/md0 mkpart primary ext4 10% 30%
	parted /dev/md0 mkpart primary ext4 30% 60%
	parted /dev/md0 mkpart primary ext4 60% 80%
	parted /dev/md0 mkpart primary ext4 80% 100%

	for i in $(seq 1 5)
	do 
		mkfs.ext4 /dev/md0p$i
	done

	#Создаем директории и монтируем туда разделы.
	#Не забываем добавить это в /etc/fstab для автоматического монтирования при старте системы.
	mkdir -p /mnt/raidpart{1,2,3,4,5}

	for i in $(seq 1 5)
	do
		mount /dev/md0p$i /mnt/raidpart$i
		echo "/dev/md0p$i    /mnt/raidpart$i    ext4    defaults    0   0" >> /etc/fstab
	done

	#Запишем что-нибудь на разделы.
	cat /etc/fstab >> /mnt/raidpart1/fstab
	cat /etc/mdadm/mdadm.conf >> /mnt/raidpart3/mdadm
	cat /proc/mdstat >> /mnt/raidpart2/mdstat
	mdadm -D /dev/md0 >> /mnt/raidpart4/raid
else
	echo "Raid is exist"
fi		



