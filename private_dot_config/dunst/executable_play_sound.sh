#!/bin/bash
# Dunst notification sound script using Oxygen sound theme
# Receives notification info via environment variables set by dunst

SOUND_DIR="/usr/share/sounds/oxygen/stereo"

# Apps to skip sound for (matched case-insensitively against appname and desktop_entry)
SKIP_APPS=(
    # Browsers
    "firefox" "chrome" "chromium" "brave" "vivaldi" "opera" "edge"
    "google-chrome" "google-chrome-stable" "google-chrome-beta"
    "chromium-browser" "brave-browser" "microsoft-edge"
    # Messaging / chat
    "telegram" "telegram-desktop" "org.telegram.desktop"
    "discord" "discord-canary" "discord-ptb"
    "slack"
)

# Check if this notification should be muted
app_lower="${DUNST_APP_NAME,,}"
desktop_lower="${DUNST_DESKTOP_ENTRY,,}"
for skip in "${SKIP_APPS[@]}"; do
    if [[ "$app_lower" == *"$skip"* ]] || [[ "$desktop_lower" == *"$skip"* ]]; then
        exit 0
    fi
done

# Map urgency to Oxygen sound file (freedesktop naming convention)
case "$DUNST_URGENCY" in
    LOW)
        SOUND="dialog-information.ogg"
        ;;
    NORMAL)
        SOUND="message-new-instant.ogg"
        ;;
    CRITICAL)
        SOUND="dialog-warning.ogg"
        ;;
    *)
        SOUND="message.ogg"
        ;;
esac

# Play the sound using PulseAudio/PipeWire
if command -v pw-play &>/dev/null; then
    pw-play "$SOUND_DIR/$SOUND" &
elif command -v paplay &>/dev/null; then
    paplay "$SOUND_DIR/$SOUND" &
fi
