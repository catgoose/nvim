load_config(){
	local config_dir config_file
	config_dir="${XDG_CONFIG_HOME:-${HOME}/.config}/fuckforticlient"
	config_file="${config_dir}/config"
	if [[ -f "$config_file" ]]; then
		while IFS= read -r line; do
			line="${line%%#*}"
			line="${line#"${line%%[![:space:]]*}"}"
			[[ -z "$line" ]] && continue
			if [[ "$line" == *=* ]]; then
				key="${line%%=*}"
				key="${key// /}"
				value="${line#*=}"
				value="${value#"${value%%[![:space:]]*}"}"
				case "$key" in
					SERVER) SERVER="$value" ;;
					URL) URL="$value" ;;
					TIMEOUT) TIMEOUT="$value" ;;
					FUCKFORTICLIENT_OPTS) FUCKFORTICLIENT_OPTS="$value" ;;
				esac
			fi
		done < "$config_file"
	fi
}
