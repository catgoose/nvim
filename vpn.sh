#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MAIN="${SCRIPT_DIR}/fuckForticlient.sh"

usage(){
	echo "Usage: vpn.sh [connect|auth|status|disconnect]"
	echo "  connect    (default) Connect using saved cookie; use config or set SERVER in config."
	echo "  auth       Force browser SAML login, then connect."
	echo "  status     Show VPN IP if connected."
	echo "  disconnect Kill openfortivpn."
}

cmd="${1:-connect}"
case "$cmd" in
	connect)
		"$MAIN" -s
		;;
	auth)
		"$MAIN" -c
		;;
	status)
		"$MAIN" -i
		;;
	disconnect)
		if pidof -q openfortivpn; then
			sudo kill "$(pidof openfortivpn)" 2>/dev/null && echo "Disconnected." || echo "Failed to kill openfortivpn."
		else
			echo "No openfortivpn process running."
		fi
		;;
	-h|--help)
		usage
		;;
	*)
		echo "Unknown subcommand: $cmd"
		usage
		exit 1
		;;
esac
