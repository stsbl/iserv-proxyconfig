#!/bin/sh

. /usr/lib/iserv/cfg

HOSTNAME=$(hostname -s)

if [ "$DeployProxy" = "1" ]; then
  echo "rem Import proxy settings"
  echo "reg import \\\\$HOSTNAME\\netlogon\\proxy.reg"
  echo ""
fi
