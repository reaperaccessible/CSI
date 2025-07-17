-- @description Speak name of selected tracks
-- @version 1.4
-- @author Lee Julien for ReaperAccessible
-- @provides [main=main] .
-- @changelog
--   # 2024-09-18 - Adding log
--   # 2025-07-16 - The script now announces all selected tracks, including the master track


-- OSARA wrapper
local function osara_msg(text)
    if reaper.osara_outputMessage then
        reaper.osara_outputMessage(text)
    else
        reaper.ShowConsoleMsg("OSARA missing: " .. text)
    end
end

-- Count normal selected tracks
local selCount = reaper.CountSelectedTracks(0)
-- Check if master track is selected
local master = reaper.GetMasterTrack(0)
local masterSel = reaper.GetMediaTrackInfo_Value(master, "I_SELECTED") == 1

-- If no selection at all, announce and exit
if selCount == 0 and not masterSel then
    osara_msg("No Track Selected")
    return
end

-- Build list of labels
local names = {}
if masterSel then
    table.insert(names, "Master")
end

for i = 0, selCount - 1 do
    local tr = reaper.GetSelectedTrack(0, i)
    local _, name = reaper.GetTrackName(tr, "")
    if name == "" then
        local num = math.floor(reaper.GetMediaTrackInfo_Value(tr, "IP_TRACKNUMBER") + 0.5)
        name = tostring(num)
    end
    table.insert(names, name)
end

-- Concatenate, append phrase, and announce
local msg = table.concat(names, ", ") .. " is selected"
osara_msg(msg)