-- @description Select next grid division from grid menu
-- @version 1.2
-- @author Lee JULIEN for ReaperAccessible
-- @provides [main=main] .
-- @changelog
--   # 2025-05-18 - Adding CSI scripts to the ReaperAccessible repository


reaper.Undo_BeginBlock()

local ret, grid = reaper.GetSetProjectGrid(0, 0)

local dict = {
    {4, "4 Measures"},
    {3, "3 Measures"},
    {2, "2 Measures"},    
    {1, "One Measure"},
    {1/2, "1/2, Half Note"},
    {1/4, "1/4, Quarter note"},
    {1/8, "1/8, Eighth Note"},
    {1/16, "1/16, Sixteenth note"},
    {1/32, "1/32, Thirteenth Note"},
    {1/64, "1/64, 16th Note"},
    {1/128, "1/128, 18th Note"},
    {2/3, "2/3, Whole Note Triplet"},
    {1/3, "1/3, Half note triplet"},
    {1/6, "1/6, Quarter Note Triplet"},
    {1/12, "1/12, Eighth Note Triplet"},
    {1/24, "1/24, Sixteenth Note Triplet"},
    {1/48, "1/48, 32nd Note Triplet"},
    {1/5, "1/5, Quarter Note Quintuplet"},
    {1/7, "1/7, Quarter Note Septuplet"},
    {1/9, "1/9, Nine‑Tuplet"},
    {1/10, "1/10, Ten‑Tuplet"},
    {1/18, "1/18, Eighteen‑Tuplet"}
}

function getNextDivision(g, d)
    for i = 1, 22 do
        if g == d[i][1] then
            if i == 1 then
                return d[22][1], d[22][2]
            end
            return d[i - 1][1], d[i - 1][2]
        end
    end
    return 0, "invalid"
end

local division, msg = getNextDivision(grid, dict)
if division > 0 then
    reaper.SetProjectGrid(0, division)
    reaper.SetMIDIEditorGrid(0, division)
    reaper.osara_outputMessage(msg .. " is set as grid division value")
end

reaper.Undo_EndBlock("Cannot undo this action", 0) 
