#!/bin/sh

vgrouter_user="vgrouter"

remove() {
        printf "\033[32m Post Remove of a normal remove\033[0m\n"

        if id "${vgrouter_user}" >/dev/null 2>&1; then
                userdel -r "${vgrouter_user}"
        else 
                echo "user ${vgrouter_user} does not exists"              
        fi

        printf "\033[32m Reload the service unit from disk\033[0m\n"
}

purge() {
    printf "\033[32m Pre Remove purge, deb only\033[0m\n"
}

upgrade() {
    printf "\033[32m Pre Remove of an upgrade\033[0m\n"
}

echo "$@"

action="$1"

case "$action" in
  "0" | "remove")
    remove
    ;;
  "1" | "upgrade")
    upgrade
    ;;
  "purge")
    purge
    ;;
  *)
    printf "\033[32m Alpine\033[0m"
    remove
    ;;
esac
