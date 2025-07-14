-- @description Move selected FX one position down
-- @version 1.1
-- @author Lee JULIEN for ReaperAccessible
-- @provides [main=main] .
-- @changelog
--   # 2025-05-18 - Adding CSI scripts to the ReaperAccessible repository


-- 1) Ensure at least one track is selected
local selCount = reaper.CountSelectedTracks(0)
if selCount == 0 then
    reaper.osara_outputMessage("No FX selected")
    return
end

-- 2) Get the first selected track
local tr = reaper.GetSelectedTrack2(0, 0, true)

-- 3) Count FX on that track
local fxCount = reaper.TrackFX_GetCount(tr)
if fxCount < 1 then
    reaper.osara_outputMessage("No FX selected")
    return
end

-- 4) Read track chunk to find LASTSEL index
local _, chunk = reaper.GetTrackStateChunk(tr, "", false)
local idx = tonumber(string.match(chunk, "LASTSEL (%d+)"))
if not idx then
    reaper.osara_outputMessage("No FX selected")
    return
end

-- 5) Compute target position (one down, capped at bottom)
local newIdx = (idx < fxCount - 1) and (idx + 1) or idx

-- 6) Retrieve FX name for announcement (cleanup prefixes)
local _, name = reaper.TrackFX_GetFXName(tr, idx, "")
name = name
  :gsub("^DX: ", "")
  :gsub("^DXi: ", "")
  :gsub("^VST3?i?: ", "")
  :gsub("^JS: ", "")
  :gsub("^ReWire: ", "")
  :gsub(" %(.-%)", "")

-- 7) If already at bottom, announce and exit
if newIdx == idx then
    reaper.osara_outputMessage("FX " .. name .. " is already at bottom")
    return
end

-- 8) Move the FX:
--    prefer native API if available, else fallback to SWS action without altering track selection
if type(reaper.TrackFX_CopyToTrack) == "function" then
    -- native move: copy with isMove=true
    reaper.TrackFX_CopyToTrack(tr, idx, tr, newIdx, true)
else
    local cmd = reaper.NamedCommandLookup("_S&M_MOVE_FX_DOWN")
    if cmd == 0 then
        reaper.osara_outputMessage("SWS move-FX-down action not found.")
        return
    end

    -- save current track selection
    local saved = {}
    for i = 0, selCount - 1 do saved[#saved+1] = reaper.GetSelectedTrack(0, i) end

    -- execute move on target track only
    reaper.Main_OnCommand(40297, 0)      -- unselect all tracks
    reaper.SetTrackSelected(tr, true)    -- select only target
    reaper.Main_OnCommand(cmd, 0)        -- move FX down
    -- restore original selection
    reaper.Main_OnCommand(40297, 0)
    for _, t in ipairs(saved) do reaper.SetTrackSelected(t, true) end
end

-- 9) Announce result
reaper.osara_outputMessage("FX " .. name .. " moved down")
