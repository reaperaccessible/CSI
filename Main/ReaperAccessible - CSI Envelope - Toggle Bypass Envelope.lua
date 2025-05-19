-- @description Toggle Bypass Envelope
-- @version 1.0
-- @author Ludovic SANSONE for ReaperAccessible
-- @provides [main=main] .
-- @changelog
--   # 2025-05-18 - Adding CSI scripts to the ReaperAccessible repository


-- Exécute la commande de bypass de l'enveloppe sélectionnée
reaper.Main_OnCommand(40883, 0)

-- Récupère l'enveloppe sélectionnée
envelope = reaper.GetSelectedEnvelope(0)

-- Vérifie si une enveloppe est sélectionnée
if envelope ~= nil then
    brEnvelope = reaper.BR_EnvAlloc(envelope, false)
    active, visible, armed, inLane, laneHeight, defaultShape, minValue, maxValue, centerValue, type, faderScaling = reaper.BR_EnvGetProperties(brEnvelope)

    if active == false then
        reaper.osara_outputMessage("Envelope bypasse")
    else
        reaper.osara_outputMessage("Envelope active")
    end
else
    reaper.osara_outputMessage("No envelope selected")
end
