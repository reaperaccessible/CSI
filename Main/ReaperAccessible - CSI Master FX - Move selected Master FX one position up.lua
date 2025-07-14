-- @description Move selected Master FX one position up
-- @version 1.1
-- @author Lee JULIEN for ReaperAccessible
-- @provides [main=main] .
-- @changelog
--   # 2025-07-13 - Adding CSI scripts to the ReaperAccessible repository


-- 1) Get the Master track
local tr = reaper.GetMasterTrack(0)

-- 2) Count FX on the Master track
local fxCount = reaper.TrackFX_GetCount(tr)
if fxCount < 1 then
    reaper.osara_outputMessage("No FX selected on Master track.")
    return
end

-- 3) Read track state chunk to find LASTSEL index
local _, chunk = reaper.GetTrackStateChunk(tr, "", false)
local idx = tonumber(string.match(chunk, "LASTSEL (%d+)"))
if not idx then
    reaper.osara_outputMessage("No FX selected on Master track.")
    return
end

-- 4) Compute target position (one up, but not above 0)
local newIdx = idx > 0 and (idx - 1) or idx

-- 5) Retrieve FX name for announcement (cleanup prefixes)
local _, name = reaper.TrackFX_GetFXName(tr, idx, "")
name = name
  :gsub("^DX: ", "")
  :gsub("^DXi: ", "")
  :gsub("^VST3?i?: ", "")
  :gsub("^JS: ", "")
  :gsub("^ReWire: ", "")
  :gsub(" %(.-%)", "")

-- 6) If already at top, announce and exit
if newIdx == idx then
    reaper.osara_outputMessage("FX " .. name .. " is already at top")
    return
end

-- 7) Move the FX:
--    prefer native API if available, else fallback to SWS action without altering track selection
if type(reaper.TrackFX_CopyToTrack) == "function" then
    -- native move: copy with isMove=true
    reaper.TrackFX_CopyToTrack(tr, idx, tr, newIdx, true)
else
    local cmd = reaper.NamedCommandLookup("_S&M_MOVE_FX_UP")
    if cmd == 0 then
        reaper.osara_outputMessage("SWS move-FX-up action not found.")
        return
    end

    -- save current track selection
    local saved = {}
    for i = 0, reaper.CountSelectedTracks(0)-1 do
        saved[#saved+1] = reaper.GetSelectedTrack(0, i)
    end

    -- execute move on Master only
    reaper.Main_OnCommand(40297, 0)      -- unselect all tracks
    reaper.SetTrackSelected(tr, true)    -- select Master
    reaper.Main_OnCommand(cmd, 0)        -- move FX up
    -- restore original selection
    reaper.Main_OnCommand(40297, 0)
    for _, t in ipairs(saved) do
        reaper.SetTrackSelected(t, true)
    end
end

-- 8) Announce result
reaper.osara_outputMessage("FX " .. name .. " moved up")