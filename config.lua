Config = {}

Config.Webhook = "https://discord.com/api/webhooks/1304477676563857470/TNcTQIn90EeLaJ663TgCvFUMyqPzYXufmPHuwOmMWjPWfFJrkqUqYFV8RNokWU7PodNY"
Config.WebhookName = "Horizon Fishing"


Config.SellLowPrice = 1500 --Lowest potential price per 5 sushi rolls sold
Config.SellHighPrice = 2500 --Highest potential price per 5 sushi rolls sold
Config.RequiredBait = 'canoworms'       --There must not be a seperate use function created for this else will conflict with script
Config.IllegalBait = 'illegalfishbait'  --There must not be a seperate use function created for this else will conflict with script
Config.AlertChance = 50 --% chance alert will be triggered when an illegal fish is caught

--Selling Locations
Config.pedLocation = vector4(-1038.32, -1396.94, 5.55, 75.59) --Make sures matches the suhi sell blip
Config.pedType = `MP_M_Meth_01`
Config.illegalpedLocation = vector4(-457.91, -2266.19, 8.52, 274.14)
Config.illegalpedType = `S_M_M_Warehouse_01`

--FISH CONFIGS
Config.fish = {
    [1] = 'oceancod',
    [2] = 'oceanflounder',
--Rare fish are fish above 2, fish below 2 are "common"
    [3] = 'oceanmackerel',
    [4] = 'oceanbluefish'
}



Config.illegalfish = {
    [1] = 'stingray',
    [2] = 'sharkfish',
--Rare fish are fish above 2, fish below 2 are "common"
    [3] = 'seaturtle',
    [4] = 'dolphin'
}

--UnwashedCash is given at this value 
Config.illegalfishValue = {
    ['stingray'] = 15000,
    ['sharkfish'] = 17500,
    ['seaturtle'] = 110000,
    ['dolphin'] = 115000
}


Config.fishCutValue = {
    ['oceancod'] = 1,
    ['oceanflounder'] = 2,
    ['oceanmackerel'] = 4,
    ['oceanbluefish'] = 8
}

Config.badFish = {
    [1] = 'oceanboot',
    [2] = 'pot',
    [3] = 'bottle',
    [4] = 'can', 
    [5] = 'oceanchest', --Make sure this item stays in array
    [6] = 'oceanlockbox', --Make sure this item stays in array
    [7] = 'illegalfishbait',
}

--DROP CONFIGS FOR OCEANCHEST AND OCEANLOCKBOX
Config.dropItems = {
    [1] = 'weapon_pistol',
    [2] = 'goldchain',
    [3] = 'illegalfishbait',
    [4] = 'stolen_diamond',
    [5] = 'rolex',
    --From here only the chest will drop these items
    [6] = 'heavyarmor', 
    [7] = 'drug_meth',
    [8] = 'security_card_01',
}

Config.dropQuantity = {
    ['weapon_pistol'] = 1,
    ['goldchain'] = 4,
    ['illegalfishbait'] = 10,
    ['stolen_diamond'] = 3,
    ['rolex'] = 2,
    ['heavyarmor'] = 1,
    ['drug_meth'] = 10,
    ['security_card_01'] = 5,
}

--How many times the dice roll for is done for dropItems, in essence they will get this amount of item type drops, does not affect quantity of the item type
Config.AmountOfRareDrops = 2 


--MAP BLIPS
Config.blips = {
    {title="Fish Cutting", colour=62, id=68, scale=0.7, x = -3427.2314453125, y = 967.49719238281, z = 8.3466892242432},
    {title="Sushi Rolling", colour=41, id=501, scale=0.7, x = -3426.88, y = 978.62, z = 8.35},
    {title="Sushi Sales", colour=9, id=356, scale=0.7, x = -1037.6729736328, y = -1397.1528320312, z = 5.5531921386719}
}





--Jim Bridge compatibility
Config.System = {
    Debug = false,		-- This enables Debug mode
                        -- Revealing debug prints and debug boxes on targets

    Menu = "ox", 		-- This specifies what menu script will be loaded
                        -- "qb" = `qb-menu` and edited versions of it
                        -- "ox" = `ox_lib`'s context menu system
                        -- "gta" = `WarMenu' a free script for a gta style menu

    Notify = "ox",		-- This allows you to choose the notification system for scripts
                        -- "qb" = `qb-core`'s built in notifications
                        -- "ox" = `ox_lib`'s built in notifications
                        -- "esx" = `esx_notify` esx's default notifications
                        -- "okok" = `okok-notify` okok's notifications
                        -- "gta" = Native GTA style popups

    drawText = "ox",	-- The style of drawText you want to use
                        -- "qb" = `qb-core`'s drawText system
                        -- "ox" = `ox_lib`'s drawTextUI system
                        -- "gta" = Native GTA style popups


    progressBar = "ox" -- The style of progressBar you want to use
                        -- "qb" = `qb-core`'s style progressBar
                        -- "ox" = `ox_lib`'s default progressBar
                        -- "gta" = Native GTA style "spinner"
}