-- @description Delete selected FX on Master Track
-- @version 1.0
-- @author Lee JULIEN for ReaperAccessible
-- @provides [main=main] .
-- @changelog
--   # 2025-07-13 - Adding CSI scripts to the ReaperAccessible repository


-- 1) Get the Master track
local tr = reaper.GetMasterTrack(0)

-- 2) Count how many FX are on the Master
local nbFX = reaper.TrackFX_GetCount(tr)
if nbFX < 1 then
    reaper.osara_outputMessage("No FX selected on Master track.")
    return
end

-- 3) Get the track state chunk and find the LASTSEL index
local _, chunk = reaper.GetTrackStateChunk(tr, "", false)
local idxSelFx = tonumber(string.match(chunk, "LASTSEL (%d+)"))
if not idxSelFx then
    reaper.osara_outputMessage("No FX selected on Master track.")
    return
end

-- 4) Retrieve the FX name
local _, fx_name = reaper.TrackFX_GetFXName(tr, idxSelFx, "")

-- 5) Strip common prefixes and vendor tags
fx_name = fx_name
  :gsub("^DX: ", "")
  :gsub("^DXi: ", "")
  :gsub("^VST3?i?: ", "")
  :gsub("^JS: ", "")
  :gsub("^ReWire: ", "")
  :gsub(" %(.-%)", "")

-- 6) Delete the selected FX
reaper.TrackFX_Delete(tr, idxSelFx)

-- 7) Announce deletion
reaper.osara_outputMessage("FX " .. fx_name .. " deleted")