-- @description Increase and Invert Track Width by 1%
-- @version 1.0
-- @author Lee JULIEN for ReaperAccessible
-- @provides [main=main] .
-- @changelog
--   # 2025-07-15 - New script


local function osara_msg(text)
  if reaper.osara_outputMessage then
    reaper.osara_outputMessage(text)
  else
    reaper.ShowConsoleMsg("OSARA missing: "..text)
  end
end

-- piste sélectionnée
local track = reaper.GetSelectedTrack(0, 0)
if not track then
  osara_msg("No track is selected")
  return
end

-- valeur brute D_WIDTH (-1 = inversé, 0 = mono, 1 = normal)
local width_raw = reaper.GetMediaTrackInfo_Value(track, "D_WIDTH")

-- conversion en affichage 0…100% (0 = normal, 50 = mono, 100 = inversé)
local percent = math.floor(((1 - width_raw) / 2) * 100 + 0.5)

-- nouveau pourcentage augmenté de 1%, clamp [0,100]
local new_percent = math.min(percent + 1, 100)

-- reconstruction de D_WIDTH dans [-1,1]
local new_width = 1 - (new_percent * 2 / 100)

-- application et feedback
reaper.SetMediaTrackInfo_Value(track, "D_WIDTH", new_width)
osara_msg(tostring(new_percent) .. " %")
