-- @description Decrease Envelope Point Value by 1
-- @version 1.0
-- @author Ludovic SANSONE for ReaperAccessible
-- @provides [main=main] .
-- @changelog
--   # 2025-05-18 - Adding CSI scripts to the ReaperAccessible repository


-- Obtenir l'enveloppe sélectionnée
envelope = reaper.GetSelectedEnvelope(0)

-- Arrêter le script si aucune enveloppe n'est sélectionnée
if not envelope then
    reaper.osara_outputMessage("No envelope selected")
    return
end

-- Récupérer l'index du point d'enveloppe à la position du curseur
point = reaper.GetEnvelopePointByTimeEx(envelope, -1, reaper.GetCursorPosition())

-- Obtenir les propriétés du point d'envelope
ret, time, value, shape, tension, selected = reaper.GetEnvelopePointEx(envelope, -1, point)

-- Récupérer les propriétés de l'enveloppe
brEnvelope = reaper.BR_EnvAlloc(envelope, false)
active, visible, armed, inLane, laneHeight, defaultShape, minValue, maxValue, centerValue, type, faderScaling = reaper.BR_EnvGetProperties(brEnvelope)

-- Définir le pas du changement de valeur en fonction du type d'enveloppe
if type == 0 or type == 1 then -- Enveloppe de volume
    scalingValue = reaper.ScaleFromEnvelopeMode(1, value)
    dbValue = 20 * math.log(scalingValue, 10)
    dbValue = dbValue - 1
    scalingValue = 10^(dbValue / 20)
    unscalingValue = reaper.ScaleToEnvelopeMode(1, scalingValue)
    if scalingValue > 2.8183829380472e-008 then
        value = unscalingValue
    end
elseif type == 2 or type == 3 then -- Enveloppe de panoramique
    if value < 1.0 then
        value = value + 0.01
    end
elseif type == 4  or type == 5 then-- Enveloppe de largeur
    if value > -1 then
        value = value - 0.01
    end
elseif type == 6 then -- Enveloppe de sourdine
    value = 0
elseif type == 7 then -- Enveloppe de hauteur tonale
    if value > -3 then
        value = value - 1
    end
elseif type == 9 then -- Enveloppe de Tempo
    if value > 40 then
        value = value - 1
    end
elseif type == 10 then -- Enveloppe de paramètre
    if value > 0 then
        value = value - 0.01
    end
end

-- Appliquer la nouvelle valeur au point d'enveloppe
reaper.SetEnvelopePointEx(envelope, -1, point, time, value, shape, tension, true, false)

-- Énonciation de la valeur intelligible
reaper.osara_outputMessage(reaper.Envelope_FormatValue(envelope, value))
