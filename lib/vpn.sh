getVPNIp(){
	local data iface
	for iface in ppp0 ppp1; do
		data=$(ip -o -4 addr show dev "$iface" 2>/dev/null | awk '{print $4}')
		if [[ -n "$data" ]]; then
			echo "$data"
			return 0
		fi
	done
	data=$(ip -o -4 addr show 2>/dev/null | grep -E "tun[0-9]+" | head -1 | awk '{print $4}')
	if [[ -n "$data" ]]; then
		echo "$data"
		return 0
	fi
	echo ""
	return 1
}

run_openfortivpn(){
	local dbg=""
	[[ $DEBUG -eq 1 ]] && dbg="-vvv"
	sudo "${OPENFORTIVPN}" "${SERVER}:443" --cookie-on-stdin < "${COOKIE_PATH}" ${dbg} ${FUCKFORTICLIENT_OPTS}
	return $?
}

checkAnotherInstance(){
	pidof -q openfortivpn
	if [[ $? -eq 0 ]]; then
		echo -e "${clRed}[!] Another openfortivpn instance detected!${clNone}"
		local ipvpn
		ipvpn=$(getVPNIp)
		if [[ $? -eq 0 ]]; then
			echo -e "[+] Current VPN IP: ${clGreen}${ipvpn}${clNone}"
			echo -e "${clRed}[!] If you kill openfortivpn instance, you will be disconnected!${clNone}"
		fi
		echo -e "[!] Run: ${clGreen} sudo kill \$(pidof openfortivpn)${clNone} or just press CTRL+c on the terminal window..."
		exit 1
	fi
	return 0
}

checkOpenfortivpn(){
	local path
	path=$(type -p openfortivpn 2>/dev/null)
	[[ -n "$path" && "$path" == /usr/* ]] && return 0
	return 1
}
