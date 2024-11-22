# fuckForticlient

**fuckForticlient** is a command-line utility to connect to SAML fortivpn servers by using **openfortivpn** and the --cookie-in-stdin parameter.
This repo was formerly a [Github gist](https://gist.github.com/nonamed01).
This script has been written for and tested on Debian GNU/Linux distros and derivatives. With minor changes, it may also work on RPM-based distros such as Fedora, etc.

## Why?

Well, because the official Forticlient for GNU/Linux is total crap! \
When I wrote this script, the main idea was to solve a problem that I though temporary... and, well, one year in and the official Forticlient GNU/Linux client is still total crap... so, heck, it looks like we'll be using this for quite a long time...

## Usage

```bash
   ___         __    ____         __  _     ___          __
  / _/_ ______/ /__ / __/__  ____/ /_(_)___/ (_)__ ___  / /_
 / _/ // / __/  '_// _// _ \/ __/ __/ / __/ / / -_) _ \/ __/
/_/ \_,_/\__/_/\_\/_/  \___/_/  \__/_/\__/_/_/\__/_//_/\__/  v1.1

2022-2023 by: Toni Castillo Girona (@Disbauxes)

[*] Detected distro: Debian, version: 12
[*] Auto-detected firefox profile: /home/user/.mozilla/firefox/vujtoola.default/sessionstore-backups
[*] Openfortivpn version: 1.20.5
[*] Openfortivpn installed from: GITHUB

Usage: fuckForticlient.sh  -L|-u|-d|[-p][-P][-t][-v][-S][-c][-s]
 	-h Shows this help and exits.
 	-c Opens firefox to perform SAML Authentication.
 	-s Tries to re-use a previous SVPNCOOKIE.
 	-p PATH Overrides the detection of the Firefox Profile to use.
 	-P Saves chosen Firefox Profile (-p) as the default one.
 	-t SECONDS Sets the timeout to wait for the SVPNCOOKIE cookie to SECONDS.
 	-v Shows the SVPNCOOKIE cookie on screen.
 	-S SERVER Authenticates against VPN server SERVER .
 	-U PATH Overwrites the default PATH to use for SAML.
 	-L Lists all Firefox profiles detected and exits.
 	-d Removes Forticlient from the system and exits.
 	-u Updates openfortivpn and exits.
 	-i Shows current assigned VPN Ip address and exits.
 	-D Runs the script in debug mode.
 Examples:
 	fuckForticlient.sh -L
 	fuckForticlient.sh -S myserver.org.edu -c
 	fuckForticlient.sh -i
 	fuckForticlient.sh -t 200 -S myvpnserver.com -c
 	fuckForticlient.sh -p /home/u1/.mozilla/firefox/myprofile -S vpnsrv -c
 	fuckForticlient.sh -p /home/u1/.mozilla/firefox/myprofile -P -S vpnsrv -c
 	fuckForticlient.sh -p /home/u1/.mozilla/firefox/myprofile -S vpnsrv -s
 	fuckForticlient.sh -t 200 -p /home/u1/.mozilla/firefox/myprofile -S vpnsrv -c
 	fuckForticlient.sh -S vpnsrv -U /remote/SAML/login -c

 Extra options for openfortivpn
 	 FUCKFORTICLIENT_OPTS="--op1 --op2 ..." fuckForticlient.sh options ...
 Example:
 	FUCKFORTICLIENT_OPTS="--no-dns" fuckForticlient.sh -S myserver.org.edu -c

```

## Dependencies

 * [openfortivpn](https://github.com/adrienverge/openfortivpn)
 * Mozilla Firefox
 * [jq](https://github.com/jqlang/jq) - ```sudo apt install jq``` on Debian/Ubuntu and derivatives
 * [lz4jsoncat](https://github.com/andikleen/lz4json) - ```sudo apt install lz4json``` on Debian/Ubuntu and derivatives
 * [inotify-tools](https://github.com/inotify-tools/inotify-tools) - ```sudo apt install inotify-tools``` on Debian/Ubuntu and derivatives


## Alias
If you do not want to re-type every single time the command to connect to your FortiVPN provider, you can add this alias to your ~.bashrc file:

```bash
    alias vpn='FUCKFORTICLIENT_OPTS="--no-dns" fuckForticlient.sh -S VPN_SERVER -c'
```

After re-loading your ~.bashrc, you can connect to the vpn by simply running:

```bash
    vpn
```
