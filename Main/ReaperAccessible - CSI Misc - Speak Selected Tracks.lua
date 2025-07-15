-- @description Speak Selected Tracks
-- @version 1.0
-- @author Lee JULIEN for ReaperAccessible
-- @provides [main=main] .
-- @changelog
--   # 2025-07-15 - New script


-- OSARA wrapper
local function osara_msg(text)
    if reaper.osara_outputMessage then
        reaper.osara_outputMessage(text)
    else
        reaper.ShowConsoleMsg("OSARA missing: " .. text)
    end
end

-- Count selected tracks
local sel_count = reaper.CountSelectedTracks(0)
if sel_count == 0 then
    osara_msg("No track is selected")
    return
end

-- Collect and sort selected track numbers
local nums = {}
for i = 0, sel_count - 1 do
    local tr = reaper.GetSelectedTrack(0, i)
    local tn = reaper.GetMediaTrackInfo_Value(tr, "IP_TRACKNUMBER")
    nums[#nums+1] = math.floor(tn + 0.5)
end
table.sort(nums)

-- Build ranges list
local parts = {}
local start_num = nums[1]
local prev = nums[1]
for i = 2, #nums do
    local n = nums[i]
    if n == prev + 1 then
        -- continue range
        prev = n
    else
        -- close previous range
        if start_num == prev then
            parts[#parts+1] = tostring(start_num)
        else
            parts[#parts+1] = tostring(start_num) .. " to " .. tostring(prev)
        end
        start_num = n
        prev = n
    end
end
-- close last range
if start_num == prev then
    parts[#parts+1] = tostring(start_num)
else
    parts[#parts+1] = tostring(start_num) .. " to " .. tostring(prev)
end

-- Join parts and announce
local selection_str = table.concat(parts, ", ")
local msg = "Track " .. selection_str .. " Selected"
osara_msg(msg)