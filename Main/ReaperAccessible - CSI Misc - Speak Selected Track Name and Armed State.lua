-- @description Speak Selected Track Name and Armed State
-- @version 1.0
-- @author Lee JULIEN for ReaperAccessible
-- @provides [main=main] .
-- @changelog
--   # 2025-07-15 - New script


-- OSARA wrapper
local function osara_msg(text)
    if reaper.osara_outputMessage then
        reaper.osara_outputMessage(text)
    else
        reaper.ShowConsoleMsg("OSARA missing: " .. text)
    end
end

-- Get first selected track
local track = reaper.GetSelectedTrack(0, 0)
if not track then
    osara_msg("No track is selected")
    return
end

-- Track number (1-based integer)
local tn = reaper.GetMediaTrackInfo_Value(track, "IP_TRACKNUMBER")
local track_index = math.floor(tn + 0.5)

-- Get track name (returns default "Track X" if no custom name)
local _, track_name = reaper.GetTrackName(track, "")

-- Record‑arm state
local rec_arm = reaper.GetMediaTrackInfo_Value(track, "I_RECARM")
local arm_text = (rec_arm == 1) and "Armed" or "Unarmed"

-- Build base message
local default_name = "Track " .. track_index
local msg = default_name .. ":"

-- Append custom name if present
if track_name ~= default_name then
    msg = msg .. " " .. track_name .. "."
end

-- Always append armed state
msg = msg .. " " .. arm_text

-- Announce via OSARA
osara_msg(msg)