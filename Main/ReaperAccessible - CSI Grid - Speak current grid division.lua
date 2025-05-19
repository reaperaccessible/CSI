-- @description Speak current grid division
-- @version 1.0
-- @author Lee JULIEN for ReaperAccessible
-- @provides [main=main] .
-- @changelog
--   # 2025-05-18 - Adding CSI scripts to the ReaperAccessible repository


local dict = {
    {1.0, 4, "to 4 measures"},
    {2.0, 3, "to 3 measures"},
    {3.0, 2, "to 2 measures"},
    {4.0, 1, "to 1 measure "},
    {5.0, 1/2, "to 1/2"},
    {6.0, 1/4, "to 1/4"},
    {7.0, 1/8, "to 1/8"},
    {8.0, 1/16, "to 1/16"},
    {9.0, 1/32, "to 1/32"},
    {10.0, 1/64, "to 1/64"},
    {11.0, 1/128, "to 1/128"},
    {12.0, 2/3, "to 2/3"},
    {13.0, 1/3, "to 1/3"},
    {14.0, 1/6, "to 1/6"},
    {15.0, 1/12, "to 1/12"},
    {16.0, 1/24, "to 1/24"},
    {17.0, 1/48, "to 1/48"},
    {18.0, 1/5, "to 1/5"},
    {19.0, 1/7, "to 1/7"},
    {20.0, 1/9, "to 1/9"},
    {21.0, 1/10, "to 1/10"},
    {22.0, 1/18, "to 1/18"}
}

function getDivision(projectGrid, d)
    for i = 1, 22 do
        if projectGrid == d[i][2] then
            return d[i][3]
        end
    end
    return "invalide"
end

local ret, grid = reaper.GetSetProjectGrid(0, 0)
local msg = getDivision(grid, dict)

reaper.osara_outputMessage("Grid set" .. msg)
