#!/bin/bash

kerbadminusername="ipausercreator"
kerbadminpass="ipausercreator password"
username=test
password=$(pwgen 12 1 -A -0)
kerbrealmname="LOC.LOCAL"

while getopts ":u:p:" opt; do
  case $opt in
    u) username="$OPTARG"
    ;;
    p) password="$OPTARG"
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    ;;
  esac
done

echo "${kerbadminpass}" | kinit $kerbadminusername@$kerbrealmname >:
randgenpass=$( ipa user-add $username --first=USER --last=LUSER --random | \
sed -n 's/Random password: \(.*\)/\1/p' | sed 's/^[ \t]*//;s/[ \t]*$//') >:
echo -e  "${randgenpass}\n${password}\n${password}"  | kinit $username@$kerbrealmname >:
kliststr=$(klist)
createduser=$(echo -e  "Created ${kliststr}" | sed -n 's/Default principal: \(.*\)/\1/p' )
echo "LDAP user $createduser created successfully" 
echo "Username: $username , Password: $password"

kdestroy -A
