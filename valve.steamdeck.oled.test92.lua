-- Steam Deck OLED Test Script - Add 92Hz only
-- Minimal changes from stock to test if extended rates work at all

local steamdeck_oled_hdr = {
    supported = true,
    force_enabled = true,
    eotf = gamescope.eotf.gamma22,
    max_content_light_level = 1000,
    max_frame_average_luminance = 800,
    min_content_light_level = 0
}

-- Stock rates + 92Hz
local steamdeck_oled_refresh_rates_test = {
    45, 47, 48, 49,
    50, 51, 53, 55, 56, 59,
    60, 62, 64, 65, 66, 68,
    72, 73, 76, 77, 78,
    80, 81, 82, 84, 85, 86, 87, 88,
    90, 92  -- Added 92Hz
}

-- SDC panel with 92Hz test
gamescope.config.known_displays.steamdeck_oled_sdc_test = {
    pretty_name = "Steam Deck OLED (SDC) Test",
    hdr = steamdeck_oled_hdr,
    dynamic_refresh_rates = steamdeck_oled_refresh_rates_test,
    dynamic_modegen = function(base_mode, refresh)
        debug("TEST: Generating mode "..refresh.."Hz for Steam Deck OLED (SDC)")
        
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
        
        -- For 92Hz, try using minimum VFP (9) like stock 90Hz
        -- and let calc_max_clock figure out the clock
        if refresh == 92 then
            debug("TEST: Trying 92Hz with VFP=9 and calculated clock")
            gamescope.modegen.adjust_front_porch(mode, 9)
            mode.clock = gamescope.modegen.calc_max_clock(mode, 92)
            mode.vrefresh = 92
            debug("TEST: 92Hz clock="..mode.clock)
            return mode
        end
        
        -- Stock behavior for 45-90Hz
        local vfp = vfps[refresh - 44]  -- 45Hz = index 1
        if vfp == nil then
            warn("TEST: No VFP for "..refresh.."Hz")
            return base_mode
        end

        gamescope.modegen.adjust_front_porch(mode, vfp)
        mode.vrefresh = gamescope.modegen.calc_vrefresh(mode)

        return mode
    end,
    matches = function(display)
        if display.vendor == "VLV" and display.product == 0x3003 then
            debug("[steamdeck_oled_sdc_test] Matched SDC panel")
            return 5200  -- Higher priority than stock
        end
        return -1
    end
}
debug("TEST: Registered Steam Deck OLED (SDC) Test config")

-- BOE panel with 92Hz test  
gamescope.config.known_displays.steamdeck_oled_boe_test = {
    pretty_name = "Steam Deck OLED (BOE) Test",
    hdr = steamdeck_oled_hdr,
    dynamic_refresh_rates = steamdeck_oled_refresh_rates_test,
    dynamic_modegen = function(base_mode, refresh)
        debug("TEST: Generating mode "..refresh.."Hz for Steam Deck OLED (BOE)")
        
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
        
        -- For 92Hz, try using minimum VFP (8) and calculated clock
        if refresh == 92 then
            debug("TEST: Trying 92Hz with VFP=8 and calculated clock")
            gamescope.modegen.adjust_front_porch(mode, 8)
            mode.clock = gamescope.modegen.calc_max_clock(mode, 92)
            mode.vrefresh = 92
            debug("TEST: 92Hz clock="..mode.clock)
            return mode
        end
        
        -- Stock behavior for 45-90Hz
        local vfp = vfps[refresh - 44]  -- 45Hz = index 1
        if vfp == nil then
            warn("TEST: No VFP for "..refresh.."Hz")
            return base_mode
        end

        gamescope.modegen.adjust_front_porch(mode, vfp)
        mode.vrefresh = gamescope.modegen.calc_vrefresh(mode)

        return mode
    end,
    matches = function(display)
        if display.vendor == "VLV" and display.product == 0x3004 then
            debug("[steamdeck_oled_boe_test] Matched BOE panel")
            return 5200  -- Higher priority than stock
        end
        return -1
    end
}
debug("TEST: Registered Steam Deck OLED (BOE) Test config")
