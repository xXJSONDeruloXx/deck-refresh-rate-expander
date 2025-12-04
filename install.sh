#!/bin/bash

# Steam Deck OLED Refresh Rate Expander
# Extends refresh rates beyond stock 90Hz limit
#
# SDC (Samsung) panels: Up to 96Hz
# BOE panels: Up to 120Hz (experimental)
#
# No system modifications required - uses user Lua scripts

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_DIR="$HOME/.config/gamescope/scripts/displays"
LUA_FILE="valve.steamdeck.oled.expanded.lua"

echo "=========================================="
echo "Steam Deck OLED Refresh Rate Expander"
echo "=========================================="
echo ""

# Check if running on Steam Deck
if [[ ! -f /sys/class/dmi/id/board_name ]]; then
    echo "Warning: Could not detect board. Continuing anyway..."
    MODEL="Unknown"
else
    MODEL=$(cat /sys/class/dmi/id/board_name)
fi

echo "Detected model: $MODEL"

# Check for OLED
if [[ "$MODEL" == "Jupiter" ]]; then
    echo ""
    echo "Steam Deck LCD detected."
    echo "This script is for OLED models only."
    echo ""
    echo "For LCD 70Hz mod, use:"
    echo "https://github.com/ryanrudolfoba/SteamDeck-RefreshRateUnlocker"
    exit 0
fi

# Detect panel type
detect_panel() {
    local edid_path="/sys/class/drm/card0-eDP-1/edid"
    if [[ -f "$edid_path" ]]; then
        local product_hex=$(xxd -p -l 2 -s 10 "$edid_path" 2>/dev/null)
        case "$product_hex" in
            "0330") echo "SDC" ;;
            "0430") echo "BOE" ;;
            *) echo "Unknown" ;;
        esac
    else
        echo "Unknown"
    fi
}

PANEL=$(detect_panel)
echo "Panel type: $PANEL"
echo ""

if [[ "$PANEL" == "SDC" ]]; then
    echo "SDC (Samsung) panel detected."
    echo "Maximum recommended: 96Hz"
    echo "(Higher rates may cause flickering due to bandwidth limits)"
elif [[ "$PANEL" == "BOE" ]]; then
    echo "BOE panel detected."
    echo "Maximum available: 120Hz"
    echo "(Quality may degrade above 110Hz)"
fi

echo ""
echo "Options:"
echo "  1) Install expanded refresh rates"
echo "  2) Uninstall (restore stock)"
echo "  3) Exit"
echo ""
read -p "Choose [1-3]: " choice

case "$choice" in
    1)
        # Check source file exists
        if [[ ! -f "$SCRIPT_DIR/$LUA_FILE" ]]; then
            echo "Error: $LUA_FILE not found in $SCRIPT_DIR"
            exit 1
        fi
        
        echo ""
        echo "Installing..."
        
        mkdir -p "$INSTALL_DIR"
        cp "$SCRIPT_DIR/$LUA_FILE" "$INSTALL_DIR/"
        
        echo ""
        echo "✓ Installed to: $INSTALL_DIR/$LUA_FILE"
        echo ""
        echo "Please REBOOT your Steam Deck for changes to take effect."
        echo ""
        if [[ "$PANEL" == "SDC" ]]; then
            echo "  3. Try 92Hz first, then 94Hz, 96Hz"
            echo "     (Stop if you see flickering)"
        else
            echo "  3. Try increasing gradually to find your panel's limit"
        fi
        ;;
        
    2)
        echo ""
        echo "Uninstalling..."
        
        if [[ -f "$INSTALL_DIR/$LUA_FILE" ]]; then
            rm "$INSTALL_DIR/$LUA_FILE"
            echo "✓ Removed: $INSTALL_DIR/$LUA_FILE"
        fi
        
        # Clean up old files too
        for old_file in valve.steamdeck.oled.test92.lua valve.steamdeck.oled.extended.lua valve.steamdeck.oled.custom.lua; do
            if [[ -f "$INSTALL_DIR/$old_file" ]]; then
                rm "$INSTALL_DIR/$old_file"
                echo "✓ Removed old file: $old_file"
            fi
        done
        
        echo ""
        echo "Reboot to restore stock refresh rates (45-90Hz)."
        ;;
        
    3)
        echo "Exiting."
        ;;
        
    *)
        echo "Invalid choice."
        exit 1
        ;;
esac
