#!/bin/bash
#
# Use this script for starting and stopping the Oracle Instance and Listener within a docker container

shutdown() {
  killall sleep

  echo ""
  echo "**************************"
  echo "**** Shutting down... ****"
  echo "**************************"
  echo ""

  sudo -u oracle -i bash -c "lsnrctl stop"
  sudo -u oracle -i bash -c "dbshut $ORACLE_HOME"
  #sudo -u oracle -i bash -c "emctl stop dbconsole"

  echo ""
  echo "**************************"
  echo "**** Shutdown finished ***"
  echo "**************************"
  echo ""
}

echo ""
echo "**************************"
echo "**** Starting up...   ****"
echo "**************************"
echo ""

sudo -u oracle -i bash -c "lsnrctl start"
sudo -u oracle -i bash -c "dbstart $ORACLE_HOME"
#sudo -u oracle -i bash -c "emctl start dbconsole"
sudo -u oracle -i bash -c "lsnrctl status"

echo ""
echo "**************************"
echo "**** Startup finished ****"
echo "**************************"
echo ""

# Call shutdown() if this script receives SIGINT or SIGTERM
trap 'shutdown' INT TERM

# wait for SIGINT / SIGTERM
while true; do sleep 3600 & wait $!; done

