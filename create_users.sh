#!/bin/bash

echo "Start."

#Kontrol att användare har root access.
if [ "$EUID" -ne 0 ];
	then echo "Programmet måste köras som root. (Superuser)"
	exit 1
fi

EXSISTING_USERS=$(cut -d: -f1 /etc/passwd)

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

	#Lägger in text i rad.
	echo "Välkommen $user" > "$WELCOME_FILE"
	echo "Användare som redan finns:" >> "$WELCOME_FILE"
	echo "$EXSISTING_USERS" >> "$WELCOME_FILE"

	#Här ger vi rättigheter till rätt användare.
	chmod 700 "$USER_DIR/Documents" "$USER_DIR/Downloads" "$USER_DIR/Work"
	chmod 600 "$WELCOME_FILE"

	chown -R "$user":"$user" "$USER_DIR"
	chown "$user":"$user" "$WELCOME_FILE"
	echo "$USER_DIR"
done

