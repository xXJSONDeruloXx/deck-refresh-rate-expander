# Steam Deck Refresh Rate Expander - Research Notes

## Overview

This document catalogues our research into extending Steam Deck refresh rates beyond factory limits.

## Panel Types

### Steam Deck LCD (Jupiter)
- **Model identifier:** `Jupiter`
- **Panel vendors:** WLC, ANX, VLV (all use ANX7530 U)
- **Stock refresh range:** 40-60Hz
- **Achievable:** Up to 70Hz (confirmed by Ryan's mod)
- **Resolution:** 800x1280

### Steam Deck OLED (Galileo)

#### BOE Panel
- **Product ID:** `0x3004`
- **Vendor:** VLV (Valve)
- **Stock refresh range:** 45-90Hz
- **Pixel clock at 90Hz:** ~102MHz
- **Bandwidth limit:** ~147-148MHz (MIPI converter limit)
- **Theoretical max refresh:** ~130-134Hz
- **Achievable:** Up to 120Hz (confirmed by Nyaaori)
- **Detection:** `xrandr --verbose | grep MHz` shows ~102.00MHz

#### SDC (Samsung) Panel
- **Product ID:** `0x3003`  
- **Vendor:** VLV (Valve)
- **Stock refresh range:** 45-90Hz
- **Pixel clock at 90Hz:** ~133MHz (ALREADY HIGH!)
- **Bandwidth limit:** ~147-148MHz (MIPI converter limit)
- **Theoretical max refresh:** ~98-102Hz
- **Detection:** `xrandr --verbose | grep MHz` shows ~133.20MHz

**Critical insight from Nyaaori:**
> "SDC at 90Hz uses ~133MHz of bandwidth while BOE at 90Hz uses ~102MHz of bandwidth; Valve's MIPI converter seems to begin struggling at roughly ~147-148MHz"

This explains why SDC panels are fundamentally limited - they're already using 90% of available bandwidth at 90Hz!

## How Gamescope Handles Refresh Rates

### Lua Script Location
- **System scripts:** `/usr/share/gamescope/scripts/00-gamescope/displays/`
- **User scripts:** `~/.config/gamescope/scripts/` (higher priority)

### Key Files
- `valve.steamdeck.lcd.lua` - LCD panel configuration
- `valve.steamdeck.oled.lua` - OLED panel configuration (BOE + SDC)
- `common/modegen.lua` - Mode generation helper functions

### Display Matching Priority
- Scripts return a priority number in their `matches()` function
- Higher number = higher priority
- Stock LCD: 5000, Stock OLED: 5100
- Custom scripts should use 5200+ to override stock

## Mode Generation Approaches

### LCD Approach (Works for Extended Rates)
```lua
dynamic_modegen = function(base_mode, refresh)
    local mode = base_mode
    
    -- Set fixed display timings
    gamescope.modegen.set_resolution(mode, 800, 1280)
    gamescope.modegen.set_h_timings(mode, 40, 4, 40)  -- hfp, hsync, hbp
    gamescope.modegen.set_v_timings(mode, 30, 4, 8)   -- vfp, vsync, vbp
    
    -- Calculate clock for desired refresh rate
    mode.clock = gamescope.modegen.calc_max_clock(mode, refresh)
    mode.vrefresh = gamescope.modegen.calc_vrefresh(mode)
    
    return mode
end
```

**Why it works for any rate:** Rebuilds entire mode with fixed timings, only clock changes.

### OLED Approach (Limited to VFP Table)
```lua
dynamic_modegen = function(base_mode, refresh)
    local vfps = {
        1321, 1264, 1209, ...  -- VFP values for each refresh rate
    }
    local vfp = vfps[zero_index(refresh - 45)]
    
    local mode = base_mode
    gamescope.modegen.adjust_front_porch(mode, vfp)
    mode.vrefresh = gamescope.modegen.calc_vrefresh(mode)
    
    return mode
end
```

**Why it's limited:** VFP table only has entries for 45-90Hz. At 90Hz, VFP=8 (minimum). Can't go lower for higher rates.

## Ryan's Approach (LCD 70Hz Mod)

Ryan's script (`ryanrudolfoba/SteamDeck-RefreshRateUnlocker`):

1. **Copies** the entire system LCD lua file to user directory
2. **Uses sed** to modify ONLY the `dynamic_refresh_rates` array
3. **Does NOT modify** the `dynamic_modegen` function
4. Works because LCD's modegen uses clock scaling (not VFP lookup)

```bash
# Ryan's sed command - just adds 61-70 to the array
sed -i '/50, 51, 52, 53, 54, 55, 56, 57, 58, 59,/!b;n;c\\t60, 61, 62, 63, 64, 65, 66, 67, 68, 69, \n\t70'
```

## Our Failed Attempts

### Attempt 1: Create New OLED Config with Extended Rates
- Added 92-120Hz to `dynamic_refresh_rates`
- For >90Hz, tried clock scaling approach (like LCD)
- **Result:** Screen artifacts, broke on first boot

### Attempt 2: Conservative 92Hz Only
- Only added 92Hz to rates
- Used clock scaling for >90Hz
- **Result:** 
  - 92Hz appeared in settings ✓
  - Brightness controls broken ✗
  - Mode switching broken (screen wouldn't change when selecting different rates) ✗

### Problem Identified
Our modegen function for >90Hz returns modes that:
1. Gamescope accepts initially
2. But then can't switch away from
3. Possibly invalid timings that panel accepts but causes issues

## What Nyaaori Actually Did

From the Reddit thread, we learned:

### 1. They Modified the Gamescope Binary
> "either switch steamos branch so it updates and overwrites it, or disable read-only, move `/usr/bin/gamescope.orig` back to `/usr/bin/gamescope`"

### 2. They Manually Tuned 80 Timing Modes
> "It took me about 6-8 hours of manual tuning and testing of display timings to get these values for BOE panels"

> "Hard part was manually tuning and testing timings for BOE panels over several hours, code part only took like 5-10 minutes."

### 3. They Added Clock Rate Logic (Not Just VFP)
> "primarily adding logic for handling setting clock rates in addition to vfp rates"

### 4. SDC Never Fully Worked
From user reports:
- **100Hz:** "completely garbled"
- **96Hz+:** "starts flickering"
- **91-95Hz:** "image quality gets increasingly pixelated"
- **70Hz:** "gamma was unusable on Samsung panel"

Nyaaori said:
> "I'm pretty sure I would need to have physical access to one for a while in order to find compatible timings, given that calculating them alone does not seem to work well."

### 5. Commit Reference - RECOVERED FROM WAYBACK MACHINE!
The original commit: `d39000aa9f53d1bd3c6fa993fdaeb6cc99ad4ae0`
Repository: `git.spec.cat/Nyaaori/gamescope` (archived on Wayback Machine)
Archive URL: `https://web.archive.org/web/20250518/https://git.spec.cat/Nyaaori/gamescope/commit/d39000aa9f53d1bd3c6fa993fdaeb6cc99ad4ae0`

**This is C++ code, not Lua!** They modified:
- `src/drm.cpp` - Added refresh rate arrays
- `src/modegen.cpp` - Added timing tables and clock values

### 6. Future Plans (from 2 months ago!)
> "I've been really busy for a while now, but intend on updating this for SteamOS 3.8 after valve gets around to releasing, there have been a few changes in the OS that should make things much easier to do."

> "Valve made changes that make modifications like this significantly easier to do and it looks like they'll be present in 3.8"

## What We Need to Figure Out

### For SDC (Samsung) Panels - BAD NEWS
**SDC panels may never go much above 90Hz** due to bandwidth constraints:
- Already at 133MHz at 90Hz
- MIPI converter limit is ~147MHz
- That's only ~10% headroom (~99Hz theoretical max)
- User reports confirm: anything above 96Hz causes artifacts

### For BOE Panels - POSSIBLE
- Has ~45% bandwidth headroom (102MHz → 147MHz)
- Nyaaori got 120Hz working with manual timing tuning
- Would need:
  1. Access to a BOE panel Deck
  2. Manual timing tuning (6-8 hours per Nyaaori)
  3. Or find someone with the original mod to extract timings

### Finding Nyaaori's Timings - FOUND!
We recovered the full commit from Wayback Machine. See "Nyaaori's Actual Timing Data" section below.

### Alternative: Wait for SteamOS 3.8
Nyaaori mentioned Valve is making changes that will make this easier. Might be worth waiting.

### Questions for Fear (Customer)
1. Does he have the modded binary on any of his Decks?
2. Can we get a hexdump of relevant sections?
3. What panel type does he have (BOE vs SDC)?

## Panel Detection Code

```bash
# Get panel type from EDID
EDID_PATH="/sys/class/drm/card0-eDP-1/edid"
PRODUCT_HEX=$(xxd -p -l 2 -s 10 "$EDID_PATH" 2>/dev/null)

case "$PRODUCT_HEX" in
    "0330") echo "SDC (Samsung)" ;;  # 0x3003 little-endian
    "0430") echo "BOE" ;;            # 0x3004 little-endian
esac
```

## Next Steps

1. **Try copying entire OLED lua file** (like Ryan does for LCD) and only modify refresh rates array
   - This will use stock modegen which has proper VFP values
   - Won't work for >90Hz (no VFP entries), but tests if our approach is fundamentally broken

2. **Find OLED panel timing specs**
   - Look for DSI timing documentation
   - Reverse engineer from working modes

3. **Contact original mod author** if possible
   - Get the actual changes they made to gamescope

## References

- [Ryan's LCD 70Hz Mod](https://github.com/ryanrudolfoba/SteamDeck-RefreshRateUnlocker)
- [Gamescope Source](https://github.com/ValveSoftware/gamescope)
- [Original OLED 120Hz discussion](https://www.resetera.com/threads/steam-deck-modders-boost-display-up-to-120hz-on-the-new-oled-boe-panels.789597/)
- [Nyaaori's Reddit Thread](https://www.reddit.com/r/SteamDeck/comments/185qpx5/release_120hz_boe_oled_refresh_rate_enabler_sdc/) - TONS of info
- Original commit (dead): `git.spec.cat/Nyaaori/gamescope/commit/d39000aa9f53d1bd3c6fa993fdaeb6cc99ad4ae0`

## User Reports Summary (from Reddit)

### BOE Panel
| Refresh Rate | Status | Notes |
|--------------|--------|-------|
| 45-90Hz | ✅ Works | Stock rates |
| 91-108Hz | ⚠️ Works | Minor gamma/color issues |
| 109Hz | ✅ Best | "colors go back to normal" per user |
| 110-120Hz | ⚠️ Works | "brightness and colors are horrible", "black clipping" |

### SDC Panel  
| Refresh Rate | Status | Notes |
|--------------|--------|-------|
| 45-90Hz | ✅ Works | Stock rates |
| 91-95Hz | ⚠️ Degraded | "image quality gets increasingly pixelated" |
| 96Hz+ | ❌ Broken | "starts flickering" |
| 100Hz | ❌ Broken | "completely garbled" |

### Key Takeaway
**SDC panels are hardware-limited to ~95Hz max.** The bandwidth constraint is physical, not software.

For Fear's commission: If he has SDC panel, realistic max is ~95Hz. If BOE panel, 120Hz is achievable with Nyaaori's timing values.

---

## Nyaaori's Actual Timing Data (Recovered from Wayback Machine!)

**Source:** `https://web.archive.org/web/20250518/https://git.spec.cat/Nyaaori/gamescope/commit/d39000aa9f53d1bd3c6fa993fdaeb6cc99ad4ae0`

### Key Discovery: This is C++ Code, Not Lua!

Nyaaori modified `src/modegen.cpp` to add **both VFP values AND clock values** for each refresh rate.
The Lua scripts can only set VFP (via `adjust_front_porch`), but the C++ code sets `mode->clock` directly.

**This is why our Lua-only approach failed!**

### BOE Panel Timing Tables (40-120Hz)

Index 0 = 40Hz, Index 80 = 120Hz

**VFP Values (must be multiple of 4 for BOE):**
```cpp
unsigned int galileo_boe_vfp[] = {
    1320,1320,1216,1216,1216,1216,1320,1320,1216,1112,  // 40-49Hz
    1112, 992, 928, 992, 992, 828, 808, 700, 808, 664,  // 50-59Hz
     700, 664, 664, 604, 544, 544, 500, 436, 488, 436,  // 60-69Hz
     336, 316, 336, 316, 228, 336, 316, 252, 252, 212,  // 70-79Hz
     100,  84, 172, 136,  68,  36,  84,  52,  36,  68,  // 80-89Hz
      84,  36, 136,  52,  36,  52,  52,   8, 152,  68,  // 90-99Hz
     100,   8, 136,  36,  84,   8,  36,   8,  84,   8,  // 100-109Hz
     172,  68,   8,   8,  52,  36,  68,   8,  36, 100,  // 110-119Hz
     100                                                 // 120Hz
};
```

**Clock Values (kHz):**
```cpp
unsigned int galileo_boe_clock[] = {
     90340, 92590, 91100, 93270, 95440, 97610,103880,106140,104120,101910,  // 40-49Hz
    103990,100820, 99940,104780,106750,100990,101870, 98400,105500,100030,  // 50-59Hz
    103580,103420,105120,103570,101920,103510,102610,100490,105020,103490,  // 60-69Hz
     98980, 99180,101810,101970, 97780,106050,106160,103330,104670,103300,  // 70-79Hz
     96920, 97020,104410,103120, 99460, 98310,103010,101820,101780,105380,  // 80-89Hz
    107800,105250,114300,108840,108720,111180,112350,109860,123100,117220,  // 90-99Hz
    121150,114390,126730,119130,124570,118920,122600,121190,129360,123450,  // 100-109Hz
    140060,131430,126850,127980,133420,133010,137350,132510,136480,144170,  // 110-119Hz
    145380                                                                   // 120Hz
};
```

### SDC Panel Timing Tables (40-120Hz) - UNTESTED by Nyaaori

**VFP Values:**
```cpp
unsigned int galileo_sdc_vfp[] = {
    1321,1321,1321,1321,1321,1321,1264,1209,1157,1106,  // 40-49Hz
    1058,1012, 967, 925, 883, 844, 805, 768, 732, 698,  // 50-59Hz
     665, 632, 601, 571, 542, 513, 486, 459, 433, 408,  // 60-69Hz
     383, 360, 337, 314, 292, 271, 250, 230, 210, 191,  // 70-79Hz
     173, 154, 137, 119, 102,  86,  70,  54,  38,  23,  // 80-89Hz
       9,   9,   9,   9,   9,   9,   9,   9,   9,   9,  // 90-99Hz (VFP bottomed out!)
       9,   9,   9,   9,   9,   9,   9,   9,   9,   9,  // 100-109Hz
       9,   9,   9,   9,   9,   9,   9,   9,   9,   9,  // 110-119Hz
       9                                                 // 120Hz
};
```

**Clock Values (kHz):**
```cpp
unsigned int galileo_sdc_clock[] = {
    118400,121360,124320,127280,130240,133200,133200,133200,133200,133200,  // 40-49Hz
    133200,133200,133200,133200,133200,133200,133200,133200,133200,133200,  // 50-59Hz
    133200,133200,133200,133200,133200,133200,133200,133200,133200,133200,  // 60-69Hz
    133200,133200,133200,133200,133200,133200,133200,133200,133200,133200,  // 70-79Hz
    133200,133200,133200,133200,133200,133200,133200,133200,133200,133200,  // 80-89Hz
    133200,134680,136160,137640,139120,140600,142080,143560,145040,146520,  // 90-99Hz
    148000,149480,150960,152440,153920,155400,156880,158360,159840,161320,  // 100-109Hz
    162800,164280,165760,167240,168720,170200,171680,173160,174640,176120,  // 110-119Hz
    177160                                                                   // 120Hz
};
```

**Note from Nyaaori:** "Unlikely to function over ~100Hz due to bandwidth limitations"

### The C++ Code Logic

```cpp
void generate_fixed_mode(drmModeModeInfo *mode, const drmModeModeInfo *base, int vrefresh,
                         bool use_tuned_clocks, unsigned int use_vfp)
{
    *mode = *base;
    if (!vrefresh) vrefresh = 60;
    
    if (use_vfp) {
        unsigned int clock, vfp, vsync, vbp = 0;
        
        if (GALILEO_SDC_PID == use_vfp) {
            vfp = get_galileo_vfp(vrefresh, galileo_sdc_vfp, ARRAY_SIZE(galileo_sdc_vfp));
            clock = get_galileo_clock(vrefresh, galileo_sdc_clock, ARRAY_SIZE(galileo_sdc_clock));
            if (!vfp) { vrefresh = 60; vfp = 665; clock = 133200; }
            vsync = GALILEO_SDC_VSYNC;
            vbp = GALILEO_SDC_VBP;
        } else { // BOE Panel
            vfp = get_galileo_vfp(vrefresh, galileo_boe_vfp, ARRAY_SIZE(galileo_boe_vfp));
            clock = get_galileo_clock(vrefresh, galileo_boe_clock, ARRAY_SIZE(galileo_boe_clock));
            if (!vfp) { vrefresh = 60; vfp = 700; clock = 103580; }
            vsync = GALILEO_BOE_VSYNC;
            vbp = GALILEO_BOE_VBP;
        }
        
        mode->clock = clock;  // THIS IS THE KEY - Lua can't do this!
        mode->vsync_start = mode->vdisplay + vfp;
        mode->vsync_end = mode->vsync_start + vsync;
        mode->vtotal = mode->vsync_end + vbp;
    }
    // ...
}
```

### What This Means for Our Approach

1. **Lua scripts CANNOT set the clock value** - only VFP
2. **We need to compile a patched gamescope binary** to use these values
3. **The gamescope submodule we added** is the right approach
4. **We have all the timing data** - just need to apply it to current gamescope

---

## Updated Next Steps

1. **Apply Nyaaori's changes to our gamescope fork**
   - Modify `src/drm.cpp` to add extended refresh rate arrays
   - Modify `src/modegen.cpp` to add timing tables
   
2. **Compile gamescope for Steam Deck**
   - Cross-compile or compile on-device
   - Test on BOE panel first (more likely to work)
   
3. **For SDC panels** - may need to limit to 95Hz max based on user reports

4. **Create install script** that:
   - Backs up original gamescope binary
   - Copies patched binary
   - Handles readonly filesystem


Wayback Machine
https://git.spec.cat/Nyaaori/gamescope/commit/d39000aa9f53d1bd3c6fa993fdaeb6cc99ad4ae0
1 capture
18 May 2025
Apr	May	Jun
18	
2024	2025	2026
  
 About this capture
Logo

Explore Help
 Sign in
Nyaaori/gamescope
Watch 1
Star 0
Fork
You've already forked gamescope
0
 Code  Issues  Pull requests  Projects  Releases 1  Packages  Wiki  Activity
feat: add out-of-spec but mostly working display frequencies to steam deck
Browse source
...
This commit is contained in:
Nyaaori Nyaaori 2023-11-28 07:23:25 +01:00
parent 146da86c89
commit d39000aa9f
 Signed by: Nyaaori Nyaaori
 GPG key ID: E7819C3ED4D1F82E
 
 2 changed files with 84 additions and 20 deletions
 Show all changes  Ignore whitespace when comparing lines  Ignore changes in amount of whitespace  Ignore changes in whitespace at EOL
Show stats Download patch file Download diff file Expand all files Collapse all files

18
src/drm.cpp 
Unescape Escape View file

@ -82,17 +82,21 @@ static uint32_t steam_deck_display_rates[] =
{
40, 41, 42, 43, 44, 45, 46, 47, 48, 49,
50, 51, 52, 53, 54, 55, 56, 57, 58, 59,
60,
60, 61, 62, 63, 64, 65, 66, 67, 68, 69,
70
};
static uint32_t galileo_display_rates[] =
{
45,47,48,49,
50,51,53,55,56,59,
60,62,64,65,66,68,
72,73,76,77,78,
80,81,82,84,85,86,87,88,
90,
40, 41, 42, 43, 44, 45, 46, 47, 48, 49,
50, 51, 52, 53, 54, 55, 56, 57, 58, 59,
60, 61, 62, 63, 64, 65, 66, 67, 68, 69,
70, 71, 72, 73, 74, 75, 76, 77, 78, 79,
80, 81, 82, 83, 84, 85, 86, 87, 88, 89,
90, 91, 92, 93, 94, 95, 96, 97, 98, 99,
100,101,102,103,104,105,106,107,108,109,
110,111,112,113,114,115,116,117,118,119,
120,
};
static uint32_t get_conn_display_info_flags(struct drm_t *drm, struct connector *connector)



86
src/modegen.cpp 
Unescape Escape View file

@ -276,24 +276,65 @@ void generate_cvt_mode(drmModeModeInfo *mode, int hdisplay, int vdisplay,
// fps 45 48 51 55 60 65 72 80 90
// VFP 1320 1156 992 828 664 500 336 172 8
// SDC VFP values for 45 Hz to 90 Hz
// SDC VFP values for 40 Hz to 120 Hz, Untested
unsigned int galileo_sdc_vfp[] =
{
1321,1264,1209,1157,1106,1058,993,967,925,883,829,805,768,732,698,
665,632,601,571,542,501,486,459,433,408,383,360,337,314,292,271,250,230,210,191,
173,154,137,119,102,86,70,54,38,23,9
1321,1321,1321,1321,1321,1321,1264,1209,1157,1106,
1058,1012, 967, 925, 883, 844, 805, 768, 732, 698,
665, 632, 601, 571, 542, 513, 486, 459, 433, 408,
383, 360, 337, 314, 292, 271, 250, 230, 210, 191,
173, 154, 137, 119, 102, 86, 70, 54, 38, 23,
9, 9, 9, 9, 9, 9, 9, 9, 9, 9,
9, 9, 9, 9, 9, 9, 9, 9, 9, 9,
9, 9, 9, 9, 9, 9, 9, 9, 9, 9,
9
};
// BOE VFP values for 45 Hz to 90 Hz
// SDC pixel clock values for 40 to 120 Hz, Untested
// Unlikely to function over ~100Hz due to bandwidth limitations
unsigned int galileo_sdc_clock[] =
{
118400,121360,124320,127280,130240,133200,133200,133200,133200,133200,
133200,133200,133200,133200,133200,133200,133200,133200,133200,133200,
133200,133200,133200,133200,133200,133200,133200,133200,133200,133200,
133200,133200,133200,133200,133200,133200,133200,133200,133200,133200,
133200,133200,133200,133200,133200,133200,133200,133200,133200,133200,
133200,134680,136160,137640,139120,140600,142080,143560,145040,146520,
148000,149480,150960,152440,153920,155400,156880,158360,159840,161320,
162800,164280,165760,167240,168720,170200,171680,173160,174640,176120,
177160
};
// BOE VFP values for 40 Hz to 120 Hz
// BOE Vtotal must be a multiple of 4
unsigned int galileo_boe_vfp[] =
{
1320,1272,1216,1156,1112,1064,992,972,928,888,828,808,772,736,700,
664,636,604,572,544,500,488,460,436,408,384,360,336,316,292,272,252,228,212,192,
172,152,136,120,100,84,68,52,36,20,8
1320,1320,1216,1216,1216,1216,1320,1320,1216,1112,
1112, 992, 928, 992, 992, 828, 808, 700, 808, 664,
700, 664, 664, 604, 544, 544, 500, 436, 488, 436,
336, 316, 336, 316, 228, 336, 316, 252, 252, 212,
100, 84, 172, 136, 68, 36, 84, 52, 36, 68,
84, 36, 136, 52, 36, 52, 52, 8, 152, 68,
100, 8, 136, 36, 84, 8, 36, 8, 84, 8,
172, 68, 8, 8, 52, 36, 68, 8, 36, 100,
100
};
#define GALILEO_MIN_REFRESH 45
// BOE pixel clock values for 40 to 120 Hz
unsigned int galileo_boe_clock[] =
{
90340, 92590, 91100, 93270, 95440, 97610,103880,106140,104120,101910,
103990,100820, 99940,104780,106750,100990,101870, 98400,105500,100030,
103580,103420,105120,103570,101920,103510,102610,100490,105020,103490,
98980, 99180,101810,101970, 97780,106050,106160,103330,104670,103300,
96920, 97020,104410,103120, 99460, 98310,103010,101820,101780,105380,
107800,105250,114300,108840,108720,111180,112350,109860,123100,117220,
121150,114390,126730,119130,124570,118920,122600,121190,129360,123450,
140060,131430,126850,127980,133420,133010,137350,132510,136480,144170,
145380
};
#define GALILEO_MIN_REFRESH 40
#define GALILEO_SDC_PID 0x3003
#define GALILEO_SDC_VSYNC 1
#define GALILEO_SDC_VBP 22

@ -312,33 +353,52 @@ unsigned int get_galileo_vfp( int vrefresh, unsigned int * vfp_array, unsigned i
return 0;
}
unsigned int get_galileo_clock( int vrefresh, unsigned int * clock_array, unsigned int num_rates )
{
for ( unsigned int i = 0; i < num_rates; i++ ) {
if ( i+GALILEO_MIN_REFRESH == (unsigned int)vrefresh ) {
return clock_array[i];
}
}
return 0;
}
void generate_fixed_mode(drmModeModeInfo *mode, const drmModeModeInfo *base, int vrefresh,
bool use_tuned_clocks, unsigned int use_vfp )
bool use_tuned_clocks, unsigned int use_vfp )
{
*mode = *base;
if (!vrefresh)
vrefresh = 60;
if ( use_vfp ) {
unsigned int vfp, vsync, vbp = 0;
unsigned int clock, vfp, vsync, vbp = 0;
if (GALILEO_SDC_PID == use_vfp) {
vfp = get_galileo_vfp( vrefresh, galileo_sdc_vfp, ARRAY_SIZE(galileo_sdc_vfp) );
clock = get_galileo_clock( vrefresh, galileo_sdc_clock, ARRAY_SIZE(galileo_sdc_clock) );
// if we did not find a matching rate then we default to 60 Hz
if ( !vfp ) {
vrefresh = 60;
vfp = 665;
clock = 133200;
}
vsync = GALILEO_SDC_VSYNC;
vbp = GALILEO_SDC_VBP;
} else { // BOE Panel
vfp = get_galileo_vfp( vrefresh, galileo_boe_vfp, ARRAY_SIZE(galileo_boe_vfp) );
clock = get_galileo_clock( vrefresh, galileo_boe_clock, ARRAY_SIZE(galileo_boe_clock) );
// if we did not find a matching rate then we default to 60 Hz
if ( !vfp ) {
vrefresh = 60;
vfp = 664;
vfp = 700;
clock = 103580;
}
vsync = GALILEO_BOE_VSYNC;
vbp = GALILEO_BOE_VBP;
}
}
mode->clock = clock;
mode->vsync_start = mode->vdisplay + vfp;
mode->vsync_end = mode->vsync_start + vsync;
mode->vtotal = mode->vsync_end + vbp;


Reference in a new issue
Repository
Nyaaori/gamescope
Title 
Body 
Create issue
Powered by Forgejo Page: 123ms Template: 77ms
 English
Bahasa Indonesia Deutsch English Español Esperanto Filipino Français Italiano Latviešu Magyar nyelv Nederlands Plattdüütsch Polski Português de Portugal Português do Brasil Slovenščina Suomi Svenska Türkçe Čeština Ελληνικά Български Русский Українська فارسی 日本語 简体中文 繁體中文（台灣） 繁體中文（香港） 한국어
Licenses API