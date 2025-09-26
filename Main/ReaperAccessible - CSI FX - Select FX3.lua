-- @description Select FX3
-- @version 1.4
-- @author Lee JULIEN for ReaperAccessible
-- @provides [main=main] .
-- @changelog
--   # 2025-09-01 - New script


local function speak(msg)
  if reaper.osara_outputMessage then
    reaper.osara_outputMessage(msg)
  else
    reaper.ShowMessageBox(msg, "Info", 0)
  end
end

local function trim(s) return (s:gsub("^%s+", ""):gsub("%s+$", "")) end

local function base_before_dash(name)
  local base = name:match("^%s*(.-)%s*%-")
  if base == nil then base = name end
  return trim(base)
end

local function is_amp_by_base(name)
  -- Case-sensitive. Require "Amp" before first dash.
  return base_before_dash(name) == "Amp"
end

-- 1) Track selection checks
local sel = reaper.CountSelectedTracks(0)
if sel == 0 then
  speak("No track is selected via OSARA")
  return
elseif sel > 1 then
  speak("You must select only one track")
  return
end
local track = reaper.GetSelectedTrack(0, 0)

-- 2) Ensure FX in slot 3 (index 2)
local fxcount = reaper.TrackFX_GetCount(track)
if fxcount < 3 then
  speak("No FX in slot 3")
  return
end

-- 3) Try SWS _S&M_SELFX3, else focus slot 3
local cmd = reaper.NamedCommandLookup("_S&M_SELFX3")
if cmd ~= 0 then
  reaper.Main_OnCommand(cmd, 0)
else
  reaper.TrackFX_Show(track, 2, 1) -- 1 = show and focus
end

-- 4) Target slot 3
local fx_index = 2
local _, fxname = reaper.TrackFX_GetFXName(track, fx_index, "")
local targeted_is_amp = is_amp_by_base(fxname)

reaper.Undo_BeginBlock2(0)
reaper.PreventUIRefresh(1)

-- Toggle targeted FX
local enabled = reaper.TrackFX_GetEnabled(track, fx_index) and 1 or 0
local new_enabled = (enabled == 0) and 1 or 0
reaper.TrackFX_SetEnabled(track, fx_index, new_enabled == 1)

-- If targeted is an Amp, bypass all other Amps (detected before dash, case-sensitive)
if targeted_is_amp then
  for i = 0, fxcount - 1 do
    if i ~= fx_index then
      local _, nm = reaper.TrackFX_GetFXName(track, i, "")
      if is_amp_by_base(nm) then
        reaper.TrackFX_SetEnabled(track, i, false)
      end
    end
  end
end

-- Announce final state
local final_enabled = reaper.TrackFX_GetEnabled(track, fx_index)
speak(final_enabled and "Enabled" or "Bypassed")

reaper.PreventUIRefresh(-1)
reaper.Undo_EndBlock2(0, "Toggle FX slot 3; Amp policy and announce", -1)
