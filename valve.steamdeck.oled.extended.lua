-- Steam Deck OLED Extended Refresh Rate Script
-- Based on Nyaaori's timing research from:
-- https://web.archive.org/web/20250518/https://git.spec.cat/Nyaaori/gamescope/commit/d39000aa9f53d1bd3c6fa993fdaeb6cc99ad4ae0
--
-- Install to: ~/.config/gamescope/scripts/displays/
-- 
-- WARNING: SDC (Samsung) panels limited to ~95Hz due to bandwidth constraints
-- BOE panels can reach 120Hz with proper timings

local steamdeck_oled_hdr = {
    supported = true,
    force_enabled = true,
    eotf = gamescope.eotf.gamma22,
    max_content_light_level = 1000,
    max_frame_average_luminance = 800,
    min_content_light_level = 0
}

-- Extended refresh rates (same for both panels in UI, but SDC will fail >~95Hz)
local steamdeck_oled_refresh_rates_extended = {
    45, 47, 48, 49,
    50, 51, 53, 55, 56, 59,
    60, 62, 64, 65, 66, 68,
    72, 73, 76, 77, 78,
    80, 81, 82, 84, 85, 86, 87, 88,
    90, 92, 94, 96, 98,
    100, 102, 104, 106, 108, 110,
    112, 114, 116, 118, 120
}

-- Nyaaori's hand-tuned VFP values for BOE panels (40-120Hz)
-- Index 1 = 40Hz, Index 81 = 120Hz
local boe_vfp_table = {
    1320,1320,1216,1216,1216,1216,1320,1320,1216,1112,  -- 40-49Hz
    1112, 992, 928, 992, 992, 828, 808, 700, 808, 664,  -- 50-59Hz
     700, 664, 664, 604, 544, 544, 500, 436, 488, 436,  -- 60-69Hz
     336, 316, 336, 316, 228, 336, 316, 252, 252, 212,  -- 70-79Hz
     100,  84, 172, 136,  68,  36,  84,  52,  36,  68,  -- 80-89Hz
      84,  36, 136,  52,  36,  52,  52,   8, 152,  68,  -- 90-99Hz
     100,   8, 136,  36,  84,   8,  36,   8,  84,   8,  -- 100-109Hz
     172,  68,   8,   8,  52,  36,  68,   8,  36, 100,  -- 110-119Hz
     100                                                 -- 120Hz
}

-- Nyaaori's hand-tuned clock values for BOE panels (40-120Hz) in kHz
local boe_clock_table = {
     90340, 92590, 91100, 93270, 95440, 97610,103880,106140,104120,101910,  -- 40-49Hz
    103990,100820, 99940,104780,106750,100990,101870, 98400,105500,100030,  -- 50-59Hz
    103580,103420,105120,103570,101920,103510,102610,100490,105020,103490,  -- 60-69Hz
     98980, 99180,101810,101970, 97780,106050,106160,103330,104670,103300,  -- 70-79Hz
     96920, 97020,104410,103120, 99460, 98310,103010,101820,101780,105380,  -- 80-89Hz
    107800,105250,114300,108840,108720,111180,112350,109860,123100,117220,  -- 90-99Hz
    121150,114390,126730,119130,124570,118920,122600,121190,129360,123450,  -- 100-109Hz
    140060,131430,126850,127980,133420,133010,137350,132510,136480,144170,  -- 110-119Hz
    145380                                                                   -- 120Hz
}

-- Nyaaori's SDC VFP values (40-120Hz) - UNTESTED, may not work well
local sdc_vfp_table = {
    1321,1321,1321,1321,1321,1321,1264,1209,1157,1106,  -- 40-49Hz
    1058,1012, 967, 925, 883, 844, 805, 768, 732, 698,  -- 50-59Hz
     665, 632, 601, 571, 542, 513, 486, 459, 433, 408,  -- 60-69Hz
     383, 360, 337, 314, 292, 271, 250, 230, 210, 191,  -- 70-79Hz
     173, 154, 137, 119, 102,  86,  70,  54,  38,  23,  -- 80-89Hz
       9,   9,   9,   9,   9,   9,   9,   9,   9,   9,  -- 90-99Hz (VFP bottomed out!)
       9,   9,   9,   9,   9,   9,   9,   9,   9,   9,  -- 100-109Hz
       9,   9,   9,   9,   9,   9,   9,   9,   9,   9,  -- 110-119Hz
       9                                                 -- 120Hz
}

-- Nyaaori's SDC clock values (40-120Hz) in kHz - unlikely to work >100Hz
local sdc_clock_table = {
    118400,121360,124320,127280,130240,133200,133200,133200,133200,133200,  -- 40-49Hz
    133200,133200,133200,133200,133200,133200,133200,133200,133200,133200,  -- 50-59Hz
    133200,133200,133200,133200,133200,133200,133200,133200,133200,133200,  -- 60-69Hz
    133200,133200,133200,133200,133200,133200,133200,133200,133200,133200,  -- 70-79Hz
    133200,133200,133200,133200,133200,133200,133200,133200,133200,133200,  -- 80-89Hz
    133200,134680,136160,137640,139120,140600,142080,143560,145040,146520,  -- 90-99Hz
    148000,149480,150960,152440,153920,155400,156880,158360,159840,161320,  -- 100-109Hz
    162800,164280,165760,167240,168720,170200,171680,173160,174640,176120,  -- 110-119Hz
    177160                                                                   -- 120Hz
}

-- Helper function to get table index from refresh rate (40-120Hz maps to index 1-81)
local function get_timing_index(refresh)
    return refresh - 39  -- 40Hz = index 1, 120Hz = index 81
end

-- BOE panel extended configuration
gamescope.config.known_displays.steamdeck_oled_boe_extended = {
    pretty_name = "Steam Deck OLED (BOE) Extended",
    hdr = steamdeck_oled_hdr,
    dynamic_refresh_rates = steamdeck_oled_refresh_rates_extended,
    dynamic_modegen = function(base_mode, refresh)
        debug("Generating extended mode for "..refresh.."Hz for Steam Deck OLED (BOE)")
        
        local mode = base_mode
        local idx = get_timing_index(refresh)
        
        -- Check if we have timing data for this refresh rate
        if idx < 1 or idx > #boe_vfp_table then
            warn("No timing data for "..refresh.."Hz on BOE panel, using stock")
            -- Fall back to stock behavior for unsupported rates
            local stock_vfps = {
                1320, 1272, 1216, 1156, 1112,
                1064, 992,  972,  928,  888,  828,  808,  772,  736,  700,
                664,  636,  604,  572,  544,  500,  488,  460,  436,  408,
                384,  360,  336,  316,  292,  272,  252,  228,  212,  192,
                172,  152,  136,  120,  100,  84,   68,   52,   36,   20,
                8
            }
            local stock_idx = refresh - 44  -- Stock table starts at 45Hz
            if stock_idx >= 1 and stock_idx <= #stock_vfps then
                gamescope.modegen.adjust_front_porch(mode, stock_vfps[stock_idx])
                mode.vrefresh = gamescope.modegen.calc_vrefresh(mode)
            end
            return mode
        end
        
        local vfp = boe_vfp_table[idx]
        local clock = boe_clock_table[idx]
        
        -- Apply Nyaaori's hand-tuned timings
        -- BOE requires VFP to be multiple of 4
        local vsync = 1  -- BOE VSYNC
        local vbp = 22   -- BOE VBP
        
        mode.clock = clock
        mode.vsync_start = mode.vdisplay + vfp
        mode.vsync_end = mode.vsync_start + vsync
        mode.vtotal = mode.vsync_end + vbp
        mode.vrefresh = refresh
        
        debug("BOE extended: "..refresh.."Hz, vfp="..vfp..", clock="..clock)
        return mode
    end,
    matches = function(display)
        if display.vendor == "VLV" and display.product == 0x3004 then
            debug("[steamdeck_oled_boe_extended] Matched VLV and product 0x3004")
            -- Higher priority than stock (5100)
            return 5200
        end
        return -1
    end
}
debug("Registered Steam Deck OLED (BOE) Extended as a known display")

-- SDC panel extended configuration - WARNING: >95Hz likely won't work!
gamescope.config.known_displays.steamdeck_oled_sdc_extended = {
    pretty_name = "Steam Deck OLED (SDC) Extended",
    hdr = steamdeck_oled_hdr,
    dynamic_refresh_rates = steamdeck_oled_refresh_rates_extended,
    dynamic_modegen = function(base_mode, refresh)
        debug("Generating extended mode for "..refresh.."Hz for Steam Deck OLED (SDC)")
        
        -- WARN about SDC limitations
        if refresh > 95 then
            warn("SDC panel bandwidth limited - "..refresh.."Hz may cause artifacts!")
        end
        
        local mode = base_mode
        local idx = get_timing_index(refresh)
        
        -- Check if we have timing data for this refresh rate
        if idx < 1 or idx > #sdc_vfp_table then
            warn("No timing data for "..refresh.."Hz on SDC panel, using stock")
            -- Fall back to stock behavior
            local stock_vfps = {
                1321, 1264, 1209, 1157, 1106,
                1058, 993,  967,  925,  883,  829,  805,  768,  732,  698,
                665,  632,  601,  571,  542,  501,  486,  459,  433,  408,
                383,  360,  337,  314,  292,  271,  250,  230,  210,  191,
                173,  154,  137,  119,  102,  86,   70,   54,   38,   23,
                9
            }
            local stock_idx = refresh - 44
            if stock_idx >= 1 and stock_idx <= #stock_vfps then
                gamescope.modegen.adjust_front_porch(mode, stock_vfps[stock_idx])
                mode.vrefresh = gamescope.modegen.calc_vrefresh(mode)
            end
            return mode
        end
        
        local vfp = sdc_vfp_table[idx]
        local clock = sdc_clock_table[idx]
        
        -- Apply Nyaaori's timings
        local vsync = 1   -- SDC VSYNC
        local vbp = 22    -- SDC VBP
        
        mode.clock = clock
        mode.vsync_start = mode.vdisplay + vfp
        mode.vsync_end = mode.vsync_start + vsync
        mode.vtotal = mode.vsync_end + vbp
        mode.vrefresh = refresh
        
        debug("SDC extended: "..refresh.."Hz, vfp="..vfp..", clock="..clock)
        return mode
    end,
    matches = function(display)
        if display.vendor == "VLV" and display.product == 0x3003 then
            debug("[steamdeck_oled_sdc_extended] Matched VLV and product 0x3003")
            -- Higher priority than stock (5100)
            return 5200
        end
        return -1
    end
}
debug("Registered Steam Deck OLED (SDC) Extended as a known display")
