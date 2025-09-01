-- @description Bypass-Unbypass Amp and Stomp
-- @version 1.0
-- @author Lee JULIEN for ReaperAccessible
-- @provides [main=main] .
-- @changelog
--   # 2025-09-01 - New script


local function contains_amp(name)
  return name and string.find(string.lower(name), "amp", 1, true) ~= nil
end

local function base_name_before_dash(name)
  if not name then return "" end
  local pos = string.find(name, "%s*%-") -- spaces before '-'
  local base = pos and string.sub(name, 1, pos - 1) or name
  base = base:gsub("^%s+", ""):gsub("%s+$", "")
  return base
end

local function speak(msg)
  if reaper.APIExists("osara_outputMessage") then
    reaper.osara_outputMessage(msg) -- one argument only
  end
end

local function get_track_from_index(idx)
  if idx == 0x1000000 then return reaper.GetMasterTrack(0) end
  return reaper.GetTrack(0, idx) or reaper.GetTrack(0, idx - 1)
end

reaper.Undo_BeginBlock()
reaper.PreventUIRefresh(1)

local retval, track_idx, _, fxindex = reaper.GetFocusedFX()
if retval ~= 1 then
  reaper.PreventUIRefresh(-1)
  reaper.Undo_EndBlock("Toggle focused FX with OSARA speak (track FX only)", -1)
  return
end

local track = get_track_from_index(track_idx)
if not track or fxindex < 0 then
  reaper.PreventUIRefresh(-1)
  reaper.Undo_EndBlock("Toggle focused FX with OSARA speak (track FX only)", -1)
  return
end

local _, focused_name = reaper.TrackFX_GetFXName(track, fxindex, "")
local name_base = base_name_before_dash(focused_name)
local focused_enabled_before = reaper.TrackFX_GetEnabled(track, fxindex)

if contains_amp(focused_name) then
  -- Case A: "Amp"
  reaper.TrackFX_SetEnabled(track, fxindex, not focused_enabled_before)
  local fx_count = reaper.TrackFX_GetCount(track)
  for i = 0, fx_count - 1 do
    if i ~= fxindex then
      local _, nm = reaper.TrackFX_GetFXName(track, i, "")
      if contains_amp(nm) then
        reaper.TrackFX_SetEnabled(track, i, false) -- bypass
      end
    end
  end
else
  -- Case B: non-"Amp"
  reaper.TrackFX_SetEnabled(track, fxindex, not focused_enabled_before)
end

-- Speak final state as "bypass" or "unbypass"
local focused_enabled_after = reaper.TrackFX_GetEnabled(track, fxindex)
local state_str = focused_enabled_after and "unbypass" or "bypass"
speak(string.format("%s (%s)", name_base ~= "" and name_base or focused_name, state_str))

reaper.PreventUIRefresh(-1)
reaper.Undo_EndBlock("Toggle focused FX with OSARA speak (track FX only)", -1)
