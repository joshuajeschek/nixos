#!/usr/bin/env bash
prefix="[player-progress]"

# Function to convert seconds to HH:MM:SS format
format_time() {
    local total_seconds=$1

    # Remove any decimal points
    total_seconds=${total_seconds%.*}

    local hours=$((total_seconds / 3600))
    local minutes=$(( (total_seconds % 3600) / 60 ))
    local seconds=$((total_seconds % 60))

    # Only show hours if they exist
    if [ $hours -gt 0 ]; then
        printf "%d:%02d:%02d" $hours $minutes $seconds
    else
        printf "%d:%02d" $minutes $seconds
    fi
}

# Function to convert microseconds to HH:MM:SS format
format_time_from_microseconds() {
    local microseconds=$1

    # Convert to seconds
    local total_seconds=$((microseconds / 1000000))

    format_time $total_seconds
}

position=$(playerctl position -a | tail -1)
length_microseconds=$(playerctl metadata -a -f '{{mpris:length}}' | tail -1)

current_progress="$(format_time $position) / $(format_time_from_microseconds $length_microseconds)"
echo "$prefix Current progress: $current_progress" >&2
echo $current_progress
