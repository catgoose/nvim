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
#		2. After a succesful authentication, SVPNCOOKIE
#		   is saved to sessionstore-backups/recovery.jsonlz4 on Firefox's profile.
#		2. The script will use openfortivpn to start the tunnel providing it 
#          with SVPNCOOKIE (--cookie-on-stdin < cookie_file) because 
#          it does not support SAML (yet!).
#
#	NOTES
#		> Firefox will store cookies in sessionstore-backups/recovery.jsonlz4 only when
#		  the following options within "Privacy&Security/History" are not enabled:
#		  "Always use private(...)" and "Clear history when Firefox closes".
#       > SVPNCOOKIE is saved into ~/.${USER}.svpncookie with 0600 perms and removed
#         when exiting the script (thanks to trap).
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

# We get the current distro:
DISTRO=`lsb_release -i|cut -d":" -f2|tr -d '\t'`
DISTROV=`lsb_release -r|awk '{print $2}'`

# No debug by default (use -D to change it)
DEBUG=0

# Try to auto-detect openfortivpn full path.
# Override with OPENFORTIVPN="/path/to/openfortivpn"
OPENFORTIVPN="$(type -p openfortivpn)"

#####################################################################################
# Colors
#####################################################################################
clRed='\033[1;31m'
clYellow='\033[1;33m'
clGreen='\033[1;32m'
clNone='\033[0m'

#####################################################################################
# cleanup()
#####################################################################################
cleanup(){
    # Removes SVPNCOOKIE:
	test -r $HOME/.${USER}.svpncookie && rm $HOME/.${USER}.svpncookie
    test -d /tmp/openfortivpn && rm -rf /tmp/openfortivpn
}

#####################################################################################
# banner()
#   Shows the banner ;-)
#####################################################################################
banner (){
   echo    "   ___         __    ____         __  _     ___          __ "
   echo    "  / _/_ ______/ /__ / __/__  ____/ /_(_)___/ (_)__ ___  / /_"
   echo    " / _/ // / __/  '_// _// _ \/ __/ __/ / __/ / / -_) _ \/ __/"
   echo -e "/_/ \_,_/\__/_/\_\/_/  \___/_/  \__/_/\__/_/_/\__/_//_/\__/  ${clRed}v${VERSION}"
   echo ""
   echo -e "${clYellow}2022-2023 by: $AUTHOR ($TWITTER)"
   echo -e "${clNone}"
}

#####################################################################################
# getProfilePath()
#	Gets the Firefox profile path or returns an error. Depending on the distro,
#	sometimes the profile path is not on the usual path (like with Ubuntu because
#	it uses SNAPd)
#####################################################################################
getProfilePath(){
	profilepath=""
	case $DISTRO in
		Debian|Raspbian|Parrot)
			if [ ! -d ${HOME}/.mozilla/firefox ]; then
				return 1
			fi
			profilepath="${HOME}/.mozilla/firefox"
			;;
		Ubuntu)
			# Ubuntu can be snap or usual path. Check for files, not versions
			if [ -d ${HOME}/snap/firefox/common/.mozilla/firefox ]; then
				profilepath="${HOME}/snap/firefox/common/.mozilla/firefox"
			elif [ -d ${HOME}/.mozilla/firefox ]; then
				profilepath="${HOME}/.mozilla/firefox"
			else 
				return 1
			fi
			;;
		*)
			# We return the usual path, but who knows if it even works at all!
			profilepath="${HOME}/.mozilla/firefox"
			;;
	esac
	echo "${profilepath}"
	return 0
}

#####################################################################################
# enumerateProfiles()
#	Enumerates all profiles available by reading profiles.ini. This can be used
# 	to determine which profile to use to override the automatic detection of the
#	default profile with -p.
#####################################################################################
enumerateProfiles(){
	profilepath=`getProfilePath`
	if [ $? -eq 0 ]; then
		profs=`cat ${profilepath}/profiles.ini|grep Path|cut -d"=" -f2|xargs`
		for p in ${profs}; do
			pName=`echo ${p}|cut -d"." -f2`
			echo -e "  [>] Name     : ${clGreen}${pName}"
            echo -en "${clNone}"
			echo -e "  [>] Path (-p): ${clGreen}${profilepath}/${p}"
            echo -en "${clNone}"
			echo ""
		done
	else
		echo "[!] Unable to determine Firefox profile PATH!!!"
		return 1
	fi
}

#####################################################################################
# getFirefoxProfile()
#	Returns the path for the default Firefox profile or "" if it cannot determine
#	where it is. Using -p overrrides this function.
#   If the user has decided to write the profile-path to use right in the file
#   ~/.${USER}.fuckforticlient-profile, this functions simply returns the contents
#   of ~/.${USER}.fuckforticlient-profile.
#####################################################################################
getFirefoxProfile(){
    # Do we have a saved profile to use?
    if [ -r ~/.${USER}.fuckforticlient-profile ]; then
        profilep=`cat -v  ~/.${USER}.fuckforticlient-profile`
        # If it's not empty and the directory is valid:
        if [ ! -z "${profilep}" -a -d "${profilep}" ]; then
            echo "${profilep}"
            return 0
        fi
    fi
	# First, we get the profile path depending on the Distro:
	profilepath=`getProfilePath`
	if [ $? -eq 0 ]; then
		prof=`cat ${profilepath}/profiles.ini |grep Path=|grep -i default|tail -1|cut -d"=" -f2`
		if [ ! -z "$prof" ]; then
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

#####################################################################################
# getCookie(profile,waitForIt)
#	Waits up to TIMEOUT seconds for the SVPNCOOKIE to appear. Stores the cookie in
#	$HOME/${USER].svpncookie and returns 0; returns 1 otherwise.
#####################################################################################
getCookie(){
	# Storage file where the cookie is stored in firefox:
	storage="$1"
	waitForIt=$2
	# We save the current umask value first:
	curUmask=`umask`
	# We change it to 0077:
	umask 077
	# We try to grab the cookie right away:
	c=`lz4jsoncat ${storage}/recovery.jsonlz4 2>/dev/null|jq '.cookies[]|select(.name!=null)|select(.name|contains("SVPNCOOKIE"))|.value'`
	if [ ! -z "$c" ]; then
		echo "SVPNCOOKIE=${c}" > $HOME/.${USER}.svpncookie
		sed -i 's/\"//g' $HOME/.${USER}.svpncookie
		# We restore umask:
		umask $curUmask
		return 0
	fi
	# We only wait if waitForIt == 1
	test $waitForIt -eq 0 && return 1
	# We will wait until the cookie is already there...
	while inotifywait -e modify -t $TIMEOUT --format '%w%f' ${storage} -q >/dev/null 2>&1;
	do
		if [ -r ${storage}/recovery.jsonlz4 ]; then
			# Make sure we check for the cookie once the file changes:
			c=`lz4jsoncat ${storage}/recovery.jsonlz4 2>/dev/null|jq '.cookies[]|select(.name!=null)|select(.name|contains("SVPNCOOKIE"))|.value'`
			if [ ! -z "$c" ]; then
				#echo ${c}
				echo "SVPNCOOKIE=${c}" > $HOME/.${USER}.svpncookie
				sed -i 's/\"//g' $HOME/.${USER}.svpncookie
				# We restore umask
				umask $curUmask
				return 0
			fi
		fi
	done
	# If we reach this, we exit with error (timeout!):
	# We restore umask:
	umask $curUmask
	return 1
}

#####################################################################################
# usage()
#	Shows the help screen and some examples and exits
#####################################################################################
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

#####################################################################################
# sanityCheck()
#	Performs some trivial sanity checks before attempting to run the script.
#####################################################################################
sanityCheck(){
	# Test for jq presence:
	type jq >/dev/null 2>&1|| return 1
	# Test for lz4jsoncat
	type lz4jsoncat >/dev/null 2>&1 || return 1
	# Test for openfortivpn:
	type openfortivpn >/dev/null 2>&1|| return 1
	# Make sure openfortivpn supports "--cookie-on-stdin":
	"${OPENFORTIVPN}" --help|grep cookie >/dev/null|| return 1
	# Make sure we have Firefox installed:
	type firefox >/dev/null 2>&1 || return 1
	# Make sure the user running this script belongs to the sudo group:
	id -Gn |grep sudo >/dev/null || return 1
	return 0
}

#####################################################################################
# checkFirefoxSettings()
#   Makes sure the following two options ARE not enabled on the chosen
#   firefox profile to ensure the SVPNCOOKIE cookie will be stored in the
#   sessionstore-backups/recovery.jsonlz4 file:
#
#   browser.privatebrowsing.autostart
#   privacy.sanitize.pending
#####################################################################################
checkFirefoxSettings(){
    # Now, if the sessionstore-backups directory DOES NOT EXIST at all,
    # it is obvious these options are ALREADY ENABLED!
    if [ ! -d "${fProfile}" ]; then
        return 1
    else
        # Otherwise, make sure everything else fits:
        grep -q "browser.privatebrowsing.autostart" "${fProfile}/../prefs.js"
        # Not found, maybe the next option?
        if [ $? -eq 1 ]; then
            # sanitize pending should'nt have anything between "[]":
            sa=`cat "${fProfile}/../prefs.js"|grep "privacy.sanitize.pending"|awk '{print $2}'|cut -d"\"" -f2`
            if [ "${sa}" != "[]" ]; then
                if [ "${sa}" != "[{\\" ]; then
                    return 1
                else
                    return 0
                fi  
            else
                return 0
            fi
        fi
        return 1
    fi
}

#####################################################################################
# getVPNIp()
#   Returns the current assigned VPN IP Address or error
#   It assumes the VPN device used by openfortivpn is always "ppp0", quite naive!!
#####################################################################################
getVPNIp(){
    data=`ip a list ppp0 2>/dev/null|grep "inet"`
    if [ $? -eq 0 ]; then
        echo ${data}|awk '{print $2}'
        return 0
    else
        echo ""
        return 1
    fi
}

#####################################################################################
# checkAnotherInstance()
#	Checks whether there's a running instance of openfortivpn. If there is,
#	exits with error. Otherwise, returns 0.
#####################################################################################
checkAnotherInstance(){
	pidof -q openfortivpn
	if [ $? -eq 0 ]; then
		echo -e "${clRed}[!] Another openfortivpn instance detected!${clNone}"
        # If there is another instance running, it is probably because there is
        # an active VPN connection running already:
        ipvpn=`getVPNIp`
        if [ $? -eq 0 ]; then
            echo -e "[+] Current VPN IP: ${clGreen}${ipvpn}${clNone}"
            echo -e "${clRed}[!] If you kill openfortivpn instance, you will be disconnected!${clNone}"
        fi
		echo -e "[!] Run: ${clGreen} sudo kill `pidof openfortivpn`${clNone} or just press CTRL+c on the terminal window..."
		exit 1
	fi
	return 0
}

#####################################################################################
# checkOpenfortivpn()
#   Returns 0 if the installed version of Openfortivpn is from the repo or 1
#   otherwise. For some distros, the included openfortivpn from the official repos
#   does not support "--cookie-on-stdin"  
#####################################################################################
checkOpenfortivpn(){
    dpkg -l |grep openfortivpn|grep -E "^ii" >/dev/null 2>&1
    return $?
}

# Tiddy things up if we cancel or finish the script:
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
                    echo -e "[*] ${clGreen}openfortivpn updated sucessfully!"
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
            # used the "-p" parameter; we save it to ~/.${USER}-fuckforticlient-profile
            # anyways...:
            echo -e "[+] Saving profile to: ${clGreen}~/.${USER}.fuckforticlient-profile"
            echo -ne "${clNone}"
            echo -n "${fProfile}" >  ~/.${USER}.fuckforticlient-profile
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
			echo -e "[*] Overwritting SAML path: ${clGreen}${URL} "
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
			# First of all, if there is a running openfortivpn instance,
			# we exit and we do not try to re-connect:
			checkAnotherInstance
			# We do nothing if we do not specify a valid VPN-SSL server:
			if [ -z "$SERVER" ]; then
				echo "[!] Please, re-run the script with -S VPNSERVER"
				exit 0
			fi
			echo -e "[*] Firefox profile: ${clRed}$fProfile"
            echo -ne "${clNone}"
			echo "[*] Trying to re-use a previous SVPNCOOKIE..."
			getCookie "$fProfile" "0"
			if [ ! $? -eq 0 ]; then
				echo "[!] Unable to get SVPNCOOKIE; aborting..."
				exit 0
			else
				test $SHOWCOOKIE -eq 1 && echo "[*] `cat $HOME/.${USER}.svpncookie`"
				echo -e "[*] ${clGreen}SVPNCOOKIE sucessfully retrieved!"
                echo -ne "${clNone}"
				# We save the cookie file to a variable first:
				cookie=$HOME/.${USER}.svpncookie
				# We connect to the vpn now:
                test $DEBUG -eq 1 && dbg="-vvv"
				sudo "${OPENFORTIVPN}" $SERVER:443 --cookie-on-stdin < ${cookie} ${dbg} ${FUCKFORTICLIENT_OPTS}
				if [ ! $? -eq 0 ]; then
					echo "${clRed}[!] Error, expired cookie probably...${clNone}"
					echo "[!] Close Firefox and re-lanch the script using -c"
					exit 1
				fi
			fi
		;;
		# Establishes a new connection by opening Firefox first. The user
		# needs to authenticate against the Fortinet server first:
		c)
			# First of all, if there is a running openfortivpn instance,
			# we exit and we do not try to re-connect:
			checkAnotherInstance
			# We do nothing if we do not specify a valid VPN-SSL server:
			if [ -z "$SERVER" ]; then
				echo "[!] Please, re-run the script with -S VPNSERVER"
				exit 0
			fi
			# FIX: make sure to use the right profile!!!!
			profName=`dirname ${fProfile}|rev|cut -d"." -f1|rev|cut -d"/" -f1`
			echo -e "[*] Opening Firefox for SAML login with: ${clGreen}-P ${profName}...${clNone}"
			firefox -P ${profName} ${OPTIONS} https://${SERVER}${URL} >/dev/null 2>&1 &
			echo -e "[*] Firefox profile: ${clRed}$fProfile"
            echo -ne "${clNone}"
			echo -e "[*] Authenticating against ${clRed}https://$SERVER ..."
            echo -ne "${clNone}"
			# There's some delay before firefox stores the cookie unless it is closed,
			# in which case it's inmediately there.
			echo -e "[*] Waiting up to ${clRed}$TIMEOUT seconds${clNone} until the cookie appears..."
			# Gets the cookie:
			getCookie "$fProfile" "1"
			if [ ! $? -eq 0 ]; then
				echo "[!] Unable to get SVPNCOOKIE; aborting..."
				exit 0
			else
				test $SHOWCOOKIE -eq 1 && echo "[*] `cat $HOME/.${USER}.svpncookie`"
				echo -e "[*] ${clGreen}SVPNCOOKIE sucessfully retrieved!"
                echo -ne "${clNone}"
				# We save the cookie file to a variable first:
				cookie=$HOME/.${USER}.svpncookie
				# We connect to the vpn now:
                test $DEBUG -eq 1 && dbg="-vvv"
				sudo "${OPENFORTIVPN}" ${SERVER}:443 --cookie-on-stdin < ${cookie} ${dbg} ${FUCKFORTICLIENT_OPTS}
				if [ ! $? -eq 0 ]; then
					echo -e "${clRed}[!] Error, expired cookie probably...${clNone}"
					echo "[!] Close Firefox and re-lanch the script using -c"
					exit 1
				fi
			fi
		;;
	esac
done
