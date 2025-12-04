# Steam Deck OLED Refresh Rate Expander

Extends OLED refresh rates beyond stock 90Hz via user Lua scripts. No system modifications required.

## Panel Limits

| Panel | Stock | Extended | Notes |
|-------|-------|----------|-------|
| SDC (Samsung) | 90Hz | 96Hz | Bandwidth limited (~133MHz at 90Hz) |
| BOE | 90Hz | 130Hz | Experimental above 110Hz |

## Install

```bash
mkdir -p ~/.config/gamescope/scripts/displays
curl -L https://raw.githubusercontent.com/xXJSONDeruloXx/deck-refresh-rate-expander/main/valve.steamdeck.oled.expanded.lua -o ~/.config/gamescope/scripts/displays/valve.steamdeck.oled.expanded.lua
# Reboot
```

## Uninstall

```bash
rm ~/.config/gamescope/scripts/displays/valve.steamdeck.oled.expanded.lua
# Reboot
```

## How It Works

Lua script in `~/.config/gamescope/scripts/displays/` overrides system display config (priority 5200 vs stock 5100).

For rates >90Hz: sets minimum VFP and scales pixel clock via `calc_max_clock()`.

## Panel Detection

```bash
xxd -p -l 2 -s 10 /sys/class/drm/card0-eDP-1/edid
# 0330 = SDC, 0430 = BOE
```

## References

- [Nyaaori's original research](https://www.reddit.com/r/SteamDeck/comments/185qpx5/release_120hz_boe_oled_refresh_rate_enabler_sdc/)
- [Timing values (Wayback)](https://web.archive.org/web/20250518/https://git.spec.cat/Nyaaori/gamescope/commit/d39000aa9f53d1bd3c6fa993fdaeb6cc99ad4ae0)
- [Ryan's LCD 70Hz mod](https://github.com/ryanrudolfoba/SteamDeck-RefreshRateUnlocker)

## License

MIT
