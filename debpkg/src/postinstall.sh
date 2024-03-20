#!/bin/sh


fixconf() {
        if [ -r /etc/nginx/sites-available/messages.conf ]; then
                printf "\033[32m messages.conf exists\033[0m\n"

                if [ ! -L  /etc/nginx/sites-enabled/messages.conf ]; then
                        ln -s -f /etc/nginx/sites-available/messages.conf /etc/nginx/sites-enabled/messages.conf
                fi
        fi

        if [ -L /etc/nginx/sites-enabled/default ]; then
                rm -f /etc/nginx/sites-enabled/default

                if [ -r /etc/nginx/sites-available/default ]; then
                        rm -f /etc/nginx/sites-available/default
                fi
        fi

    	printf "\033[32m Reload the service unit from disk\033[0m\n"
    	systemctl reload nginx ||:
}

cleanInstall() {
	printf "\033[32m Post Install of an clean install\033[0m\n"
	# Step 3 (clean install), enable the service in the proper way for this platform

        set -e

        fixconf
}

upgrade() {
    	printf "\033[32m Post Install of an upgrade\033[0m\n"
    	# Step 3(upgrade), do what you need

        set -e

        fixconf
}

# Step 2, check if this is a clean install or an upgrade
action="$1"
if  [ "$1" = "configure" ] && [ -z "$2" ]; then
 	# Alpine linux does not pass args, and deb passes $1=configure
 	action="install"
elif [ "$1" = "configure" ] && [ -n "$2" ]; then
   	# deb passes $1=configure $2=<current version>
	action="upgrade"
fi

case "$action" in
  "1" | "install")
    cleanInstall
    ;;
  "2" | "upgrade")
    printf "\033[32m Post Install of an upgrade\033[0m\n"
    upgrade
    ;;
  *)
    # $1 == version being installed
    printf "\033[32m Alpine\033[0m"
    cleanInstall
    ;;
esac

