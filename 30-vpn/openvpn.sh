
# #!/bin/bash
# set -euo pipefail


# USERNAME="openvpn"
# PASSWORD='Openvpn@123' 
# SCRIPTS="/usr/local/openvpn_as/scripts"
#   # Use SSM or Secrets Manager in production

# # Wait until Access Server UI is ready
# until curl -ks https://127.0.0.1:943/ >/dev/null 2>&1; do sleep 3; done

# # 1. Accept the license agreement
# $SCRIPTS/sacli --key 'eula_accepted' --value 'true' ConfigPut

# # 2. Set admin user and password
# $SCRIPTS/sacli --user "$USERNAME" --new_pass "$PASSWORD" SetLocalPassword
# $SCRIPTS/sacli --user "$USERNAME" --key 'prop_superuser' --value 'true' UserPropPut

# # 3. VPN port and protocol
# $SCRIPTS/sacli --key 'vpn.server.port'     --value '1194' ConfigPut
# $SCRIPTS/sacli --key 'vpn.server.protocol' --value 'udp'  ConfigPut

# # 4. DNS configuration: use Access Server host DNS
# $SCRIPTS/sacli --key 'vpn.client.dns.server_auto' --value 'true' ConfigPut
# $SCRIPTS/sacli --key 'cs.prof.defaults.dns.0' --value '8.8.8.8' ConfigPut
# $SCRIPTS/sacli --key 'cs.prof.defaults.dns.1' --value '1.1.1.1' ConfigPut

# # 5. Route all client traffic through the VPN
# $SCRIPTS/sacli --key 'vpn.client.routing.reroute_gw' --value 'true' ConfigPut

# # 6. Block access to VPN server services from clients (your latest request)
# $SCRIPTS/sacli --key 'vpn.server.routing.gateway_access' --value 'true' ConfigPut

# systemctl restart openvpnas

# # 7. Save and start
# $SCRIPTS/sacli ConfigSync
# $SCRIPTS/sacli start


##############################################################################################################

#!/bin/bash
set -euo pipefail

USERNAME="openvpn"
PASSWORD="Openvpn@123"
SCRIPTS="/usr/local/openvpn_as/scripts"

# # Ensure OpenVPN service is running
systemctl enable openvpnas
systemctl start openvpnas

# Wait until UI backend is fully initialized
until curl -ks https://127.0.0.1:943/ >/dev/null 2>&1; do sleep 3; done

# Create Linux admin user (MANDATORY)
id $USERNAME &>/dev/null || useradd $USERNAME

# Accept license
$SCRIPTS/sacli --key 'eula_accepted' --value 'true' ConfigPut

# Set admin password and role
$SCRIPTS/sacli --user "$USERNAME" --new_pass "$PASSWORD" SetLocalPassword
$SCRIPTS/sacli --user "$USERNAME" --key 'prop_superuser' --value 'true' UserPropPut

# VPN Port & protocol
$SCRIPTS/sacli --key 'vpn.server.port'     --value '1194' ConfigPut
$SCRIPTS/sacli --key 'vpn.server.protocol' --value 'udp'  ConfigPut

# DNS settings
$SCRIPTS/sacli --key 'vpn.client.dns.server_auto' --value 'true' ConfigPut
$SCRIPTS/sacli --key 'cs.prof.defaults.dns.0' --value '8.8.8.8' ConfigPut
$SCRIPTS/sacli --key 'cs.prof.defaults.dns.1' --value '1.1.1.1' ConfigPut

# Route all client traffic via VPN
$SCRIPTS/sacli --key 'vpn.client.routing.reroute_gw' --value 'true' ConfigPut

# Block VPN clients from accessing server LAN
$SCRIPTS/sacli --key 'vpn.server.routing.gateway_access' --value 'true' ConfigPut

# Save and apply all settings
$SCRIPTS/sacli ConfigSync
$SCRIPTS/sacli start




