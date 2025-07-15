-- @description Set selection end point of area to remove from selected tracks
-- @version 1.0
-- @author Lee JULIEN for ReaperAccessible
-- @provides [main=main] .
-- @changelog
--   # 2024-09-18 - Adding log


-- Définir l'édition Ripple sur désactiver
reaper.Main_OnCommand(40309, 0)

-- Sélection temporelle: Définir le point de fin
reaper.Main_OnCommand(40626, 0)

-- Aller au début de la sélection temporelle
reaper.Main_OnCommand(40630, 0)

-- Sélectionner tous les Objets des pistes sélectionnées dans la sélection temporelle actuelle
reaper.Main_OnCommand(40718, 0)

-- Objet: Supprimer la zone sélectionnée des Objets
reaper.Main_OnCommand(40312, 0)

-- Déplacer le curseur d'édition deux battement en arrière
reaper.Main_OnCommand(41045, 0)
reaper.Main_OnCommand(41045, 0)

-- Transport: Lecture
reaper.Main_OnCommand(1007, 0)

reaper.osara_outputMessage("Area selection deleted")
