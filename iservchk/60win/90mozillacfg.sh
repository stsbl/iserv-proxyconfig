#!/bin/sh

if [[ $(dpkg-query --showformat='${Status}\n' --show "winst-mozilla-firefox" | grep "install ok installed") ]]
then  
  echo 'Check "/srv/deploy/install/mozilla-firefox/add/mozilla.cfg"'
  echo
  echo '# re-install Firefox to all Computers which has Firefox installed when the mozilla.cfg has been modified by the check'
  echo
  echo "Shell \"Re-install Mozilla Firefox on all computers\" ! [ \$REPAIR ] || psql -c \"UPDATE deploy_state SET action='setup' WHERE product = 'mozilla-firefox';\" iserv postgres"
  echo
  echo 'Shell "Remove backup files of mozilla.cfg" ! [ \$REPAIR ] || rm -f /srv/deploy/install/mozilla-firefox/add/mozilla.cfg.*'
fi
