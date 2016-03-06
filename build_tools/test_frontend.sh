#!/bin/bash

# This script is meant to be run from the script step in .travis.yml
# The tests run by this script are "frontend" testing

echo "In" `pwd`

# Start a hub that our tests can interact with
echo "Starting everware"

# XXX Latest release does not yet force SSL
if [[ "$JHUB_VERSION" == "latest" ]]; then
    OPTS="-f build_tools/frontend_test_config.py --debug"
else
    OPTS="-f build_tools/frontend_test_config.py --no-ssl --debug"
fi
jupyterhub ${OPTS} > /tmp/frontend_test_hub.log 2>&1 &
HUB_PID=$!
sleep 3

export UPLOADDIR=/tmp/everware-frontend-test-screenshots
echo "Start running frontend tests"
nose2 -v --start-dir frontend_tests

if [ -f /tmp/frontend_test_hub.log ]; then
    echo ">>> Frontend test hub log:"
    cat /tmp/frontend_test_hub.log
    echo "<<< Frontend test hub log:"
fi

kill ${HUB_PID}