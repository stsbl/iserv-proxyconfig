#!/bin/sh

. /usr/lib/iserv/cfg

if [ "$ProxyDMZMode" = "1" ]; then
  echo "# Squid Proxy aus anderen Subnetzen zugänglich machen (für TfK-DMZ in HH)"
  echo "# Überschreibt MAC-Adressen-Check von weiter oben, der in HH leider (danke BSB!) nicht funktioniert."
  echo "# Die Regel wird mit -I angewendet, damit sie an den Anfang des Chains gestellt wird und die vorherige Regel auch überschreibt."
  echo "iptables -I INPUT -p tcp -s \$LAN_SPEC --dport 3128 -j ACCEPT"
  echo "iptables -I INPUT -p tcp -s \$LAN_SPEC --dport 3129 -j ACCEPT"
  echo ""
  echo "# Prüfung der MAC-Adresse beim allgemeinen Routing wieder deaktivieren, das funktioniert bei einem IServ in einer DMZ-Umgebung nämlich nicht."
  echo "iptables -D FORWARD -p tcp --syn -j check_mac"
  echo "iptables -D FORWARD ! -p tcp -j check_mac"
  echo ""
fi
