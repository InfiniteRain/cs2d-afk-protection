--AFK protection v2.0 by Factis699
--That script allows you to go to toiled while playing
--Type "!afk" to turn on protection
--Type "!afk" again to turn off protection
--On AFK protection you cant move, cant be dameged, cant damage someone

--settings
SECONDS_PER_SAY = 10

--array function
function array(m, h)
	local d = {}
	for a = 1, m do
		d[a] = h
	end
return d
end

afkP = array(32, false)
wpns = array(32, {})
wpnM = array(32, 0)
spdM = array(32, 0)
imgI = array(32, 0)
secs = array(32, 0)

--afk function
function afk(id)
	if not afkP[id] then
		afkP[id] = true
		secs[id] = SECONDS_PER_SAY
		wpns[id] = playerweapons(id)
		wpnM[id] = player(id, 'weapontype')
		spdM[id] = player(id, 'speedmod')
		imgI[id] = image('gfx/afk.png', -1, -1, 132 + id)
		parse('strip '.. id ..' 0')
		parse('speedmod '.. id ..' -100')
	elseif afkP[id] then
		afkP[id] = false
		secs[id] = SECONDS_PER_SAY
		for n, w in ipairs(wpns[id]) do
			parse('equip '.. id ..' '.. w)
		end
		parse('setweapon '.. id ..' '.. wpnM[id])
		parse('speedmod '.. id ..' '.. spdM[id])
		freeimage(imgI[id])
	end
end

--hooks
addhook('say', 'say_hook')
addhook('hit', 'hit_hook')
addhook('buildattempt', 'build_hook')
addhook('second', 'second_hook')
addhook('endround', 'round_hook')
addhook('die', 'die_hook')

--functions
function say_hook(id, text)
	if text == '!afk' then
		if player(id, 'health') ~= 0 then
			if secs[id] == 0 then
				afk(id)
			else
				msg2(id, '©255000000You must wait '.. secs[id] ..' second(s) to use this command again!')
			end
		else
			msg2(id, '©255000000You have to be alive to use this command!')
		end
		return 1
	end
end

function hit_hook(id, source, weapon, hpdmg, apdmg)
	if afkP[id] then
		return 1
	elseif afkP[source] then
		return 1
	end
end

function build_hook(id, type, x, y, mode)
	if afkP[id] then
		return 1
	end
end

function second_hook()
	for id = 1, 32 do
		if secs[id] ~= 0 then
			secs[id] = secs[id] - 1
		end
	end
end

function round_hook()
	for id = 1, 32 do
		if afkP[id] then
			afk(id)
		end
		secs[id] = 0
	end
end

function die_hook(victim, killer, weapon, x, y)
	if afkP[victim] then
		afk(victim)
		secs[victim] = 0
	end
end