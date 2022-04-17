#!/bin/bash
#
# By เอเจ
# ==================================================

# initialisasi var
export DEBIAN_FRONTEND=noninteractive
OS=`uname -m`;
MYIP=$(wget -qO- icanhazip.com);
MYIP2="s/xxxxxxxxx/$MYIP/g";
ANU=$(ip -o $ANU -4 route show to default | awk '{print $5}');

# Install OpenVPN dan Easy-RSA
apt install openvpn easy-rsa unzip -y
apt install openssl iptables iptables-persistent -y
mkdir -p /etc/openvpn/server/easy-rsa/
cd /etc/openvpn/
wget https://github.com/Bankzza555666/ws/raw/main/vpn.zip
unzip vpn.zip
rm -f vpn.zip
chown -R root:root /etc/openvpn/server/easy-rsa/

cd
mkdir -p /usr/lib/openvpn/
cp /usr/lib/x86_64-linux-gnu/openvpn/plugins/openvpn-plugin-auth-pam.so /usr/lib/openvpn/openvpn-plugin-auth-pam.so

# nano /etc/default/openvpn
sed -i 's/#AUTOSTART="all"/AUTOSTART="all"/g' /etc/default/openvpn

# restart openvpn dan cek status openvpn
systemctl enable --now openvpn-server@server-tcp-443
systemctl enable --now openvpn-server@server-udp-2200
/etc/init.d/openvpn restart
/etc/init.d/openvpn status

# aktifkan ip4 forwarding
echo 1 > /proc/sys/net/ipv4/ip_forward
sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf

# Buat config client TCP 1194
cat > /etc/openvpn/TCP.ovpn <<-END
FRIENDLY_NAME "AJNET"
client
dev tun
proto tcp
remote xxxxxxxxx 443 
http-proxy xxxxxxxxx 8080
resolv-retry infinite
route-method exe
nobind
persist-key
persist-tun
auth-user-pass
comp-lzo
verb 3
http-proxy-option VERSION 1.1
http-proxy-option AGENT Chrome/80.0.3987.87
http-proxy-option CUSTOM-HEADER Host www.freeinternet.net
http-proxy-option CUSTOM-HEADER X-Forward-Host www.freeinternet.net
http-proxy-option CUSTOM-HEADER X-Forwarded-For www.freeinternet.net
http-proxy-option CUSTOM-HEADER Referrer www.freeinternet.net
dhcp-option DNS 8.8.8.8
dhcp-option DNS 8.8.4.4
dhcp-option DNS 1.1.1.1
dhcp-option DNS 1.0.0.1
END

sed -i $MYIP2 /etc/openvpn/TCP.ovpn;

# Buat config client UDP 2200
cat > /etc/openvpn/UDP.ovpn <<-END
FRIENDLY_NAME "AJNET"
client
dev tun
proto udp
remote xxxxxxxxx 2200
resolv-retry infinite
route-method exe
nobind
persist-key
persist-tun
auth-user-pass
comp-lzo
verb 3
END

sed -i $MYIP2 /etc/openvpn/UDP.ovpn;

# Buat config client SSL
cat > /etc/openvpn/SSL.ovpn <<-END
FRIENDLY_NAME "AJNET"
client
dev tun
proto tcp
remote xxxxxxxxx 442
resolv-retry infinite
route-method exe
nobind
persist-key
persist-tun
auth-user-pass
comp-lzo
verb 3
END

sed -i $MYIP2 /etc/openvpn/SSL.ovpn;

cd
# pada tulisan xxx ganti dengan alamat ip address VPS anda 
/etc/init.d/openvpn restart

# masukkan certificatenya ke dalam config client TCP 1194
echo '<ca>' >> /etc/openvpn/TCP.ovpn
cat /etc/openvpn/server/ca.crt >> /etc/openvpn/TCP.ovpn
echo '</ca>' >> /etc/openvpn/TCP.ovpn

# Copy config OpenVPN client ke home directory root agar mudah didownload ( TCP 1194 )
cp /etc/openvpn/TCP.ovpn /home/vps/public_html/TCP.ovpn

# masukkan certificatenya ke dalam config client UDP 2200
echo '<ca>' >> /etc/openvpn/UDP.ovpn
cat /etc/openvpn/server/ca.crt >> /etc/openvpn/UDP.ovpn
echo '</ca>' >> /etc/openvpn/UDP.ovpn

# Copy config OpenVPN client ke home directory root agar mudah didownload ( UDP 2200 )
cp /etc/openvpn/UDP.ovpn /home/vps/public_html/UDP.ovpn

# masukkan certificatenya ke dalam config client SSL
echo '<ca>' >> /etc/openvpn/SSL.ovpn
cat /etc/openvpn/server/ca.crt >> /etc/openvpn/SSL.ovpn
echo '</ca>' >> /etc/openvpn/SSL.ovpn

# Copy config OpenVPN client ke home directory root agar mudah didownload ( SSL )
cp /etc/openvpn/SSL.ovpn /home/vps/public_html/SSL.ovpn

#firewall untuk memperbolehkan akses UDP dan akses jalur TCP

iptables -t nat -I POSTROUTING -s 10.6.0.0/24 -o $ANU -j MASQUERADE
iptables -t nat -I POSTROUTING -s 10.7.0.0/24 -o $ANU -j MASQUERADE
iptables-save > /etc/iptables.up.rules
chmod +x /etc/iptables.up.rules

iptables-restore -t < /etc/iptables.up.rules
netfilter-persistent save
netfilter-persistent reload

# Restart service openvpn
systemctl enable openvpn
systemctl start openvpn
/etc/init.d/openvpn restart

# Delete script
history -c
rm -f /root/vpn.sh

