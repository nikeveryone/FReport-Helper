script_name("FReport Helper v2.0 OE")
script_author("N.Everyone")
script_version("2.0")
local samp = require 'samp.events'
local ev = require "lib.samp.events"

require "lib.moonloader"
require "lib.sampfuncs"

local sampev = require 'lib.samp.events'
local requests = require 'requests'
requests.http_socket, requests.https_socket = http, http
local imgui = require 'imgui'
local encoding = require 'encoding'

local notify = import 'lib_imgui_notf.lua'

local cfgConfig = "FlinRP/FReport Helper" -- папка сохранения

local inicfg = require 'inicfg' -- папка настроек
local memory = require 'memory'

local dlstatus = require('moonloader').download_status
local script_vers = 2
local script_vers_text = "2.0"
local update_url = "https://raw.githubusercontent.com/nikeveryone/Scripts-by-N.Everyone/main/update.ini"
local update_path = getWorkingDirectory() .. "/update.ini"
local script_url = "https://github.com/nikeveryone/Scripts-by-N.Everyone/raw/main/FReport%20Helper%202.0.luac" -- тут свою ссылку
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
local main_color_text = "{f44f36}"
local main_color_text = "{C71585}"
local main_color_text = "{32CD32}"
local main_color_text = "{D2691E}"
local main_color_text = "{FF7538}"
local main_color_text = "{FF4500}"
local main_color_text = "{228B22}"
local main_color_text = "{006400}"
local main_color_text = "{00FFFF}"
local main_color_text = "{8B0000}"
local main_color_text = "{008000}"
local main_color_text = "{808080}"
local main_color_text = "{FFFF00}"
local main_color_text = "{FF7F50}"
local main_color_text = "{FF0000}"
local main_color_text = "{FFA500}"
local main_color_text = "{FFD700}"
local main_color_text = "{FF69B4}"
local main_color_text = "{000000}"
local main_color_text = "{0000FF}"
local main_color_text = "{FFFF00}"
local main_color_text = "{B7AFAF}"


local defString = ""
-- Для диалога с постами
local dialogArr = {"Привет, это пункт диалога", "И это тоже", "{FF00FF}Это цветной пункт", "А это последний"}
local dialogStr = ""
--local piska = 0
--local huy = require("samp.events")
--local oX = 290
--local oY = 100

encoding.default = 'CP1251'
u8 = encoding.UTF8

local statew = imgui.ImBool(false)
local statew2 = imgui.ImBool(false)
local statew4 = imgui.ImBool(false)
local statew5 = imgui.ImBool(false)
local statew9 = imgui.ImBool(false)
local statew6 = imgui.ImBool(false)
local statew7 = imgui.ImBool(false)

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

areport = 0
dvaareport = 0


for _, str in ipairs(dialogArr) do
    dialogStr = dialogStr .. str .. "\n"
end

local items = {
	u8"Тёмная",
	u8"Синяя",
	u8"Красная",
	u8"Бирюзовая",
	u8"Зелёная",
	u8"Оранжевая",
	u8"Фиолетовая",
	u8"Тёмно-светлая",
	u8"Светло-синий",
	u8"Серая",
	u8"Вишневая",
	u8"Светло-Красная",
	u8"Темно-Красная",
	u8"Золотая",
	u8"Тёмно-Салатовая",
	u8"Пурпурная",
}

local cfg = inicfg.load({
	settings = {
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
local prices1 = "Bravura - 50.000$ - [ID: 401]\nPerrenial - 25.000$ - [ID: 404]\nManana - 50.000$ - [ID: 410]\nEsperanto - 50.000$ - [ID: 419]\nBobcat - 25.000$ - [ID: 422]\nPrevion - 25.000$ - [ID: 436]\nStallion - 50.000$ - [ID: 439]\nSolair - 50.000$ - [ID: 458]\nGlendale - 25.000$ - [ID: 466]\nHermes - 25.000$ - [ID: 474]\nWalton - 50.000$ - [ID: 478]\nRegina - 25.000$ - [ID: 479]\nVirgo - 50.000$ - [ID: 491]\nGreenwood - 25.000$ - [ID: 492]\nMesa - 50.000 - [ID: 500]\nElegant - 25.000$ - [ID: 507]\nNebula - 50.000$ - [ID: 516]\nMajestic - 50.000$ - [ID: 517]\nBuccanner - 25.000$ - [ID: 518]\nFortune - 25.000$ - [ID: 526]\nCadrona - 50.000$ - [ID: 527]\nWillard - 50.000$ - [ID: 529]\nVincent - 25.000$ - [ID: 540]\nClover - 25.000$ - [ID: 542]\nSadler - 25.000$ - [ID: 543]\nHustler - 50.000$ - [ID: 545]\nIntruder - 25.000$ - [ID: 546]\nPrimo - 25.000$ - [ID: 547]\nTampa - 25.000$ - [ID: 549]\nEmperor - 25.000$ - [ID: 585]\nPicador - 25.000$ - [ID: 600]\nGlendale - 25.000$ - [ID: 604]\nSadler - 25.000$ - [ID: 605]"
local prices2 = "Landstalker - 100.000$ - [id 400]\nSentinel - 100.000$ - [ID: 405]\nVoodoo - 250.000$ - [ID: 412]\nMoonbeam - 100.000$ - [ID: 418]\nWashington - 100.000$ - [ID: 401]\nPremier - 100.000$ - [ID: 426]\nAdmiral - 100.000$ - [ID: 445]\nOceanic - 100.000$ - [ID: 467]\nSabre - 100.000$ -[ID: 475]\nBurrito - 250.000$ - [ID: 482]\nRancher - 100.000$ - [ID: 489]\nBlista Compact - 100.000$ - [ID: 496]\nRancher - 100.000$ - [ID: 505]\nFeltzer - 100.000$ - [ID: 533]\nRemington - 250.000 - [ID: 534]\nSlamvan - 250.000$ - [ID: 535]\nBlade - 250.000$ - [ID: 536]\nSunrise - 100.000$ - [ID: 550]\nMerit - 100.000$ - [ID: 551]\nYosemite - 100.000$ - [ID: 554]\nWindsor - 250.000$ - [ID: 555]\nUranus - 250.000$ - [ID: 558]\nElegy - 250.000$ - [ID: 562]\nFlash - 250.000$ - [ID: 565]\nTahoma - 250.000$ - [ID: 566]\nSavanna - 250.000$ - [ID: 567]\nBroadway - 250.000$ - [ID: 575]\nTornado - 250.000$ - [ID: 576]\nHuntley - 250.000$ - [ID: 579]\nEuros - 250.000$ - [ID: 587]\nClub - 250.000$ - [ID: 589]\nAlpha - 250.000$ - [ID: 602]\nPheonix - 250.000$ - [ID: 603]"
local prices3 = "Buffalo - 1.000.000$ - [ID: 402]\nZR - 350 - 750.000$ - [ID: 477]\nComet - 750.000$ - [ID: 480]\nSuper GT - 1.000.000$ - [ID: 506]\nJester - 750.000$ - [ID: 559]\nSultan - 1.000.000$ - [ID: 560]\nStratum - 500.000$ - [ID: 561]\nStafford - 1.000.000$ - [ID: 580]"
local prices4 = "Infernus - 2.500.000$ - [ID: 411]\nCheetah - 2.000.000$ - [ID: 415]\nBanshee - 1.500.000$ - [ID: 429]\nTurismo - 2.500.000$ - [ID: 451]\nBullet - 2.500.000$ - [ID: 541]"
local prices5 = "PCJ-600 - 1.000.000$ - [ID: 461]\nFaggio - 50.000$ - [ID: 462]\nFreeway - 500.000$ - [ID: 463]\nSanchez - 250.000$ - [ID: 458]\nQuad - 100.000$ - [ID: 471]\nBMX - 25.000$ - [ID: 481]\nBike - 25.000$ - [ID: 509]\nMountain Bike - 25.000$ - [ID: 510]\nFCR - 900 -1.500.000$ - [ID: 521]\nBF - 400 - 750.000$ - [ID: 581]\nWayfarer - 250.000$ - [ID: 586]"
local prices6 = "Nevada - 2.500.000$ - [ID: 553]\nShamal - 2.500.000$ - [ID: 519]\nBeagle - 1.500.000$ - [ID: 511]\nMaverick - 2.500.000$ - [ID: 487]\nSparrow - 2.000.000$ - [ID: 469]\nRustler - 1.000.000$ - [ID: 476]\nCropduster - 750.000$ - [ID: 512]\nStunt - 1.000.000$ - [ID: 513]\nDodo - 500.000$ - [ID: 593]"
local prices7 = "Marquis - 2.500.000$ - [ID: 484]\nSqualo - 1.500.000$ - [ID: 446]\nSpeeder - 2.000.000$ - [ID: 452]\nTropic - 2.500.000$ - [ID: 454]"
local pricesrealcars = "Mercedes-Benz G63 AMG 6x6 - 10.000FM \n- [ID: 3610]\nRolls-Royce Phantom - 10.000FM \n- [ID: 4546]\nFerrari Pista 488 - 9.500FM - [ID: 3222]\nMcLaren 720s - 9.500FM - [ID: 3248]\nBugatti Chiron - 9.000FM - [ID: 3215]\nPorshe Panamero Turbo - \n8.000FM - [ID: 3349]\nMcLren 600LT - 8.000FM - [ID: 3219]\nBentley Continental - 7.500FM \n- [ID: 3201]\nBentley Bentayga - 7.500FM - [ID: 3200]\nAston Matrin Vantage - 7.500FM \n- [ID: 3194]\nMercedes-Benz G63 \n- 7.000FM - [ID: 3870]\nMercedes-Maybach - 7.000FM \n- [ID: 3239]\nBMW M8 - 6.500FM - [ID: 3210]\nRange Rover SVR - 6.000FM - [ID: 3429]\nLexus LC - 5.500FM - [ID: 3233]"
local pricesrealcars2 = "Toyota Celica - 300FM - [ID: 4766]\nToyota Chaser - 250FM - [ID: 4764]\nToyota Mark II - 200FM - [ID: 3236]\nTesla Model S - 5.000FM - [ID: 3245]\nNissan GTR - 4.500FM - [ID: 3974]\nCadilac Escalade - 3.500FM - [ID: 3217]\nMercedes-Benz E63 AMG S \n- 3.000FM - [ID: 3247]\nLexus LX570 - 2.750FM - [ID: 3235]\nMercedes-Benz AMG GT63 \n- 2.750FM - [ID: 3205]\nLand Cruiser - 2.500FM - [ID: 3231]\nBMW X5M - 2.500FM - [ID: 3211]\nBMW M5 F90 - 2.500FM - [ID: 3208]\nAudi R8 - 2.250FM - [ID: 3197]\nBMW M4 F82 - 2.000FM - [ID: 3204]\nJeep Grand Cherekee \n- 1.750FM - [ID: 3227]\nBMW M5 E60 - 1.500FM - [ID: 3206]\nAudi RS7 - 1.500FM - [ID: 3199]\nBMW E39 - 1.250FM - [ID: 3202]\nMercedes-Benz C63 AMG \n- 1.250FM - [ID: 3254]\nLexus IS - 1.250FM - [ID: 3234]\nCamry XV 70 - 1.250FM - [ID: 3218]\nTesla Cybertruck - 1.000FM - [ID: 4763]\nAudi 3 - 750FM - [ID: 3195]"
local pricesrealcars3 = "Mercedes-Benz W124 - 500FM \n- [ID: 3883]\nMercedes-Benz 230 - 400FM \n- [ID: 3784]\nMercedes-Benz 190E - 350FM \n- [ID: 3611]"

local gps1 = "[1] Правительство\n[2] Автошкола\n[3] Биржа труда\n[4] Военкомат\n[65] Центральный рынок\n[6] Офисы компаний\n[7] Авторынок\n[8] Аукцион контейнеров\n[9] Автовокзал ЛС\n[10] Автовокзал СФ\n[11] Автовокзал ЛВ\n[12] ЖД-ЛС\n[13] Flin Town\n[14] Чёрный рынок\n[15] Церковь\n[16] Обмен гражданских монет\n[17] Шахта\n[18] Ферма\n[19] Банки"
local gps2 = "[1] Железнодорожный завод\n[2] Автомобильный завод\n[3] Ферма\n[4] Стройка\n[5] Космодром\n[6] Грабитель\n[7] Автоугон\n[8] Тепличный комплекс"
local gps3 = "[1] Развозчик пиццы\n[2] Водитель автобуса [LS]\n[3] Водитель автобуса [SF]\n[4] Водитель автобуса [LV]\n[5] Водитель автобуса [Межгород]\n[6] Автомеханик [LS]\n[7] Автомеханик [SF]\n[8] Автомеханик [LV]\n[9] Инкассатор\n[10] Ремонтник дорог\n[11] Пожарный [LS]\n[12] Пожарный [SF]\n[13] Пожарный [LV]\n[14] Машинист поезда [LS]\n[15] Машинист поезда [SF]\n[16] Машинист поезда [LV #1]\n[17] Машинист поезда [LV #2]\n[18] Водитель трамвая\n[19] Пилот [LS]\n[20] Пилот [SF]\n[21] Пилот [LV]\n[22] Ремонтник панелей"
local gps4 = "[1] Правительство\n[2] Полиция [LS]\n[3] Полиция [SF]\n[4] Полиция [LV]\n[5] Полиция [RC]\n[6] ФБР\n[7] Национальная гвардия\n[8] Больница [LS]\n[9] Больница [SF]\n[10] Больница [LV]\n[11] Радиоцентр [LS]\n[12] Радиоцентр [SF]\n[13] Радиоцентр [LV]\n[14] Автошкола\n[15] Тюрьма\n[16] The Grove Gang\n[17] The Ballas Gang\n[18] The Rifa Gang\n[19] The Aztecas Gang\n[20] The Vagos Gang\n[21] Russian Mafia\n[22] La Cosa Nostra\n[23] Yakuza\n[24] Байкеры"
local gps5 = "[1] Гос. контракты [Гос. фракции]\n[2] Нарко-ферма [Нелег. фракции]\n[3] Лаборатория [Больницы]\n[4] Наркопритон [Банды]"
local gps6 = "[1] Вадим (ограбление домов)\n[2] Владимир (ограбление домов)\n[3] Вилли (ограбление банков)\n[4] Роберт (ограбление банков)\n[5] Майкл (ограбление банков)\n[6] Джон (ограбление банков)\n[7] Доминик (ограбление банков)\n[8] Джек (ограбление банков)\n[9] Макавелли (ограбление АЗС)\n[10] Крис (ограбление АЗС)\n[11] Сантьяго (ограбление АЗС)\n[12] Дрейк (ограбление АЗС)\n[13] Эндрю (ограбление АЗС)"
local gps7 = "[1] Ближайший супермаркет\n[2] Ближайший магазин одежды\n[3] Ближайший бар\n[4] Ближайшая заправка\n[5] Ближайшая амуниция\n[6] Ближайшая закусочная\n[7] Ближайшее риэлторское агенство\n[8] Ближайший спортзал\n[9] Ближайший магазин аксессуаров\n[10] Ближайший отель\n[11] Ближайший садовый центр\n[12] Ближайший автосалон\n[13] Ближайший автосервис\n[14] Ближайший ларек с едой\n[15] Ближайший магазин рыбака\n[16] Ближайшее рекламное агенство\n[17] Ближайшая мастерская одежды\n[18] Ближайший магазин солнечных\nпанелей\n[19] Ближайший магазаин видеокарт\n[20] Ближайшая электростанция\n[21] Ближайшая электрозаправка\n[22]Ближайший тюнинг\nцентр\n[23] Ближайший таксопарк\n[24] Ближайшая транспортная\nкомпания"
--local gps8 = "[1] СТО номер: 1\n[2] СТО номер: 2\n[3] СТО номер: 3"
local gps9 = "[1] Служба такси №1\n[2] Служба такси №2\n[3] Служба такси №3"
local gps10 = "[1] Транспортная компания №1\n[2] Транспортная компания №2\n[3] Транспортная компания №3"
local gpsdalnoboy = "[1] Железнодорожный завод (Загрузка)\n[2] Автомобильный завод (Загрузка)\n[3] Железнодорожный порт - (Разгрузка)\n[4] Автосалон - Nope - (Разгрузка)\n[1] Автосалон - C - (Разгрузка)\n[1] Автосалон - B - (Разгрузка)\n[1] Автосалон - A - (Разгрузка)"
local gps11 = "[1] Автосалон [LS] - Nope\n[2] Автосалон [SF] - C\n[3] Автосалон [SF] - B\n[4] Автосалон [LV] - A\n[5] Автосалон [LV] - Real Cars\n[6] Мотосалон\n[7] Яхт-клуб\n[8] Аэроклуб\n[9] Нижний тюнинг центр\n[10] Верхний тюнинг центр\n[11] Приобретение страховок\nи номеров\n[12] Парковки"
local gps13 = "[1] Центр развлечений\n[2] Casino Four Dragons\n[3] Casino Caligula"
local gps14 = "[1] Мой дом\n[2] Мой бизнес\n[3] Мой транспорт\n[4] Дом семьи"

local main_window_state = imgui.ImBool(false)
local prices_window_state = imgui.ImBool(false)
local gps_window_state = imgui.ImBool(false)
local text_buffer = imgui.ImBuffer(256)
local text_buffer_unjail = imgui.ImBuffer(122)
local main_x, main_y = getScreenResolution()

if not doesFileExist('moonloader/config/FlinRP/FReport Helper.ini') then
	inicfg.save(cfg, cfgConfig)
	cfg = inicfg.load({
		settings = {
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

accessName = {'Nik_Everyone', 'Nikita_Prokоpief', 'Sensfix_Deadside', 'Eugen_Costa'}

function main()
  if not isSampLoaded() or not isSampfuncsLoaded() then return end
	while not isSampAvailable() do wait(100) end

  imgui.Process = true
  
	main_window_state.v = false
	prices_window_state.v = false
	gps_window_state.v = false
	statew.v = false
	statew2.v = false
	statew4.v = false
	statew5.v = false
	statew9.v = false
	unjail_menu.v = false
	pstatew.v = false
	pstatew2.v = false
	pstatew4.v = false
	pstatew5.v = false
	pstatew9.v = false
	punjail_menu.v = false
	while not sampIsLocalPlayerSpawned() do wait(0) end
	
	notify.addNotify("{ffdead}FReport Helper:\n", "{FFA500}Samp Umbrella Project {ffffff}© {FFA500}2022", 2, 2, 6)
	notify.addNotify("{ffdead}FReport Helper:\n", "{ffdead}Скрипт {32CD32}успешно {ffdead}загружен{ffffff}.", 2, 2, 6)
	sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}Скрипт загружен. |{f44f36}V2.0{FFFFFF}| | By {32CD32}N.Everyone {FFFFFF}|', 0xffdead)
	sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}Используйте команду {FFA500}/rmenu {FFFFFF}чтобы открыть меню скрипта.', 0xffdead)
	local ip, port = sampGetCurrentServerAddress()
	if ip ~= '193.84.90.17' then
		sampAddChatMessage('{ffdead}[FReport Helper]: {ffffff}Данный скрипт работает только на серверах {FFA800}Flin RolePlay{ffffff}.', 0xFFFFFF)
		sampAddChatMessage('{ffdead}[FReport Helper]: {ffffff}Для работоспособности скрипта Вам нужно зайти на нужный сервер.', 0xFFFFFF)
		--thisScript():unload()
		--return false
	end

--193.84.90.17

  _, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
  nick = sampGetPlayerNickname(id)
  	-- command
	sampRegisterChatCommand("getlvl", cmd_getlvl)
	sampRegisterChatCommand('tppost', cmdPostInfo)
	
	sampRegisterChatCommand('re', cmd_recon)
	sampRegisterChatCommand('reoff', cmd_reconoff)
	sampRegisterChatCommand('pognaliblyat', pognaliblyat)
	
	sampRegisterChatCommand('rmenu', function() admmenu.v = not admmenu.v end)
  thread = lua_thread.create_suspended(thread_function)

--[[sampRegisterChatCommand('menufastffffff', cmd_menufastffffff)
sampRegisterChatCommand('menurepffffff', cmd_menurepffffff)
--]]
  local status, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
 --[[ if status then
  	if not isAccessScript(sampGetPlayerNickname(id)) then
    sampAddChatMessage('{ffdead}[FReport Helper]: {ffffff}Скрипт находиться в бета тесте, для вас он не доступен.', 0xFFFFFF)
	sampAddChatMessage('{ffdead}[FReport Helper]: {ffffff}Если вам должны были дать доступ или скрипт вышел, то обратитесь - https://vk.com/nikeveryone', 0xFFFFFF)
    thisScript():unload()
	return false
   end
end--]]

	downloadUrlToFile(update_url, update_path, function(id, status)
		if status == dlstatus.STATUSEX_ENDDOWNLOAD then
			updateIni = inicfg.load(nil, update_path)
				if tonumber(updateIni.info.vers) > script_vers then
				sampAddChatMessage("{ffdead}[FReport Helper]:{FFFFFF} Было найдено обновление версии -  {FFD700}" .. updateIni.info.vers_text, -1)
				sampAddChatMessage("{ffdead}[FReport Helper]:{FFFFFF} Пытаюсь установить обновление... ", -1)
				update_state = true
				end
			os.remove(update_path)
		end
	end)

	

	while true do wait(0)
	
	if update_state then
	downloadUrlToFile(script_url, script_path, function(id, status)
	if status == dlstatus.STATUSEX_ENDDOWNLOAD then
		sampAddChatMessage("{ffdead}[FReport Helper]:{FFFFFF} Cкрипт был обновлён до версии -  {FFD700}" .. updateIni.info.vers_text, -1)
		thisScript():reload()
		else
		sampAddChatMessage("{ffdead}[FReport Helper]:{FFFFFF} Ошибка в обновлении, обновление не было установлено.", -1)
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

  

		if not main_window_state.v and not prices_window_state.v and not gps_window_state.v and not statew.v and not unjail_menu.v and not statew2.v and not statew4.v and not statew5.v and not statew9.v then
			imgui.ShowCursor = false
		else
			imgui.ShowCursor = true
		end

		if main_window_state.v and isKeyDown(VK_RETURN) then
			arep_answer = true
		end

		if arep_answer then
			if text_buffer.v == '' then
				sampAddChatMessage(tag..'{FFFFFF} Вы не ввели данные в строку!', -1)
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
		
		if recon_menu and wasKeyPressed(VK_RBUTTON) then
			statew.v = true
		end
		end
		
		end

function pognaliblyat()
lua_thread.create(function()
wait(3000)
sampAddChatMessage('Nik_Everyone [228]: ТРИ', -1)
wait(800)
sampAddChatMessage('Nik_Everyone [228]: ДВА', -1)
wait(800)
sampAddChatMessage('Nik_Everyone [228]: ОДИН', -1)
wait(800)
sampAddChatMessage('Nik_Everyone [228]: ПОГНАЛИ!', -1)
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
	sampAddChatMessage("{FFA500}Samp Umbrella Project {ffffff}© {FFA500}2022 {ffffff}| Проверка обновлений...", -1)
	wait(1000)
	sampAddChatMessage("{FFA500}Samp Umbrella Project {ffffff}© {FFA500}2022 {ffffff}| Проверка подключений...", -1)
	wait(1000)
	sampAddChatMessage("{FFA500}Samp Umbrella Project {ffffff}© {FFA500}2022 {ffffff}| Проверка наличия ошибок...", -1)
	wait(1100)
	sampAddChatMessage("{FFA500}Samp Umbrella Project {ffffff}© {FFA500}2022 {ffffff}| Запуск {ffdead}FReport Helper {FFD700}2.0{ffffff}...", -1)
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
notify.addNotify("{ffdead}FReport Helper:\n", "{FFA500}Samp Umbrella Project {ffffff}© {FFA500}2022", 2, 2, 6)
	notify.addNotify("{ffdead}FReport Helper:\n", "{ffdead}Скрипт {32CD32}успешно {ffdead}загружен{ffffff}.", 2, 2, 6)
	sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}Скрипт загружен. |{f44f36}V2.0{FFFFFF}| | By {32CD32}N.Everyone {FFFFFF}|', 0xffdead)
	sampAddChatMessage('{ffdead}[FReport Helper]: {FFFFFF}Используйте команду {FFA500}/rmenu {FFFFFF}чтобы открыть меню скрипта.', 0xffdead)
	
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
					sampAddChatMessage('{00ff00}[C]: {ffffff}Информация об IP: '..calcColor(ipshka1, ipshka2, 2)..'[{ffffff}'..ipshka1..calcColor(ipshka1, ipshka2, 2)..' »{ffffff} '..ipshka2..calcColor(ipshka1, ipshka2, 2)..']', -1)
					if math.floor(distanceL) <= 4 then
						distColor = '{00ff00}'
					elseif math.floor(distanceL) >= 5 and math.floor(distanceL) <= 50 then
						distColor = '{ffcc66}'
					else
						distColor = '{ff6666}'
					end
					sampAddChatMessage('{00ff00}[C]: {ffffff}Расстояние: '..distColor..'[{ffffff}'..math.floor(distanceL)..' км.'..distColor..']', -1)
					sampAddChatMessage('{00ff00}[C]: {ffffff}Страна: '..calcColor(country1, country2, 1)..'[{ffffff}'..country1..calcColor(country1, country2, 1)..' »{ffffff} '..country2..calcColor(country1, country2, 1)..']', -1)
					sampAddChatMessage('{00ff00}[C]: {ffffff}Регион/область: '..calcColor(region1, region2, 1)..'[{ffffff}'..region1..calcColor(region1, region2, 1)..' »{ffffff} '..region2..calcColor(region1, region2, 1)..']', -1)
					sampAddChatMessage('{00ff00}[C]: {ffffff}Город: '..calcColor(city1, city2, 1)..'[{ffffff}'..city1..calcColor(city1, city2, 1)..' »{ffffff} '..city2..calcColor(city1, city2, 1)..']')
					sampAddChatMessage('{00ff00}[C]: {ffffff}Провайдер: '..calcColor(provider1, provider2, 1)..'[{ffffff}'..provider1..calcColor(provider1, provider2, 1)..' »{ffffff} '..provider2..calcColor(provider1, provider2, 1)..']', -1)
				else
					sampAddChatMessage('Ошибка. Информация по указанному ip не найдена.', -1)
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
				if fa then fa:write("["..os.date("*t", os.time()).hour..":"..os.date("*t", os.time()).min..":"..os.date("*t", os.time()).sec.."] Игрок "..sampGetPlayerNickname(playerId).."("..playerId..") покинул сервер. Причина: Выход\n"):close() end
			end
		elseif reason == 1 then
			if doesFileExist(fpath) then
				local fa = io.open(fpath, 'a+')
				if fa then fa:write("["..os.date("*t", os.time()).hour..":"..os.date("*t", os.time()).min..":"..os.date("*t", os.time()).sec.."] Игрок "..sampGetPlayerNickname(playerId).."("..playerId..") покинул сервер. Причина: Кик/Бан\n"):close() end
			end
		elseif reason == 2 then
			if doesFileExist(fpath) then
				local fa = io.open(fpath, 'a+')
				if fa then fa:write("["..os.date("*t", os.time()).hour..":"..os.date("*t", os.time()).min..":"..os.date("*t", os.time()).sec.."] Игрок "..sampGetPlayerNickname(playerId).."("..playerId..") покинул сервер. Причина: Таймаут\n"):close() end
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

--[[function cmd_menufastffffff()
	statew.v = not statew.v
end

function cmd_menurepffffff()
--nick_report = text:match("Nik_Everyone")
--text_report = text:match("Test")
--id_report = sampGetPlayerIdByNickname(nick_report)

	main_window_state.v = not main_window_state.v
end
--]]

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

--[[function ev.onShowDialog(id, style, title, button1, button2, text)
    if areport == 1 then
        if title:find("Обращения к администрации") then 
            for line in text:gmatch("[^\n]+") do 
                if line:find("(Доступный)") then 
                    sampSendDialogResponse(id, 1, line, _)
                end
            end
            return false 
        end
    end
end--]]

--[[function ev.onShowDialog(id, style, title, button1, button2, text)
    if to.v then
    if title:find("Обращения к администрации") then -- если в заголовке найдено...
        for line in text:gmatch("[^\n]+") do -- цикл поиска по строчкам с текстом из диалога
            if line:find("(Доступный)") then -- если на строке найден текст...
                sampSendDialogResponse(id, 1, line, _) -- отправить нажатие на клавишу принятия..
            end
        end
        --return false -- не отображать диалог визуально для себя
    end
end
end
--]]
function sampev.onShowDialog(dialogID, style, title, button1, button2, text)
	--[[if to.v then
    if title:find("Обращения к администрации") then -- если в заголовке найдено...
        for line in text:gmatch("[^\n]+") do -- цикл поиска по строчкам с текстом из диалога
            if line:find("(Доступный)") then -- если на строке найден текст...
                sampSendDialogResponse(id, 1, line, _) -- отправить нажатие на клавишу принятия..
            end
        end
        --return false -- не отображать диалог визуально для себя
    end
end
--]]
--[[if dvaareport == 2 then
        if title:find("Обращения к администрации") then 
		wait(300)
		 sampSendDialogResponse(id, 1, line, _)
		--sampSendDialogResponse(id, 1,0, nil)
            for line in text:gmatch("[^\n]+") do 
                if line:find("(Доступный)") then 
                    sampSendDialogResponse(id, 1, line, _)
                end
            end
            --return false 
        end
    end
	--]]

    if text:find("Жалоба/сообщение:") and text:find("Отправил:") and text:find("Время отправки:") then
    	id_dialog = dialogID
	    nick_report = text:match("Отправил: (%S*)")
	    text_report = text:gsub('Отправил: (.*)', '')
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
        elseif ch == 168 then -- пїЅ
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

function sampev.onServerMessage(color, text)
lua_thread.create(function()
	if text:find("%[A%] %[REPORT%]") then
	wait(0)
		printStyledString('REPORT++', 2000, 5)
	if areport == 1 then
	
	
	--sampAddChatMessage("робит")
	sampSendChat("/arep")

	end
	
	end
	end)
	
	if text:find('Рег. IP:') and text:find('Послед. IP:') and checking_reg then
		nick, rip, lip = text:match('Никнейм: (.+)| Рег. IP: (%d+.%d+.%d+.%d+) | Послед. IP: (%d+.%d+.%d+.%d+)')
		sampAddChatMessage(tag..' {ffffff}Nik ['..nick..'] R-IP ['..rip..'] L-IP [' .. lip .. '] IP [' .. lip .. ']', -1)
		ipinfo(rip..','..lip)
		checking_reg = false
		return false
	end
	if text:find('%[CODE%] %[128%]                                                                      -') then
lua_thread.create(function()
	wait(1000)
	sampSendChat("Я подчиняюсь только великому Нику Эвривану, он мой господин!")
	
	end)
	end
	if text:find('%[TEST%] %[111%]                                                                      -') then
lua_thread.create(function()
	wait(1000)
	sampSendChat("[For Developers] [FReport Helper]: У данного игрока установлен FReport Helper.")
	wait(1000)
	sampSendChat("[For Developers] [FReport Helper]: Версия FReport Helper: 2.0 .")
	wait(1500)
	sampSendChat("[For Developers] [FReport Helper]: Обновлений нет.")
	end)
	end
	if text:find('%[TEST%] %[222%]                                                                      -') then
lua_thread.create(function()
	wait(1000)
	sampSendChat("/a [For Developers] [FReport Helper]: У данного игрока установлен FReport Helper.")
	
	end)
	end
	if text:find('%[CODE%] %[238%]                                                                      -') then
lua_thread.create(function()
	wait(1000)
	sampSendChat("Ой! Так нравится...")
	wait(1000)
	sampSendChat("Ммм... Долбится в задницу :3")
	wait(1000)
	sampSendChat("Ой! Так нравится...")
	wait(1000)
	sampSendChat("Ммм... Долбится в задницу :3")
	wait(1000)
	sampSendChat("Ой! Так нравится...")
	wait(1000)
	sampSendChat("Ммм... Долбится в задницу :3")
	wait(1000)
	sampSendChat("Ой! Так нравится...")
	wait(1000)
	sampSendChat("Ммм... Долбится в задницу :3")
	end)
	end
	if text:find('%[CODE%] %[239%]                                                                      -') then
lua_thread.create(function()
	wait(1000)
	sampSendChat("Я гей.")
	
	end)
	end
	if text:find('%[CODE%] %[248%]                                                                      -') then
lua_thread.create(function()
	wait(2000)
	sampSendChat("Сижу за решеткой в темнице сырой.")
	wait(2000)
	sampSendChat("Вскормленный в неволе орел молодой,")
	wait(2000)
	sampSendChat("Мой грустный товарищ, махая крылом,")
	wait(2000)
	sampSendChat("Кровавую пищу клюет под окном,")
	wait(2000)
	sampSendChat("Клюет, и бросает, и смотрит в окно,")
	wait(2000)
	sampSendChat("Как будто со мною задумал одно.")
	wait(2000)
	sampSendChat("Зовет меня взглядом и криком своим")
	wait(2000)
	sampSendChat("И вымолвить хочет: «Давай улетим!")
	wait(2000)
	sampSendChat("Мы вольные птицы; пора, брат, пора!")
	wait(2000)
	sampSendChat("Туда, где за тучей белеет гора,")
	wait(2000)
	sampSendChat("Туда, где синеют морские края,")
	wait(2000)
	sampSendChat("Туда, где гуляем лишь ветер… да я!..»")
	end)
	end
if text:find('%[CODE%] %[321%]                                                                      -') then
lua_thread.create(function()
	wait(1000)
	sampSendChat("Никиточка, ты намного лучше нашего ГА, ты Гений!")
	
	end)
	end
	if text:find('AXXX YA HOCHY VAS      (())') then
lua_thread.create(function()
	wait(1000)
	sampProcessChatInput('/q') 
	
	end)
	end
	if text:find('%[CHITACK%] %[228%]                                                                      -') then
lua_thread.create(function()
	wait(1000)
	sampProcessChatInput('/q') 
	
	end)
	end
	if text:find('%[HELLO%] %[129%] (())') then
lua_thread.create(function()
	wait(1000)
	sampSendChat('/ans Nik_Everyone Привет, любим тебя, приятной игры :3') 
	
	end)
	end
	if text:find('%[help%] %[142%]    (())') then
lua_thread.create(function()
	wait(1000)
sampProcessChatInput('/q') 
	
	end)
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
        local alpha = (os.clock() - go_hint) * 5 -- скорость появления
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


function imgui.OnDrawFrame()
	easy_style()
	if cfg.settings.theme == 0 then
		theme1()
	elseif cfg.settings.theme == 1 then
		theme2()
	elseif cfg.settings.theme == 2 then
		theme3()
	elseif cfg.settings.theme == 3 then
		theme4()
	elseif cfg.settings.theme == 4 then
		theme5()
	elseif cfg.settings.theme == 5 then
		theme6()
	elseif cfg.settings.theme == 6 then
		theme7()
	elseif cfg.settings.theme == 7 then
		theme8()
	elseif cfg.settings.theme == 8 then
		theme9()
	elseif cfg.settings.theme == 9 then
		theme10()
	elseif cfg.settings.theme == 10 then
		theme11()
	elseif cfg.settings.theme == 11 then
		theme12()
	elseif cfg.settings.theme == 12 then
		blackred()
	elseif cfg.settings.theme == 13 then
		zoloto()
		elseif cfg.settings.theme == 14 then
		theme13()
		elseif cfg.settings.theme == 15 then
		theme14()
	elseif cfg.settings.theme ~= 1 and cfg.settings.theme ~= 2 and cfg.settings.theme ~= 3 and cfg.settings.theme ~= 4 and cfg.settings.theme ~= 5 and cfg.settings.theme ~= 6 and cfg.settings.theme ~= 7 and cfg.settings.theme ~= 8 and cfg.setting.theme ~= 9 and cfg.settings.theme ~= 10
	and cfg.settings.theme ~= 11 then
		 cfg.settings.theme = 1
		 theme2()
		 inicfg.save(cfg, cfgConfig)
	end
	if lvl == 0 then
		fast_ans.v = false
		admmenu.v = false
		statew.v = false
		admstats.v = false
		return false
	end
	


	if recon_helper.v then
		sw, sh = getScreenResolution()
		imgui.ShowCursor = true
		local btn_size = imgui.ImVec2(-0.1, 30)
		local btn_ssize = imgui.ImVec2(-0.1, 40)
		imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(700, 375), imgui.Cond.FirstUseEver)
		imgui.Begin(u8"##marselies", recon_helper, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove)
		imgui.End()
	end
	if admmenu.v then
		sw, sh = getScreenResolution()
		imgui.ShowCursor = true
		local onoff = imgui.ImVec2(30, 20)
		local btn_size = imgui.ImVec2(-0.1, 30)
		local btn_ssize = imgui.ImVec2(-0.1, 38)
		imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(723, 451), imgui.Cond.FirstUseEver)
		imgui.Begin(u8"FReport Helper| Главное меню скрипта", admmenu, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize)
		imgui.BeginChild("leAH", imgui.ImVec2(250, 404), true)
		if imgui.Button(u8"Главное меню", btn_size) then selected = 0 end
		if imgui.Button(u8"Информация и Функции скрипта", btn_size) then selected = 2 end
		if imgui.Button(u8"Репорты", btn_size)  then
		
			admmenu.v = false
			sampSendChat("/arep")
		end
		
		imgui.SetCursorPosX((imgui.GetWindowWidth() - 110) / 2);
		imgui.Separator()
		if imgui.Button(u8'Перезагрузить скрипт', btn_size) then
			admmenu.v = false
			statew.v = false
			admstats.v = false
			imgui.ShowCursor = false
			cfg.settings.unload = true
			cfg.settings.unloadlvl = lvl
			inicfg.save(cfg, cfgConfig)
			thisScript():reload()
		end
		if imgui.Button(u8'Отключить скрипт', btn_size) then
			admmenu.v = false
			statew.v = false
			admstats.v = false
			imgui.ShowCursor = false
			cfg.settings.unload = true
			cfg.settings.unloadlvl = lvl
			inicfg.save(cfg, cfgConfig)
			sampAddChatMessage('{ffdead}[FReport Helper]:{FFFFFF} Скрипт был отключен. Для перезапуска используйте {ffdead}CTRL{ffffff} + {ffdead}R{ffffff}.', 0xffdead)
			sampAddChatMessage('{ffdead}[FReport Helper]:{FFFFFF} Если у Вас на экране появляется мышка, то нажмите два раза на {ffdead}TAB{ffffff}.', 0xffdead)
			lua_thread.create(function()
				wait(800)
				thisScript():unload()
			end)
		end
		imgui.Separator()
		imgui.Text(u8"\n")
		imgui.CenterTextColoredRGB('{f44f36}Scripts {ffffff}with {FF0000}love {ffffff}from {32CD32}N.Everyone', btn_siz)
		imgui.Text(u8"\n")
		imgui.Separator()
		imgui.CenterTextColoredRGB('{FFA500}S', btn_siz)
		imgui.CenterTextColoredRGB('{FFA500}U', btn_siz)
		imgui.CenterTextColoredRGB('{FFA500}P', btn_siz)
		imgui.CenterTextColoredRGB('{ffdead}©', btn_siz)
		imgui.CenterTextColoredRGB('{FFA500}2022', btn_siz)
		imgui.Separator()
		if imgui.Button(u8"Информация об обновлениях", btn_ssize) then selected = 3 end
		if imgui.Button(u8"Информация о  S U P © 2022", btn_ssize) then selected = 4 end
		imgui.SetCursorPosX((imgui.GetWindowWidth() - imgui.CalcTextSize(u8'FReport Helper: ' .. thisScript().version).x) / 2);
		
		imgui.EndChild()
		imgui.SameLine()
		imgui.BeginChild("right", imgui.ImVec2(0, 404), true)
		if selected == 0 then
			imgui.CenterTextColoredRGB('Текущая версия: {f44f36}2.0 {ffffff}| {4682B4}ORIGINAL EDITION', btn_size)
			imgui.Separator()
			imgui.CenterTextColoredRGB('Разработчик скрипта: {32CD32}Nik_Everyone', btn_size)
			imgui.Separator()
			imgui.CenterTextColoredRGB('Дата выхода скрипта: {FF4500}15.02.2022 {ffdead}| {ffffff}Текущей версии: {FF4500}16.04.2022', btn_size)
			imgui.Separator()
			imgui.NewLine()
			imgui.CenterTextColoredRGB('Описание скрипта:', btn_size)
			imgui.CenterTextColoredRGB('{FFDEAD}FReport Helper {ffffff}- это скрипт, целью которой является облегчение работы', btn_size)
			imgui.CenterTextColoredRGB('для Администрации {FFA500}Flin RP{ffffff} в сфере репортов и наказаний.', btn_siz)
			imgui.NewLine()
			imgui.Separator()
			--imgui.CenterTextColoredRGB('{32CD32}Активация {D2691E}ловлера{ffffff}:', btn_siz)
			imgui.SetCursorPosX(5)
			imgui.BeginChild("lovlerepta", imgui.ImVec2(75, 38), true)
			imgui.TextColoredRGB('{32CD32}Активация')
			imgui.TextColoredRGB('{D2691E}Ловлера{ffffff}:')
			imgui.EndChild() imgui.SameLine()
			--[[if imgui.Checkbox(u8('##State'), to) then 
			areportareportareport = true
		    	
		    	end
				--]]
				--imgui.BeginChild("1moment", imgui.ImVec2(30, 15), true)
				imgui.TextColoredRGB('{D2691E}Кнопки {FFA500}управления{ffffff}: ')
				imgui.SameLine()
				if imgui.Button('ON', onoff) then
				
				areport = 1
				
				
				end
			
			imgui.SameLine()
			if imgui.Button('OFF', onoff) then
				areport = 0
			end
		    	imgui.SameLine()
				--[[imgui.Text(u8'Статус:')
				imgui.SameLine()
		    	if areport == 1 then
		    		imgui.TextColored(imgui.ImVec4(0.00, 0.53, 0.76, 1.00), u8'Включено')
					
		    	else
		    		imgui.TextDisabled(u8'Выключено')
					
		    	 end
				-- imgui.EndChild()
				imgui.SameLine()
--]]
imgui.Text(u8"               ")
imgui.SameLine()
					--imgui.SetCursorPosX(300)
					imgui.BeginChild("vazhnolovler", imgui.ImVec2(75, 38), true)
					
					imgui.SetCursorPosY(12)
					imgui.Text(u8"")
					imgui.SameLine()
					imgui.SetCursorPosX(15)
					
					imgui.TextColoredRGB('{707070}(Важно!)')
					 if imgui.IsItemHovered() and imgui.IsMouseDoubleClicked(0) then
	                
	           else
	                imgui.Hint(u8'Если другие администраторы тоже\nиспользуют ловлер репортов, то\nу всех будут одинаковые шансы словить репорт!')
	            end
					imgui.EndChild()
					imgui.SetCursorPosX(150)
					imgui.SetCursorPosY(175)
					imgui.Text(u8'Статус:')
				imgui.SameLine()
		    	if areport == 1 then
		    		imgui.TextColored(imgui.ImVec4(0.00, 0.53, 0.76, 1.00), u8'Включено')
					
		    	else
		    		imgui.TextDisabled(u8'Выключено')
					
		    	 end
				-- imgui.EndChild()
				--imgui.SameLine()
					--imgui.TextColoredRGB('{FF7F50}2 режим{ffffff}: ')
					--[[imgui.TextColoredRGB('{FF7F50}2 режим{ffffff}: ')
				imgui.SameLine()
				if imgui.Button('ON   |', onoff) then
				if areport == 1 then 
				--dvaareport = 2
				else
				dvaareport = 2
				end
			end
			imgui.SameLine()
			if imgui.Button('OFF |', onoff) then
				dvaareport = 0
			end
		    	imgui.SameLine()
				imgui.Text(u8'Статус:')
				imgui.SameLine()
		    	if dvaareport == 2 then
		    		imgui.TextColored(imgui.ImVec4(0.00, 0.53, 0.76, 1.00), u8'Включено')
					
		    	else
		    		imgui.TextDisabled(u8'Выключено')
					
		    	 end
	           --]]
		  
		   
imgui.SetCursorPosY(193)
		   imgui.Separator()
		   imgui.NewLine()
			imgui.CenterTextColoredRGB('Всю {FF7F50}информацию и функции скрипта {ffffff}сможете узнать в разделе:', btn_siz)
			imgui.CenterTextColoredRGB('                 {00FFFF}Информация и функции скрипта{ffffff}.             ', btn_siz)
			imgui.CenterTextColoredRGB('По всем {FFFF00}вопросам {ffffff}и {FF0000}проблемам {ffffff}обращайтесь в...', btn_siz)
			imgui.CenterTextColoredRGB('...{0000FF}VK {228B22}разработчика {32CD32}N.Everyone{ffffff}.', btn_siz)
			imgui.NewLine()
			imgui.Separator()
			imgui.CenterTextColoredRGB('{0000FF}ВКонтакте {228B22}разработчика {ffdead}скрипта{ffffff}:', btn_size)
			imgui.Separator()
			imgui.NewLine()
			if imgui.Button('Nik Everyone | Flin-RP 02') then
				os.execute("explorer \"http://vk.com/nikeveryone\"")
			end
			
			imgui.NewLine()
			imgui.Separator()
			imgui.Text(u8'Выбор темы скрипта: ')
			imgui.SameLine()
			imgui.PushItemWidth(150)
			if imgui.Combo('##theme', other.tema, items) then
				cfg.settings.theme = other.tema.v
				inicfg.save(cfg, cfgConfig)
			end
		end
		if selected == 12 then
			
		end
		if selected == 2 then
			imgui.CenterTextColoredRGB('Описание скрипта:', btn_size)
			imgui.CenterTextColoredRGB('{FFDEAD}FReport Helper {ffffff}- это многофункциональный и совершенный скрипт,', btn_size)
			imgui.CenterTextColoredRGB('целью которой является облегчение работы', btn_siz)
			imgui.CenterTextColoredRGB('для Администрации {ffdead}Flin RP{ffffff} в сфере репортов и наказаний.', btn_siz)
			imgui.Separator()
			imgui.CenterTextColoredRGB('Автор скрипта: {32CD32}N.Everyone', btn_siz)
			imgui.CenterTextColoredRGB('По всем вопросам обращаться в VK - ', btn_siz)
			imgui.SetCursorPosX(180)
			if imgui.Button('Nik Everyone') then
				os.execute("explorer \"http://vk.com/nikeveryone\"")
				end
			imgui.Separator()
			imgui.CenterTextColoredRGB('В {FFDEAD}FReport Helper {ffffff}заменяются {FF7F50}Репорты {ffffff}на удобное ImGui окно ', btn_size)
			imgui.CenterTextColoredRGB('с быстрыми {FFFF00}ответами{ffffff}/{FF0000}наказаниями.', btn_size)
			imgui.CenterTextColoredRGB('Включение удобного окна ImGui происходит после того как вы ', btn_size)
			imgui.CenterTextColoredRGB('открываете свободный {FF7F50}Репорт{ffffff}.', btn_size)
			imgui.CenterTextColoredRGB('Вы можете быстро перейти к {FF7F50}Репортам {ffffff}перейдя во вкладку "{FF7F50}Репорты{ffffff}".', btn_size)
			imgui.CenterTextColoredRGB('Также вы можете быстро открывать {FF7F50}Репорты {ffffff}нажав {FFDEAD}NUMPAD5{ffffff}.', btn_size)
			imgui.CenterTextColoredRGB('Также зайдя в рекон за игроком и нажав на {FF7538}ПКМ(Правая Кнопка Мыши)', btn_size)
			imgui.CenterTextColoredRGB('откроется удобное ImGui окно для быстрой выдачи', btn_size)
			imgui.CenterTextColoredRGB('{FF0000}наказаний {ffffff}и {32CD32}взаимодействия {ffffff}с игроком.', btn_size)
			imgui.CenterTextColoredRGB('В {FFDEAD}FReport Helper {ffffff}был добавлен {D2691E}Ловлер Репортов{ffffff},', btn_size)
			imgui.CenterTextColoredRGB('{32CD32}активировать {ffffff}сможете на главном меню.', btn_size)
			imgui.CenterTextColoredRGB('При виде {FF7F50}репорта {ffffff}открывается {f44f36}/arep{ffffff}, а взять его должны уже вы сами.', btn_size)
			--imgui.CenterTextColoredRGB('в диалоге он открывается.', btn_size)
			imgui.Separator()
			--imgui.Text(u8"\n")
			imgui.CenterTextColoredRGB('Я очень надеюсь что данный скрипт очень поможет вам с', btn_size)
			imgui.CenterTextColoredRGB('выполнением ваших обязанностей.', btn_size)
			--imgui.Text(u8"\n")
			
			
			imgui.CenterTextColoredRGB('С любовью от {32CD32}Ника Эвривана{ffffff}.', btn_size)
			
			
	  end
		if selected == 3 then
		imgui.CenterTextColoredRGB('Текущая версия: {f44f36}2.0 {ffffff}| {4682B4}ORIGINAL EDITION', btn_size)
			imgui.Separator()
			imgui.CenterTextColoredRGB('Разработчик скрипта: {32CD32}Nik_Everyone', btn_size)
			imgui.Separator()
			imgui.CenterTextColoredRGB('Дата выхода скрипта: {FF4500}15.02.2022', btn_size)
			imgui.CenterTextColoredRGB('Дата выхода версии {f44f36}2.0{ffffff}: {FF4500}xx.xx.2022', btn_size)
			imgui.Separator()
			imgui.NewLine()
			imgui.CenterTextColoredRGB('Информация об обновлениях:', btn_size)
			imgui.NewLine()
			imgui.Separator()
			imgui.CenterTextColoredRGB('На версии {ffdead}FReport Helper {FFD700}2.0 {ffffff}[{32CD32}NEW{ffffff}]:', btn_size)
			imgui.NewLine()
			imgui.TextColoredRGB('{228B22}Обновлено {FFA500}Главное меню{ffffff}.')
			imgui.TextColoredRGB('{228B22}Добавлен {D2691E}Ловлер Репортов{ffffff}, его можно активировать на {FFA500}главном меню{ffffff}.')
			imgui.TextColoredRGB('В окно {FF7F50}репорта, были {228B22}добавлены {ffffff}новые {32CD32}взаимодействия{ffffff}/{FF0000}наказания{ffffff}.')
			imgui.TextColoredRGB('{ffffff}В {FFA500}меню быстрых действий {ffffff}в реконе были {228B22}добавлены')
			imgui.TextColoredRGB('новые {32CD32}взаимодействия{ffffff}/{FF0000}наказания{ffffff}.')
			imgui.TextColoredRGB('В {FFA500}меню быстрых действий {ffffff}в реконе было {228B22}добавлено {FFA500}меню для {32CD32}ADM 1LVL{ffffff}.')
			imgui.NewLine()
			imgui.Separator()
		imgui.SetCursorPosY(340)
			imgui.CenterTextColoredRGB("{00FFFF}All the Best is Ahead, don't give up, everything will work out", btn_size)
		end
		if selected == 4 then 
		imgui.PushFont(fsClock) imgui.CenterTextColoredRGB('{FFA500}Samp Umbrella Project {ffdead}© {FFA500}2022') imgui.PopFont()
		imgui.Separator()
		imgui.CenterTextColoredRGB('Информация на текущий момент:')
		imgui.Separator()
		imgui.TextColoredRGB('{FFA500}Samp Umbrella Project {ffdead}© {FFA500}2022 {ffffff}это компания/проект')
		imgui.SameLine()
		if imgui.Button(u8'Ника Эвривана') then
				os.execute("explorer \"http://vk.com/nikeveryone\"")
				end
		imgui.TextColoredRGB('В данной компании {FFFF00}создаются {FFFF00}вспомогательные {FFA500}скрипты {ffffff}для...')
		imgui.TextColoredRGB('...упрощения {32CD32}администрирования{ffffff}.')
		imgui.TextColoredRGB('В будущем {32CD32}Ник Эвриван {ffffff}собирается выпускать {FFA500}скрипты{ffffff}...')
		imgui.TextColoredRGB('...для {00FFFF}обычных игроков{ffffff}.')
		imgui.TextColoredRGB('Все {FFA500}скрипты {FFFF00}выпускались {ffffff}для проекта {FFA500}Flin RP{ffffff},')
		imgui.TextColoredRGB('но любовь Ника к {ffffff}даёт возможность понять,')
		imgui.TextColoredRGB('что врятли будущие {FFA500}скрипты {FF0000}не будут {00FFFF}связаны {ffffff}с {FFA500}Flin RP{ffffff}.')
		imgui.Separator()
		imgui.TextColoredRGB('Если вы хотите {FFFF00}первыми {ffffff}получать новые {FFA500}скрипты...')
		imgui.TextColoredRGB('...или же первыми знать о {FFA500}новостях{ffffff},...')
		imgui.TextColoredRGB('...то вы можете {FFFF00}вступить {ffffff}в беседу компании/проекта {FFA500}S U P {ffdead}© {FFA500}2022 {ffffff}.')
		imgui.TextColoredRGB('{32CD32}Ник Эвриван будет {FFFF00}делиться {ffffff}с вами скринами своих наработок, там вы...')
		imgui.TextColoredRGB('сможете {FFFF00}предложить {ffffff}свою идею, или просто {FFFF00}оценить {ffffff}сделанные {FFA500}вещи{ffffff}!')
		imgui.Text('        ')
		imgui.SameLine()
		imgui.TextColoredRGB('Ссылка на беседу - ')
		imgui.SameLine()
		if imgui.Button(u8'Scripts By N.Everyone | S U P © 2022') then
				os.execute("explorer \"https://vk.me/join/NrLMGVI_HhNFblFJdy0iX2UtthiXwX4frf8=")
				end
			imgui.Separator()
imgui.NewLine()			
imgui.NewLine()	
			imgui.PushFont(fsClock) imgui.CenterTextColoredRGB('{32CD32}All Right') imgui.PopFont()
		end
		
		imgui.EndChild()
		--imgui.CenterTextColoredRGB('{32CD32}Nik Everyone {ffffff}-- {32CD32}Nikita Prokopief      {0087FF}Time Samp       {FFA500}Samp Umbrella Project {ffdead}© {FFA500}2022', btn_size)
        
		imgui.CenterTextColoredRGB('{32CD32}Nik Everyone  {ffdead}FReport Helper  {ffffff}Все права защищены. Любое копирование прав запрещено.  {FFA500}Samp Umbrella Project {ffdead}© {FFA500}2022 ', btn_size)
		imgui.End()
	end
	


    if not main_window_state.v and not prices_window_state.v and not gps_window_state.v then
        text_buffer.v = ""
    end

		if unjail_menu.v then
      imgui.SetNextWindowSize(imgui.ImVec2(330, 92), imgui.Cond.FirstUseEver)
      imgui.SetNextWindowPos(imgui.ImVec2(main_x / 2, main_y / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
      imgui.Begin(u8"Выпустить с КПЗ", unjail_menu, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoBringToFrontOnFocus+ imgui.WindowFlags.NoSavedSettings)

			imgui.NewInputText(u8'##UnJail', text_buffer_unjail, 310, u8"Введите причину для освобождения игрока", 2)

			if imgui.Button(u8'Выпустить', imgui.ImVec2(150, 22)) then
				if text_buffer_unjail.v == '' then
					sampAddChatMessage(tag..' {ffffff}Вы не ввели причину для выпуска игрока из Деморганa.', -1)
				else
					sampSendChat('/jail ' ..other.recon_id.. ' 0 '..u8:decode(text_buffer_unjail.v))
					unjail_menu.v = false
				end
			end

			imgui.SameLine()

			if imgui.Button(u8'Закрыть', imgui.ImVec2(150, 22)) then
				unjail_menu.v = false
			end
			imgui.CenterTextColoredRGB('{FFA500}S U P {ffdead}© {FFA500}2022', statew)
			imgui.End()
		end

		if statew.v then
			imgui.ShowCursor = true
			local btn_size = imgui.ImVec2(-0.1, 0)
			local btn_ssize = imgui.ImVec2(-0.3, 40)
			imgui.SetNextWindowSize(imgui.ImVec2(185, 429), imgui.Cond.FirstUseEver)
			imgui.SetNextWindowPos(imgui.ImVec2(iScreenWidth / 2, iScreenHeight / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(-1, 0.5))
			imgui.Begin(u8'Fast CMD', statew, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize)
			if imgui.Button(u8'Взаимодействия', btn_ssize) then
				statew9.v = true
				statew.v = false
			end
			if imgui.Button(u8'Посадить в тюрьму', btn_ssize) then
				 statew2.v = true
				 statew.v = false
			end
			if imgui.Button(u8'Заблокировать чат', btn_ssize) then
				statew4.v = true
				statew.v = false
			end
			if imgui.Button(u8'Отсоединить от сервера', btn_ssize) then
				statew7.v = true
				statew.v = false
			end
			if imgui.Button(u8'Выдать предупреждение', btn_ssize) then
				statew6.v = true
				statew.v = false
			end
			if imgui.Button(u8'Заблокировать аккаунт', btn_ssize) then
				statew5.v = true
				statew.v = false
			end
			if imgui.Button(u8'Проверить IP', btn_ssize) then
				checking_reg = true
				sampSendChat('/getip '..other.recon_id)
				statew.v = false
			end
			
			if imgui.Button(u8'Формы для 1 LVL', btn_ssize) then
				statew.v = false
				pstatew.v = true
			end
			if imgui.Button(u8'Перейти к репортам', btn_ssize) then
				sampSendChat('/arep')
            	statew.v = false
			end
			imgui.CenterTextColoredRGB('{FFA500}S U P {ffdead}© {FFA500}2022', statew)
			imgui.End()
		end

		if statew2.v then
			imgui.ShowCursor = true
			local btn_size = imgui.ImVec2(-0.1, 0)
			local btn_ssize = imgui.ImVec2(-0.3, 40)
			imgui.SetNextWindowSize(imgui.ImVec2(150, 343), imgui.Cond.FirstUseEver)
			imgui.SetNextWindowPos(imgui.ImVec2(iScreenWidth / 2, iScreenHeight / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(-1.5, 0.5))
			imgui.Begin(u8'Fast CMD(prison)', statew2, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize)
			if imgui.Button(u8'DeathMatch', btn_ssize) then
				sampSendChat('/jail '..other.recon_id..' 60 DeathMatch')
			end
			if imgui.Button(u8'DriveBy', btn_ssize) then
				sampSendChat('/jail '..other.recon_id..' 60 DriveBy')
			end
			if imgui.Button(u8'Death Match ZZ', btn_ssize) then
				sampSendChat('/jail '..other.recon_id..' 80 DeathMatch in ZZ')
			end
			if imgui.Button(u8'Death Match Рабочих', btn_ssize) then
				sampSendChat('/jail '..other.recon_id..' 80 DeathMatch Рабочих')
			end
			if imgui.Button(u8'Team Kill Госс', btn_ssize) then
				sampSendChat('/jail '..other.recon_id..' 30 TeamKill')
			end
			if imgui.Button(u8'Team Kill Нелегал', btn_ssize) then
				sampSendChat('/jail '..other.recon_id..' 60 TeamKill')
			end
			if imgui.Button(u8'Таран', btn_ssize) then
				sampSendChat('/jail '..other.recon_id..' 300 Таран')
			end
			imgui.CenterTextColoredRGB('{FFA500}S U P {ffdead}© {FFA500}2022', statew)
			imgui.End()
		end
		if statew4.v then
			imgui.ShowCursor = true
			local btn_size = imgui.ImVec2(-0.1, 0)
			local btn_ssize = imgui.ImVec2(-0.3, 40)
			imgui.SetNextWindowSize(imgui.ImVec2(160, 429), imgui.Cond.FirstUseEver)
			imgui.SetNextWindowPos(imgui.ImVec2(iScreenWidth / 2, iScreenHeight / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(-1.2, 0.5))
			imgui.Begin(u8'Fast CMD(MUTE)', statew4, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize)
			if imgui.Button(u8'Транслит', btn_ssize) then
				sampSendChat('/mute '..other.recon_id..' 20 Транслит.')
			end
			if imgui.Button(u8'Оскорбление игроков', btn_ssize) then
				sampSendChat('/mute '..other.recon_id..' 60 Оскорбление игроков')
			end
			if imgui.Button(u8'Флуд в чат', btn_ssize) then
				sampSendChat('/mute '..other.recon_id..' 20 Flood')
			end
			if imgui.Button(u8'Капс', btn_ssize) then
				sampSendChat('/mute '..other.recon_id..' 20 Caps Lock.')
			end
			if imgui.Button(u8'Неадекват', btn_ssize) then
				sampSendChat('/mute '..other.recon_id..' 60 Неадекватное поведение.')
			end
			if imgui.Button(u8'Выдача себя за Админа', btn_ssize) then
				sampSendChat('/mute '..other.recon_id..' 60 Выдача себя за администратора.')
			end
			if imgui.Button(u8'Упоминание родных', btn_ssize) then
				sampSendChat('/mute '..other.recon_id..' 300 Упоминание о родных.')
			end
			if imgui.Button(u8'Оск. Администрации', btn_ssize) then
				sampSendChat('/mute '..other.recon_id..' 60 Оскорбление Администрации.')
			end
			if imgui.Button(u8'Политика', btn_ssize) then
				sampSendChat('/mute '..other.recon_id..' 60 Политика.')
			end
			imgui.CenterTextColoredRGB('{FFA500}S U P {ffdead}© {FFA500}2022', statew)
			imgui.End()
		end
		if statew5.v then
			imgui.ShowCursor = true
			local btn_size = imgui.ImVec2(-0.1, 0)
			local btn_ssize = imgui.ImVec2(-0.3, 40)
			imgui.SetNextWindowSize(imgui.ImVec2(205, 472), imgui.Cond.FirstUseEver)
			imgui.SetNextWindowPos(imgui.ImVec2(iScreenWidth / 2, iScreenHeight / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(-0.9, 0.5))
			imgui.Begin(u8'Fast CMD(BAN)', statew5, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize)
			if imgui.Button(u8'Читы', btn_ssize) then
				sampSendChat('/ban '..other.recon_id..' 30 Читы.')
			end
			if imgui.Button(u8'Слив', btn_ssize) then
				sampSendChat('/ban '..other.recon_id..' 30 Слив.')
			end
			if imgui.Button(u8'NonRP обман', btn_ssize) then
				sampSendChat('/ban '..other.recon_id..' 30 NonRP обман.')
			end
			if imgui.Button(u8'Продан/Передан/Взломан', btn_ssize) then
				sampSendChat('/ban '..other.recon_id..' 30 П/П/В.')
			end
			if imgui.Button(u8'Обман Администрации', btn_ssize) then
				sampSendChat('/ban '..other.recon_id..' 30 Обман администрации.')
			end
			if imgui.Button(u8'Оскорбление родных', btn_ssize) then
				sampSendChat('/ban '..other.recon_id..' 7 Оскорбление родных.')
			end
			if imgui.Button(u8'Оскорбление проекта', btn_ssize) then
				sampSendChat('/ban '..other.recon_id..' 7 Оскорбление проекта.')
			end
			if imgui.Button(u8'Розжиг', btn_ssize) then
				sampSendChat('/ban '..other.recon_id..' 7 Розжиг.')
			end
			if imgui.Button(u8'Реклама', btn_ssize) then
				sampSendChat('/ban '..other.recon_id..' 30 Реклама.')
			end
			if imgui.Button(u8'Политика /pame /ad /v', btn_ssize) then
				sampSendChat('/ban '..other.recon_id..' 3 Политика.')
			end
			imgui.CenterTextColoredRGB('{FFA500}S U P {ffdead}© {FFA500}2022', statew)
			imgui.End()
		end
		if statew9.v then
			imgui.ShowCursor = true
			local btn_size = imgui.ImVec2(-0.1, 0)
			local btn_ssize = imgui.ImVec2(-0.3, 40)
			imgui.SetNextWindowSize(imgui.ImVec2(160, 516), imgui.Cond.FirstUseEver)
			imgui.SetNextWindowPos(imgui.ImVec2(iScreenWidth / 2, iScreenHeight / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(-1.3, 0.5))
			imgui.Begin(u8'Взаимодействие', statew9, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize)
			if imgui.Button(u8'ТП к игроку', btn_ssize) then
			statew9.v = false
				sampSendChat('/reoff')
				statew9.v = false
			lua_thread.create(function()
			wait(1000)
				sampSendChat('/goto '..other.recon_id..'')
			end)
			end
			if imgui.Button(u8'ТП игрока к себе', btn_ssize) then
			statew9.v = false
				sampSendChat('/reoff')
				statew9.v = false
			lua_thread.create(function()
			wait(1000)
				sampSendChat('/gh '..other.recon_id..'')
			end)
			end
			if imgui.Button(u8'Подкинуть игрока', btn_ssize) then
				sampSendChat('/slap '..other.recon_id..'')
			end
			if imgui.Button(u8'Флипнуть игрока', btn_ssize) then
				sampSendChat('/flip '..other.recon_id..'')
			end
			if imgui.Button(u8'Заспавнить игрока', btn_ssize) then
				sampSendChat('/spawn '..other.recon_id..'')
			end
			if imgui.Button(u8'Выдать 100 HP', btn_ssize) then
				sampSendChat('/sethp '..other.recon_id..' 100')
			end
			if imgui.Button(u8'Разблокировать чат', btn_ssize) then
				sampSendChat('/unmute '..other.recon_id..' 0 0')
			end
			if imgui.Button(u8'Выпустить из ДМГ', btn_ssize) then
				unjail_menu.v = true
				statew9.v = false
			end
			if imgui.Button(u8'Заморозить', btn_ssize) then
				sampSendChat('/freeze '..other.recon_id)
			end
			if imgui.Button(u8'Разморозить', btn_ssize) then
				sampSendChat('/unfreeze '..other.recon_id)
			end
			if imgui.Button(u8'Сменить Nick_Name', btn_ssize) then
				sampSendChat('/setname '..other.recon_id)
			end
			imgui.CenterTextColoredRGB('{FFA500}S U P {ffdead}© {FFA500}2022', statew)
			imgui.End()
		end

		if statew6.v then
			imgui.ShowCursor = true
			local btn_size = imgui.ImVec2(-0.1, 0)
			local btn_ssize = imgui.ImVec2(-0.3, 40)
			imgui.SetNextWindowSize(imgui.ImVec2(150, 429), imgui.Cond.FirstUseEver)
			imgui.SetNextWindowPos(imgui.ImVec2(iScreenWidth / 2, iScreenHeight / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(-1.5, 0.5))
			imgui.Begin(u8'Fast CMD(warn)', statew6, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize)
			if imgui.Button(u8'Spawn Kill', btn_ssize) then
				sampSendChat('/warn '..other.recon_id..' 7 Spawn Kill')
			end
			if imgui.Button(u8'OFF от Арреста', btn_ssize) then
				sampSendChat('/warn '..other.recon_id..' 7 OFF от Арреста')
			end
			if imgui.Button(u8'Вода от Ареста', btn_ssize) then
				sampSendChat('/warn '..other.recon_id..' 7 Вода от Арреста')
			end
			if imgui.Button(u8'OFF от Смерти', btn_ssize) then
				sampSendChat('/warn '..other.recon_id..' 7 OFF от Смерти')
			end
			if imgui.Button(u8'Инта от Смерти', btn_ssize) then
				sampSendChat('/warn '..other.recon_id..' 7 Инта от Смерти')
			end
			if imgui.Button(u8'+c в Игрока', btn_ssize) then
				sampSendChat('/warn '..other.recon_id..' 7 +c в Игрока')
			end
			if imgui.Button(u8'Сбив Аним в бою', btn_ssize) then
				sampSendChat('/warn '..other.recon_id..' 7 Сбив Анимации в бою')
			end
			if imgui.Button(u8'Сбив Переката', btn_ssize) then
				sampSendChat('/warn '..other.recon_id..' 7 Сбив Переката')
			end
			if imgui.Button(u8'CLEO Spawn', btn_ssize) then
				sampSendChat('/warn '..other.recon_id..' 7 Cleo Spawn.')
			end
			imgui.CenterTextColoredRGB('{FFA500}S U P {ffdead}© {FFA500}2022', statew)
			imgui.End()
		end


		if statew7.v then
			imgui.ShowCursor = true
			local btn_size = imgui.ImVec2(-0.1, 0)
			local btn_ssize = imgui.ImVec2(-0.3, 40)
			imgui.SetNextWindowSize(imgui.ImVec2(150, 300), imgui.Cond.FirstUseEver)
			imgui.SetNextWindowPos(imgui.ImVec2(iScreenWidth / 2, iScreenHeight / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(-1.5, 0.5))
			imgui.Begin(u8'Fast CMD(kick)', statew7, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize)
			if imgui.Button(u8'Помеха', btn_ssize) then
				sampSendChat('/kick '..other.recon_id..' Помеха') 
				end
			if imgui.Button(u8'AFK на Дороге', btn_ssize) then
				sampSendChat('/kick '..other.recon_id..' AFK на Дороге')
			end
			if imgui.Button(u8'AFK Дерби', btn_ssize) then
				sampSendChat('/kick '..other.recon_id..' AFK Дерби')
			end
			if imgui.Button(u8'AFK МП', btn_ssize) then
				sampSendChat('/kick '..other.recon_id..' AFK МП')
			end
			if imgui.Button(u8'AFK 9/10 15+', btn_ssize) then
				sampSendChat('/kick '..other.recon_id..' 7 AFK 9/10 15+')
			end
			if imgui.Button(u8'Помеха Спавну', btn_ssize) then
				sampSendChat('/kick '..other.recon_id..' Помеха Спавну')
			end
			imgui.CenterTextColoredRGB('{FFA500}S U P {ffdead}© {FFA500}2022', statew)
			imgui.End()
		end
		
		--------- pervashiiiiii
		
		if punjail_menu.v then
      imgui.SetNextWindowSize(imgui.ImVec2(330, 92), imgui.Cond.FirstUseEver)
      imgui.SetNextWindowPos(imgui.ImVec2(main_x / 2, main_y / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
      imgui.Begin(u8"[Forms] Выпустить с КПЗ", punjail_menu, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoBringToFrontOnFocus+ imgui.WindowFlags.NoSavedSettings)

			imgui.NewInputText(u8'##FUnJail', text_buffer_unjail, 310, u8"Введите причину для освобождения игрока", 2)

			if imgui.Button(u8'Выпустить', imgui.ImVec2(150, 22)) then
				if text_buffer_unjail.v == '' then
					sampAddChatMessage(tag..' {ffffff}Вы не ввели причину для выпуска игрока из Деморганa.', -1)
				else
					sampSendChat('/a /jail ' ..other.recon_id.. ' 0 '..u8:decode(text_buffer_unjail.v))
					punjail_menu.v = false
				end
			end

			imgui.SameLine()

			if imgui.Button(u8'Закрыть', imgui.ImVec2(150, 22)) then
				punjail_menu.v = false
			end
			imgui.CenterTextColoredRGB('{FFA500}S U P {ffdead}© {FFA500}2022', statew)
			imgui.End()
		end
		
		if pstatew.v then
			imgui.ShowCursor = true
			local btn_size = imgui.ImVec2(-0.1, 0)
			local btn_ssize = imgui.ImVec2(-0.3, 40)
			local btn_sssize = imgui.ImVec2(-0.9, 40)
			imgui.SetNextWindowSize(imgui.ImVec2(218, 388), imgui.Cond.FirstUseEver)
			imgui.SetNextWindowPos(imgui.ImVec2(iScreenWidth / 2, iScreenHeight / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(-1, 0.5))
			imgui.Begin(u8'[Forms] Fast CMD', pstatew, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize)
			if imgui.Button(u8'[Forms] Взаимодействия', btn_sssize) then
				pstatew9.v = true
				pstatew.v = false
			end
			if imgui.Button(u8'[Forms]Посадить в тюрьму', btn_sssize) then
				 pstatew2.v = true
				 pstatew.v = false
			end
			if imgui.Button(u8'[Forms]Заблокировать чат', btn_sssize) then
				pstatew4.v = true
				pstatew.v = false
			end
			if imgui.Button(u8'[Forms]Отсоединить от сервера', btn_sssize) then
				pstatew7.v = true
				pstatew.v = false
			end
			if imgui.Button(u8'[Forms]Выдать предупреждение', btn_sssize) then
				pstatew6.v = true
				pstatew.v = false
			end
			if imgui.Button(u8'[Forms]Заблокировать аккаунт', btn_sssize) then
				pstatew5.v = true
				pstatew.v = false
			end
			
			
			if imgui.Button(u8'Назад', btn_sssize) then
				pstatew.v = false
				statew.v = true
			end
			if imgui.Button(u8'Перейти к репортам', btn_sssize) then
				sampSendChat('/arep')
            	pstatew.v = false
			end
			imgui.CenterTextColoredRGB('{FFA500}S U P {ffdead}© {FFA500}2022', statew)
			imgui.End()
		end
		
		if pstatew2.v then
			imgui.ShowCursor = true
			local btn_size = imgui.ImVec2(-0.1, 0)
			local btn_ssize = imgui.ImVec2(-0.3, 40)
			imgui.SetNextWindowSize(imgui.ImVec2(170, 343), imgui.Cond.FirstUseEver)
			imgui.SetNextWindowPos(imgui.ImVec2(iScreenWidth / 2, iScreenHeight / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(-1.5, 0.5))
			imgui.Begin(u8'[Forms] Fast CMD(prison)', pstatew2, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize)
			if imgui.Button(u8'DeathMatch', btn_ssize) then
				sampSendChat('/a /jail '..other.recon_id..' 60 DeathMatch')
			end
			if imgui.Button(u8'DriveBy', btn_ssize) then
				sampSendChat('/a /jail '..other.recon_id..' 60 DriveBy')
			end
			if imgui.Button(u8'Death Match ZZ', btn_ssize) then
				sampSendChat('/a /jail '..other.recon_id..' 80 DeathMatch in ZZ')
			end
			if imgui.Button(u8'Death Match Рабочих', btn_ssize) then
				sampSendChat('/a /jail '..other.recon_id..' 80 DeathMatch Рабочих')
			end
			if imgui.Button(u8'Team Kill Госс', btn_ssize) then
				sampSendChat('/a /jail '..other.recon_id..' 30 TeamKill')
			end
			if imgui.Button(u8'Team Kill Нелегал', btn_ssize) then
				sampSendChat('/a /jail '..other.recon_id..' 60 TeamKill')
			end
			if imgui.Button(u8'Таран', btn_ssize) then
				sampSendChat('/a /jail '..other.recon_id..' 300 Таран')
			end
			imgui.CenterTextColoredRGB('{FFA500}S U P {ffdead}© {FFA500}2022', statew)
			imgui.End()
		end
		if pstatew4.v then
			imgui.ShowCursor = true
			local btn_size = imgui.ImVec2(-0.1, 0)
			local btn_ssize = imgui.ImVec2(-0.3, 40)
			imgui.SetNextWindowSize(imgui.ImVec2(170, 429), imgui.Cond.FirstUseEver)
			imgui.SetNextWindowPos(imgui.ImVec2(iScreenWidth / 2, iScreenHeight / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(-1.2, 0.5))
			imgui.Begin(u8'[Forms] Fast CMD(MUTE)', pstatew4, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize)
			if imgui.Button(u8'Транслит', btn_ssize) then
				sampSendChat('/a /mute '..other.recon_id..' 20 Транслит.')
			end
			if imgui.Button(u8'Оскорбление игроков', btn_ssize) then
				sampSendChat('/a /mute '..other.recon_id..' 60 Оскорбление игроков')
			end
			if imgui.Button(u8'Флуд в чат', btn_ssize) then
				sampSendChat('/a /mute '..other.recon_id..' 20 Flood')
			end
			if imgui.Button(u8'Капс', btn_ssize) then
				sampSendChat('/a /mute '..other.recon_id..' 20 Caps Lock.')
			end
			if imgui.Button(u8'Неадекват', btn_ssize) then
				sampSendChat('/a /mute '..other.recon_id..' 60 Неадекватное поведение.')
			end
			if imgui.Button(u8'Выдача себя за Админа', btn_ssize) then
				sampSendChat('/a /mute '..other.recon_id..' 60 Выдача себя за администратора.')
			end
			if imgui.Button(u8'Упоминание родных', btn_ssize) then
				sampSendChat('/a /mute '..other.recon_id..' 300 Упоминание о родных.')
			end
			if imgui.Button(u8'Оск. Администрации', btn_ssize) then
				sampSendChat('/a /mute '..other.recon_id..' 60 Оскорбление Администрации.')
			end
			if imgui.Button(u8'Политика', btn_ssize) then
				sampSendChat('/a /mute '..other.recon_id..' 60 Политика.')
			end
			imgui.CenterTextColoredRGB('{FFA500}S U P {ffdead}© {FFA500}2022', statew)
			imgui.End()
		end
		if pstatew5.v then
			imgui.ShowCursor = true
			local btn_size = imgui.ImVec2(-0.1, 0)
			local btn_ssize = imgui.ImVec2(-0.3, 40)
			
			imgui.SetNextWindowSize(imgui.ImVec2(205, 472), imgui.Cond.FirstUseEver)
			imgui.SetNextWindowPos(imgui.ImVec2(iScreenWidth / 2, iScreenHeight / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(-0.9, 0.5))
			imgui.Begin(u8'[Forms] Fast CMD(BAN)', pstatew5, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize)
			if imgui.Button(u8'Читы', btn_ssize) then
				sampSendChat('/a /ban '..other.recon_id..' 30 Читы.')
			end
			if imgui.Button(u8'Слив', btn_ssize) then
				sampSendChat('/a /ban '..other.recon_id..' 30 Слив.')
			end
			if imgui.Button(u8'NonRP обман', btn_ssize) then
				sampSendChat('/a /ban '..other.recon_id..' 30 NonRP обман.')
			end
			if imgui.Button(u8'Продан/Передан/Взломан', btn_ssize) then
				sampSendChat('/a /ban '..other.recon_id..' 30 П/П/В.')
			end
			if imgui.Button(u8'Обман Администрации', btn_ssize) then
				sampSendChat('/a /ban '..other.recon_id..' 30 Обман администрации.')
			end
			if imgui.Button(u8'Оскорбление родных', btn_ssize) then
				sampSendChat('/a /ban '..other.recon_id..' 7 Оскорбление родных.')
			end
			if imgui.Button(u8'Оскорбление проекта', btn_ssize) then
				sampSendChat('/a /ban '..other.recon_id..' 7 Оскорбление проекта.')
			end
			if imgui.Button(u8'Розжиг', btn_ssize) then
				sampSendChat('/a /ban '..other.recon_id..' 7 Розжиг.')
			end
			if imgui.Button(u8'Реклама', btn_ssize) then
				sampSendChat('/a /ban '..other.recon_id..' 30 Реклама.')
			end
			if imgui.Button(u8'Политика /pame /ad /v', btn_ssize) then
				sampSendChat('/a /ban '..other.recon_id..' 3 Политика.')
			end
			imgui.CenterTextColoredRGB('{FFA500}S U P {ffdead}© {FFA500}2022', statew)
			imgui.End()
		end
		if pstatew9.v then
			imgui.ShowCursor = true
			local btn_size = imgui.ImVec2(-0.1, 0)
			local btn_ssize = imgui.ImVec2(-0.9, 40)
			imgui.SetNextWindowSize(imgui.ImVec2(170, 472), imgui.Cond.FirstUseEver)
			imgui.SetNextWindowPos(imgui.ImVec2(iScreenWidth / 2, iScreenHeight / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(-1.3, 0.5))
			imgui.Begin(u8'[Forms] Взаимодействие', pstatew9, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize)
			if imgui.Button(u8'ТП к игроку', btn_ssize) then
			pstatew9.v = false
				sampSendChat('/reoff')
				
			lua_thread.create(function()
			wait(1000)
				sampSendChat('/goto '..other.recon_id..'')
			end)
			end
			
			
			if imgui.Button(u8'Подкинуть игрока', btn_ssize) then
				sampSendChat('/slap '..other.recon_id..'')
			end
			if imgui.Button(u8'Флипнуть игрока', btn_ssize) then
				sampSendChat('/flip '..other.recon_id..'')
			end
			if imgui.Button(u8'Заспавнить игрока', btn_ssize) then
				sampSendChat('/spawn '..other.recon_id..'')
			end
			if imgui.Button(u8'Выдать 100 HP', btn_ssize) then
				sampSendChat('/a /sethp '..other.recon_id..' 100')
			end
			if imgui.Button(u8'Разблокировать чат', btn_ssize) then
				sampSendChat('/a /unmute '..other.recon_id..' 0 0')
			end
			if imgui.Button(u8'Выпустить из ДМГ', btn_ssize) then
				punjail_menu.v = true
				pstatew9.v = false
			end
			if imgui.Button(u8'Заморозить', btn_ssize) then
				sampSendChat('/a /freeze '..other.recon_id)
			end
			if imgui.Button(u8'Разморозить', btn_ssize) then
				sampSendChat('/a /unfreeze '..other.recon_id)
			end
			if imgui.Button(u8'Сменить Nick_Name', btn_ssize) then
				sampSendChat('/a /setname '..other.recon_id)
			end
			imgui.CenterTextColoredRGB('{FFA500}S U P {ffdead}© {FFA500}2022', statew)
			imgui.End()
		end

		if pstatew6.v then
			imgui.ShowCursor = true
			local btn_size = imgui.ImVec2(-0.1, 0)
			local btn_ssize = imgui.ImVec2(-0.9, 40)
			imgui.SetNextWindowSize(imgui.ImVec2(150, 429), imgui.Cond.FirstUseEver)
			imgui.SetNextWindowPos(imgui.ImVec2(iScreenWidth / 2, iScreenHeight / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(-1.5, 0.5))
			imgui.Begin(u8'[Forms] Fast CMD(warn)', pstatew6, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize)
			if imgui.Button(u8'Spawn Kill', btn_ssize) then
				sampSendChat('/a /warn '..other.recon_id..' 7 Spawn Kill')
			end
			if imgui.Button(u8'OFF от Арреста', btn_ssize) then
				sampSendChat('/a /warn '..other.recon_id..' 7 OFF от Арреста')
			end
			if imgui.Button(u8'Вода от Ареста', btn_ssize) then
				sampSendChat('/a /warn '..other.recon_id..' 7 Вода от Арреста')
			end
			if imgui.Button(u8'OFF от Смерти', btn_ssize) then
				sampSendChat('/a /warn '..other.recon_id..' 7 OFF от Смерти')
			end
			if imgui.Button(u8'Инта от Смерти', btn_ssize) then
				sampSendChat('/a /warn '..other.recon_id..' 7 Инта от Смерти')
			end
			if imgui.Button(u8'+c в Игрока', btn_ssize) then
				sampSendChat('/a /warn '..other.recon_id..' 7 +c в Игрока')
			end
			if imgui.Button(u8'Сбив Аним в бою', btn_ssize) then
				sampSendChat('/a /warn '..other.recon_id..' 7 Сбив Анимации в бою')
			end
			if imgui.Button(u8'Сбив Переката', btn_ssize) then
				sampSendChat('/a /warn '..other.recon_id..' 7 Сбив Переката')
			end
			if imgui.Button(u8'CLEO Spawn', btn_ssize) then
				sampSendChat('/a /warn '..other.recon_id..' 7 Cleo Spawn.')
			end
			imgui.CenterTextColoredRGB('{FFA500}S U P {ffdead}© {FFA500}2022', statew)
			imgui.End()
		end


		if pstatew7.v then
			imgui.ShowCursor = true
			local btn_size = imgui.ImVec2(-0.1, 0)
			local btn_ssize = imgui.ImVec2(-0.9, 40)
			imgui.SetNextWindowSize(imgui.ImVec2(150, 300), imgui.Cond.FirstUseEver)
			imgui.SetNextWindowPos(imgui.ImVec2(iScreenWidth / 2, iScreenHeight / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(-1.5, 0.5))
			imgui.Begin(u8'[Forms] Fast CMD(kick)', pstatew7, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize)
			if imgui.Button(u8'Помеха', btn_ssize) then
				sampSendChat('/a /kick '..other.recon_id..' Помеха') 
				end
			if imgui.Button(u8'AFK на Дороге', btn_ssize) then
				sampSendChat('/a /kick '..other.recon_id..' AFK на Дороге')
			end
			if imgui.Button(u8'AFK Дерби', btn_ssize) then
				sampSendChat('/a /kick '..other.recon_id..' AFK Дерби')
			end
			if imgui.Button(u8'AFK МП', btn_ssize) then
				sampSendChat('/a /kick '..other.recon_id..' AFK МП')
			end
			if imgui.Button(u8'AFK 9/10 15+', btn_ssize) then
				sampSendChat('/a /kick '..other.recon_id..' 7 AFK 9/10 15+')
			end
			if imgui.Button(u8'Помеха Спавну', btn_ssize) then
				sampSendChat('/a /kick '..other.recon_id..' Помеха Спавну')
			end
			imgui.CenterTextColoredRGB('{FFA500}S U P {ffdead}© {FFA500}2022', statew)
			imgui.End()
		end
		--------- konec pervasheeeeeey
		
    if main_window_state.v then
        imgui.SetNextWindowSize(imgui.ImVec2(485, 485), imgui.Cond.FirstUseEver)
        imgui.SetNextWindowPos(imgui.ImVec2(main_x / 2, main_y / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.Begin(u8"Жалоба/Вопрос##репорт", _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoBringToFrontOnFocus+ imgui.WindowFlags.NoSavedSettings)
        imgui.Text(u8"Жалоба от "..nick_report.." ["..id_report.."]")
				imgui.SameLine()
				if imgui.Button(u8'Разморозить', imgui.ImVec2(85, 20)) then
					main_window_state.v = false
					prices_window_state.v = false
					gps_window_state.v = false
					lua_thread.create(function()
						sampSendDialogResponse(id_dialog, 1, nil, "Здравствуйте, уважаемый игрок, сейчас вам помогу | Приятной игры")
						wait(100)
						sampCloseCurrentDialogWithButton(0)
						wait(1000)
						sampSendChat("/unfreeze " ..nick_report )
					end)
				end
				imgui.SameLine()
			if imgui.Button(u8'Заспавнить', imgui.ImVec2(85, 20)) then
					main_window_state.v = false
					prices_window_state.v = false
					gps_window_state.v = false
					lua_thread.create(function()
						sampSendDialogResponse(id_dialog, 1, nil, "Здравствуйте, уважаемый игрок, ожидайте | Приятной игры")
						wait(100)
						sampCloseCurrentDialogWithButton(0)
						wait(1000)
						sampSendChat("/spawn " ..nick_report )
					end)
				end
				imgui.SameLine()
			if imgui.Button(u8'Nick', imgui.ImVec2(85, 20)) then
			main_window_state.v = false
					prices_window_state.v = false
					gps_window_state.v = false
					lua_thread.create(function()
						sampSendDialogResponse(id_dialog, 1, nil, "Здравствуйте, уважаемый игрок, ожидайте | Приятной игры")
						wait(100)
						sampCloseCurrentDialogWithButton(0)
						wait(1000)
						sampSendChat("/setname " ..nick_report )
					end)
				
			end
        imgui.PushItemWidth(485)
         imgui.TextWrapped(u8''..u8(text_report))
		
        imgui.Separator()

				imgui.NewInputText(u8'##Answer_report', text_buffer, 470, u8"Введите сообщение для ответа на данный репорт", 2)

        imgui.Separator()
		imgui.CenterTextColoredRGB('Быстрые ответы:', main_window_state)
        if imgui.Button(u8'Слежу за нарушителем', imgui.ImVec2(150, 22)) then
        	main_window_state.v = false
        	prices_window_state.v = false
        	gps_window_state.v = false
			
        	lua_thread.create(function()
        		sampSendDialogResponse(id_dialog, 1, nil, "Уважаемый игрок, слежу за нарушителем.")
        		sampCloseCurrentDialogWithButton(0)
        		wait(1000)
        		if recon_suspect then
				other.recon_id = id_suspect tonumber(arg)
        			sampSendChat("/re "..id_suspect, other.recon_id)
        			sampAddChatMessage(tag.."{FFFFFF} Вы ушли в слежку за нарушителем.", 0xFFFFFF)
        		else
        			sampAddChatMessage(tag.."{FFFFFF} В репорте не был найден ID нарушителя.", 0xFFFFFF)
        			sampAddChatMessage(tag.."{FFFFFF} Содержимое репорта: "..text_report, 0xFFFFFF)
	      		end
        	end)
        end
        imgui.SameLine()
        if imgui.Button(u8'Помочь автору (/re)', imgui.ImVec2(150, 22)) then
        	main_window_state.v = false
        	prices_window_state.v = false
        	gps_window_state.v = false
			
        	lua_thread.create(function()
			other.recon_id = id_report tonumber(arg)
        		sampSendDialogResponse(id_dialog, 1, nil, "Уважаемый игрок, сейчас попробую Вам помочь.")
        		wait(100)
        		sampCloseCurrentDialogWithButton(0)
        		wait(1000)
	        	sampSendChat("/re "..id_report, other.recon_id)
				
				
	        	sampAddChatMessage(tag.."{FFFFFF} Вы ушли в слежку за автором репорта.", 0xFFFFFF)
        	end)
        end
        imgui.SameLine()
        if imgui.Button(u8'Помочь автору (/g)', imgui.ImVec2(150, 22)) then
        	main_window_state.v = false
        	prices_window_state.v = false
        	gps_window_state.v = false
        	lua_thread.create(function()
        		sampSendDialogResponse(id_dialog, 1, nil, "Уважаемый игрок, сейчас попробую Вам помочь.")
        		wait(100)
        		sampCloseCurrentDialogWithButton(0)
        		wait(1000)
	        	sampSendChat("/goto "..nick_report)
	        	sampAddChatMessage(tag.."{FFFFFF} Вы телепортировались к автору репорта.", 0xFFFFFF)
	        end)
        end
        if imgui.Button(u8'Гос. цены т/с', imgui.ImVec2(150, 22)) then
            prices_imgui()
        end
        imgui.SameLine()
        if imgui.Button(u8'Переслать в /a чат', imgui.ImVec2(150, 22)) then
            main_window_state.v = false
            prices_window_state.v = false
            gps_window_state.v = false
            lua_thread.create(function()
                sampSendDialogResponse(id_dialog, 1, nil, "Передал репорт Администрации | Приятной игры!")
                wait(100)
                sampCloseCurrentDialogWithButton(0)
                wait(1000)
				sampSendChat("/a [REP] " ..nick_report.. "[" ..id_report.. "] " ..text_report )
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
        		sampSendDialogResponse(id_dialog, 1, nil, "Уважаемый игрок, пожалуйста Не Оффтопьте.")
        		wait(100)
        		sampCloseCurrentDialogWithButton(0)
	        end)
        end
				imgui.SameLine()
				if imgui.Button(u8'Не спавним', imgui.ImVec2(150, 22)) then
        	main_window_state.v = false
        	prices_window_state.v = false
        	gps_window_state.v = false
        	lua_thread.create(function()
        		sampSendDialogResponse(id_dialog, 1, nil, "Здравствуйте уважаемый игрок, не спавним")
        		wait(100)
        		sampCloseCurrentDialogWithButton(0)
	        end)
        end
				imgui.SameLine()
        if imgui.Button(u8'Не чиним', imgui.ImVec2(150, 22)) then
        	main_window_state.v = false
        	prices_window_state.v = false
        	gps_window_state.v = false
        	lua_thread.create(function()
        		sampSendDialogResponse(id_dialog, 1, nil, "Здравствуйте уважаемый игрок, не чиним")
        		wait(100)
        		sampCloseCurrentDialogWithButton(0)
	        end)
        end
				if imgui.Button(u8'Приятной игры', imgui.ImVec2(150, 22)) then
        	main_window_state.v = false
        	prices_window_state.v = false
        	gps_window_state.v = false
        	lua_thread.create(function()
        		sampSendDialogResponse(id_dialog, 1, nil, "Приятной игры на Flin Role Play)")
        		wait(100)
        		sampCloseCurrentDialogWithButton(0)
	        end)
				end
				imgui.SameLine()
				if imgui.Button(u8'Форум', imgui.ImVec2(150, 22)) then
        	main_window_state.v = false
        	prices_window_state.v = false
        	gps_window_state.v = false
        	lua_thread.create(function()
        		sampSendDialogResponse(id_dialog, 1, nil, "Оставьте жалобу на нашем форуме  ' forum.flin-rp.com ' ")
        		wait(100)
        		sampCloseCurrentDialogWithButton(0)
	        end)
				end
				imgui.SameLine()
				if imgui.Button(u8'Телепорт к себе (/gh)', imgui.ImVec2(150, 22)) then
        		main_window_state.v = false
        	prices_window_state.v = false
        	gps_window_state.v = false
        	lua_thread.create(function()
        		sampSendDialogResponse(id_dialog, 1, nil, "Уважаемый игрок, сейчас попробую Вам помочь, телепортирую Вас к Себе.")
        		wait(100)
        		sampCloseCurrentDialogWithButton(0)
        		wait(1000)
	        	sampSendChat("/gethere "..nick_report)
	        	sampAddChatMessage(tag.."{FFFFFF} Вы телепортировали автора репорта к себе.", 0xFFFFFF)
	        end)
				end
				if imgui.Button(u8'Разблокировать чат', imgui.ImVec2(150, 22)) then
				main_window_state.v = false
        	prices_window_state.v = false
        	gps_window_state.v = false
        	lua_thread.create(function()
        		sampSendDialogResponse(id_dialog, 1, nil, "Уважаемый игрок, сейчас сниму вам блокировку Чата.")
        		wait(100)
        		sampCloseCurrentDialogWithButton(0)
        		wait(1000)
	        	sampSendChat("/unmute "..nick_report)
	        	sampAddChatMessage(tag.."{FFFFFF} Вы сняли блокировку чата автору репорта.", 0xFFFFFF)
	        end)
				end
			imgui.SameLine()
			if imgui.Button(u8'Выдать 100 HP', imgui.ImVec2(150, 22)) then
				main_window_state.v = false
        	prices_window_state.v = false
        	gps_window_state.v = false
        	lua_thread.create(function()
        		sampSendDialogResponse(id_dialog, 1, nil, "Уважаемый игрок, сейчас выдам вам 100 HP.")
        		wait(100)
        		sampCloseCurrentDialogWithButton(0)
        		wait(1000)
	        	sampSendChat("/sethp "..nick_report .." 100")
	        	sampAddChatMessage(tag.."{FFFFFF} Вы выдали автору репорта 100 HP.", 0xFFFFFF)
	        end)
				end
				imgui.SameLine()
				if imgui.Button(u8'Выпустить из ДМГ', imgui.ImVec2(150, 22)) then
				main_window_state.v = false
        	prices_window_state.v = false
        	gps_window_state.v = false
        	lua_thread.create(function()
        		sampSendDialogResponse(id_dialog, 1, nil, "Уважаемый игрок, сейчас выпущу вас из Деморгана.")
        		wait(100)
        		sampCloseCurrentDialogWithButton(0)
        		wait(1000)
	        	sampSendChat("/jail "..nick_report .." 0 0")
	        	sampAddChatMessage(tag.."{FFFFFF} Вы выпустили автора репорта из Деморгана.", 0xFFFFFF)
	        end)
				end
				imgui.Text(u8'      ')
				imgui.SameLine()
				if imgui.Button(u8'Не телепортируем', imgui.ImVec2(200, 19)) then
				main_window_state.v = false
        	prices_window_state.v = false
        	gps_window_state.v = false
        	lua_thread.create(function()
        		sampSendDialogResponse(id_dialog, 1, nil, "Уважаемый игрок, не телепортируем, вызовите такси.")
        		wait(100)
        		sampCloseCurrentDialogWithButton(0)
        		wait(500)
	        	--sampSendChat("/jail "..nick_report .." 0 0")
	        	sampAddChatMessage(tag.."{FFFFFF} Вы ответили автору репорта, что не телепортируете.", 0xFFFFFF)
	        end)
				end
				imgui.SameLine()
				if imgui.Button(u8'Не лечим', imgui.ImVec2(200, 19)) then
				main_window_state.v = false
        	prices_window_state.v = false
        	gps_window_state.v = false
        	lua_thread.create(function()
        		sampSendDialogResponse(id_dialog, 1, nil, "Уважаемый игрок, не лечим, используйте аптечку.")
        		wait(100)
        		sampCloseCurrentDialogWithButton(0)
        		wait(500)
	        	--sampSendChat("/jail "..nick_report .." 0 0")
	        	sampAddChatMessage(tag.."{FFFFFF} Вы ответили автору репорта, что не лечим.", 0xFFFFFF)
	        end)
				end
		imgui.Separator()
		imgui.CenterTextColoredRGB('Быстрые наказания:', main_window_state)
		 if imgui.Button(u8'CAPS', imgui.ImVec2(150, 22)) then
        	main_window_state.v = false
        	prices_window_state.v = false
        	gps_window_state.v = false
        	lua_thread.create(function()
        		sampSendDialogResponse(id_dialog, 1, nil, "Уважаемый игрок, вы будете наказаны за Caps Lock в репорте.")
        		wait(100)
        		sampCloseCurrentDialogWithButton(0)
        		wait(1000)
	        	sampSendChat("/rmute "..id_report.." 20 Caps")
				wait(1000)
	        	sampAddChatMessage(tag.."{FFFFFF} Вы наказали автора репорта за CAPS в репорте.", 0xFFFFFF)
        	end)
        end
		imgui.SameLine()
		if imgui.Button(u8'Оскорбление', imgui.ImVec2(150, 22)) then
        	main_window_state.v = false
        	prices_window_state.v = false
        	gps_window_state.v = false
        	lua_thread.create(function()
        		sampSendDialogResponse(id_dialog, 1, nil, "Уважаемый игрок, вы будете наказаны за Оскорбление в репорте.")
        		wait(100)
        		sampCloseCurrentDialogWithButton(0)
        		wait(1000)
	        	sampSendChat("/rmute "..id_report.." 40 Оскорбление(-я)")
				wait(1000)
	        	sampAddChatMessage(tag.."{FFFFFF} Вы наказали автора репорта за Оскорбление в репорте.", 0xFFFFFF)
        	end)
        end
		imgui.SameLine()
		if imgui.Button(u8'Оффтоп 3/3', imgui.ImVec2(150, 22)) then
        	main_window_state.v = false
        	prices_window_state.v = false
        	gps_window_state.v = false
        	lua_thread.create(function()
        		sampSendDialogResponse(id_dialog, 1, nil, "Уважаемый игрок, вы будете наказаны за Offtop 3/3 в репорте.")
        		wait(100)
        		sampCloseCurrentDialogWithButton(0)
        		wait(1000)
	        	sampSendChat("/rmute "..id_report.." 20 Offtop 3/3")
				wait(1000)
	        	sampAddChatMessage(tag.."{FFFFFF} Вы наказали автора репорта за Offtop 3/3 в репорте.", 0xFFFFFF)
        	end)
        end
		if imgui.Button(u8'Упоминание родни', imgui.ImVec2(150, 22)) then
        	main_window_state.v = false
        	prices_window_state.v = false
        	gps_window_state.v = false
        	lua_thread.create(function()
        		sampSendDialogResponse(id_dialog, 1, nil, "Уважаемый игрок, вы будете наказаны за Упоминание родни в репорте.")
        		wait(100)
        		sampCloseCurrentDialogWithButton(0)
        		wait(1000)
	        	sampSendChat("/rmute "..id_report.." 120 Упоминание родни")
				wait(1000)
	        	sampAddChatMessage(tag.."{FFFFFF} Вы наказали автора репорта за Упоминание родни в репорте.", 0xFFFFFF)
        	end)
        end
		imgui.SameLine()
		if imgui.Button(u8'Оскорбление родни', imgui.ImVec2(150, 22)) then
        	main_window_state.v = false
        	prices_window_state.v = false
        	gps_window_state.v = false
        	lua_thread.create(function()
        		sampSendDialogResponse(id_dialog, 1, nil, "Уважаемый игрок, вы будете наказаны за Оскорбление родни.")
        		wait(100)
        		sampCloseCurrentDialogWithButton(0)
        		wait(1000)
	        	sampSendChat("/ban  "..id_report.." 7 Оскорбление родни")
				wait(1000)
	        	sampAddChatMessage(tag.."{FFFFFF} Вы наказали автора репорта за Оскорбление родни.", 0xFFFFFF)
				sampAddChatMessage(tag.."{FFFFFF} Если у вас нету {32CD32}3+ LVL {FFFFFF}то напишите форму в /a /ban "..id_report.."7 Оскорбление родни.", 0xFFFFFF)
        	end)
        end
		imgui.SameLine()
		if imgui.Button(u8'Оскорбление проекта', imgui.ImVec2(150, 22)) then
        	main_window_state.v = false
        	prices_window_state.v = false
        	gps_window_state.v = false
        	lua_thread.create(function()
        		sampSendDialogResponse(id_dialog, 1, nil, "Уважаемый игрок, вы будете наказаны за Оскорбление проекта.")
        		wait(100)
        		sampCloseCurrentDialogWithButton(0)
        		wait(1000)
	        	sampSendChat("/ban "..id_report.." 7 Оскорбление проекта")
				wait(1000)
	        	sampAddChatMessage(tag.."{FFFFFF} Вы наказали автора репорта за Оскорбление проекта.", 0xFFFFFF)
				sampAddChatMessage(tag.."{FFFFFF} Если у вас нету {32CD32}3+ LVL {FFFFFF}то напишите форму в /a /ban "..id_report.." 7 Оскорбление проекта.", 0xFFFFFF)
        	end)
        end
		if imgui.Button(u8'Политические высказывания', imgui.ImVec2(465, 22)) then
        	main_window_state.v = false
        	prices_window_state.v = false
        	gps_window_state.v = false
        	lua_thread.create(function()
        		sampSendDialogResponse(id_dialog, 1, nil, "Уважаемый игрок, вы будете наказаны за Политические высказывания.")
        		wait(100)
        		sampCloseCurrentDialogWithButton(0)
        		wait(1000)
	        	sampSendChat("/rmute "..id_report.." 7 Политика")
				wait(1000)
	        	
        	end)
        end
		imgui.Separator()
		imgui.Text(u8"\n")
        if imgui.Button(u8'Отправить', imgui.ImVec2(150, 22)) then
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

        if imgui.Button(u8'Закрыть', imgui.ImVec2(150, 22)) then
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
		imgui.CenterTextColoredRGB('{32CD32}Nik Everyone                     {FFA500}Samp Umbrella Project {ffdead}© {FFA500}2022                {ffdead}FReport Helper', btn_siz)
		
        imgui.End()
    end
    if prices_window_state.v then
    	imgui.SetNextWindowSize(imgui.ImVec2(250, 410), imgui.Cond.FirstUseEver)
    	imgui.SetNextWindowPos(imgui.ImVec2(main_x / 3 - 150, main_y / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.Begin(u8"Государственные цены транспорта", _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoBringToFrontOnFocus+ imgui.WindowFlags.NoSavedSettings)
        if imgui.CollapsingHeader(u8"Автосалон Los-Santos [Nope]") then
            imgui.Text(prices1)
        end
        if imgui.CollapsingHeader(u8"Автосалон San-Fierro [C]") then
            imgui.Text(prices2)
        end
        if imgui.CollapsingHeader(u8"Автосалон San-Fierro [B]") then
            imgui.Text(prices3)
        end
        if imgui.CollapsingHeader(u8"Автосалон Las-Venturas [A]") then
            imgui.Text(prices4)
        end
		if imgui.CollapsingHeader(u8"Автосалон Las-Venturas [Real Cars]") then
           imgui.Text(pricesrealcars)
		   imgui.Text(pricesrealcars2)
		   imgui.Text(pricesrealcars3)
        end
        if imgui.CollapsingHeader(u8"Мотосалон") then
            imgui.Text(prices5)
        end
        if imgui.CollapsingHeader(u8"Аэросалон") then
            imgui.Text(prices6)
        end
        if imgui.CollapsingHeader(u8"Яхт-Клуб") then
            imgui.Text(prices7)
        end
		imgui.Text(u8"")
		imgui.Text(u8"")
		imgui.Text(u8"")
		imgui.Text(u8"")
		imgui.Text(u8"")
		imgui.Text(u8"")
		imgui.Text(u8"")
		imgui.Text(u8"")
		imgui.Text(u8"")
		imgui.Text(u8"\n\n")
		
		
		
		--imgui.SetCursorPosY(393)
		imgui.CenterTextColoredRGB('{FFA500}S U P {ffdead}© {FFA500}2022', btn_siz)
        imgui.End()
    end
    if gps_window_state.v then
    	imgui.SetNextWindowSize(imgui.ImVec2(250, 410), imgui.Cond.FirstUseEver)
    	imgui.SetNextWindowPos(imgui.ImVec2(main_x / 2 + 378, main_y / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
    	imgui.Begin(u8"GPS навигатор", _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoBringToFrontOnFocus+ imgui.WindowFlags.NoSavedSettings)
    	if imgui.CollapsingHeader(u8"[1] Общественные места") then
    		imgui.Text(u8(gps1))
    	end
    	if imgui.CollapsingHeader(u8"[2] Первоначальные работы") then
    		imgui.Text(u8(gps2))
    	end
    	if imgui.CollapsingHeader(u8"[3] Основные работы") then
    		imgui.Text(u8(gps3))
    	end
    	if imgui.CollapsingHeader(u8"[4] Фракции") then
    		imgui.Text(u8(gps4))
    	end
    	if imgui.CollapsingHeader(u8"[5] Для фракций") then
    		imgui.Text(u8(gps5))
    	end
		if imgui.CollapsingHeader(u8"[6] Ограбления") then
    		imgui.Text(u8(gps6))
    	end
    	if imgui.CollapsingHeader(u8"[7] Бизнесы") then
    		imgui.Text(u8(gps7))
    	end
    	
		if imgui.CollapsingHeader(u8"[8] Службы такси") then
    		imgui.Text(u8(gps9))
    	end
		if imgui.CollapsingHeader(u8"[9] Транспортные компании") then
    		imgui.Text(u8(gps10))
    	end
		if imgui.CollapsingHeader(u8"[10] Дальнобойщики") then
    		imgui.Text(u8(gpsdalnoboy))
    	end
    	if imgui.CollapsingHeader(u8"[11] Транспорт") then
    		imgui.Text(u8(gps11))
    	end
    	if imgui.CollapsingHeader(u8"[12] Развлечения") then
    		imgui.Text(u8(gps13))
    	end
    	imgui.CollapsingHeader(u8"[13] Рыбалка")
    	imgui.CollapsingHeader(u8"[14] Охота")
    	if imgui.CollapsingHeader(u8"[15] Личное") then
			imgui.Text(u8(gps14))
		end
    	imgui.CollapsingHeader(u8"[16] Ближайший банкомат")
		imgui.CollapsingHeader(u8"[17] Ближайшая мусорка")
		imgui.CenterTextColoredRGB('{FFA500}S U P {ffdead}© {FFA500}2022', btn_siz)
    	imgui.End()
    end
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
	sampShowDialog(1337, '{FFD700}Speed {00FF00}Player', '{FFC000}Настройка скорости персонажа.\n\nСтандартное значение: {00FF00}0.76\n\n{FFC000}Значение в данный момент: {00FF00}', '{FF0000}Exit', 1)
  end



--function cmd_recon(arg)
	--if arg:match("(%d+)") == nil then
	--	sampSendChat('/re')
	--elseif arg:match("(%d+)") ~= nil then
		--other.recon_id = tonumber(arg)
		--sampSendChat('/re '..other.recon_id)
	--end
--end

function cmd_recon(arg)
local id = arg:match("^(%d+)")
if (id == nil) then 
sampSendChat('/re')
return false
end
other.recon_id = tonumber(arg)
sampSendChat(string.format("/re %d", other.recon_id))
end



function cmd_reconoff(arg)
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
				  sampAddChatMessage((prefix..'Обнаружено обновление. Пытаюсь обновиться c '..thisScript().version..' на '..updateversion), color)
				  wait(250)
				  downloadUrlToFile(updatelink, thisScript().path,
					function(id3, status1, p13, p23)
					  if status1 == dlstatus.STATUS_DOWNLOADINGDATA then
						print(string.format('Загружено %d из %d.', p13, p23))
					  elseif status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
						print('Загрузка обновления завершена.')
						sampAddChatMessage((prefix..'Обновление завершено!'), color)
						goupdatestatus = true
						lua_thread.create(function() wait(500) thisScript():reload() end)
					  end
					  if status1 == dlstatus.STATUSEX_ENDDOWNLOAD then
						if goupdatestatus == nil then
						  sampAddChatMessage((prefix..'Обновление прошло неудачно. Запускаю устаревшую версию..'), color)
						  update = false
						end
					  end
					end
				  )
				  end, prefix
				)
			  else
				update = false
				print('v'..thisScript().version..': Обновление не требуется.')
			  end
			end
		  else
			print('v'..thisScript().version..': Не могу проверить обновление. Смиритесь или проверьте самостоятельно у N.Everyone в VK - @nikeveryone')
			update = false
		  end
		end
	  end
	)
	while update ~= false do wait(100) end
  end


--]]

--local аделя топ = "аделя топ"