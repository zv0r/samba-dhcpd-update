  GNU nano 4.8                                                                           /etc/kea/dhcpd-update-samba-dns.sh                                                                            Modified
#!/bin/bash

[ "${KEA_FAKE_ALLOCATION}" = "0" ] || exit 1
. /etc/kea/dhcpd-update-samba-dns.conf || exit 1
. /etc/environment || exit 1

sleep 10

HNAME=`echo "$KEA_LEASE4_HOSTNAME" | sed "s/\..*$//"`
if [ -n "$1" ] && [ -n "${HNAME}" ] && [ -n "${KEA_LEASE4_ADDRESS}" ]; then
    case $1 in
        lease4_select | lease4_renew)
                ACTION=ADD
        ;;
        lease4_expire | lease4_release)
                ACTION=DEL
        ;;
        *)
                echo "Error: invalid action \"ACTION\"."  exit 3
        ;;
    esac
    IP=$KEA_LEASE4_ADDRESS

    export PATH KRB5CC KEYTAB DOMAIN REALM PRINCIPAL NAMESERVER ZONE ACTION IP HNAME

    /etc/kea/samba-dnsupdate.sh -m &

fi
