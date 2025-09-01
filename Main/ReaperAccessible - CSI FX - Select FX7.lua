-- @description Select FX7
-- @version 1.0
-- @author Lee JULIEN for ReaperAccessible
-- @provides [main=main] .
-- @changelog
--   # 2025-09-01 - New script


local function speak(msg)
  if reaper.APIExists("osara_outputMessage") then
    reaper.osara_outputMessage(msg)
  end
end

local function get_focused_or_selected_track()
  local retval, track_idx = reaper.GetFocusedFX()
  if retval == 1 then
    if track_idx == 0x1000000 then return reaper.GetMasterTrack(0) end
    return reaper.GetTrack(0, track_idx) or reaper.GetTrack(0, track_idx - 1)
  end
  local tr = reaper.GetSelectedTrack(0, 0)
  if tr then return tr end
  return reaper.GetMasterTrack(0)
end

reaper.Undo_BeginBlock()
reaper.PreventUIRefresh(1)

local track = get_focused_or_selected_track()
if not track then
  speak("No FX in this slot")
  reaper.PreventUIRefresh(-1)
  reaper.Undo_EndBlock("Select FX #7", -1)
  return
end

local fx_count = reaper.TrackFX_GetCount(track)
if fx_count < 7 then
  speak("No FX in this slot")
  reaper.PreventUIRefresh(-1)
  reaper.Undo_EndBlock("Select FX #7", -1)
  return
end

-- Select seventh FX in chain (slot 7 -> index 6) and show chain
reaper.TrackFX_Show(track, 6, 1) -- 1 = show chain and select that FX

reaper.PreventUIRefresh(-1)
reaper.Undo_EndBlock("Select FX #7", -1)
