#!/bin/sh

. /usr/lib/iserv/cfg

if [ "$DeployProxy" = "1" ]; then
  echo "[HKEY_LOCAL_MACHINE\\SOFTWARE\\Policies\\Microsoft\\Internet Explorer\\Control Panel]"
  echo "; Grafische Einstellungsmöglichkeit für Verbindungen u.a. Proxy deaktivieren"
  echo '"ConnectionsTab"=dword:1'
else
  echo "[HKEY_LOCAL_MACHINE\\SOFTWARE\\Policies\\Microsoft\\Internet Explorer\\Control Panel]"
  echo "; Grafische Einstellungsmöglichkeit für Verbindungen u.a. Proxy wieder zulassen"
  echo '"ConnectionsTab"=dword:0'
fi

echo ""
