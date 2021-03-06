

function fw.team.addPlayerToFaction(ply, factionId)
	if ply:inFaction() then
		fw.team.remvoePlayerFromFaction(ply)
	end

	ply.GetFWData().faction = factionId
	hook.Call('PlayerJoinedFaction', factionId)
end

function fw.team.removePlayerFromFaction(ply)
	if (not ply:inFaction()) then return end
	
	local t = fw.team.list[ply:Team()]
	if t ~= nil and (t.faction ~= nil or team.factionOnly) then
		-- if they are removed from the faction they must loose their job if it is limited to their faction
		fw.team.demotePlayer(ply)
	end

	local oldFaction = ply:getFaction()
	ply:GetFWData().faction = nil

	hook.Call('PlayerLeftFaction', oldFaction)
end

function fw.team.setFactionBoss(factionId, ply)
	fw.team.getFactionByID(factionId):getNWData().boss = ply
end

function fw.team.removeFactionBoss(factionId)
	fw.team.setFactionBoss(factionId, nil)
end