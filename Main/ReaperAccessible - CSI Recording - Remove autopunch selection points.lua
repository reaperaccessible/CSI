-- @description Remove autopunch selection points
-- @version 1.0
-- @author Lee JULIEN for ReaperAccessible
-- @provides [main=main] .
-- @changelog
--   # 2024-09-18 - Adding log


-- Définir l'enregistrement en mode normal
reaper.Main_OnCommand(40252, 0)

-- Supprimer (désélectionner) la sélection temporelle et les points de boucle
reaper.Main_OnCommand(40020, 0)

-- Lier les points de boucle à la sélection temporelle
reaper.Main_OnCommand(40749, 0)

-- SWS: Désactiver la boucle dans le transport
local commandId1 = reaper.NamedCommandLookup("_SWS_UNSETREPEAT")
-- On utilise la fonction habituelle avec la variable commandId
reaper.Main_OnCommand(commandId1, 0)   

-- Enregistrement: Définir l'enregistrement en mode normal
reaper.Main_OnCommand(40252, 0)

reaper.osara_outputMessage("Autopunch selection points removed")
