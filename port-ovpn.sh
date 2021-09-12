#!/bin/bash
red='\e[1;31m'
green='\e[0;32m'
NC='\e[0m'
MYIP=$(wget -qO- icanhazip.com);
clear
MYIP=$(wget -qO- icanhazip.com);
ovpn="$(netstat -nlpt | grep -i openvpn | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
ovpn2="$(netstat -nlpu | grep -i openvpn | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
echo -e "**************************************"
echo -e ""
echo -e "             สคริปโดยเอเจ"​
echo -e ""
echo -e "     [1]  เปลี่ยนพอร์ต TCP $ovpn"
echo -e "     [2]  เปลี่ยนพอร์ต UDP $ovpn2"
echo -e "     [x]  ออก"
echo -e "**************************************"
echo -e ""
read -p "     เลือกจาก [1-2 หริอ x] :  " prot
echo -e ""
case $prot in
1)
read -p "พอร์ตใหม่: " vpn
if [ -z $vpn ]; then
echo "โปรดระบุพอร์ตที่ต้องการ"
exit 0
fi
cek=$(netstat -nutlp | grep -w $vpn)
if [[ -z $cek ]]; then
rm -f /etc/openvpn/server/server-tcp-$ovpn.conf
rm -f /etc/openvpn/client-tcp-$ovpn.ovpn
rm -f /home/vps/public_html/client-tcp-$ovpn.ovpn
cat > /etc/openvpn/server/server-tcp-$vpn.conf<<END
port $vpn
proto tcp
dev tun
ca ca.crt
cert server.crt
key server.key
dh dh2048.pem
plugin /usr/lib/openvpn/openvpn-plugin-auth-pam.so login
verify-client-cert none
username-as-common-name
server 10.6.0.0 255.255.255.0
ifconfig-pool-persist ipp.txt
push "redirect-gateway def1 bypass-dhcp"
push "dhcp-option DNS 8.8.8.8"
push "dhcp-option DNS 8.8.4.4"
keepalive 5 30
comp-lzo
persist-key
persist-tun
status openvpn-tcp.log
verb 3
END
cat > /etc/openvpn/client-tcp-$vpn.ovpn <<-END
client
dev tun
proto tcp
remote $MYIP $vpn
resolv-retry infinite
route-method exe
nobind
persist-key
persist-tun
auth-user-pass
comp-lzo
verb 3
END
echo '<ca>' >> /etc/openvpn/client-tcp-$vpn.ovpn
cat /etc/openvpn/server/ca.crt >> /etc/openvpn/client-tcp-$vpn.ovpn
echo '</ca>' >> /etc/openvpn/client-tcp-$vpn.ovpn
cp /etc/openvpn/client-tcp-$vpn.ovpn /home/vps/public_html/client-tcp-$vpn.ovpn
systemctl disable --now openvpn-server@server-tcp-$ovpn > /dev/null
systemctl enable --now openvpn-server@server-tcp-$vpn > /dev/null
sed -i "s/   - OpenVPN                 : TCP $ovpn, UDP $ovpn2, SSL 442/   - OpenVPN                 : TCP $vpn, UDP $ovpn2, SSL 442/g" /root/log-install.txt
sed -i "s/$ovpn/$vpn/g" /etc/stunnel/stunnel.conf
echo -e "\e[032;1mพอร์ต $vpn แก้ไขสำหรับแล้ว\e[0m"
else
echo "พอร์ต $vpn ถูกใช้งานแล้ว"
fi
;;
2)
read -p "พอร์ใหม่: " vpn
if [ -z $vpn ]; then
echo "โปรดระบุพอร์ตที่ต้องการ"
exit 0
fi
cek=$(netstat -nutlp | grep -w $vpn)
if [[ -z $cek ]]; then
rm -f /etc/openvpn/server/server-udp-$ovpn2.conf
rm -f /etc/openvpn/client-udp-$ovpn2.ovpn
rm -f /home/vps/public_html/client-tcp-$ovpn2.ovpn
cat > /etc/openvpn/server/server-udp-$vpn.conf<<END
port $vpn
proto udp
dev tun
ca ca.crt
cert server.crt
key server.key
dh dh2048.pem
plugin /usr/lib/openvpn/openvpn-plugin-auth-pam.so login
verify-client-cert none
username-as-common-name
server 10.7.0.0 255.255.255.0
ifconfig-pool-persist ipp.txt
push "redirect-gateway def1 bypass-dhcp"
push "dhcp-option DNS 8.8.8.8"
push "dhcp-option DNS 8.8.4.4"
keepalive 5 30
comp-lzo
persist-key
persist-tun
status openvpn-udp.log
verb 3
explicit-exit-notify
END
cat > /etc/openvpn/client-udp-$vpn.ovpn <<-END
client
dev tun
proto udp
remote $MYIP $vpn
resolv-retry infinite
route-method exe
nobind
persist-key
persist-tun
auth-user-pass
comp-lzo
verb 3
END
echo '<ca>' >> /etc/openvpn/client-udp-$vpn.ovpn
cat /etc/openvpn/server/ca.crt >> /etc/openvpn/client-udp-$vpn.ovpn
echo '</ca>' >> /etc/openvpn/client-udp-$vpn.ovpn
cp /etc/openvpn/client-udp-$vpn.ovpn /home/vps/public_html/client-udp-$vpn.ovpn
systemctl disable --now openvpn-server@server-udp-$ovpn2 > /dev/null
systemctl enable --now openvpn-server@server-udp-$vpn > /dev/null
sed -i "s/   - OpenVPN                 : TCP $ovpn, UDP $ovpn2, SSL 442/   - OpenVPN                 : TCP $ovpn, UDP $vpn, SSL 442/g" /root/log-install.txt
echo -e "\e[032;1mพอร์ต $vpn แก้ไขสำเร็จแล้ว\e[0m"
else
echo "พอร์ต $vpn ถูกใช้งานแล้ว"
fi
;;
x)
exit
menu
;;
*)
echo "โปรดเลือกคำสั่งให้ถูกต้อง"
;;
esac

