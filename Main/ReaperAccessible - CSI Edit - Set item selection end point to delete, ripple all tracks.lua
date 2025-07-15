-- @description Set item selection end point to delete, ripple all tracks
-- @version 1.0
-- @author Lee JULIEN for ReaperAccessible
-- @provides [main=main] .
-- @changelog
--   # 2024-09-18 - Adding log


-- Sélection temporelle: Définir le point de fin
reaper.Main_OnCommand(40626, 0)

-- Aller au début de la sélection temporelle
reaper.Main_OnCommand(40630, 0)

-- Sélection temporelle: Supprimer le contenu de la Sélection temporelle (déplacer les Objets ultérieurs)
reaper.Main_OnCommand(40201, 0)

-- Déplacer le curseur d'édition deux battement en arrière
reaper.Main_OnCommand(41045, 0)
reaper.Main_OnCommand(41045, 0)

-- Transport: Lecture
reaper.Main_OnCommand(1007, 0)

reaper.osara_outputMessage("Content is removed")
