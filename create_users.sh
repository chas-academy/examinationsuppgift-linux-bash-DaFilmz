#!/bin/bash

#kontrollera att användare har root / är Superuser

if ["$EUID" -ne 0]; then #Noll är Superuser.
	echo "Du har inte tillgång till programmet. (Superuser)"
	exit 1
fi


