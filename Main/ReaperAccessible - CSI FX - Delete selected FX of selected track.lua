-- @description Delete selected FX of selected track
-- @version 1.0
-- @author Ludovic SANSONE for ReaperAccessible
-- @provides [main=main] .
-- @changelog
--   # 2025-05-18 - Adding CSI scripts to the ReaperAccessible repository


local countSelTrack = reaper.CountSelectedTracks(0);

if countSelTrack == 0 then
    reaper.osara_outputMessage("No FX selected")
    return
end

-- On récupère la piste sélectionnée
local tr = reaper.GetSelectedTrack2(0, 0, 1)

-- On compte le nombre d'effet insérés sur la piste
local nbFX = reaper.TrackFX_GetCount(tr)

-- Si aucun effet n'est inséré, on sort du programme
if nbFX < 1 then
    reaper.osara_outputMessage("No FX selected")
    return
-- Si non on exécute le code
else
    local retval, str = reaper.GetTrackStateChunk(tr, "", false);

    local idxSelFx = tonumber(string.match(str, "LASTSEL (%d+)"))

    local b, fx_name = reaper.TrackFX_GetFXName(tr, idxSelFx, "")

    local commandID = reaper.NamedCommandLookup("_S&M_REMOVE_FX")
    reaper.Main_OnCommand(commandID, 0)

    fx_name = fx_name:gsub("DX: ", "")
    fx_name = fx_name:gsub(" %(.-%)", "")
    fx_name = fx_name:gsub("DXi: ", "")
    fx_name = fx_name:gsub(" %(.-%)", "")
    fx_name = fx_name:gsub("VST: ", "")
    fx_name = fx_name:gsub(" %(.-%)", "")
    fx_name = fx_name:gsub("VSTi: ", "")
    fx_name = fx_name:gsub(" %(.-%)", "")
    fx_name = fx_name:gsub("VST3: ", "")
    fx_name = fx_name:gsub(" %(.-%)", "")
    fx_name = fx_name:gsub("VST3i: ", "")
    fx_name = fx_name:gsub(" %(.-%)", "")
    fx_name = fx_name:gsub("JS: ", "")
    fx_name = fx_name:gsub(" %(.-%)", "")
    fx_name = fx_name:gsub("ReWire: ", "")
    fx_name = fx_name:gsub(" %(.-%)", "")

    reaper.osara_outputMessage("FX " .. fx_name .. " deleted")
end
