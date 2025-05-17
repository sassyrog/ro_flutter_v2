#!/bin/bash

# Kill any existing ADB servers
adb kill-server >/dev/null 2>&1
pkill -9 adb >/dev/null 2>&1

# Start ADB server in no-daemon mode and log output
echo "Starting ADB server..."
adb -a -P 5037 nodaemon server > adb.log 2>&1 &
ADB_PID=$!

# Wait for server to initialize
sleep 3


echo "Connecting to BlueStacks..."
max_retries=3
retry_count=0
ADB_PORT=${ADB_PORT:-5555}

while [ $retry_count -lt $max_retries ]; do
    adb connect host.docker.internal:$ADB_PORT
    if adb devices | grep -q "host.docker.internal:$ADB_PORT"; then
        echo "Successfully connected to BlueStacks"
        break
    else
        retry_count=$((retry_count+1))
        echo "Connection failed, retry $retry_count/$max_retries..."
        sleep 3
    fi
done

# Verify connection
echo -e "\nConnected devices:"
adb devices -l

# Check if connection succeeded
if ! adb devices | grep -q "host.docker.internal:$ADB_PORT"; then
    echo -e "\nERROR: Failed to connect to BlueStacks after $max_retries attempts"
    echo "ADB server log:"
    cat adb.log
    kill $ADB_PID
    exit 1
fi

# Set up port forwarding for Flutter web debugging
adb forward tcp:8081 tcp:8081

exit 0