#!/bin/sh

. /usr/lib/iserv/cfg

if [ ! -z "$ProxyCacheMgr" ]
then
  echo "# Cache Administrator"
  echo "  cache_mgr $ProxyCacheMgr"
  echo ""
fi

if [ ! -z "$ProxyCachePeer" ]
then
  PEERSTRING=$(echo $ProxyCachePeer | sed 's/:/ parent /g')
  echo "# Cache peer"
  echo "  cache_peer $PEERSTRING 0 default name=peer never-direct no-query no-digest no-netdb-exchange"
  echo
  echo "# domains which should not use the upstream proxy"
  echo "  acl peer_black_list dstdomain .windowsupdate.com"
  echo
  echo "# Send windows update requests still via nginx"
  echo "  cache_peer_access peer deny peer_black_list"
  echo "  cache_peer_access peer allow !peer_black_list"
  echo
  echo "# Allow redirection of CONNECT requests to the cache peer"
  echo "  never_direct allow CONNECT"
  echo
  if [ ! -z "$ProxyAlwaysDirect" ]
  then
    echo "# Domains which should bypass the cache peer"
    for i in "${ProxyAlwaysDirect[@]}"
    do
      echo "  acl cache_peer_bypass dstdomain .$i"
    done
    echo
    echo "# Bypass the upstream proxy for the selected domains"
    echo "  always_direct allow cache_peer_bypass"
    echo "  cache_peer_access peer deny cache_peer_bypass"
    echo
  fi
fi
