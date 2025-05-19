-- @description Toggle show all envelopes for tracks
-- @version 1.0
-- @author Ludovic SANSONE for ReaperAccessible
-- @provides [main=main] .
-- @changelog
--   # 2025-05-18 - Adding CSI scripts to the ReaperAccessible repository


track = reaper.GetSelectedTrack(0, 0) -- sélectionne la première piste sélectionnée

if track == nil then
    return
end

count = reaper.CountTrackEnvelopes(track)

i = 0
j = 0

while i < count do
    env = reaper.GetTrackEnvelope(track, i)
    _, chunk = reaper.GetEnvelopeStateChunk(env, "", false)
    start = string.find(chunk, "VIS 1")
    if start ~= nil then
        j = j + 1
        message = "All envelopes hidden for selected tracks"
        new_chunk = string.gsub(chunk, "VIS 1", "VIS 0")
        ret = reaper.SetEnvelopeStateChunk(env, new_chunk, false)
    end
    i = i + 1
end

if j == 0 then
    i = 0
    while i < count do
        env = reaper.GetTrackEnvelope(track, i)
        _, chunk = reaper.GetEnvelopeStateChunk(env, "", false)
        start = string.find(chunk, "VIS 0")
        if start ~= nil then
            message = "All envelopes visible for selected tracks"
            new_chunk = string.gsub(chunk, "VIS 0", "VIS 1")
            ret = reaper.SetEnvelopeStateChunk(env, new_chunk, false)
        end
        i = i + 1
    end
    
end

reaper.osara_outputMessage(message)
