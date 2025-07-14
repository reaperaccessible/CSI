-- @description Speak name of selected FX on Master Track
-- @version 1.0
-- @author Lee JULIEN for ReaperAccessible
-- @provides [main=main] .
-- @changelog
--   # 2025-07-13 - Adding CSI scripts to the ReaperAccessible repository


-- 1) Get the Master track
local tr = reaper.GetMasterTrack(0)

-- 2) Count how many FX are on Master
local nbFX = reaper.TrackFX_GetCount(tr)

-- 3) If no FX at all, nothing to select
if nbFX < 1 then
    reaper.osara_outputMessage("No FX selected on Master track.")
    return
end

-- 4) Retrieve the track state chunk to find LASTSEL index
local _, chunk = reaper.GetTrackStateChunk(tr, "", false)
local idxSelFx = tonumber(string.match(chunk, "LASTSEL (%d+)"))

-- 5) If no LASTSEL, no FX was selected
if not idxSelFx then
    reaper.osara_outputMessage("No FX selected on Master track.")
    return
end

-- 6) Get the FX name
local retval, fx_name = reaper.TrackFX_GetFXName(tr, idxSelFx, "")

-- 7) Strip common prefixes and parenthetical vendor info
fx_name = fx_name
  :gsub("^DX: ", "")
  :gsub("^DXi: ", "")
  :gsub("^VST3?i?: ", "")
  :gsub("^JS: ", "")
  :gsub("^ReWire: ", "")
  :gsub(" %(.-%)", "")

-- 8) Check bypass status
local enabled = reaper.TrackFX_GetEnabled(tr, idxSelFx)
local status = enabled and "active" or "bypassed"

-- 9) Speak the index (1-based), name and status
reaper.osara_outputMessage((idxSelFx + 1) .. " " .. fx_name .. " " .. status)