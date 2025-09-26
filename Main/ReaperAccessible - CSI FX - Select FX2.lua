-- @description Select FX2
-- @version 1.2
-- @author Lee JULIEN for ReaperAccessible
-- @provides [main=main] .
-- @changelog
--   # 2025-09-01 - New script
--   # 2025-09-25 - Bug correction


-- CONFIG
local TARGET_SLOT = 2            -- numéro humain: 1 = FX #1, 2 = FX #2, etc.
local ENFORCE_SINGLE_AMP = true  -- un seul "amp" actif sur la piste
local SELECT_IN_UI = false       -- true pour montrer/sélectionner l’FX dans la chaîne
local AMP_PATTERNS = { "%f[%a]amp%f[%A]", "amplitube", "amp room" } -- évite "preamp"

-- Utils
local function is_amp(name)
  if not name or name == "" then return false end
  local s = name:lower()
  for _, pat in ipairs(AMP_PATTERNS) do
    if s:find(pat) then return true end
  end
  return false
end

local function base_name_before_dash(name)
  if not name then return "" end
  local pos = name:find("%s*%-")
  local base = pos and name:sub(1, pos - 1) or name
  return base:gsub("^%s+", ""):gsub("%s+$", "")
end

local function speak(msg)
  if reaper.APIExists("osara_outputMessage") then
    reaper.osara_outputMessage(msg)
  end
end

local function get_single_selected_track()
  local cnt = reaper.CountSelectedTracks(0)
  if cnt ~= 1 then return nil, cnt end
  return reaper.GetSelectedTrack(0, 0), 1
end

-- Main
reaper.Undo_BeginBlock()
reaper.PreventUIRefresh(1)

local track, selcnt = get_single_selected_track()
if not track then
  -- silencieux par exigence (aucune ou plusieurs pistes sélectionnées)
  reaper.PreventUIRefresh(-1)
  reaper.Undo_EndBlock("Abort: require exactly one selected track", -1)
  return
end

local fx_count = reaper.TrackFX_GetCount(track)
local fxindex = math.max(0, (TARGET_SLOT or 1) - 1) -- 0-based

if fxindex >= fx_count then
  speak(string.format("No FX in slot %d", fxindex + 1))
  reaper.PreventUIRefresh(-1)
  reaper.Undo_EndBlock(string.format("No FX in slot %d on selected track", fxindex + 1), -1)
  return
end

if SELECT_IN_UI then
  reaper.TrackFX_Show(track, fxindex, 1) -- montre la chaîne et sélectionne l’FX ciblé
end

local _, fxname = reaper.TrackFX_GetFXName(track, fxindex, "")
local label = (base_name_before_dash(fxname) ~= "" and base_name_before_dash(fxname)) or fxname

local was_enabled = reaper.TrackFX_GetEnabled(track, fxindex)
local now_enabled = not was_enabled
if now_enabled ~= was_enabled then
  reaper.TrackFX_SetEnabled(track, fxindex, now_enabled)
end

-- “Un seul amp actif” si on vient d’activer un amp
if ENFORCE_SINGLE_AMP and now_enabled and is_amp(fxname) then
  for i = 0, fx_count - 1 do
    if i ~= fxindex then
      local _, nm = reaper.TrackFX_GetFXName(track, i, "")
      if is_amp(nm) and reaper.TrackFX_GetEnabled(track, i) then
        reaper.TrackFX_SetEnabled(track, i, false)
      end
    end
  end
end

speak(string.format("%s (%s)", label, now_enabled and "unbypass" or "bypass"))

reaper.PreventUIRefresh(-1)
local trnum = reaper.GetMediaTrackInfo_Value(track, "IP_TRACKNUMBER")
local trlabel = (trnum == 0) and "Master" or tostring(trnum)
reaper.Undo_EndBlock(string.format("Toggle FX slot %d on selected track %s: %s", fxindex + 1, trlabel, label), -1)
