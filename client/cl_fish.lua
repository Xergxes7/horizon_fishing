local QBCore = exports['qb-core']:GetCoreObject()

local LegalBait = false
local IllegalBait = false
local BaitSet = false
local fishingRod
local hasPoleOut = false
local poleTimer = 0
local baitTimer = 0

local function timerCount()
    if poleTimer ~= 0 then
        poleTimer = poleTimer - 1
    end
    if baitTimer ~= 0 then
        baitTimer = baitTimer - 1
    end
    SetTimeout(1000, timerCount)
end

local rodHandle = ""
timerCount()



CastBait = function(rodHandle, castLocation)
    baitTimer = 5
    local startedCasting = GetGameTimer()
    while not IsControlJustPressed(0, 47) do
        lib.showTextUI('Flex [G] to cast line. \n Flex [SPACEBAR] to Catch a Fish', {
            position = "top-center",
            icon = 'fish',
            style = {
                borderRadius = 0,
                backgroundColor = '#ffaa00',
                color = 'white'
            }
        })
        Citizen.Wait(5)
        DisableControlAction(0, 311, true)
        DisableControlAction(0, 157, true)
        DisableControlAction(0, 158, true)
        DisableControlAction(0, 160, true)
        DisableControlAction(0, 164, true)
        if not hasPoleOut then
            return
        end
    end
    if not hasPoleOut then 
        ShowNotification("Item Missing","You need a fishing rod.","error") 
        return 
    end
    if not BaitSet then
        ShowNotification("Direction","You need to put bait on your line first.","error")
        return
    end
    if IsPedSwimming(PlayerPedId()) then 
        ShowNotification("Wrong Zone","You can't fish while in the water.","error") 
        return 
    end
    if IsPedInAnyVehicle(PlayerPedId(),true) then 
        ShowNotification("In Vehicle","Exit your vehicle first before fishing.","error") 
        return 
    end
    rodHandle, castLocation = IsInWater()
    if not rodHandle and not castLocation then
        ShowNotification("No water nearby","You need to fish from a body of water","error") 
        return 
    end

    PlayAnimation(PlayerPedId(), "mini@tennis", "forehand_ts_md_far", {
        ["flag"] = 48
    })
    while IsEntityPlayingAnim(PlayerPedId(), "mini@tennis", "forehand_ts_md_far", 3) do
        Citizen.Wait(0)
    end
    PlayAnimation(PlayerPedId(), "amb@world_human_stand_fishing@idle_a", "idle_c", {
        ["flag"] = 11
    })   
    local startedBaiting = GetGameTimer()
    local randomBait = math.random(3000, 10000)
    --DrawBusySpinner("Waiting for a fish to bite...")
    DisableControlAction(0, 311, true)
    DisableControlAction(0, 157, true)
    DisableControlAction(0, 158, true)
    DisableControlAction(0, 160, true)
    DisableControlAction(0, 164, true)
    local interupted = false
    Citizen.Wait(1000)
    while GetGameTimer() - startedBaiting < randomBait do
        Citizen.Wait(5)
        if not IsEntityPlayingAnim(PlayerPedId(), "amb@world_human_stand_fishing@idle_a", "idle_c", 3) or not hasPoleOut then
            interupted = true
            break
        end
    end
    RemoveLoadingPrompt()
    if interupted then
        ClearPedTasks(PlayerPedId())
        CastBait(rodHandle, castLocation)
        return
    end
    local caughtFish = false

    exports['boii_minigames']:skill_bar({
        style = 'default', -- Style template
        icon = 'fa-solid fa-fish', -- Any font-awesome icon; will use template icon if none is provided
        orientation = 2, -- Orientation of the bar; 1 = horizontal centre, 2 = vertical right.
        area_size = 15, -- Size of the target area in %
        perfect_area_size = 2, -- Size of the perfect area in %
        speed = 0.75, -- Speed the target area moves
        moving_icon = true, -- Toggle icon movement; true = icon will move randomly, false = icon will stay in a static position
        icon_speed = 5, -- Speed to move the icon if icon movement enabled; this value is / 100 in the javascript side true value is 0.03
    }, function(success) -- Game callback
        if success == 'perfect' then
            -- If perfect do something
            caughtFish = true
            ClearPedTasks(PlayerPedId())
            TriggerServerEvent("void-fish:removebait",LegalBait,IllegalBait)
            TriggerServerEvent("void-fish:payoutForFishingCatch",LegalBait,IllegalBait)
            TriggerServerEvent("void-fish:payoutForFishingCatch",LegalBait,IllegalBait)
            BaitSet = false
            ShowNotification("Amazing!","Perfect Catch!","success")
        elseif success == 'success' then
            -- If success do something
            caughtFish = true
            ClearPedTasks(PlayerPedId())
            TriggerServerEvent("void-fish:removebait",LegalBait,IllegalBait)
            TriggerServerEvent("void-fish:payoutForFishingCatch",LegalBait,IllegalBait)
            BaitSet = false
            ShowNotification("Congratulations","You caught a fish","success")
        elseif success == 'failed' then
            -- If failed do something
            caughtFish = false
            ClearPedTasks(PlayerPedId())
            TriggerServerEvent("void-fish:removebait",LegalBait,IllegalBait)
            BaitSet = false
            ShowNotification("Bad Luck","The fish got loose","error")
        end
    end)
    
end

IsInWater = function()
    local startedCheck = GetGameTimer()
    local ped = PlayerPedId()
    local pedPos = GetEntityCoords(ped)
    local forwardVector = GetEntityForwardVector(ped)
    local forwardPos = vector3(pedPos["x"] + forwardVector["x"] * 10, pedPos["y"] + forwardVector["y"] * 10, pedPos["z"])
    local fishHash = GetHashKey('a_c_fish')
    RequestModel(fishHash)
    if not HasModelLoaded(fishHash) then
        Citizen.Wait(0)
    end
    local waterHeight = GetWaterHeight(forwardPos["x"], forwardPos["y"], forwardPos["z"])
---@diagnostic disable-next-line: missing-parameter
    local fishHandle = CreatePed(1, fishHash, forwardPos, 0.0, false)
    SetEntityAlpha(fishHandle, 0, true)
    ShowNotification("Checking Location","Checking Fishing Location","warning")
    while GetGameTimer() - startedCheck < 3000 do
        Citizen.Wait(0)
    end
    RemoveLoadingPrompt()
    local fishInWater = IsEntityInWater(fishHandle)
    DeleteEntity(fishHandle)
    SetModelAsNoLongerNeeded(fishHash)
    if fishInWater then
        ShowNotification("In Location", "You are at a valid body of water","inform")
    end
    return fishInWater, fishInWater and vector3(forwardPos["x"], forwardPos["y"], waterHeight) or false
end



-- GenerateFishingRod = function(ped)
--     local pedPos = GetEntityCoords(ped)
--     local fishingRodHash = GetHashKey('prop_fishing_rod_01')
--     RequestModel(fishingRodHash)
--     if not HasModelLoaded(fishingRodHash) then
--         Citizen.Wait(0)
--     end
--     rodHandle = CreateObject(fishingRodHash, pedPos, true)
--     AttachEntityToEntity(rodHandle, ped, GetPedBoneIndex(ped, 18905), 0.1, 0.05, 0, 80.0, 120.0, 160.0, true, true, false, true, 1, true)
--     SetModelAsNoLongerNeeded(fishingRodHash)
-- end



PlayAnimation = function(ped, dict, anim, settings)
	if dict then
        Citizen.CreateThread(function()
            RequestAnimDict(dict)

            while not HasAnimDictLoaded(dict) do
                Citizen.Wait(100)
            end

            if settings == nil then
                TaskPlayAnim(ped, dict, anim, 1.0, -1.0, 1.0, 0, 0, 0, 0, 0)
            else 
                local speed = 1.0
                local speedMultiplier = -1.0
                local duration = 1.0
                local flag = 0
                local playbackRate = 0
                if settings["speed"] then
                    speed = settings["speed"]
                end

                if settings["speedMultiplier"] then
                    speedMultiplier = settings["speedMultiplier"]
                end

                if settings["duration"] then
                    duration = settings["duration"]
                end
                if settings["flag"] then
                    flag = settings["flag"]
                end
                if settings["playbackRate"] then

                    playbackRate = settings["playbackRate"]

                end
                TaskPlayAnim(ped, dict, anim, speed, speedMultiplier, duration, flag, playbackRate, 0, 0, 0)
            end
            RemoveAnimDict(dict)
		end)
	else
		TaskStartScenarioInPlace(ped, anim, 0, true)
	end
end



FadeOut = function(duration)
    DoScreenFadeOut(duration)
    while not IsScreenFadedOut() do
        Citizen.Wait(0)
    end
end



FadeIn = function(duration)
    DoScreenFadeIn(500)
    while not IsScreenFadedIn() do
        Citizen.Wait(0)
    end
end



WaitForModel = function(model)
    if not IsModelValid(model) then
        return
    end
	if not HasModelLoaded(model) then
		RequestModel(model)
	end
	while not HasModelLoaded(model) do
		Citizen.Wait(0)
	end
end



DrawBusySpinner = function(text)
    SetLoadingPromptTextEntry("STRING")
    AddTextComponentSubstringPlayerName(text)
    ShowLoadingPrompt(3)
end




-- Process

RegisterNetEvent('void-fish:rollsushi')
AddEventHandler('void-fish:rollsushi', function()

    if HasItem("cutfish",1) then
        if lib.progressCircle({
            duration = 2000,
            position = 'bottom',
            useWhileDead = false,
            canCancel = true,
            disable = {
                car = true,
            },
            anim = {
                dict = 'mini@repair',
                clip = 'fixing_a_ped'
            },
            prop = {
                model = `v_ind_cfknife`,
                pos = vec3(0.03, 0.03, 0.02),
                rot = vec3(0.0, 0.0, -1.5)
            },
        }) then 
            if HasItem("cutfish",1) then
                TriggerServerEvent('void-fish:process')
                ShowNotification("Rolled", "You Rolled 2 Sushi", "success")
            else
                ShowNotification("Not Enough Items", "You need at least 1 Cut Fish", "error")
            end
        else 
          print("Progress Bar Cancelled")
        end
    else 
        ShowNotification('Missing Item', 'You are missing cut fish.', "error")
    end

end)




RegisterNetEvent('void-fish:client:sellSushi')
AddEventHandler('void-fish:client:sellSushi', function()

        if HasItem('sushi',5) then 
            if lib.progressCircle({
                duration = 2000,
                position = 'bottom',
                useWhileDead = false,
                canCancel = true,
                disable = {
                    car = true,
                },
                anim = {
                    dict = 'mp_common',
                    clip = 'givetake1_a'
                },
                prop = {
                    model = `p_brain_chunk_s`,
                    pos = vec3(0.03, 0.03, 0.02),
                    rot = vec3(0.0, 0.0, -1.5)
                },
            }) then 
                if HasItem('sushi',5) then
                    local sushi = math.random(Config.SellLowPrice, Config.SellHighPrice)
                    TriggerServerEvent('void-fish:sellSushi', sushi)
                    ShowNotification("Sold", "You sold 5 Sushi", "success")
                else
                    ShowNotification("Not Enough Items", "You need at least 5 Sushi", "error")
                end
            else 
              print("Sale Cancelled")
            end
  
        
        else
            ShowNotification("Not Enough Items", "You need at least 5 Sushi", "error")
        end
end)



-- Blips

Citizen.CreateThread(function()
    for _, info in pairs(Config.blips) do
      info.blip = AddBlipForCoord(info.x, info.y, info.z)
      SetBlipSprite(info.blip, info.id)
      SetBlipDisplay(info.blip, 4)
      SetBlipScale(info.blip, info.scale)
      SetBlipColour(info.blip, info.colour)
      SetBlipAsShortRange(info.blip, true)
	  BeginTextCommandSetBlipName("STRING")
      AddTextComponentString(info.title)
      EndTextCommandSetBlipName(info.blip)
    end
end)



RegisterNetEvent("void-fish:toggleRod")
AddEventHandler("void-fish:toggleRod", function()
    hasPoleOut = not hasPoleOut
    if hasPoleOut == true then
        local fishingRodHash = GetHashKey('prop_fishing_rod_01')
        RequestModel(fishingRodHash)
        if not HasModelLoaded(fishingRodHash) then
            Citizen.Wait(0)
        end
        local pedPos = GetEntityCoords(PlayerPedId())
---@diagnostic disable-next-line: cast-local-type, missing-parameter, param-type-mismatch
        rodHandle = CreateObject(fishingRodHash, pedPos, true)
        AttachEntityToEntity(rodHandle, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 18905), 0.1, 0.05, 0, 80.0, 120.0, 160.0, true, true, false, true, 1, true)
        SetModelAsNoLongerNeeded(fishingRodHash)
        while hasPoleOut do
            CastBait()
            Wait(100)
        end
    else
        TriggerEvent('illenium-appearance:client:ClearStuckProps')
        lib.hideTextUI()
        if DoesEntityExist(rodHandle) then
            DeleteEntity(rodHandle)
        end
    end
end)


-- Notification
ShowHelpNotification = function(msg)
    BeginTextCommandDisplayHelp('STRING')
    AddTextComponentSubstringPlayerName(msg)
    EndTextCommandDisplayHelp(0, false, true, -1)
end

function ShowNotification(titleIn,textIn,typeIn)
    lib.notify({
        title = titleIn,
        description = textIn,
        type = typeIn
    })
end

function HasItem(items, amount)
    local amount = amount or 1
    local count = 0
    for _, itemData in pairs(QBCore.Functions.GetPlayerData().items) do
        if itemData and (itemData.name == items) then
            if Config.Debug then print("^5Debug^7: ^3HasItem^7: ^2Item^7: '^3"..tostring(items).."^7' ^2Slot^7: ^3"..itemData.slot.." ^7x(^3"..tostring(itemData.amount).."^7)") end
            count += itemData.amount
        end
    end
    if count >= amount then
        if Config.Debug then print("^5Debug^7: ^3HasItem^7: ^2Items ^5FOUND^7 x^3"..count.."^7") end
        return true
    else
        if Config.Debug then print("^5Debug^7: ^3HasItem^7: ^2Items ^1NOT FOUND^7") end
        return false
    end
end

local function cutFishingLoot()
    local foundValidFish = false
    for i = 1, #Config.fish do
        local fishName = Config.fish[i]


        if HasItem(fishName,1) then 
            if lib.progressCircle({
                duration = 2000,
                position = 'bottom',
                useWhileDead = false,
                canCancel = true,
                disable = {
                    car = true,
                },
                anim = {
                    dict = 'mini@repair',
                    clip = 'fixing_a_ped'
                },
                prop = {
                    model = `v_ind_cfknife`,
                    pos = vec3(0.03, 0.03, 0.02),
                    rot = vec3(0.0, 0.0, -1.5)
                },
            }) then 
                if HasItem(fishName,1) then 
                    TriggerServerEvent('void-fish:cutFish',fishName)
                    ShowNotification("Sold", "You cut up fish", "success")
                    foundValidFish = true
                else 
                    ShowNotification("Missing Item", 'You need to have fish to cut.', "error")
                end
            else 
              print("Cutting Cancelled")
            end
        end

    end
    if not foundValidFish then
        ShowNotification("Missing Item", 'You need to have fish to cut.', "error")
    end
    
end

RegisterNetEvent('void-fish:cutFishingLoot')
AddEventHandler('void-fish:cutFishingLoot', function()
    cutFishingLoot()
end)




--Bait and box logic


RegisterNetEvent("void-fish:oceanchest")
AddEventHandler("void-fish:oceanchest", function()
  TriggerServerEvent('void-fish:lootboxdrop',true)
end)

RegisterNetEvent("void-fish:oceanlockbox")
AddEventHandler("void-fish:oceanlockbox", function()
  TriggerServerEvent('void-fish:lootboxdrop',false)
end)






RegisterNetEvent("void-fish:setbait")
AddEventHandler("void-fish:setbait", function()
    if hasPoleOut then
        if lib.progressCircle({
            duration = 4000,
            position = 'bottom',
            label = 'Attaching Worms to hook',
            useWhileDead = false,
            canCancel = true,
            disable = {
                car = true,
            },
            anim = {
                dict = 'missbigscore1',
                clip = 'idle_e'
            },
            prop = {
                model = `p_brain_chunk_s`,
                pos = vec3(0.03, 0.03, 0.02),
                rot = vec3(0.0, 0.0, -1.5)
            },
        }) then 
            LegalBait = true
            IllegalBait = false
            BaitSet = true
        else 
        print("Cancelled attaching bait")
        LegalBait = false
        IllegalBait = false
        BaitSet = false
        end
    else
        ShowNotification("Equipment", "Need a fishing rod in your hands", "error")
    end
    

end)

RegisterNetEvent("void-fish:setillegalbait")
AddEventHandler("void-fish:setillegalbait", function()
    if hasPoleOut then
        if lib.progressCircle({
            duration = 4000,
            label = 'Attaching Prawns to hook',
            position = 'bottom',
            useWhileDead = false,
            canCancel = true,
            disable = {
                car = true,
            },
            anim = {
                dict = 'missbigscore1',
                clip = 'idle_e'
            },
            prop = {
                model = `p_brain_chunk_s`,
                pos = vec3(0.03, 0.03, 0.02),
                rot = vec3(0.0, 0.0, -1.5)
            },
        }) then 
            LegalBait = false
            IllegalBait = true
            BaitSet = true
        else 
        print("Cancelled attaching bait")
        LegalBait = false
        IllegalBait = false
        BaitSet = false
        end
    else
        ShowNotification("Equipment", "Need a fishing rod in your hands", "error")
    end
end)

RegisterNetEvent('void-fish:client:sellillegal')
AddEventHandler('void-fish:client:sellillegal', function()
    for i = 1, #Config.illegalfish do
        local fishName = Config.illegalfish[i]
        if HasItem(fishName,1) then

                if lib.progressCircle({
                    duration = 5000,
                    position = 'bottom',
                    label = 'Ruining the ecosystem',
                    useWhileDead = false,
                    canCancel = true,
                    disable = {
                        car = true,
                    },
                    anim = {
                        dict = 'mp_common',
                        clip = 'givetake1_a'
                    },
                    prop = {
                        model = `prop_cash_pile_01`,
                        pos = vec3(0.03, 0.03, 0.02),
                        rot = vec3(0.0, 0.0, -1.5)
                    },
                }) then 
                    TriggerServerEvent('void-fish:server:sellillegal',fishName)
                    ShowNotification("Sold", "You sold exotic fish", "success")
                else 
                  print("Sale Cancelled")
                end
            
        end
    end
end)

---Alert Logic
---local messageT = ""

RegisterNetEvent('void-fish:client:alert')
AddEventHandler('void-fish:client:alert', function(fishName)
    local diceroll = math.random(1,100)

    if diceroll <= Config.AlertChance then

        local codeNameT = 'suspicioushandoff'
        local tenCodeT = "10-13"
        local descriptionT = "Person seen dragging " .. fishName .. " out of the water."
        local positionT = GetEntityCoords(PlayerPedId())
        local genderT = QBCore.Functions.GetPlayerData().charinfo.gender
        local messageT = "Illegal Fishing Spotted"
        local sprite = 404


        
        exports["ps-dispatch"]:CustomAlert({
            coords = positionT,
            message = messageT,
            dispatchCode = codeNameT,
            code = tenCodeT,
            description = descriptionT,
            radius = 0,
            gender = genderT,
            sprite = sprite,
            scale = 1.5,
            priority = 2,
            length = 3,
            sound = 'Lose_1st',
            sound2 = 'GTAO_FM_Events_Soundset',
            job = 'police',
            carCheck = false,
            jobs = {'leo'}
        })
    end

end)