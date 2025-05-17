#!/bin/sh
set -eu pipefail

# Configuration
ADB_PORT=${ADB_PORT:-5555}
ADB_SERVER_PORT=${ADB_SERVER_PORT:-5037}
MAX_RETRIES=5
RETRY_DELAY=2

# Cleanup function
cleanup() {
    echo "Cleaning up ADB processes..."
    pkill -9 adb 2>/dev/null || true
    adb kill-server 2>/dev/null || true
}

# Start ADB server
start_adb_server() {
    echo "Starting ADB server on port $ADB_SERVER_PORT..."
    adb -a -P "$ADB_SERVER_PORT" nodaemon server > adb.log 2>&1 &
    ADB_PID=$!
    sleep 2  # Wait for server initialization
}

# Connection function
connect_to_bluestacks() {
    echo "Attempting to connect to BlueStacks..."
    
    i=1
    while [ "$i" -le "$MAX_RETRIES" ]; do
        if adb connect "host.docker.internal:$ADB_PORT" 2>/dev/null; then
            if adb devices | grep -q "host.docker.internal:$ADB_PORT.*device$"; then
                echo "Successfully connected to BlueStacks"
                return 0
            fi
        fi
        
        echo "Connection attempt $i/$MAX_RETRIES failed, retrying in $RETRY_DELAY seconds..."
        i=$((i + 1))
        sleep "$RETRY_DELAY"
    done
    
    return 1
}

# Main execution
cleanup
start_adb_server

if connect_to_bluestacks; then
    echo -e "\nConnected devices:"
    adb devices -l
    
    echo "Setting up port forwarding..."
    adb forward tcp:8081 tcp:8081
    
    echo "ADB connection established successfully"
    exit 0
else
    echo -e "\nERROR: Failed to connect after $MAX_RETRIES attempts"
    echo "ADB server logs:"
    cat adb.log
    exit 1
fi