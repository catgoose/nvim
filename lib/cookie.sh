getCookie(){
	local storage="$1" waitForIt="$2" c curUmask
	curUmask=$(umask)
	umask 077
	c=$(lz4jsoncat "${storage}/recovery.jsonlz4" 2>/dev/null | jq -r '.cookies[]|select(.name!=null)|select(.name|contains("SVPNCOOKIE"))|.value // empty')
	if [[ -n "$c" ]]; then
		echo "SVPNCOOKIE=${c}" > "${COOKIE_PATH}"
		umask "$curUmask"
		return 0
	fi
	[[ "$waitForIt" -eq 0 ]] && { umask "$curUmask"; return 1; }
	while inotifywait -e modify -t "$TIMEOUT" --format '%w%f' "${storage}" -q >/dev/null 2>&1; do
		if [[ -r "${storage}/recovery.jsonlz4" ]]; then
			c=$(lz4jsoncat "${storage}/recovery.jsonlz4" 2>/dev/null | jq -r '.cookies[]|select(.name!=null)|select(.name|contains("SVPNCOOKIE"))|.value // empty')
			if [[ -n "$c" ]]; then
				echo "SVPNCOOKIE=${c}" > "${COOKIE_PATH}"
				umask "$curUmask"
				return 0
			fi
		fi
	done
	c=$(lz4jsoncat "${storage}/recovery.jsonlz4" 2>/dev/null | jq -r '.cookies[]|select(.name!=null)|select(.name|contains("SVPNCOOKIE"))|.value // empty')
	if [[ -n "$c" ]]; then
		echo "SVPNCOOKIE=${c}" > "${COOKIE_PATH}"
		umask "$curUmask"
		return 0
	fi
	umask "$curUmask"
	return 1
}
