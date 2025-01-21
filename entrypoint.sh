#!/bin/sh

# Bring down the interface if it already exists
wg-quick down /etc/wireguard/wg1.conf || true

# Bring up the interface
wg-quick up /etc/wireguard/wg1.conf

# Keep the container running
tail -f /dev/null
