local ADDON,private = ...
local D = private.data
local Presets = D.Presets
local PresetLoaders = D.PresetLoaders
local PresetLinks = D.PresetLinks
local L = PriorityTarget_Localization
local wowver,wowbuild,wowbuilddate,wowtoc = GetBuildInfo()
local Vanilla,TBC,Wrath,Cata,MoP,Mainline
Vanilla = WOW_PROJECT_ID == WOW_PROJECT_CLASSIC
TBC = WOW_PROJECT_ID == WOW_PROJECT_BURNING_CRUSADE_CLASSIC
MoP = wowtoc > 50000 and wowtoc < 60000
Cata = wowtoc > 40000 and wowtoc < 50000
Wrath = WOW_PROJECT_ID == WOW_PROJECT_WRATH_CLASSIC and (not (Cata or MoP))
Mainline = WOW_PROJECT_ID == WOW_PROJECT_MAINLINE

D.Presets = { ["!Clear"] = {} }

if GetLocale() == "enUS" then

if Mainline then
    D.Presets["PT:" .. L["Hellfire_Assault"]] = {"Felfire Crusher","Felfire Flamebelcher","Felfire Artillery","Felfire Transporter","Gorebound Terror","Grand Corruptor U'rogg","Grute","Siegemaster Mar'tak","Hulking Berserker","Gorebound Cauterizer","Gorebound Felcaster","Gorebound Fanatic","Gorebound Corruptor","Siegeworks Technician",}
    D.Presets["PT:Iron Reaver"] = {"Quick-Fuse Firebomb","Volatile Firebomb","Burning Firebomb","Reinforced Firebomb","Reactive Firebomb","Iron Reaver",}
    D.Presets["PT:Kormrok"] = {"Grasping Hand","Dragging Hand","Crushing Hand","Kormrok",}
    D.Presets["PT:" .. L["Hellfire_High_Council"]] = {"Gurtogg Bloodboil","Blademaster Jubei'thos","Dia Darkwhisper",}
    D.Presets["PT:Kilrogg Deadeye"] = {"Fel Blood Globule","Blood Globule","Salivating Bloodthirster","Hulking Terror","Hellblaze Mistress","Hellblaze Fiend","Hellblaze Imp","Kilrogg Deadeye",}
    D.Presets["PT:Gorefiend"] = {"Gorebound Essence","Gorebound Construct","Gorebound Spirit","Shadowy Construct","Enraged Spirit","Gorefiend",}
    D.Presets["PT:Shadow-Lord Iskar"] = {"Corrupted Talonpriest","Shadowfel Warden","Iron Dockhand","Phantasmal Resonance","Shadow-Lord Iskar",}
    D.Presets["PT:" .. L["Socretar_the_Eternal"]] = {"Sargerei Dominator","Voracious Soulstalker","Sargerei Shadowcaller","Soulbound Construct","Soul of Socrethar","Haunting Soul",}
    D.Presets["PT:Tyrant Velhari"] = {"Ancient Harbinger","Ancient Sovereign","Tyrant Velhari","Ancient Enforcer",}
    D.Presets["PT:Xhul'horac"] = {"Wild Pyromaniac","Unstable Voidfiend","Vanguard Akkelion","Omnus","Xhul'horac",}
    D.Presets["PT:Mannoroth"] = {"Doom Lord","Dread Infernal","Fel Imp","Mannoroth",}
    D.Presets["PT:Archimonde"] = {"Doomfire Spirit","Hellfire Deathcaller","Living Shadow","Felborne Overfiend","Hellfire Deathcaller","Infernal Doombringer","Void Star","Shadowed Netherwalker","Archimonde",}

    D.PresetLoaders = {
        ["npc:95068"] = "[npc]Siegemaster Mar'tak",
        ["npc:90284"] = "[npc]Iron Reaver",
        ["npc:90435"] = "[npc]Kormrok",
        ["npc:92146"] = "[npc]Gurtogg Bloodboil",
        ["npc:90378"] = "[npc]Kilrogg Deadeye",
        ["npc:90199"] = "[npc]Gorefiend",
        ["npc:90316"] = "[npc]Shadow-Lord Iskar",
        ["npc:90296"] = "[npc]Soulbound Construct",
        ["npc:90269"] = "[npc]Tyrant Velhari",
        ["npc:93068"] = "[npc]Xhul'horac",
        ["npc:91349"] = "[npc]Mannoroth",
        ["npc:91331"] = "[npc]Archimonde",
    }

    D.PresetLinks = {
        ["npc:95068"] = "PT:" .. L["Hellfire_Assault"],
        ["npc:90284"] = "PT:Iron Reaver",
        ["npc:90435"] = "PT:Kormrok",
        ["npc:92146"] = "PT:" .. L["Hellfire_High_Council"],
        ["npc:90378"] = "PT:Kilrogg Deadeye",
        ["npc:90199"] = "PT:Gorefiend",
        ["npc:90316"] = "PT:Shadow-Lord Iskar",
        ["npc:90296"] = "PT:" .. L["Socretar_the_Eternal"],
        ["npc:90269"] = "PT:Tyrant Velhari",
        ["npc:93068"] = "PT:Xhul'horac",
        ["npc:91349"] = "PT:Mannoroth",
        ["npc:91331"] = "PT:Archimonde",
    }
end

end

if GetLocale() == "ruRU" then

if Mainline then
    D.Presets["PT:" .. L["Hellfire_Assault"]] = {"Буравчик огня Скверны","Извергатель пламени Скверны","Артиллерийское орудие Скверны","Транспортер огня Скверны","Связанный кровью ужас","Великий осквернитель У'рогг","Грут","Осадный мастер Мар'так","Огромный берсерк","Связанный кровью прижигатель","Связанная кровью чародейка Скверны","Связанный кровью фанатик","Связанный кровью осквернитель","Техник осадного лагеря",}
    D.Presets["PT:Железный разоритель"] = {"Быстровоспламеняемая огнебомба","Неустойчивая огнебомба","Горящая огнебомба","Усиленная огнебомба","Реактивная огнебомба","Железный разоритель",}
    D.Presets["PT:Кормрок"] = {"Хваткая длань","Тянущая длань","Сокрушающая длань","Кормрок",}
    D.Presets["PT:" .. L["Hellfire_High_Council"]] = {"Гуртогг Кипящая Кровь","Мастер клинка Джубей'тос","Диа Зловещий Шепот",}
    D.Presets["PT:Килрогг Мертвый Глаз"] = {"Сгусток оскверненной крови","Сгусток крови","Истекающий слюной кровопийца","Громадный ужас","Повелительница адского огня","Демон адского огня","Бес адского огня","Килрогг Мертвый Глаз",}
    D.Presets["PT:Кровожад"] = {"Связанная кровью сущность","Связанное кровью создание","Связанный кровью дух","Мрачное создание","Разъяренный дух","Кровожад",}
    D.Presets["PT:Повелитель теней Искар"] = {"Оскверненный жрец Когтя","Страж Тьмы и Скверны","Железный матрос","Ирреальный резонанс","Повелитель теней Искар",}
    D.Presets["PT:" .. L["Socretar_the_Eternal"]] = {"Саргерайский доминатор","Ненасытный ловец душ","Саргерайский призыватель теней","Ритуальный голем","Душа Сокретара","Навязчивый дух",}
    D.Presets["PT:Деспотичная Велари"] = {"Древняя предвестница","Древний властелин","Деспотичная Велари","Древний каратель",}
    D.Presets["PT:Ксул'горак"] = {"Дикий пироман","Нестабильное исчадие Бездны","Передовой боец Аккелион","Омний","Ксул'горак",}
    D.Presets["PT:Маннорот"] = {"Владыка судеб","Жуткий инфернал","Бес Скверны","Маннорот",}
    D.Presets["PT:Архимонд"] = {"Дух Рокового Огня","Призыватель смерти Адского Пламени","Живая тень","Порожденный Скверной архидемон","Призыватель смерти Адского Пламени","Инфернал - вестник погибели","Звезда Бездны","Теневой демон Пустоты","Архимонд",}

    D.PresetLoaders = {
        ["npc:95068"] = "[npc]Осадный мастер Мар'так",
        ["npc:90284"] = "[npc]Железный разоритель",
        ["npc:90435"] = "[npc]Кормрок",
        ["npc:92146"] = "[npc]Гуртогг Кипящая Кровь",
        ["npc:90378"] = "[npc]Килрогг Мертвый Глаз",
        ["npc:90199"] = "[npc]Кровожад",
        ["npc:90316"] = "[npc]Повелитель теней Искар",
        ["npc:90296"] = "[npc]Ритуальный голем",
        ["npc:90269"] = "[npc]Деспотичная Велари",
        ["npc:93068"] = "[npc]Ксул'горак",
        ["npc:91349"] = "[npc]Маннорот",
        ["npc:91331"] = "[npc]Архимонд",
    }

    D.PresetLinks = {
        ["npc:95068"] = "PT:" .. L["Hellfire_Assault"],
        ["npc:90284"] = "PT:Железный разоритель",
        ["npc:90435"] = "PT:Кормрок",
        ["npc:92146"] = "PT:" .. L["Hellfire_High_Council"],
        ["npc:90378"] = "PT:Килрогг Мертвый Глаз",
        ["npc:90199"] = "PT:Кровожад",
        ["npc:90316"] = "PT:Повелитель теней Искар",
        ["npc:90296"] = "PT:" .. L["Socretar_the_Eternal"],
        ["npc:90269"] = "PT:Деспотичная Велари",
        ["npc:93068"] = "PT:Ксул'горак",
        ["npc:91349"] = "PT:Маннорот",
        ["npc:91331"] = "PT:Архимонд",
    }
end

end

if GetLocale() == "esES" then

if Mainline then
    D.Presets["PT:" .. L["Hellfire_Assault"]] = {"Triturador de fuego vil","Eructallamas de fuego vil","Artillería de fuego vil","Transportador de fuego vil","Terror Vinculasangre","Gran corruptor U'rogg","Gruto","Maestra de asedio Mar'tak","Rabioso descomunal","Cauterizador Vinculasangre","Taumaturga vil Vinculasangre","Fanático Vinculasangre","Corruptor Vinculasangre","Técnica de asedio",}
    D.Presets["PT:Atracador de la Horda de Hierro"] = {"Bomba de fuego de mecha rápida","Bomba de fuego volátil","Bomba de fuego ardiente","Bomba de fuego reforzada","Bomba de fuego reactiva","Atracador de la Horda de Hierro",}
    D.Presets["PT:Kormrok"] = {"Mano oprimente","Mano arrastrante","Mano aplastante","Kormrok",}
    D.Presets["PT:" .. L["Hellfire_High_Council"]] = {"Gurtogg Sangre Hirviente","Maestro del acero Jubei'thos","Deah Negro Rumor",}
    D.Presets["PT:Kilrogg Mortojo"] = {"Glóbulo de sangre vil","Glóbulo de sangre","Sediente de sangre salivoso","Terror descomunal","Maestra Llama Infernal","Maligno Llama Infernal","Diablillo Llama Infernal","Kilrogg Mortojo",}
    D.Presets["PT:Sanguino"] = {"Esencia Vinculasangre","Ensamblaje Vinculasangre","Espíritu Vinculasangre","Ensamblaje enigmático","Espíritu iracundo","Sanguino",}
    D.Presets["PT:Señor de las Sombras Iskar"] = {"Sacerdote de la garra corrupto","Celador de sombra vil","Estibador de la Horda de Hierro","[Phantasmal Resonance]","Señor de las Sombras Iskar",}
    D.Presets["PT:" .. L["Socretar_the_Eternal"]] = {"Dominador Sargerei","[Voracious Soulstalker]","Clamasombras Sargerei","Ensamblaje ligado al alma","Alma de Socrethar","Alma mortificadora",}
    D.Presets["PT:Tirana Velhari"] = {"Presagista ancestral","Soberano ancestral","Tirana Velhari","Déspota ancestral",}
    D.Presets["PT:Xhul'horac"] = {"Pirómano salvaje","Maligno del vacío inestable","Vanguardia Akkelion","Omnus","Xhul'horac",}
    D.Presets["PT:Mannoroth"] = {"Señor de fatalidad","Infernal aterrador","Diablillo vil","Mannoroth",}
    D.Presets["PT:Archimonde"] = {"Espíritu Fuego apocalíptico","Clamamuerte de Fuego Infernal","Sombra viviente","Gran maligno vilificado","Clamamuerte de Fuego Infernal","Portador de fatalidad infernal","Estrella del vacío","Caminante abisal ensombrecido","Archimonde",}

    D.PresetLoaders = {
        ["npc:95068"] = "[npc]Maestra de asedio Mar'tak",
        ["npc:90284"] = "[npc]Atracador de la Horda de Hierro",
        ["npc:90435"] = "[npc]Kormrok",
        ["npc:92146"] = "[npc]Gurtogg Sangre Hirviente",
        ["npc:90378"] = "[npc]Kilrogg Mortojo",
        ["npc:90199"] = "[npc]Sanguino",
        ["npc:90316"] = "[npc]Señor de las Sombras Iskar",
        ["npc:90296"] = "[npc]Ensamblaje ligado al alma",
        ["npc:90269"] = "[npc]Tirana Velhari",
        ["npc:93068"] = "[npc]Xhul'horac",
        ["npc:91349"] = "[npc]Mannoroth",
        ["npc:91331"] = "[npc]Archimonde",
    }

    D.PresetLinks = {
        ["npc:95068"] = "PT:" .. L["Hellfire_Assault"],
        ["npc:90284"] = "PT:Atracador de la Horda de Hierro",
        ["npc:90435"] = "PT:Kormrok",
        ["npc:92146"] = "PT:" .. L["Hellfire_High_Council"],
        ["npc:90378"] = "PT:Kilrogg Mortojo",
        ["npc:90199"] = "PT:Sanguino",
        ["npc:90316"] = "PT:Señor de las Sombras Iskar",
        ["npc:90296"] = "PT:" .. L["Socretar_the_Eternal"],
        ["npc:90269"] = "PT:Tirana Velhari",
        ["npc:93068"] = "PT:Xhul'horac",
        ["npc:91349"] = "PT:Mannoroth",
        ["npc:91331"] = "PT:Archimonde",
    }
end

end

if GetLocale() == "esMX" then

if Mainline then
    D.Presets["PT:" .. L["Hellfire_Assault"]] = {"Triturador de fuego vil","Eructallamas de fuego vil","Artillería de fuego vil","Transportador de fuego vil","Terror Vinculasangre","Gran corruptor U'rogg","Gruto","Maestra de asedio Mar'tak","Rabioso descomunal","Cauterizador Vinculasangre","Taumaturga vil Vinculasangre","Fanático Vinculasangre","Corruptor Vinculasangre","Técnica de asedio",}
    D.Presets["PT:Atracador de la Horda de Hierro"] = {"Bomba de fuego de mecha rápida","Bomba de fuego volátil","Bomba de fuego ardiente","Bomba de fuego reforzada","Bomba de fuego reactiva","Atracador de la Horda de Hierro",}
    D.Presets["PT:Kormrok"] = {"Mano oprimente","Mano arrastrante","Mano aplastante","Kormrok",}
    D.Presets["PT:" .. L["Hellfire_High_Council"]] = {"Gurtogg Sangre Hirviente","Maestro del acero Jubei'thos","Deah Negro Rumor",}
    D.Presets["PT:Kilrogg Mortojo"] = {"Glóbulo de sangre vil","Glóbulo de sangre","Sediente de sangre salivoso","Terror descomunal","Maestra Llama Infernal","Maligno Llama Infernal","Diablillo Llama Infernal","Kilrogg Mortojo",}
    D.Presets["PT:Sanguino"] = {"Esencia Vinculasangre","Ensamblaje Vinculasangre","Espíritu Vinculasangre","Ensamblaje enigmático","Espíritu iracundo","Sanguino",}
    D.Presets["PT:Señor de las Sombras Iskar"] = {"Sacerdote de la garra corrupto","Celador de sombra vil","Estibador de la Horda de Hierro","[Phantasmal Resonance]","Señor de las Sombras Iskar",}
    D.Presets["PT:" .. L["Socretar_the_Eternal"]] = {"Dominador Sargerei","[Voracious Soulstalker]","Clamasombras Sargerei","Ensamblaje ligado al alma","Alma de Socrethar","Alma mortificadora",}
    D.Presets["PT:Tirana Velhari"] = {"Presagista ancestral","Soberano ancestral","Tirana Velhari","Déspota ancestral",}
    D.Presets["PT:Xhul'horac"] = {"Pirómano salvaje","Maligno del vacío inestable","Vanguardia Akkelion","Omnus","Xhul'horac",}
    D.Presets["PT:Mannoroth"] = {"Señor de fatalidad","Infernal aterrador","Diablillo vil","Mannoroth",}
    D.Presets["PT:Archimonde"] = {"Espíritu Fuego apocalíptico","Clamamuerte de Fuego Infernal","Sombra viviente","Gran maligno vilificado","Clamamuerte de Fuego Infernal","Portador de fatalidad infernal","Estrella del vacío","Caminante abisal ensombrecido","Archimonde",}

    D.PresetLoaders = {
        ["npc:95068"] = "[npc]Maestra de asedio Mar'tak",
        ["npc:90284"] = "[npc]Atracador de la Horda de Hierro",
        ["npc:90435"] = "[npc]Kormrok",
        ["npc:92146"] = "[npc]Gurtogg Sangre Hirviente",
        ["npc:90378"] = "[npc]Kilrogg Mortojo",
        ["npc:90199"] = "[npc]Sanguino",
        ["npc:90316"] = "[npc]Señor de las Sombras Iskar",
        ["npc:90296"] = "[npc]Ensamblaje ligado al alma",
        ["npc:90269"] = "[npc]Tirana Velhari",
        ["npc:93068"] = "[npc]Xhul'horac",
        ["npc:91349"] = "[npc]Mannoroth",
        ["npc:91331"] = "[npc]Archimonde",
    }

    D.PresetLinks = {
        ["npc:95068"] = "PT:" .. L["Hellfire_Assault"],
        ["npc:90284"] = "PT:Atracador de la Horda de Hierro",
        ["npc:90435"] = "PT:Kormrok",
        ["npc:92146"] = "PT:" .. L["Hellfire_High_Council"],
        ["npc:90378"] = "PT:Kilrogg Mortojo",
        ["npc:90199"] = "PT:Sanguino",
        ["npc:90316"] = "PT:Señor de las Sombras Iskar",
        ["npc:90296"] = "PT:" .. L["Socretar_the_Eternal"],
        ["npc:90269"] = "PT:Tirana Velhari",
        ["npc:93068"] = "PT:Xhul'horac",
        ["npc:91349"] = "PT:Mannoroth",
        ["npc:91331"] = "PT:Archimonde",
    }
end

end

if GetLocale() == "deDE" then

if Mainline then
    D.Presets["PT:" .. L["Hellfire_Assault"]] = {"Teufelsfeuerzermalmer","Teufelsflammenwerfer","Teufelsfeuerartillerie","Teufelsfeuertransporter","Blutgebundener Schrecken","Oberster Verderber U'rogg","Kloppor","Belagerungsmeisterin Mar'tak","Bulliger Berserker","Blutgebundener Kauterisierer","Blutgebundene Teufelswirkerin","Blutgebundener Fanatiker","Blutgebundener Verderber","Belagerungstechnikerin",}
    D.Presets["PT:Eiserner Häscher"] = {"Schnellzündende Feuerbombe","Flüchtige Feuerbombe","Brennende Feuerbombe","Verstärkte Feuerbombe","Reaktive Feuerbombe","Eiserner Häscher",}
    D.Presets["PT:Kormrok"] = {"Packende Hand","Verschleppende Hand","Zertrümmernde Hand","Kormrok",}
    D.Presets["PT:" .. L["Hellfire_High_Council"]] = {"Gurtogg Siedeblut","Klingenmeister Jubei'thos","Dia Schattenflüsterer",}
    D.Presets["PT:Kilrogg Totauge"] = {"Teufelsblutgerinnsel","Blutgerinnsel","Geifernder Blutdürster","Bulliger Schrecken","Höllenglutherrin","Höllenglutscheusal","Höllenglutwichtel","Kilrogg Totauge",}
    D.Presets["PT:Blutschatten"] = {"Blutgebundene Essenz","Blutgebundenes Konstrukt","Blutgebundener Geist","Skelettschöpfung","Wütender Geist","Blutschatten",}
    D.Presets["PT:Schattenfürst Iskar"] = {"Verderbter Krallenpriester","Teufelsschattenwächter","Eiserner Dockarbeiter","Trügerisches Echo","Schattenfürst Iskar",}
    D.Presets["PT:" .. L["Socretar_the_Eternal"]] = {"Dominator der Sargerei","Gieriger Seelenpirscher","Schattenrufer der Sargerei","Seelengebundenes Konstrukt","Seele von Socrethar","Hetzende Seele",}
    D.Presets["PT:Tyrannin Velhari"] = {"Uralter Vorbote","Uralter Souverän","Tyrannin Velhari","Uralter Vollstrecker",}
    D.Presets["PT:Xhul'horac"] = {"Wilder Feuerteufel","Instabiles Leerenscheusal","Akkelion die Speerspitze","Omnus","Xhul'horac",}
    D.Presets["PT:Mannoroth"] = {"Verdammnislord","Schreckenshöllenbestie","Teufelswichtel","Mannoroth",}
    D.Presets["PT:Archimonde"] = {"Verdammnisfeuergeist","Höllenfeuertodesrufer","Lebendiger Schatten","Teufelsgeborener Oberdämon","Höllenfeuertodesrufer","Höllischer Verdammnisbringer","Leerenstern","Schattenhafter Netherwandler","Archimonde",}

    D.PresetLoaders = {
        ["npc:95068"] = "[npc]Belagerungsmeisterin Mar'tak",
        ["npc:90284"] = "[npc]Eiserner Häscher",
        ["npc:90435"] = "[npc]Kormrok",
        ["npc:92146"] = "[npc]Gurtogg Siedeblut",
        ["npc:90378"] = "[npc]Kilrogg Totauge",
        ["npc:90199"] = "[npc]Blutschatten",
        ["npc:90316"] = "[npc]Schattenfürst Iskar",
        ["npc:90296"] = "[npc]Seelengebundenes Konstrukt",
        ["npc:90269"] = "[npc]Tyrannin Velhari",
        ["npc:93068"] = "[npc]Xhul'horac",
        ["npc:91349"] = "[npc]Mannoroth",
        ["npc:91331"] = "[npc]Archimonde",
    }

    D.PresetLinks = {
        ["npc:95068"] = "PT:" .. L["Hellfire_Assault"],
        ["npc:90284"] = "PT:Eiserner Häscher",
        ["npc:90435"] = "PT:Kormrok",
        ["npc:92146"] = "PT:" .. L["Hellfire_High_Council"],
        ["npc:90378"] = "PT:Kilrogg Totauge",
        ["npc:90199"] = "PT:Blutschatten",
        ["npc:90316"] = "PT:Schattenfürst Iskar",
        ["npc:90296"] = "PT:" .. L["Socretar_the_Eternal"],
        ["npc:90269"] = "PT:Tyrannin Velhari",
        ["npc:93068"] = "PT:Xhul'horac",
        ["npc:91349"] = "PT:Mannoroth",
        ["npc:91331"] = "PT:Archimonde",
    }
end

end

if GetLocale() == "itIT" then

if Mainline then
    D.Presets["PT:" .. L["Hellfire_Assault"]] = {"Frantumatore del Vilfuoco","Sputafiamme del Vilfuoco","Artiglieria del Vilfuoco","Trasportatore del Vilfuoco","Terrore di Malacarne","[Grand Corruptor U'rogg]","[Grute]","Maestra d'Assedio Mar'tak","Berserker Gigantesco","Cauterizzatore di Malacarne","Vilstrega di Malacarne","Fanatico di Malacarne","Corruttore di Malacarne","Tecnica dell'Officina Bellica",}
    D.Presets["PT:Razziatore di Ferro"] = {"[Quick-Fuse Firebomb]","Fuocobomba Instabile","[Burning Firebomb]","[Reinforced Firebomb]","[Reactive Firebomb]","Razziatore di Ferro",}
    D.Presets["PT:Kormrok"] = {"Mano Ghermitrice","Mano Trascinante","Mano Infetta","Kormrok",}
    D.Presets["PT:" .. L["Hellfire_High_Council"]] = {"Gurtogg Bollisangue","Maestro di Spade Jubei'thos","Dia Mormoscuro",}
    D.Presets["PT:Kilrogg Occhiotetro"] = {"[Fel Blood Globule]","Globulo di Sangue","Bramasangue Sbavante","Terrore Gigantesco","Signora Ardinferno","Demonio Ardinferno","Imp Ardinferno","Kilrogg Occhiotetro",}
    D.Presets["PT:Malacarne"] = {"Essenza di Malacarne","Costrutto di Malacarne","Spirito di Malacarne","Costrutto dell'Ombra","Spirito Rabbioso","Malacarne",}
    D.Presets["PT:Signore dell'Ombra Iskar"] = {"Sacerdote Corrotto di Terokk","Guardiano Vilombra","Scaricatore di Porto di Ferro","[Phantasmal Resonance]","Signore dell'Ombra Iskar",}
    D.Presets["PT:" .. L["Socretar_the_Eternal"]] = {"Dominatore Sargerei","[Voracious Soulstalker]","Mago d'Ombra Sargerei","Costrutto Vincolato","Anima di Socrethar","Anima Infestante",}
    D.Presets["PT:Velhari la Despota"] = {"Araldo Antico","Monarca Antico","Velhari la Despota","Esecutore Antico",}
    D.Presets["PT:Xhul'horac"] = {"Piromane Selvaggio","Demonio del Vuoto Instabile","Avanguardia Akkelion","Omnus","Xhul'horac",}
    D.Presets["PT:Mannoroth"] = {"Signore della Rovina","Infernale del Terrore","Vilimp","Mannoroth",}
    D.Presets["PT:Archimonde"] = {"Spirito del Fuoco della Rovina","Invocamorte del Fuoco Infernale","Ombra Vivente","Signore dei Demoni della Stirpe Vile","Invocamorte del Fuoco Infernale","Araldo della Rovina Infernale","Stella del Vuoto","Calcafatuo Adombrato","Archimonde",}

    D.PresetLoaders = {
        ["npc:95068"] = "[npc]Maestra d'Assedio Mar'tak",
        ["npc:90284"] = "[npc]Razziatore di Ferro",
        ["npc:90435"] = "[npc]Kormrok",
        ["npc:92146"] = "[npc]Gurtogg Bollisangue",
        ["npc:90378"] = "[npc]Kilrogg Occhiotetro",
        ["npc:90199"] = "[npc]Malacarne",
        ["npc:90316"] = "[npc]Signore dell'Ombra Iskar",
        ["npc:90296"] = "[npc]Costrutto Vincolato",
        ["npc:90269"] = "[npc]Velhari la Despota",
        ["npc:93068"] = "[npc]Xhul'horac",
        ["npc:91349"] = "[npc]Mannoroth",
        ["npc:91331"] = "[npc]Archimonde",
    }

    D.PresetLinks = {
        ["npc:95068"] = "PT:" .. L["Hellfire_Assault"],
        ["npc:90284"] = "PT:Razziatore di Ferro",
        ["npc:90435"] = "PT:Kormrok",
        ["npc:92146"] = "PT:" .. L["Hellfire_High_Council"],
        ["npc:90378"] = "PT:Kilrogg Occhiotetro",
        ["npc:90199"] = "PT:Malacarne",
        ["npc:90316"] = "PT:Signore dell'Ombra Iskar",
        ["npc:90296"] = "PT:" .. L["Socretar_the_Eternal"],
        ["npc:90269"] = "PT:Velhari la Despota",
        ["npc:93068"] = "PT:Xhul'horac",
        ["npc:91349"] = "PT:Mannoroth",
        ["npc:91331"] = "PT:Archimonde",
    }
end

end

if GetLocale() == "ptBR" then

if Mainline then
    D.Presets["PT:" .. L["Hellfire_Assault"]] = {"Esmagador de Fogovil","Arrotachama de Fogovil","Artilharia de Fogovil","Transportador de Fogovil","Terror Kerssang","[Grand Corruptor U'rogg]","[Grute]","Mestre de Cerco Mar'tak","Berserker Agigantado","Cauterizador Kerssang","Lançavil Kerssang","Fanático Kerssang","Corruptor Kerssang","Técnica do Cerco de Ferro",}
    D.Presets["PT:Aniquilador de Ferro"] = {"[Quick-Fuse Firebomb]","Bomba de Fogo Volátil","[Burning Firebomb]","[Reinforced Firebomb]","[Reactive Firebomb]","Aniquilador de Ferro",}
    D.Presets["PT:Kormrok"] = {"Mão Agarradora","Mão Arrastadora","Mão Esmagadora","Kormrok",}
    D.Presets["PT:" .. L["Hellfire_High_Council"]] = {"Gurtogg Fervessangue","Mestre de Espadas Jubei'Thos","Dia Neromúrmur",}
    D.Presets["PT:Kilrogg Olho Morto"] = {"[Fel Blood Globule]","Glóbulo de Sangue","Sanguissedento Salivante","Terror Agigantado","Senhora Ardinferno","Malévolo Ardinferno","Diabrete Ardinferno","Kilrogg Olho Morto",}
    D.Presets["PT:Sanguinávido"] = {"Essência Kerssang","Constructo Kerssang","Espírito Kerssang","Constructo Sombrio","Espírito Enfurecido","Sanguinávido",}
    D.Presets["PT:Umbramestre Iskar"] = {"Sacerdote da Garra Corrompido","Guardião Sombra Vil","Estivador de Ferro","[Phantasmal Resonance]","Umbramestre Iskar",}
    D.Presets["PT:" .. L["Socretar_the_Eternal"]] = {"Dominador Sargerei","[Voracious Soulstalker]","Clamassombra Sargerei","Constructo Vinculado","Alma de Socrethar","Alma Assombrante",}
    D.Presets["PT:Tirana Velhari"] = {"Arauto Ancestral","Suserano Ancestral","Tirana Velhari","Impositor Ancestral",}
    D.Presets["PT:Xhul'horac"] = {"Piromaníaco Selvagem","Demônio do Caos Instável","Vanguardeiro Akkelion","Omnus","Xhul'horac",}
    D.Presets["PT:Mannoroth"] = {"Senhor da Perdição","Infernal Medonho","Diabrete Vil","Mannoroth",}
    D.Presets["PT:Arquimonde"] = {"Espírito Chama da Ruína","Bradamorte do Fogo do Inferno","Sombra Viva","Demônio Superior Vilanesco","Bradamorte do Fogo do Inferno","Infernal Arauto da Ruína","Estrela do Vazio","Andarilho do Éter Sombrio","Arquimonde",}

    D.PresetLoaders = {
        ["npc:95068"] = "[npc]Mestre de Cerco Mar'tak",
        ["npc:90284"] = "[npc]Aniquilador de Ferro",
        ["npc:90435"] = "[npc]Kormrok",
        ["npc:92146"] = "[npc]Gurtogg Fervessangue",
        ["npc:90378"] = "[npc]Kilrogg Olho Morto",
        ["npc:90199"] = "[npc]Sanguinávido",
        ["npc:90316"] = "[npc]Umbramestre Iskar",
        ["npc:90296"] = "[npc]Constructo Vinculado",
        ["npc:90269"] = "[npc]Tirana Velhari",
        ["npc:93068"] = "[npc]Xhul'horac",
        ["npc:91349"] = "[npc]Mannoroth",
        ["npc:91331"] = "[npc]Arquimonde",
    }

    D.PresetLinks = {
        ["npc:95068"] = "PT:" .. L["Hellfire_Assault"],
        ["npc:90284"] = "PT:Aniquilador de Ferro",
        ["npc:90435"] = "PT:Kormrok",
        ["npc:92146"] = "PT:" .. L["Hellfire_High_Council"],
        ["npc:90378"] = "PT:Kilrogg Olho Morto",
        ["npc:90199"] = "PT:Sanguinávido",
        ["npc:90316"] = "PT:Umbramestre Iskar",
        ["npc:90296"] = "PT:" .. L["Socretar_the_Eternal"],
        ["npc:90269"] = "PT:Tirana Velhari",
        ["npc:93068"] = "PT:Xhul'horac",
        ["npc:91349"] = "PT:Mannoroth",
        ["npc:91331"] = "PT:Arquimonde",
    }
end

end

if GetLocale() == "zhCN" then

if Mainline then
    D.Presets["PT:" .. L["Hellfire_Assault"]] = {"邪火碎石机","邪火喷射机","邪火巨炮","邪火运输车","血缚恐魔","腐蚀领主乌鲁格","格鲁特","攻城大师玛塔克","魁梧的狂战士","血缚火疗者","血缚邪术士","血缚狂信徒","血缚腐化者","攻城技师",}
    D.Presets["PT:钢铁掠夺者"] = {"速爆火焰炸弹","易爆火焰炸弹","炽燃火焰炸弹","强化火焰炸弹","感应火焰炸弹","钢铁掠夺者",}
    D.Presets["PT:考莫克"] = {"攫取之手","牵引之手","粉碎之手","考莫克",}
    D.Presets["PT:" .. L["Hellfire_High_Council"]] = {"古尔图格·血沸","剑圣朱倍尔索斯","迪亚·暗语",}
    D.Presets["PT:基尔罗格·死眼"] = {"邪能血球","血球","垂涎的嗜血者","巨型恐魔","鬼焰魔女","鬼焰魔","鬼焰小鬼","基尔罗格·死眼",}
    D.Presets["PT:血魔"] = {"血缚精华","血缚构造体","血缚之魂","阴暗构造体","被激怒的灵魂","血魔",}
    D.Presets["PT:暗影领主艾斯卡"] = {"腐化的鸦爪祭司","邪影守望者","钢铁码头工人","幻影共鸣","暗影领主艾斯卡",}
    D.Presets["PT:" .. L["Socretar_the_Eternal"]] = {"萨格雷统御者","贪婪的逐魂者","萨格雷召影者","缚魂构装体","索克雷萨之魂","作祟的幽魂",}
    D.Presets["PT:暴君维哈里"] = {"上古先驱","上古统御者","暴君维哈里","上古执行者",}
    D.Presets["PT:祖霍拉克"] = {"野生纵火魔","不稳定的空灵魔","先锋阿基里奥","奥姆努斯","祖霍拉克",}
    D.Presets["PT:玛诺洛斯"] = {"末日领主","恐惧地狱火","邪能小鬼","玛诺洛斯",}
    D.Presets["PT:阿克蒙德"] = {"魔火之魂","炎狱召亡者","活体暗影","邪脉大恶魔","炎狱召亡者","地狱火末日使者","虚空之星","暗影虚无行者","阿克蒙德",}

    D.PresetLoaders = {
        ["npc:95068"] = "[npc]攻城大师玛塔克",
        ["npc:90284"] = "[npc]钢铁掠夺者",
        ["npc:90435"] = "[npc]考莫克",
        ["npc:92146"] = "[npc]古尔图格·血沸",
        ["npc:90378"] = "[npc]基尔罗格·死眼",
        ["npc:90199"] = "[npc]血魔",
        ["npc:90316"] = "[npc]暗影领主艾斯卡",
        ["npc:90296"] = "[npc]缚魂构装体",
        ["npc:90269"] = "[npc]暴君维哈里",
        ["npc:93068"] = "[npc]祖霍拉克",
        ["npc:91349"] = "[npc]玛诺洛斯",
        ["npc:91331"] = "[npc]阿克蒙德",
    }

    D.PresetLinks = {
        ["npc:95068"] = "PT:" .. L["Hellfire_Assault"],
        ["npc:90284"] = "PT:钢铁掠夺者",
        ["npc:90435"] = "PT:考莫克",
        ["npc:92146"] = "PT:" .. L["Hellfire_High_Council"],
        ["npc:90378"] = "PT:基尔罗格·死眼",
        ["npc:90199"] = "PT:血魔",
        ["npc:90316"] = "PT:暗影领主艾斯卡",
        ["npc:90296"] = "PT:" .. L["Socretar_the_Eternal"],
        ["npc:90269"] = "PT:暴君维哈里",
        ["npc:93068"] = "PT:祖霍拉克",
        ["npc:91349"] = "PT:玛诺洛斯",
        ["npc:91331"] = "PT:阿克蒙德",
    }
end

end

if GetLocale() == "frFR" then

if Mainline then
    D.Presets["PT:" .. L["Hellfire_Assault"]] = {"Ecraseur gangrefeu","Crache-flamme gangrefeu","Artillerie gangrefeu","Transporteur gangrefeu","Terreur sang-lié","Grand corrupteur U’rogg","Grute","Maître de siège Mar’tak","Berserker massif","Cautérisateur sang-lié","Gangre-lanceuse sang-lié","Fanatique sang-lié","Corrupteur sang-lié","Technicienne de l’atelier de siège",}
    D.Presets["PT:Saccageur de Fer"] = {"Bombe incendiaire à mèche courte","Bombe incendiaire volatile","Bombe incendiaire enflammée","Bombe incendiaire renforcée","Bombe incendiaire réactive","Saccageur de Fer",}
    D.Presets["PT:Kormrok"] = {"Main avide","Main traînante","Main écrasante","Kormrok",}
    D.Presets["PT:" .. L["Hellfire_High_Council"]] = {"Gurtogg Fièvresang","Maître-lame Jubei’thos","Dia Sombre-Murmure",}
    D.Presets["PT:Kilrogg Oeil-Mort"] = {"Globule de gangresang","Globule de sang","Carnassier salivant","Terreur massive","Maîtresse feu-d’enfer","Fiel feu-d’enfer","Diablotin feu-d’enfer","Kilrogg Oeil-Mort",}
    D.Presets["PT:Fielsang"] = {"Essence sang-lié","Assemblage sang-lié","Esprit sang-lié","Assemblage ténébreux","Esprit enragé","Fielsang",}
    D.Presets["PT:Seigneur de l’ombre Iskar"] = {"Prêtre de la serre corrompu","Gardien gangre-ombre","Débardeur de Fer","Résonance fantasmatique","Seigneur de l’ombre Iskar",}
    D.Presets["PT:" .. L["Socretar_the_Eternal"]] = {"Dominateur sargereï","Traqueur d’âmes vorace","Mande-l’ombre sargereï","Assemblage spirituel","Ame de Socrethar","Ame hanteuse",}
    D.Presets["PT:Velhari la Despote"] = {"Ancienne messagère","Ancien souverain","Velhari la Despote","Ancien massacreur",}
    D.Presets["PT:Xhul’horac"] = {"Pyromane sauvage","Videfiel instable","Avant-garde Akkelion","Omnus","Xhul’horac",}
    D.Presets["PT:Mannoroth"] = {"Seigneur funeste","Infernal de l’effroi","Diablotin gangrené","Mannoroth",}
    D.Presets["PT:Archimonde"] = {"Esprit du feu funeste","Mandemort des Flammes infernales","Ombre vivante","Démon supérieur gangrelien","Mandemort des Flammes infernales","Porte-destin infernal","Etoile du Vide","Marcheur du Néant d’ombre","Archimonde",}

    D.PresetLoaders = {
        ["npc:95068"] = "[npc]Maître de siège Mar’tak",
        ["npc:90284"] = "[npc]Saccageur de Fer",
        ["npc:90435"] = "[npc]Kormrok",
        ["npc:92146"] = "[npc]Gurtogg Fièvresang",
        ["npc:90378"] = "[npc]Kilrogg Oeil-Mort",
        ["npc:90199"] = "[npc]Fielsang",
        ["npc:90316"] = "[npc]Seigneur de l’ombre Iskar",
        ["npc:90296"] = "[npc]Assemblage spirituel",
        ["npc:90269"] = "[npc]Velhari la Despote",
        ["npc:93068"] = "[npc]Xhul’horac",
        ["npc:91349"] = "[npc]Mannoroth",
        ["npc:91331"] = "[npc]Archimonde",
    }

    D.PresetLinks = {
        ["npc:95068"] = "PT:" .. L["Hellfire_Assault"],
        ["npc:90284"] = "PT:Saccageur de Fer",
        ["npc:90435"] = "PT:Kormrok",
        ["npc:92146"] = "PT:" .. L["Hellfire_High_Council"],
        ["npc:90378"] = "PT:Kilrogg Oeil-Mort",
        ["npc:90199"] = "PT:Fielsang",
        ["npc:90316"] = "PT:Seigneur de l’ombre Iskar",
        ["npc:90296"] = "PT:" .. L["Socretar_the_Eternal"],
        ["npc:90269"] = "PT:Velhari la Despote",
        ["npc:93068"] = "PT:Xhul’horac",
        ["npc:91349"] = "PT:Mannoroth",
        ["npc:91331"] = "PT:Archimonde",
    }
end

end

