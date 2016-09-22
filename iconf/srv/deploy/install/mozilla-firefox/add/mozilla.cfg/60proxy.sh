#!/bin/sh

. /usr/lib/iserv/cfg

LANIPs=""
for I in ${LAN[@]}
do
  if [ "$LANIPs" = "" ]
  then
    LANIPs=", $I"
  else
    LANIPs="$LANIPs, $I"
  fi
done

if [ "$DeployProxy" = "1" ]
then
  if [ "$DeployProxyUse" = "direct" ]
  then
    echo '// Proxy: No Proxy'
    echo 'lockPref("network.proxy.type", 0);'
  elif [ "$DeployProxyUse" = "" ]
  then
    echo '// Proxy: Use Proxy from iservcfg'
    echo 'lockPref("network.proxy.type", 1);'
    if [ "$Proxy" = "" ]
    then
      FxProxy="$Domain"
      FxPort="3128"
    else
      IFS=':' read -r -a ProxyArray <<< "$Proxy"
      FxProxy="${ProxyArray[0]}"
      FxPort="${ProxyArray[1]}"
    fi

    echo 'lockPref("network.proxy.type", 1);'
    echo 'lockPref("network.proxy.share_proxy_settings", true);'
    echo 'lockPref("network.proxy.http", "'$FxProxy'");'
    echo 'lockPref("network.proxy.http_port", '$FxPort');'
    echo 'lockPref("network.proxy.no_proxies_on", "localhost, 127.0.0.1'$LANIPs'");'
  elif [ "$DeployProxyUse" = "script" ]
  then
    echo '// Proxy: Use PAC script of IServ'
    echo 'lockPref("network.proxy.type", 2);'
    echo 'lockPref("network.proxy.autoconfig_url", "http://'$Domain'/proxy.pac");'
  elif [ "$DeployProxyUse" = "auto" ]
  then
    echo '// Proxy: Autoconfig'
    echo 'defaultPref("network.proxy.type", 4);'
  else
    IFS=':' read -r -a ProxyArray <<< "$DeployProxyUse"
    FxProxy="${ProxyArray[0]}"
    FxPort="${ProxyArray[1]}"

    echo '// Proxy: Use Custom Proxy'
    echo 'lockPref("network.proxy.type", 1);'
    echo 'lockPref("network.proxy.share_proxy_settings", true);'
    echo 'lockPref("network.proxy.http", "'$FxProxy'");'
    echo 'lockPref("network.proxy.http_port", '$FxPort');'
    echo 'lockPref("network.proxy.no_proxies_on", "localhost, 127.0.0.1'$LANIPs'");'
  fi
else
  echo '// Proxy: Autoconfig'
  echo 'defaultPref("network.proxy.type", 4);'
fi
echo ''
