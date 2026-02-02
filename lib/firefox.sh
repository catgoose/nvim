getProfilePath(){
	local profilepath=""
	case $DISTRO in
		Debian|Raspbian|Parrot)
			[[ ! -d "${HOME}/.mozilla/firefox" ]] && return 1
			profilepath="${HOME}/.mozilla/firefox"
			;;
		Ubuntu)
			if [[ -d "${HOME}/snap/firefox/common/.mozilla/firefox" ]]; then
				profilepath="${HOME}/snap/firefox/common/.mozilla/firefox"
			elif [[ -d "${HOME}/.mozilla/firefox" ]]; then
				profilepath="${HOME}/.mozilla/firefox"
			else
				return 1
			fi
			;;
		*)
			profilepath="${HOME}/.mozilla/firefox"
			;;
	esac
	echo "${profilepath}"
	return 0
}

enumerateProfiles(){
	local profilepath profs p pName
	profilepath=$(getProfilePath)
	if [[ $? -eq 0 ]]; then
		profs=$(cat "${profilepath}/profiles.ini" | grep Path | cut -d"=" -f2 | xargs)
		for p in ${profs}; do
			pName=$(echo "$p" | cut -d"." -f2)
			echo -e "  [>] Name     : ${clGreen}${pName}${clNone}"
			echo -e "  [>] Path (-p): ${clGreen}${profilepath}/${p}${clNone}"
			echo ""
		done
	else
		echo "[!] Unable to determine Firefox profile PATH!!!"
		return 1
	fi
}

getFirefoxProfile(){
	local profilep profilepath prof
	if [[ -r "${PROFILE_PATH}" ]]; then
		profilep=$(cat "${PROFILE_PATH}")
		if [[ -n "${profilep}" && -d "${profilep}" ]]; then
			echo "${profilep}"
			return 0
		fi
	fi
	profilepath=$(getProfilePath)
	if [[ $? -eq 0 ]]; then
		prof=$(cat "${profilepath}/profiles.ini" | grep Path= | grep -i default | tail -1 | cut -d"=" -f2)
		if [[ -n "$prof" ]]; then
			echo "${profilepath}/${prof}/sessionstore-backups"
			return 0
		else
			echo ""
			return 2
		fi
	else
		echo ""
		return 2
	fi
}

checkFirefoxSettings(){
	if [[ ! -d "${fProfile}" ]]; then
		return 1
	fi
	if [[ -f "${fProfile}/../prefs.js" ]]; then
		if grep -q "browser.privatebrowsing.autostart.*true" "${fProfile}/../prefs.js" 2>/dev/null; then
			echo -e "${clYellow}[!] Firefox may have private browsing autostart enabled; cookie might not be saved.${clNone}"
		fi
		if grep -q "privacy.sanitize.pending" "${fProfile}/../prefs.js" 2>/dev/null; then
			local sa
			sa=$(grep "privacy.sanitize.pending" "${fProfile}/../prefs.js" | head -1)
			if [[ "$sa" == *"[]"* ]] || [[ -z "$sa" ]]; then
				:
			else
				echo -e "${clYellow}[!] Firefox may clear history on exit; ensure SVPNCOOKIE can be stored.${clNone}"
			fi
		fi
	fi
	return 0
}
