-- @description Set autopunch selection start point
-- @version 1.0
-- @author Lee JULIEN for ReaperAccessible
-- @provides [main=main] .
-- @changelog
--   # 2025-07-19 - New script


-- Définir l'enregistrement en mode auto-punch sur la sélection temporelle
reaper.Main_OnCommand(40076, 0)

-- Ne pas lier les points de boucle à la sélection temporelle
reaper.Main_OnCommand(40750, 0)

-- Définir le mode d'enregistrement de la piste sur l'entrée
reaper.Main_OnCommand(40496, 0)

-- Sélection temporelle: Définir le point de début
reaper.Main_OnCommand(40625, 0)

-- Déplacement du curseur
reaper.Main_OnCommand(41041, 0)
reaper.Main_OnCommand(41041, 0)

-- Points de boucle: Définir le point de début
reaper.Main_OnCommand(40222, 0)

-- Déplacer le curseur d'édition à l'emplacement initiale
reaper.Main_OnCommand(41040, 0)
reaper.Main_OnCommand(41040, 0)

-- SWS: Activer la boucle dans le transport
local commandId1 = reaper.NamedCommandLookup("_SWS_SETREPEAT")
-- On utilise la fonction habituelle avec la variable commandId
reaper.Main_OnCommand(commandId1, 0)   

reaper.osara_outputMessage("Set autopunch selection start")
