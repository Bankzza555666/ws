#!/bin/bash
clear

#!/bin/bash
yl='\e[031;1m'
bl='\e[36;1m'
gl='\e[32;1m'

clear 
echo -e "" 
echo -e "*****************************************************************"
echo -e "                Server Information"
echo -e "*****************************************************************"
ISP=$(curl -s ipinfo.io/org | cut -d " " -f 2-10 )
CITY=$(curl -s ipinfo.io/city )
WKT=$(curl -s ipinfo.io/timezone )
IPVPS=$(curl -s ipinfo.io/ip )
	cname=$( awk -F: '/model name/ {name=$2} END {print name}' /proc/cpuinfo )
	cores=$( awk -F: '/model name/ {core++} END {print core}' /proc/cpuinfo )
	freq=$( awk -F: ' /cpu MHz/ {freq=$2} END {print freq}' /proc/cpuinfo )
	tram=$( free -m | awk 'NR==2 {print $2}' )
	swap=$( free -m | awk 'NR==4 {print $2}' )
	up=$(uptime|awk '{ $1=$2=$(NF-6)=$(NF-5)=$(NF-4)=$(NF-3)=$(NF-2)=$(NF-1)=$NF=""; print }')

echo -e " \e[032;1mCPU Model:\e[0m $cname"
echo -e " \e[032;1mNumber Of Cores:\e[0m $cores"
echo -e " \e[032;1mCPU Frequency:\e[0m $freq MHz"
echo -e " \e[032;1mTotal Amount Of RAM:\e[0m $tram MB"
echo -e " \e[032;1mSystem Uptime:\e[0m $up"
echo -e " \e[032;1mIsp Name:\e[0m $ISP"
echo -e " \e[032;1mCity:\e[0m $CITY"
echo -e " \e[032;1mTime:\e[0m $WKT"
echo -e " \e[033;1mIPVPS:\e[0m $IPVPS"
echo -e " \e[032;1mAuto Install Script By AJ" 
echo -e ""
echo -e "*****************************************************************"
echo -e "* menu         : List of Commands"
echo -e "*****************************************************************"
echo -e "                        {SSH & OpenVPN}"
echo -e "* new          : Create account"
echo -e "* trial        : Create trial account"
echo -e "* renew        : Renew account"
echo -e "* deluser      : Delete account"
echo -e "* check        : Check online user"
echo -e "* user         : list of all user"
echo -e "* delete       : Delete expired account"
echo -e "* autokill     : Setup autokill feature"
echo -e "* multi        : Display multi-login user"
echo -e "* restart      : Restart services"
echo -e "* limit        : Set multi-login for ovpn" 
echo -e "*****************************************************************"
echo -e "                       {SHADOWSOCK-R}"
echo -e "* ssr          : Create account"
echo -e "* ssrd         : Delete account"
echo -e "* ssrr         : Renew account"
echo -e "* more         : Show more SSR menu"
echo -e "*****************************************************************"
echo -e "                       {SHADOWSOCK-S OBFS}"
echo -e "* ss           : Create account"
echo -e "* sd           : Delete account"
echo -e "* sr           : Renew account"
echo -e "* sc           : Check online user"
echo -e "*****************************************************************"
echo -e "                       {TROJAN}"
echo -e "* tj           : Create account"
echo -e "* tjd          : Delete account"
echo -e "* tjr          : Renew account"
echo -e "* tjc          : Check online user"
echo -e "*****************************************************************"
echo -e "                       {V2RAY WS}"
echo -e "* vr           : Create account"
echo -e "* vrd          : Delete account"
echo -e "* vrr          : Renew account"
echo -e "* vrc          : Check online user"
echo -e "*****************************************************************"
echo -e "                       {VLESS WS}"
echo -e "* vs           : Create account"
echo -e "* vsd          : Delete account"
echo -e "* vsr          : Renew account"
echo -e "* vsc          : Check online user"
echo -e "*****************************************************************"
echo -e "                       {WIREGUARD}"
echo -e "* wg           : Create account"
echo -e "* wgd          : Delete account"
echo -e "* wgc          : Check online user"
echo -e "* wgr          : Renew account"
echo -e "* wg show      : Check Wireguard user interface"
echo -e "*****************************************************************"
echo -e "                       {SYSTEM}"
echo -e "* add          : Add or change subdomain"
echo -e "* cert         : Renew v2ray certificate"
echo -e "* port         : Change service port"
echo -e "* web          : Install webmin"
echo -e "* kernel       : Update kernel"
echo -e "* ram          : Check current RAM usage"
echo -e "* reboot       : Reboot"
echo -e "* speedtest    : Test server speed"
echo -e "* update       : Update script"
echo -e "* info         : Display system-information"
echo -e "* exit         : Exit"
echo -e " The way to get started is to quit talking and begin doing" 
echo -e "*****************************************************************"
echo -e ""
