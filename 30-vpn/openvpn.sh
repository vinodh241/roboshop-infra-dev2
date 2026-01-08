#!/usr/bin/env bash
set -euxo pipefail

sleep 25

USERNAME="openvpn"
PASSWORD="Openvpn@123"
SCRIPTS="/usr/local/openvpn_as/scripts"

until curl -ks https://127.0.0.1:943/ >/dev/null 2>&1; do sleep 5; done

$SCRIPTS/sacli --key 'eula_accepted' --value 'true' ConfigPut

id $USERNAME &>/dev/null || useradd $USERNAME

$SCRIPTS/sacli --user "$USERNAME" --new_pass "$PASSWORD" SetLocalPassword
$SCRIPTS/sacli --user "$USERNAME" --key 'prop_superuser' --value 'true' UserPropPut

$SCRIPTS/sacli --key 'vpn.server.port' --value '1194' ConfigPut
$SCRIPTS/sacli --key 'vpn.server.protocol' --value 'udp' ConfigPut

$SCRIPTS/sacli --key 'vpn.client.dns.server_auto' --value 'true' ConfigPut
$SCRIPTS/sacli --key 'cs.prof.defaults.dns.0' --value '8.8.8.8' ConfigPut
$SCRIPTS/sacli --key 'cs.prof.defaults.dns.1' --value '1.1.1.1' ConfigPut

$SCRIPTS/sacli --key 'vpn.client.routing.reroute_gw' --value 'true' ConfigPut
$SCRIPTS/sacli --key 'vpn.server.routing.gateway_access' --value 'true' ConfigPut

systemctl restart openvpnas

echo "==============================================="
echo " OPENVPN ACCESS SERVER READY"
echo " Admin UI : https://<PUBLIC-IP>:943/admin"
echo " User UI  : https://<PUBLIC-IP>:943"
echo " Username : openvpn"
echo " Password : Openvpn@123"
echo "==============================================="
