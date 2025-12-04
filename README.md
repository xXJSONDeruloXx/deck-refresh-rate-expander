# Steam Deck Refresh Rate Expander

Extends available refresh rate options for Steam Deck displays.

### LCD (Jupiter)
- **Working!** Based on Ryan Rudolf's approach
- Extends refresh rate from 40-60Hz to 40-70Hz

### OLED (Galileo)  
- **Not yet working** - The OLED panels use a different timing mechanism
- See [RESEARCH.md](RESEARCH.md) for technical details on what we've learned

## Installation

```bash
git clone https://github.com/xXJSONDeruloXx/deck-refresh-rate-expander.git
cd deck-refresh-rate-expander
bash install-rre.sh
```

Follow the on-screen prompts to install or uninstall.

## WARNING

**Running hardware outside of factory specifications may reduce lifespan and/or cause damage!**

- I am not responsible if your Steam Deck dies prematurely or any other damage occurs
- Be prepared to restore your Steam Deck using a recovery image if problems arise

## How It Works

This script uses the same approach as [Ryan Rudolf's LCD 70Hz mod](https://github.com/ryanrudolfoba/SteamDeck-RefreshRateUnlocker):

1. Copies the system display Lua config to user directory (`~/.config/gamescope/scripts/`)
2. Modifies the refresh rate array to include additional rates
3. Gamescope loads user scripts with higher priority than system scripts

No system files are modified - everything lives in your home directory.

## Why OLED is Different

The LCD and OLED panels use different timing approaches:

- **LCD:** Uses clock scaling - works for any refresh rate
- **OLED:** Uses VFP (Vertical Front Porch) lookup table - only works for rates with predefined timings

The stock OLED config only has VFP values for 45-90Hz. To add higher rates, we need to either:
1. Calculate new VFP values (can't go below 8, so limited)
2. Find the correct fixed timings to use clock scaling like LCD
3. Get the original 120Hz mod's approach (binary no longer available)

## Uninstallation

Run the install script again and select "Uninstall", or manually:

```bash
# For LCD:
rm ~/.config/gamescope/scripts/valve.steamdeck.lcd.custom.lua

# For OLED:
rm ~/.config/gamescope/scripts/valve.steamdeck.oled.custom.lua
```

Then reboot.

## Credits

- [Ryan Rudolf's SteamDeck-RefreshRateUnlocker](https://github.com/ryanrudolfoba/SteamDeck-RefreshRateUnlocker) - Original LCD 70Hz approach
- Valve for making gamescope open source and configurable
- Original OLED 120Hz mod creators (research reference)
