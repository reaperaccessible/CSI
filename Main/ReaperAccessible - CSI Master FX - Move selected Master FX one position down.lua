-- @description Move selected Master FX one position down
-- @version 1.0
-- @author Lee JULIEN for ReaperAccessible
-- @provides [main=main] .
-- @changelog
--   # 2025-07-13 - Adding CSI scripts to the ReaperAccessible repository


-- @description Move selected FX one position down on Master track (no visible track-selection change)
-- @version 1.2
-- @author ChatGPT
-- @changelog
--   # 2025-07-13 - Avoid any track-selection change by using native move or CopyToTrack fallback

-- 1) Get the Master track
local tr = reaper.GetMasterTrack(0)

-- 2) Count how many FX are on the Master track
local nbFX = reaper.TrackFX_GetCount(tr)
if nbFX < 1 then
    reaper.osara_outputMessage("No FX selected on Master track.")
    return
end

-- 3) Retrieve the track state chunk and find the LASTSEL index
local _, chunk = reaper.GetTrackStateChunk(tr, "", false)
local idxSelFx = tonumber(string.match(chunk, "LASTSEL (%d+)"))
if not idxSelFx then
    reaper.osara_outputMessage("No FX selected on Master track.")
    return
end

-- 4) Compute the new position (one down, but not past the end)
local newIdx = idxSelFx < nbFX - 1 and (idxSelFx + 1) or idxSelFx

-- 5) If already at bottom, announce and exit
local _, currentName = reaper.TrackFX_GetFXName(tr, idxSelFx, "")
currentName = currentName:gsub("^DX: ", "")
                          :gsub("^DXi: ", "")
                          :gsub("^VST3?i?: ", "")
                          :gsub("^JS: ", "")
                          :gsub("^ReWire: ", "")
                          :gsub(" %(.-%)", "")
if newIdx == idxSelFx then
    reaper.osara_outputMessage("FX " .. currentName .. " is already at bottom")
    return
end

-- 6) Try native API move if available
if type(reaper.TrackFX_CopyToTrack) == "function" then
    -- move-in-place via CopyToTrack (isMove = true)
    reaper.TrackFX_CopyToTrack(tr, idxSelFx, tr, newIdx, true)
else
    -- 7) Fallback: temporarily swap selection to run SWS action without leaving user-selected tracks
    local cmd_move = reaper.NamedCommandLookup("_S&M_MOVE_FX_DOWN")
    if cmd_move == 0 then
        reaper.osara_outputMessage("SWS move-FX-down action not found.")
        return
    end

    -- save current selection
    local saved = {}
    for i = 0, reaper.CountSelectedTracks(0)-1 do
        saved[#saved+1] = reaper.GetSelectedTrack(0, i)
    end

    -- deselect all, select Master, move FX, then restore
    reaper.Main_OnCommand(40297, 0)           -- Unselect all tracks
    reaper.SetTrackSelected(tr, true)         -- Select Master
    reaper.Main_OnCommand(cmd_move, 0)        -- Move FX down
    reaper.Main_OnCommand(40297, 0)           -- Unselect all again
    for _, t in ipairs(saved) do
        reaper.SetTrackSelected(t, true)
    end
end

-- 8) Retrieve and clean up the FX name at its new position
local _, fx_name = reaper.TrackFX_GetFXName(tr, newIdx, "")
fx_name = fx_name:gsub("^DX: ", "")
               :gsub("^DXi: ", "")
               :gsub("^VST3?i?: ", "")
               :gsub("^JS: ", "")
               :gsub("^ReWire: ", "")
               :gsub(" %(.-%)", "")

-- 9) Announce the result
reaper.osara_outputMessage("FX " .. fx_name .. " moved down")