-- @description Move selected FX one position up
-- @version 1.0
-- @author Lee JULIEN for ReaperAccessible
-- @provides [main=main] .
-- @changelog
--   # 2025-05-18 - Adding CSI scripts to the ReaperAccessible repository


-- Move selected FX up in chain for selected tracks
local countSelTrack = reaper.CountSelectedTracks(0);

if countSelTrack == 0 then
    reaper.osara_outputMessage("No FX selected")
    return
end

local tr = reaper.GetSelectedTrack2(0, 0, 1)

local nbFX = reaper.TrackFX_GetCount(tr)

-- Si aucun effet n'est inséré, on sort du programme
if nbFX < 1 then
    reaper.osara_outputMessage("No FX selected")
    return
end



-- On récupère l'id de l'action SWS dans la variable commandId
local commandId1 = reaper.NamedCommandLookup("_S&M_MOVE_FX_UP")

-- Énoncer le nom de l'FX sélectionné
local commandId2 = reaper.NamedCommandLookup("_RS725d9da2021b090c61d3c4e9c00a78fdb234aaf6")

-- On utilise la fonction habituelle avec la variable commandId
reaper.Main_OnCommand(commandId1, 0)   
reaper.Main_OnCommand(commandId2, 0)   
