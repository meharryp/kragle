if SERVER then
	AddCSLuaFile()
end

-- load internal dependencies
fw.dep(SHARED, 'hook')
fw.dep(SERVER, 'data')

-- load self
local Player = FindMetaTable('Player')


fw.include_sv 'economy_sv.lua'
fw.include_sh 'economy_sh.lua'