#!/bin/bash
 
# File to monitor
SSH_CONFIG="$HOME/.ssh/config"
# Webhooks
WEBHOOK_ADDED="[Your Webhook]"
WEBHOOK_REMOVED="[Your Webhook]"
# Temp file to store the last known state
TEMP_STATE="/c/Users/$HOME/Config-watch/ssh_config_last_state"

# Parse SSH config and extract Host/HostName pairs into a list
parse_config() {
    local config_file=$1
    declare -a hosts=()
    local current_host=""
    local hostname=""
    while IFS= read -r line || [[ -n $line ]]; do
        if [[ $line =~ ^Host[[:space:]]+(.+)$ ]]; then
            current_host="${BASH_REMATCH[1]}"
        elif [[ $line =~ ^[[:space:]]*HostName[[:space:]]+(.+)$ ]]; then
            hostname="${BASH_REMATCH[1]}"
            if [[ -n $current_host && -n $hostname ]]; then
                hosts+=("$current_host|$hostname")
                current_host=""
                hostname=""
            fi
        fi
    done < "$config_file"
    echo "${hosts[@]}"
}

# Get current state of the SSH config
CURRENT_HOSTS=$(parse_config "$SSH_CONFIG")

# Load previous state
if [[ -f "$TEMP_STATE" ]]; then
    PREVIOUS_HOSTS=$(cat "$TEMP_STATE")
else
    PREVIOUS_HOSTS=""
fi

# Detect added and removed hosts
ADDED_HOSTS=()
REMOVED_HOSTS=()

# Find added hosts
for host in $CURRENT_HOSTS; do
    if ! grep -q "$host" <<< "$PREVIOUS_HOSTS"; then
        ADDED_HOSTS+=("$host")
    fi
done

# Find removed hosts
for host in $PREVIOUS_HOSTS; do
    if ! grep -q "$host" <<< "$CURRENT_HOSTS"; then
        REMOVED_HOSTS+=("$host")
    fi
done

# Send webhook for added hosts
for added in "${ADDED_HOSTS[@]}"; do
    HOST=$(echo "$added" | cut -d '|' -f 1)
    HOSTNAME=$(echo "$added" | cut -d '|' -f 2)
    PAYLOAD=$(cat <<EOF
{
    "FilePath": "$SSH_CONFIG",
    "ChangeType": "Added",
    "Timestamp": "$(date)",
    "Host": "$HOST",
    "HostName": "$HOSTNAME"
}
EOF
)
    curl -X POST -H "Content-Type: application/json" -d "$PAYLOAD" "$WEBHOOK_ADDED"
    echo "Added Host: $HOST, HostName: $HOSTNAME"
done

# Send webhook for removed hosts
for removed in "${REMOVED_HOSTS[@]}"; do
    HOST=$(echo "$removed" | cut -d '|' -f 1)
    HOSTNAME=$(echo "$removed" | cut -d '|' -f 2)
    PAYLOAD=$(cat <<EOF
{
    "FilePath": "$SSH_CONFIG",
    "ChangeType": "Removed",
    "Timestamp": "$(date)",
    "Host": "$HOST",
    "HostName": "$HOSTNAME"
}
EOF
)
    curl -X POST -H "Content-Type: application/json" -d "$PAYLOAD" "$WEBHOOK_REMOVED"
    echo "Removed Host: $HOST, HostName: $HOSTNAME"
done

# Update the previous state
echo "$CURRENT_HOSTS" > "$TEMP_STATE"
