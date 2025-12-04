#!/bin/bash

# Steam Deck Refresh Rate Expander
# Based on Nyaaori's timing research (recovered from Wayback Machine)
# Original: https://git.spec.cat/Nyaaori/gamescope/commit/d39000aa9f53d1bd3c6fa993fdaeb6cc99ad4ae0
#
# This script installs a custom Lua display config with extended refresh rates.
# Uses Nyaaori's hand-tuned timing values for BOE and SDC panels.
#
# WARNING: Running hardware outside of factory specifications may reduce 
# lifespan and/or cause damage. Use at your own risk!
#
# Panel limitations:
# - BOE panels: Up to 120Hz (hand-tuned by Nyaaori)
# - SDC panels: ~95Hz max due to bandwidth constraints

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_DIR="$HOME/.config/gamescope/scripts/displays"

echo "=========================================="
echo "Steam Deck Refresh Rate Expander"
echo "Based on Nyaaori's timing research"
echo "=========================================="
echo ""

# Check if running on Steam Deck
MODEL=$(cat /sys/class/dmi/id/board_name 2>/dev/null || echo "Unknown")
STEAMOS_VERSION=$(grep -i version_id /etc/os-release 2>/dev/null | cut -d "=" -f2 | tr -d '"')

echo "Detected model: $MODEL"
echo "SteamOS version: $STEAMOS_VERSION"
echo ""

# Validate model
case "$MODEL" in
    "Jupiter")
        DECK_TYPE="LCD"
        echo "Steam Deck LCD detected."
        echo "For LCD, use Ryan's RefreshRateUnlocker instead:"
        echo "https://github.com/ryanrudolfoba/SteamDeck-RefreshRateUnlocker"
        exit 0
        ;;
    "Galileo")
        DECK_TYPE="OLED"
        ;;
    *)
        echo "ERROR: Unknown Steam Deck model: $MODEL"
        echo "This script only supports Galileo (OLED)."
        exit 1
        ;;
esac

# Detect OLED panel type
detect_oled_panel() {
    local edid_path="/sys/class/drm/card0-eDP-1/edid"
    if [[ -f "$edid_path" ]]; then
        local product_hex=$(xxd -p -l 2 -s 10 "$edid_path" 2>/dev/null)
        case "$product_hex" in
            "0330") echo "SDC" ;;
            "0430") echo "BOE" ;;
            *) echo "UNKNOWN" ;;
        esac
    else
        echo "UNKNOWN"
    fi
}

PANEL_TYPE=$(detect_oled_panel)
echo "OLED Panel type: $PANEL_TYPE"
echo ""

# Show warnings based on panel type
if [[ "$PANEL_TYPE" == "SDC" ]]; then
    echo "⚠️  WARNING: SDC (Samsung) Panel Detected"
    echo ""
    echo "SDC panels are bandwidth-limited and may only work up to ~95Hz."
    echo "User reports indicate:"
    echo "  - 91-95Hz: Minor image quality degradation"
    echo "  - 96Hz+: Flickering begins"
    echo "  - 100Hz+: Screen becomes garbled"
    echo ""
    echo "The timing values for SDC were NOT fully tested by Nyaaori."
    echo ""
elif [[ "$PANEL_TYPE" == "BOE" ]]; then
    echo "✓ BOE Panel Detected"
    echo ""
    echo "BOE panels can reach up to 120Hz with Nyaaori's hand-tuned timings."
    echo "User reports indicate:"
    echo "  - 91-108Hz: Works, minor gamma/color shifts"
    echo "  - 109Hz: Best balance of speed and quality"
    echo "  - 110-120Hz: Works but colors/brightness may be off"
    echo ""
else
    echo "⚠️  WARNING: Unknown panel type!"
    echo "Proceeding with BOE timing values (may not work correctly)."
    echo ""
fi

# Show menu
echo "Select an option:"
echo ""
echo "  1) Install extended refresh rates (up to 120Hz)"
echo "  2) Uninstall (restore stock 45-90Hz)"
echo "  3) Exit"
echo ""
read -p "Enter choice [1-3]: " choice

case "$choice" in
    1)
        echo ""
        
        # Check if source lua exists
        if [[ ! -f "$SCRIPT_DIR/valve.steamdeck.oled.extended.lua" ]]; then
            echo "ERROR: valve.steamdeck.oled.extended.lua not found!"
            echo "Make sure you're running this from the project directory."
            exit 1
        fi
        
        # Final confirmation
        echo "This will install extended refresh rate support."
        echo ""
        if [[ "$PANEL_TYPE" == "SDC" ]]; then
            echo "IMPORTANT: SDC panels may not work well above 95Hz!"
            echo "If you experience issues, select lower refresh rates or uninstall."
        fi
        echo ""
        read -p "Continue? (y/N): " confirm
        if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
            echo "Aborted."
            exit 0
        fi
        
        echo ""
        echo "Installing..."
        
        # Create install directory
        mkdir -p "$INSTALL_DIR"
        
        # Copy the extended lua file
        cp "$SCRIPT_DIR/valve.steamdeck.oled.extended.lua" "$INSTALL_DIR/"
        
        echo ""
        echo "=========================================="
        echo "Installation complete!"
        echo "=========================================="
        echo ""
        echo "Installed: $INSTALL_DIR/valve.steamdeck.oled.extended.lua"
        echo ""
        echo "Refresh rates available: 45-120Hz"
        echo "(Actual max depends on your panel - SDC ~95Hz, BOE ~120Hz)"
        echo ""
        echo "Please REBOOT your Steam Deck for changes to take effect."
        echo ""
        echo "After reboot, go to Settings > Display and try the new refresh rates."
        echo "Start with 92Hz and work up slowly to find your panel's limit."
        ;;
        
    2)
        echo ""
        echo "Uninstalling..."
        
        if [[ -f "$INSTALL_DIR/valve.steamdeck.oled.extended.lua" ]]; then
            rm "$INSTALL_DIR/valve.steamdeck.oled.extended.lua"
            echo "Removed: $INSTALL_DIR/valve.steamdeck.oled.extended.lua"
        else
            echo "No custom script found to remove."
        fi
        
        # Also remove any old custom files
        if [[ -f "$HOME/.config/gamescope/scripts/valve.steamdeck.oled.custom.lua" ]]; then
            rm "$HOME/.config/gamescope/scripts/valve.steamdeck.oled.custom.lua"
            echo "Removed old custom script."
        fi
        
        echo ""
        echo "Uninstall complete. Reboot to restore stock refresh rates (45-90Hz)."
        ;;
        
    3)
        echo "Exiting."
        exit 0
        ;;
        
    *)
        echo "Invalid choice."
        exit 1
        ;;
esac
