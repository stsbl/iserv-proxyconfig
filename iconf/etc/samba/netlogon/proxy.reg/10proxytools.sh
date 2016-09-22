#!/bin/sh

. /usr/lib/iserv/cfg

if [ "$DeployProxy" = "1" ]; then
  # Detect settings
  if [ "$DeployProxyUse" = "" ]; then
    if [ "$Proxy" = "" ]; then
      MyProxy="$Domain:3128"
      ProxyEnabled="1"
    elif [ "$Proxy" = "direct" ]; then
      ProxyEnabled="0"
    else
      MyProxy="$Proxy"
      ProxyEnabled="1"
    fi
  elif [ "$DeployProxyUse" = "direct" ]; then
    ProxyEnabled="0"
  elif [ "$DeployProxyUse" = "auto" ]; then
    ProxyEnabled="1"
    AutoDetect="1"
  elif [ "$DeployProxyUse" = "script" ]; then
    ProxyEnabled="1"
    UsePAC="1"
  else
    ProxyEnabled="1"
    MyProxy="$DeployProxyUse"
  fi

  # Generate Registry Patch
  if [ "$ProxyEnabled" = "0" ]; then
    echo "[HKEY_CURRENT_USER\\SOFTWARE\\Microsoft\\Internet Explorer\\Main]"
    echo '"AutoDectect"=dword:0'
    echo ""
    echo "[HKEY_CURRENT_USER\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Internet Settings]"
    echo '"ProxyOverride"=""'
    echo '"ProxyServer"=""'
    echo '"ProxyEnable"=dword:0'
    echo '"AutoConfigURL"=""'
  elif [ "$ProxyEnabled" = "1" ]; then
    if [ "$AutoDetect" = "1" ]; then
      echo "[HKEY_CURRENT_USER\\SOFTWARE\\Microsoft\\Internet Explorer\\Main]"
      echo '"AutoDectect"=dword:1'
      echo ""
      echo "[HKEY_CURRENT_USER\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Internet Settings]"
      echo '"ProxyOverride"=""'
      echo '"ProxyServer"=""'
      echo '"ProxyEnable"=""'
      echo '"AutoConfigURL"=""'
    elif [ "$UsePAC" = "1" ]; then
      echo "[HKEY_CURRENT_USER\\SOFTWARE\\Microsoft\\Internet Explorer\\Main]"
      echo '"AutoDectect"=dword:0'
      echo ""
      echo "[HKEY_CURRENT_USER\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Internet Settings]"
      echo '"ProxyOverride"=""'
      echo '"ProxyServer"=""'
      echo '"ProxyEnable"=""'
      echo '"AutoConfigURL"="http://'$Domain'/proxy.pac"'
    elif [ "$MyProxy" != "" ]; then
      echo "[HKEY_CURRENT_USER\\SOFTWARE\\Microsoft\\Internet Explorer\\Main]"
      echo '"AutoDectect"=dword:0'
      echo ""
      echo "[HKEY_CURRENT_USER\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Internet Settings]"
      echo '"ProxyOverride"="'$Domain';*.'$Domain';<local>"'
      echo '"ProxyServer"="'$MyProxy'"'
      echo '"ProxyEnable"=dword:1'
      echo '"AutoConfigURL"=""'
    fi
  fi

else
  # Proxy Deployment is disabled, apply default values of Windows configuration
  echo "[HKEY_CURRENT_USER\\SOFTWARE\\Microsoft\\Internet Explorer\\Main]"
  echo "; Proxy Deployment is currently disabled, so apply the default windows settings"
  echo '"AutoDectect"=dword:1'
  echo ""
  echo "[HKEY_CURRENT_USER\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Internet Settings]"
  echo "; Proxy Deployment is currently disabled, so apply the default windows settings"
  echo '"ProxyOverride"=""'
  echo '"ProxyServer"=""'
  echo '"ProxyEnable"=""'
  echo '"AutoConfigURL"=""'
fi
