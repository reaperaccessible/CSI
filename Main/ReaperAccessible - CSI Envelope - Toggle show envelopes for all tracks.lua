-- @description Toggle show envelopes for all tracks
-- @version 1.0
-- @author Ludovic SANSONE for ReaperAccessible
-- @provides [main=main] .
-- @changelog
--   # 2025-05-18 - Adding CSI scripts to the ReaperAccessible repository


reaper.Undo_BeginBlock()

reaper.Main_OnCommand(41152, 0)

state = reaper.GetToggleCommandState(41152)
if state == 0 then
    reaper.osara_outputMessage("All project envelopes hidden")
elseif state == 1 then
    reaper.osara_outputMessage("All project enveloppes displayed")
end

reaper.Undo_EndBlock("Toggle show envelopes for all tracks", 0) 
