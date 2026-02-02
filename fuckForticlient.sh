#!/bin/bash
# Uncomment the following line to debug the script:
#set -x
#####################################################################################
# fuckForticlient.sh
#
#	Script to authenticate against Fortinet SAML servers using Firefox and
#	openfortivpn. This replaces Forticlient for GNU/Linux completely.
#	Because openfortivpn does not support SAML login (yet), this script uses Firefox
#	to authenticate, grabs SVPNCOOKIE and then calls openfortivpn to setup
#   the VPN service.
#
#   See:
#    https://github.com/adrienverge/openfortivpn/pull/1042#issuecomment-1344211491
#
#	2022-2023 by Toni Castillo Girona (@Disbauxes)
#
#	INSTALLATION
#		> First, install the following packages:
#			sudo apt-get install liblz4-dev lz4json jq firefox-esr git inotify-tools \
#			     libssl-dev autoconf make gcc pkg-config
#		> Next, install all the dependencies to build openfortivpn:
#			sudo apt-get build-dep openfortivpn
#
#           Please notice that if your OS provides an openfortivpn package with
#           support for the "--cookie-on-stdin" parameter, you do not need to
#           install these dependencies or build openfortivpn from scratch.
#
#		> Now clone and build openfortivpn:
#			git clone https://github.com/adrienverge/openfortivpn.git
#			cd openfortivpn
#			./autogen.sh
#			./configure && make
#		> And finally, install it system-wide:
#			sudo make install
#
#		The user running this script must belong to the sudo group. In case they
#		don't, run:
#			sudo usermod -aG sudo USER
#
#	HOW IT WORKS
#		1. Opens firefox and navigates to https://${SERVER}/remote/login
#		2. After a successful authentication, SVPNCOOKIE
#		   is saved to sessionstore-backups/recovery.jsonlz4 on Firefox's profile.
#		2. The script will use openfortivpn to start the tunnel providing it
#          with SVPNCOOKIE (--cookie-on-stdin < cookie_file) because
#          it does not support SAML (yet!).
#
#	NOTES
#		> Firefox will store cookies in sessionstore-backups/recovery.jsonlz4 only when
#		  the following options within "Privacy&Security/History" are not enabled:
#		  "Always use private(...)" and "Clear history when Firefox closes".
#       > SVPNCOOKIE is saved into ~/.cache/fuckforticlient/svpncookie with 0600 perms
#         and removed when exiting the script (thanks to trap).
#       > Remember, this script is a HACK. So if something does not work for you,
#         change whatever you think needs to be changed and please, READ these notes
#         BEFORE assuming that it won't work at all!
#       > This script has been tested on some OS but not all. And remember that, for
#         some systems, custom configurations of Firefox may affect this script in
#         different ways. So please UNDERSTAND how this script works and then adjust
#         whatever you think you need to adjust to make it work.
#       > Tested on: Raspbian 11; Debian 10, 11; Ubuntu/Kubuntu 20.04,22.04.
#
#	USAGE
#		Run the script like this to start a new authentication process against
#		a SAML server and get the VPN up and running automatically:
#
#			./fuckForticlient.sh -S vpnserver -c
#
#		In case you already have a valid non-expired SVPNCOOKIE, you can re-use
#		it like this:
#
#			./fuckForticlient.sh -S myvpnserver -s
#
#		Once the vpn is up and running, you can close the terminal and the
#		connection will hold; you can disconnect by pressing CTRL+c at any
#		time. If you close the terminal and the connection is still alive,
#		you can kill it with:
#
#			sudo kill `pidof openfortivpn`
#
#       Run the script with "-h" to get a list of valid options and some
#       running examples.
#
#####################################################################################
VERSION="1.1"
AUTHOR="Toni Castillo Girona"
EMAIL="toni.castillo@upc.edu"
TWITTER="@Disbauxes"

# Fortinet VPN SAML server, replace with your own or use -S SERVER
# E.g: /fuckForticlient.sh -S myvpnserver.domain.org -c
SERVER=""

# On some instances, /remote/login shows a login form with an additional button
# "Single SignOn" and it allows to authenticate using username/password too. If you
# see this form, instead of using /remote/login, you will need to use /remote/saml/start?realm=
# instead. In case your set-up is somehow different, you can overwrite this with the "-U PATH"
# parameter. For example: ./fuckForticlient.sh -S server -U /remote/mySAML/login -c
URL="/remote/saml/start?realm="
#URL="/remote/login"

# Default timeout in seconds to wait for the SVPNCOOKIE to appear:
TIMEOUT=120

# Options to pass to the firefox browser (it only applies when there's no
# previous Firefox instance already running):
OPTIONS="--window-size 150,150"

# By default, we don't show the SVPNCOOKIE on screen:
SHOWCOOKIE=0

if command -v lsb_release >/dev/null 2>&1; then
	DISTRO=$(lsb_release -i 2>/dev/null | cut -d":" -f2 | tr -d '\t')
	DISTROV=$(lsb_release -r 2>/dev/null | awk '{print $2}')
else
	DISTRO=""
	DISTROV=""
fi

# No debug by default (use -D to change it)
DEBUG=0

# Try to auto-detect openfortivpn full path.
# Override with OPENFORTIVPN="/path/to/openfortivpn"
OPENFORTIVPN="$(type -p openfortivpn)"

if type -p firefox >/dev/null 2>&1; then
	FIREFOX_CMD="firefox"
elif type -p firefox-esr >/dev/null 2>&1; then
	FIREFOX_CMD="firefox-esr"
else
	FIREFOX_CMD=""
fi

CACHE_PATH="${HOME}/.cache/fuckforticlient"
mkdir -p "$CACHE_PATH"
COOKIE_PATH="$CACHE_PATH/svpncookie"
PROFILE_PATH="$CACHE_PATH/profile"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/config.sh"
load_config

clRed='\033[1;31m'
clYellow='\033[1;33m'
clGreen='\033[1;32m'
clNone='\033[0m'

source "${SCRIPT_DIR}/lib/firefox.sh"
source "${SCRIPT_DIR}/lib/cookie.sh"
source "${SCRIPT_DIR}/lib/vpn.sh"

cleanup(){
	test -r "${COOKIE_PATH}" && rm "${COOKIE_PATH}"
	test -d /tmp/openfortivpn && rm -rf /tmp/openfortivpn
}

banner(){
   echo    "   ___         __    ____         __  _     ___          __ "
   echo    "  / _/_ ______/ /__ / __/__  ____/ /_(_)___/ (_)__ ___  / /_"
   echo    " / _/ // / __/  '_// _// _ \/ __/ __/ / __/ / / -_) _ \/ __/"
   echo -e "/_/ \_,_/\__/_/\_\/_/  \___/_/  \__/_/\__/_/_/\__/_//_/\__/  ${clRed}v${VERSION}"
   echo ""
   echo -e "${clYellow}2022-2023 by: $AUTHOR ($TWITTER)"
   echo -e "${clNone}"
}

usage(){
    echo ""
	echo -ne "Usage: `basename $0`  -L|-u|-d|[-p][-P][-t][-v][-S][-c][-s] \n"  \
		 "\t-h Shows this help and exits.\n"  \
		 "\t-c Opens firefox to perform SAML Authentication.\n"  \
		 "\t-s Tries to re-use a previous SVPNCOOKIE.\n"  \
		 "\t-p PATH Overrides the detection of the Firefox Profile to use.\n"  \
		 "\t-P Saves chosen Firefox Profile (-p) as the default one.\n"  \
		 "\t-t SECONDS Sets the timeout to wait for the SVPNCOOKIE cookie to SECONDS.\n" \
		 "\t-v Shows the SVPNCOOKIE cookie on screen.\n" \
		 "\t-S SERVER Authenticates against VPN server SERVER .\n" \
		 "\t-U PATH Overwrites the default PATH to use for SAML.\n" \
		 "\t-L Lists all Firefox profiles detected and exits.\n" \
		 "\t-d Removes Forticlient from the system and exits.\n" \
		 "\t-u Updates openfortivpn and exits.\n" \
		 "\t-i Shows current assigned VPN Ip address and exits.\n" \
         "\t-D Runs the script in debug mode.\n" \
		 "Examples:\n" \
		 "\t`basename $0` -L \n" \
		 "\t`basename $0` -S myserver.org.edu -c\n" \
		 "\t`basename $0` -i\n" \
		 "\t`basename $0` -t 200 -S myvpnserver.com -c \n" \
		 "\t`basename $0` -p /home/u1/.mozilla/firefox/myprofile -S vpnsrv -c\n" \
		 "\t`basename $0` -p /home/u1/.mozilla/firefox/myprofile -P -S vpnsrv -c\n" \
		 "\t`basename $0` -p /home/u1/.mozilla/firefox/myprofile -S vpnsrv -s\n" \
		 "\t`basename $0` -t 200 -p /home/u1/.mozilla/firefox/myprofile -S vpnsrv -c\n" \
		 "\t`basename $0` -S vpnsrv -U /remote/SAML/login -c\n" \
         "\n" \
         "Extra options for openfortivpn \n" \
         "\t FUCKFORTICLIENT_OPTS=\"--op1 --op2 ...\" `basename $0` options ... \n" \
         "Example:\n" \
         "\tFUCKFORTICLIENT_OPTS=\"--no-dns\" `basename $0` -S myserver.org.edu -c\n"
	exit 0
}

sanityCheck(){
	type jq >/dev/null 2>&1 || return 1
	type lz4jsoncat >/dev/null 2>&1 || return 1
	type openfortivpn >/dev/null 2>&1 || return 1
	type inotifywait >/dev/null 2>&1 || return 1
	"${OPENFORTIVPN}" --help | grep cookie >/dev/null || return 1
	[[ -z "$FIREFOX_CMD" ]] && return 1
	type "$FIREFOX_CMD" >/dev/null 2>&1 || return 1
	id -Gn | grep sudo >/dev/null || return 1
	return 0
}

trap "cleanup" EXIT

# We show the banner:
banner

# We show the detected distro:
echo -e "[*] Detected distro: ${clRed}$DISTRO${clNone}, version: ${clRed}$DISTROV"
echo -ne "${clNone}"

# First of all, we perform a trivial sanity check:
sanityCheck
if [ ! $? -eq 0 ]; then
	echo "[!] Sanity check reported an error."
	echo "[!] Make sure you have installed all the pre-requisites first."
	echo "[!] Make sure you belong to the sudo group also."
	exit 0
fi

# We get Firefox default profile first thing:
fProfile=`getFirefoxProfile`
if [ ! $? -eq 0 ]; then
	# Has the user provided us with a custom profile path?
	args="$*"
	if [[ "$args" != *"-p"* ]]; then
		echo -e "${clRed}[!] Unable to determine the default firefox profile!...${clNone}"
        echo "[+] Enumerating all profiles now...:"
        # So we show all the detected profiles just in case:
        enumerateProfiles
		echo "[!] Please, re-run this script with the -p option! Aborting..."
		exit 1
	fi
else
	echo -e "[*] Auto-detected firefox profile: ${clRed}$fProfile"
    echo -ne "${clNone}"
fi

# If we have a valid Firefox profile (either by auto-detecting it or because the
# user has specified the -p and/or -P parameters, we make sure Firefox settings
# will save the cookie to the restore file before going further...
checkFirefoxSettings
if [ $? -eq 1 ]; then
    echo -e "${clRed}[!] Error; make sure the following two options are disabled on Firefox"
    echo -e "\t>Never Remember History"
    echo -e "\t>Always use private browsing mode"
    echo -e "\t>Clear history when Firefox closes"
    echo -e "${clNone}[!] Go to ${clGreen}Preferences/Privacy&Security/History ${clNone}to fix it!"
    echo "[!] Aborting now ... "
    exit 1
fi

# We get openfortivpn version and show it:
opv=`openfortivpn --version`
echo -e "[*] Openfortivpn version: ${clRed}$opv"
echo -en "${clNone}"
# Is it installed from a repo or from github?
checkOpenfortivpn
if [ $? -eq 0 ]; then
    echo -e "[*] Openfortivpn installed from: ${clRed}REPO"
else
    echo -e "[*] Openfortivpn installed from: ${clRed}GITHUB"
fi
echo -en "${clNone}"
# Show any extra openfortivpn parameter:
if [ ! -z "$FUCKFORTICLIENT_OPTS" ]; then
    echo -e "[*] Openfortivpn extra args: $clGreen$FUCKFORTICLIENT_OPTS "
    echo -en "${clNone}"
fi
echo -e "[*] SAML path: ${clGreen}${URL} "
echo -en "${clNone}"

# Process arguments:
while getopts "Licshut:p:PvdDS:U:" opt; do
	case "$opt" in
		# Shows usage message and exits:
		h)
			usage
			exit 0
		;;
        D)
            echo -e "[*]${clYellow} Debug mode enabled!${clNone}"
            DEBUG=1
            set -x
        ;;
        u)
            # Clones the repository first:
            echo "[*] Updating openfortivpn ... "
            echo -e "\t[>] Cloning ..."
            git clone https://github.com/adrienverge/openfortivpn.git /tmp/openfortivpn>/dev/null 2>&1
            if [ $? -eq 0 ]; then
                cd /tmp/openfortivpn >/dev/null 2>&1
                echo -e "\t[>] Running autogen.sh ... "
                ./autogen.sh >/dev/null 2>&1
                echo -e "\t[>] Running configure & make ..."
                ( ./configure && make )> /dev/null 2>&1
                echo -e "\t[>] Running make install ... "
                sudo make install >/dev/null 2>&1
                if [ $? -eq 0 ]; then
                    echo -e "[*] ${clGreen}openfortivpn updated successfully!"
                    echo -ne "${clNone}"
                else
                    echo -e "[!] ${clRed}error updating openfortivpn."
                    echo -ne "${clNone}"
                fi
                # We clean the directory:
                cd .. && rm -rf /tmp/openfortivpn >/dev/null 2>&1
            else
                echo -e "[!] ${clRed}Unable to clone openfortivpn!"
                exit 1
            fi
        ;;
        # Shows current assigned VPN Ip address (if any) and exits:
        i)
            ipvpn=`getVPNIp`
            if [ $? -eq 0 ]; then
                echo -e "[+] Current VPN Ip: ${clGreen}${ipvpn}${clNone}"
            else
                echo -e "[!] ${clRed}You are not connected to the VPN!${clNone}"
            fi
            exit 0
        ;;
		# It will show the SVPNCOOKIE on screen:
		v)
			SHOWCOOKIE=1
		;;
		# Shows all detected profiles and quits:
		L)
			echo "[*] Enumerating Firefox profiles ... "
			enumerateProfiles
			exit 0
		;;
		# Firefox default profile override:
		p)
			fProfile="$OPTARG/sessionstore-backups"
			echo "[*] Overriding detected Firefox profile"
			# Make sure the directory is valid:
			if [ ! -d "$fProfile" ]; then
				echo "[!] Error, ${fProfile} does not exist! Aborting..."
				exit 1
			fi
		;;
        P)
            # We do not really care if the fProfile variable has been filled
            # by autodetecting the Firefox profile or because the user has
            # used the "-p" parameter; we save it to ~/.cache/fuckforticlient/profile
            # anyways...:
            echo -e "[+] Saving profile to: ${clGreen}${PROFILE_PATH}"
            echo -ne "${clNone}"
            echo -n "${fProfile}" >  ${PROFILE_PATH}
        ;;
		# Timeout for the SVPNCOOKIE override:
		t)
			TIMEOUT=$OPTARG
		;;
		# Overrides SERVER and tries to authenticate against -S SERVER:
		S)
			SERVER="$OPTARG"
		;;
		# Overwrites the PATH within $SERVER to use for SAML
		U)
			URL="$OPTARG"
			echo -e "[*] Overwriting SAML path: ${clGreen}${URL} "
			echo -en "${clNone}"
		;;
		# Removes Forticlient:
		d)
			echo "[*] Removing Forticlient as requested ... "
			dpkg -l forticlient >/dev/null 2>&1
			if [ $? -eq 0 ]; then
				sudo dpkg --purge forticlient
			else
				echo "[!] Forticlient is not installed!"
			fi
			exit 0
		;;
		# Tries to get the SVPNCOOKIE without re-opening firefox and
		# then uses the cookie to start the VPN:
		s)
			checkAnotherInstance
			if [[ -z "$SERVER" ]]; then
				echo "[!] Please, re-run the script with -S VPNSERVER"
				exit 0
			fi
			echo -e "[*] Firefox profile: ${clRed}$fProfile"
			echo -ne "${clNone}"
			echo "[*] Trying to re-use a previous SVPNCOOKIE..."
			getCookie "$fProfile" "0"
			if [[ $? -ne 0 ]]; then
				echo "[!] Unable to get SVPNCOOKIE; aborting..."
				exit 0
			fi
			[[ $SHOWCOOKIE -eq 1 ]] && echo "[*] $(cat "${COOKIE_PATH}")"
			echo -e "[*] ${clGreen}SVPNCOOKIE successfully retrieved!${clNone}"
			run_openfortivpn
			if [[ $? -ne 0 ]]; then
				echo -e "${clRed}[!] Error, expired cookie probably. Run with -c to re-authenticate.${clNone}"
				exit 1
			fi
		;;
		# Establishes a new connection by opening Firefox first. The user
		# needs to authenticate against the Fortinet server first:
		c)
			checkAnotherInstance
			if [[ -z "$SERVER" ]]; then
				echo "[!] Please, re-run the script with -S VPNSERVER"
				exit 0
			fi
			profName=$(dirname "${fProfile}" | rev | cut -d"." -f1 | rev | cut -d"/" -f1)
			echo -e "[*] Opening Firefox for SAML login with: ${clGreen}-P ${profName}...${clNone}"
			"${FIREFOX_CMD}" -P "${profName}" ${OPTIONS} "https://${SERVER}${URL}" >/dev/null 2>&1 &
			echo -e "[*] Firefox profile: ${clRed}$fProfile"
			echo -ne "${clNone}"
			echo -e "[*] Authenticating against ${clRed}https://$SERVER ...${clNone}"
			echo -e "[*] Waiting up to ${clRed}$TIMEOUT seconds${clNone} until the cookie appears..."
			getCookie "$fProfile" "1"
			if [[ $? -ne 0 ]]; then
				echo "[!] Unable to get SVPNCOOKIE; aborting..."
				exit 0
			fi
			[[ $SHOWCOOKIE -eq 1 ]] && echo "[*] $(cat "${COOKIE_PATH}")"
			echo -e "[*] ${clGreen}SVPNCOOKIE successfully retrieved!${clNone}"
			run_openfortivpn
			if [[ $? -ne 0 ]]; then
				echo -e "${clRed}[!] Error, expired cookie probably. Run with -c to re-authenticate.${clNone}"
				exit 1
			fi
		;;
	esac
done
