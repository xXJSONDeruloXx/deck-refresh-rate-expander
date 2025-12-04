-- Steam Deck OLED Refresh Rate Expander
-- Extends refresh rates beyond stock 90Hz
--
-- SDC (Samsung) panels: Up to 96Hz (bandwidth limited)
-- BOE panels: Up to 120Hz (theoretical, needs testing)
--
-- Install to: ~/.config/gamescope/scripts/displays/
-- Then reboot your Steam Deck
--
-- Based on research from Nyaaori's original 120Hz mod

local steamdeck_oled_hdr = {
    supported = true,
    force_enabled = true,
    eotf = gamescope.eotf.gamma22,
    max_content_light_level = 1000,
    max_frame_average_luminance = 800,
    min_content_light_level = 0
}

-- SDC panel: Extended to 96Hz (conservative limit due to bandwidth)
local sdc_refresh_rates = {
    45, 47, 48, 49,
    50, 51, 53, 55, 56, 59,
    60, 62, 64, 65, 66, 68,
    72, 73, 76, 77, 78,
    80, 81, 82, 84, 85, 86, 87, 88,
    90, 92, 94, 96
}

-- BOE panel: Extended to 120Hz
local boe_refresh_rates = {
    45, 47, 48, 49,
    50, 51, 53, 55, 56, 59,
    60, 62, 64, 65, 66, 68,
    72, 73, 76, 77, 78,
    80, 81, 82, 84, 85, 86, 87, 88,
    90, 92, 94, 96, 98,
    100, 102, 104, 106, 108, 110,
    112, 114, 116, 118, 120
}

-- SDC (Samsung) Panel Configuration
gamescope.config.known_displays.steamdeck_oled_sdc_expanded = {
    pretty_name = "Steam Deck OLED (SDC) Expanded",
    hdr = steamdeck_oled_hdr,
    dynamic_refresh_rates = sdc_refresh_rates,
    dynamic_modegen = function(base_mode, refresh)
        -- Stock VFP table (45-90Hz)
        local vfps = {
            1321, 1264, 1209, 1157, 1106,
            1058, 993,  967,  925,  883,  829,  805,  768,  732,  698,
            665,  632,  601,  571,  542,  501,  486,  459,  433,  408,
            383,  360,  337,  314,  292,  271,  250,  230,  210,  191,
            173,  154,  137,  119,  102,  86,   70,   54,   38,   23,
            9
        }
        
        local mode = base_mode
        
        -- Extended rates (>90Hz): Use minimum VFP and scale clock
        if refresh > 90 then
            gamescope.modegen.adjust_front_porch(mode, 9)
            mode.clock = gamescope.modegen.calc_max_clock(mode, refresh)
            mode.vrefresh = refresh
            return mode
        end
        
        -- Stock behavior for 45-90Hz
        local vfp = vfps[refresh - 44]
        if vfp == nil then
            return base_mode
        end

        gamescope.modegen.adjust_front_porch(mode, vfp)
        mode.vrefresh = gamescope.modegen.calc_vrefresh(mode)
        return mode
    end,
    matches = function(display)
        if display.vendor == "VLV" and display.product == 0x3003 then
            return 5200  -- Higher priority than stock (5100)
        end
        return -1
    end
}

-- BOE Panel Configuration
gamescope.config.known_displays.steamdeck_oled_boe_expanded = {
    pretty_name = "Steam Deck OLED (BOE) Expanded",
    hdr = steamdeck_oled_hdr,
    dynamic_refresh_rates = boe_refresh_rates,
    dynamic_modegen = function(base_mode, refresh)
        -- Stock VFP table (45-90Hz)
        local vfps = {
            1320, 1272, 1216, 1156, 1112,
            1064, 992,  972,  928,  888,  828,  808,  772,  736,  700,
            664,  636,  604,  572,  544,  500,  488,  460,  436,  408,
            384,  360,  336,  316,  292,  272,  252,  228,  212,  192,
            172,  152,  136,  120,  100,  84,   68,   52,   36,   20,
            8
        }
        
        local mode = base_mode
        
        -- Extended rates (>90Hz): Use minimum VFP and scale clock
        if refresh > 90 then
            gamescope.modegen.adjust_front_porch(mode, 8)
            mode.clock = gamescope.modegen.calc_max_clock(mode, refresh)
            mode.vrefresh = refresh
            return mode
        end
        
        -- Stock behavior for 45-90Hz
        local vfp = vfps[refresh - 44]
        if vfp == nil then
            return base_mode
        end

        gamescope.modegen.adjust_front_porch(mode, vfp)
        mode.vrefresh = gamescope.modegen.calc_vrefresh(mode)
        return mode
    end,
    matches = function(display)
        if display.vendor == "VLV" and display.product == 0x3004 then
            return 5200  -- Higher priority than stock (5100)
        end
        return -1
    end
}
