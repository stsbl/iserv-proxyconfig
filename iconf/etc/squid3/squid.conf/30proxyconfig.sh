#!/bin/sh

. /usr/lib/iserv/cfg

if [ "$ProxyCacheMgr" != "" ]; then
  echo "# Cache Administrator"
  echo "  cache_mgr $ProxyCacheMgr"
  echo ""
fi

if [ "$ProxyCachePeer" != "" ]; then
  PEERSTRING=$(echo $ProxyCachePeer | sed 's/:/ parent /g')
  echo "# cache peer"
  echo "  cache_peer $PEERSTRING 0 default never-direct no-query no-digest no-netdb-exchange"
  echo
  echo "# Allow redirection of CONNECT requests to the cache peer"
  echo "never_direct allow CONNECT"
  echo
fi
