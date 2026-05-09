#!/bin/bash

echo "Start."

#Kontrol att användare har root access.
if [ "$EUID" -ne 0 ];
	then echo "Programmet måste köras som root. (Superuser)"
	exit 1
fi

#Skapar användare tidigare.
for user in "$@"; do
	if id "$user" &>/dev/null; then
		echo "Användarnamnet $user finns redan och hoppas över"
		continue
	fi

	useradd -m "$user"
	echo "Användare $user har skapats"
done

#for loop igenom alla användare som blivit givet.
for user in "$@"; do
	USER_DIR="/home/$user"

	if [ -d "$USER_DIR/Documents" ]; then
		echo "$user har redan mappar, fortsätter.."
		continue
	fi

	#Här skapar vi filer till användaren.
	mkdir -p "$USER_DIR/Documents" "$USER_DIR/Downloads" "$USER_DIR/Work"

	#skapar välkoms fil.
	WELCOME_FILE="$USER_DIR/Welcome.txt"

	#Lägger in text i rad.
	{
		echo "Välkommen $user"
		awk -F: -v excemption="$user" '$1 != excemption { print $1 }' /etc/passwd
	} > "$WELCOME_FILE"

	#Här ger vi rättigheter till rätt användare.
	chmod 700 "$USER_DIR/Documents" "$USER_DIR/Downloads" "$USER_DIR/Work"
	chmod 600 "$WELCOME_FILE"

	chown -R "$user:$user" "$USER_DIR"
	chown -R "$user:$user" "$WELCOME_FILE"
	echo "$USER_DIR skapat"
done

exit 0
