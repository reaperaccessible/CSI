-- @description Select previous FX of selected track
-- @version 1.0
-- @author Lee JULIEN for ReaperAccessible
-- @provides [main=main] .
-- @changelog
--   # 2025-05-18 - Adding CSI scripts to the ReaperAccessible repository


local rpa = reaper.NamedCommandLookup("_S&M_SELFXPREV")
reaper.Main_OnCommand(rpa, 0)  
  local countSelTrack = reaper.CountSelectedTracks(0);
  if countSelTrack == 0 then return end;
  
  local Tr;
  local LastTouchedTrack = reaper.GetLastTouchedTrack();
  if LastTouchedTrack and reaper.GetMediaTrackInfo_Value(LastTouchedTrack,"I_SELECTED")==1 then;
    Tr = LastTouchedTrack else Tr = reaper.GetSelectedTrack(0,0);
  end;
  count_FX = reaper.TrackFX_GetCount(LastTouchedTrack)  
if  count_FX == 0 then return end
  local retval,str = reaper.GetTrackStateChunk(Tr,"",false);
  local idxSelFx = tonumber(string.match(str,"LASTSEL (%d+)"));
idxSelFx1 = idxSelFx + 1 
  retval, fx_name = reaper.TrackFX_GetFXName(LastTouchedTrack , idxSelFx, "")
      if fx_name == "" then fx_name = "No fx" end;

  fx_name = fx_name:gsub("DX: ", "")
  fx_name = fx_name:gsub(" %(.-%)", "")
  fx_name = fx_name:gsub("DXi: ", "")
  fx_name = fx_name:gsub(" %(.-%)", "")
  fx_name = fx_name:gsub("VST: ", "")
  fx_name = fx_name:gsub(" %(.-%)", "")
  fx_name = fx_name:gsub("VSTi: ", "")
  fx_name = fx_name:gsub(" %(.-%)", "")
  fx_name = fx_name:gsub("VST3: ", "")
  fx_name = fx_name:gsub(" %(.-%)", "")
  fx_name = fx_name:gsub("VST3i: ", "")
   fx_name = fx_name:gsub(" %(.-%)", "")
  fx_name = fx_name:gsub("JS: ", "")
   fx_name = fx_name:gsub(" %(.-%)", "")
  fx_name = fx_name:gsub("ReWire: ", "")
   fx_name = fx_name:gsub(" %(.-%)", "")

  retval, presetname = reaper.TrackFX_GetPreset(LastTouchedTrack, idxSelFx, "")
  if presetname == "" then presetname = "No preset" end;

  local bypassStatus = reaper.TrackFX_GetEnabled(LastTouchedTrack, idxSelFx)

  if bypassStatus == true then
    reaper.osara_outputMessage((idxSelFx + 1) .. " " .. fx_name .. " Active")
  else
    reaper.osara_outputMessage((idxSelFx + 1) .. " " ..  fx_name .. " Bypassed")
  end
