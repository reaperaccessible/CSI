-- @description Speak project tempo and time signature, at current position
-- @version 1.0
-- @author Lee JULIEN for ReaperAccessible
-- @provides [main=main] .
-- @changelog
--   # 2025-05-18 - Adding CSI scripts to the ReaperAccessible repository


-- On récupère la position courante
local currentPosition = reaper.GetCursorPosition();

-- On récupère le nombre de valeur, la valeur et le tempo
local numberValues, value, tempo = reaper.TimeMap_GetTimeSigAtTime(0,currentPosition)

-- On construit le message à énoncer
local message = "Tempo " .. math.floor(tempo) .. ", signature " .. numberValues .. " " .. value

-- On énonce
reaper.osara_outputMessage(message)
