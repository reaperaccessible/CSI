-- @description Toggle bypass selected FX on selected track
-- @version 1.0
-- @author Lee JULIEN for ReaperAccessible
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

    local bypassStatus = reaper.TrackFX_GetEnabled(tr, idxSelFx)

    



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

    if bypassStatus == true then
        reaper.TrackFX_SetEnabled(tr, idxSelFx, false)
        reaper.osara_outputMessage((idxSelFx + 1) .. " " .. fx_name .. " Bypassed")
    else
        reaper.TrackFX_SetEnabled(tr, idxSelFx, true)
        reaper.osara_outputMessage((idxSelFx + 1) .. " " .. fx_name .. " Active")
    end
end
