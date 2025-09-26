-- @description Select FX1
-- @version 1.4
-- @author Lee JULIEN for ReaperAccessible
-- @provides [main=main] .
-- @changelog
--   # 2025-09-01 - New script
--   # 2025-09-25 - Bug correction


local function speak(msg)
  if reaper.osara_outputMessage then
    reaper.osara_outputMessage(msg)
  else
    reaper.ShowMessageBox(msg, "Info", 0)
  end
end

local function trim(s) return (s:gsub("^%s+", ""):gsub("%s+$", "")) end

local function base_before_dash(name)
  -- portion before first '-' (tiret)
  local base = name:match("^%s*(.-)%s*%-")
  if base == nil then
    base = name
  end
  return trim(base)
end

local function is_amp_by_base(name)
  -- Case-sensitive match of the word "Amp" before the dash
  return base_before_dash(name) == "Amp"
end

-- 1) Validate selection
local sel = reaper.CountSelectedTracks(0)
if sel == 0 then
  speak("No track is selected via OSARA")
  return
elseif sel > 1 then
  speak("You must select only one track")
  return
end

local track = reaper.GetSelectedTrack(0, 0)

-- 2) Ensure FX slot 1 exists
local fxcount = reaper.TrackFX_GetCount(track)
if fxcount < 1 then
  speak("No FX in slot 1")
  return
end

-- 3) Try SWS action _S&M_SELFX1, else fallback to TrackFX_Show
local cmd = reaper.NamedCommandLookup("_S&M_SELFX1")
if cmd ~= 0 then
  reaper.Main_OnCommand(cmd, 0)
else
  -- Show FX chain and focus FX #0 (slot 1)
  reaper.TrackFX_Show(track, 0, 1) -- 1 = show and focus
end

-- 4) Work on FX slot 1
local _, fxname = reaper.TrackFX_GetFXName(track, 0, "")
local targeted_is_amp = is_amp_by_base(fxname)

reaper.Undo_BeginBlock2(0)
reaper.PreventUIRefresh(1)

-- Toggle enabled state of targeted FX
local enabled = reaper.TrackFX_GetEnabled(track, 0) and 1 or 0
local new_enabled = (enabled == 0) and 1 or 0
reaper.TrackFX_SetEnabled(track, 0, new_enabled == 1)

-- If targeted is an Amp, bypass all other Amps on this track (based on base-before-dash)
if targeted_is_amp then
  for i = 0, fxcount - 1 do
    if i ~= 0 then
      local _, nm = reaper.TrackFX_GetFXName(track, i, "")
      if is_amp_by_base(nm) then
        reaper.TrackFX_SetEnabled(track, i, false)
      end
    end
  end
end

-- Announce final state of targeted FX
local final_enabled = reaper.TrackFX_GetEnabled(track, 0)
speak((final_enabled and "Enabled" or "Bypassed"))

reaper.PreventUIRefresh(-1)
reaper.Undo_EndBlock2(0, "Toggle FX slot 1; Amp policy and announce", -1)
