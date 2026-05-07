#!/bin/bash

#kontrollera att användare har root / är Superuser

echo "Start."

if [ "$EUID" -ne 0 ];
	then echo "Programmet måste köras som root. (Superuser)"
	exit 1
fi

for user in "$@"; do
	if id "$user" &>/dev/null; then
		echo "Användarnamntet '$user' finns redan i listan."
		continue
	fi
	
	useradd -m "$user"
	echo "Användare $user har skapats"
	#Här skapar vi filer och ger de läs och skriv rättigheter till den nya användaren.
	mkdir -p "/home/$user/Documents" "/home/$user/Downloads" "/home/$user/Work"
	chmod 700 "/home/$user/Documents" "/home/$user/Downloads" "/home/$user/Work"
done

echo "Klart."
