#!/bin/bash

echo "Start."

#Kontrol att användare har root access.
if [ "$EUID" -ne 0 ];
	then echo "Programmet måste köras som root. (Superuser)"
	exit 1
fi

#for loop igenom alla användare som blivit givet.
for user in "$@"; do
	if id "$user" &>/dev/null; then
		echo "Användarnamntet '$user' finns redan i listan."
		continue
	fi
	#User shortcut var.
	USER_DIR="/home/$user"

	useradd -m "$user"
	echo "Användare $user har skapats"
	#Här skapar vi filer till användaren.
	mkdir -p "$USER_DIR/Documents" "$USER_DIR/Downloads" "$USER_DIR/Work"

	#skapar välkoms fil.
	WELCOME_FILE="$USER_DIR/welcome.txt"
	#Lägger in text i rad 1.
	echo "välkommen $user" > "$WELCOME_FILE"

	echo "Andra användare i systemet:" >> "$WELCOME_FILE"
	cut -d: -f1 /etc/passwd >> "$WELCOME_FILE"

	#Här ger vi rättigheter till rätt användare.
	chmod 700 "$USER_DIR/Documents" "$USER_DIR/Downloads" "$USER_DIR/Work"

	chown -R "$user:$user" "$USER_DIR"

	echo "$USER_DIR"
done

echo "Klart."
