-- @description Set selection start point of area to remove from selected tracks
-- @version 1.0
-- @author Lee JULIEN for ReaperAccessible
-- @provides [main=main] .
-- @changelog
--   # 2024-09-18 - Adding log
--   # 2024-09-22 - Fixed spoken message


-- Sélection temporelle: Définir le point de début
reaper.Main_OnCommand(40625, 0)

-- Sélectionner les Objets sous le curseur d'édition sur les pistes sélectionnées
-- SWS: Activer la boucle dans le transport
local commandId1 = reaper.NamedCommandLookup("_XENAKIOS_SELITEMSUNDEDCURSELTX")
-- On utilise la fonction habituelle avec la variable commandId
reaper.Main_OnCommand(commandId1, 0)   

-- Transport: Lecture
reaper.Main_OnCommand(1007, 0)

reaper.osara_outputMessage("Area start point deleted")
