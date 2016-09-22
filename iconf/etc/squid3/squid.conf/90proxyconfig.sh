#!/bin/sh

. /usr/lib/iserv/cfg

if [ "$TrustedChildProxies" != "" ]
then
  echo "# Read X-Forwarded-For from Child Proxy"
  for TrustedChildProxy in "${TrustedChildProxies[@]}"
  do
    echo "acl child_proxy src $TrustedChildProxy"
  done 
  echo
  echo "follow_x_forwarded_for allow child_proxy"
  echo
fi
