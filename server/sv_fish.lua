---@diagnostic disable: param-type-mismatch
local QBCore = exports['qb-core']:GetCoreObject()

local DISCORD_WEBHOOK5 = Config.Webhook
local DISCORD_NAME5 = Config.WebhookName

local DISCORD_IMAGE = "https://i.imgur.com/zviw6oW.png" -- default is FiveM logo

--PerformHttpRequest(DISCORD_WEBHOOK5, function(err, text, headers) end, 'POST', json.encode({username = DISCORD_NAME5, avatar_url = DISCORD_IMAGE}), { ['Content-Type'] = 'application/json' })



local function sendToDiscord(name, message, color)
  local connect = {
    {
      ["color"] = color,
      ["title"] = "**".. name .."**",
      ["description"] = message,
    }
  }
  PerformHttpRequest(DISCORD_WEBHOOK5, function(err, text, headers) end, 'POST', json.encode({username = DISCORD_NAME5, embeds = connect, avatar_url = DISCORD_IMAGE}), { ['Content-Type'] = 'application/json' })
end


Citizen.CreateThread(function()

  QBCore.Functions.CreateUseableItem("fishingrod", function(source)
    TriggerClientEvent('void-fish:toggleRod', source, true)
  end)

  
  QBCore.Functions.CreateUseableItem("oceanchest", function(source)
    TriggerClientEvent('void-fish:oceanchest', source)
  end)

  QBCore.Functions.CreateUseableItem("oceanlockbox", function(source)
    TriggerClientEvent('void-fish:oceanlockbox', source)
  end)

  QBCore.Functions.CreateUseableItem("canoworms", function(source)
    TriggerClientEvent('void-fish:setbait', source)
  end)

  QBCore.Functions.CreateUseableItem("illegalfishbait", function(source)
    TriggerClientEvent('void-fish:setillegalbait', source)
  end)


end)


RegisterServerEvent('void-fish:process')
AddEventHandler('void-fish:process', function()
  local src = source
  local xPlayer = QBCore.Functions.GetPlayer(src)
  local itemData1 = QBCore.Shared.Items['cutfish']

  exports['ps-inventory']:RemoveItem(src, 'cutfish', 1)
  TriggerClientEvent('ps-inventory:client:ItemBox', src, itemData1, "remove", 1)
  exports['ps-inventory']:AddItem(src, 'sushi', 2)
  local itemData2 = QBCore.Shared.Items['sushi']
  TriggerClientEvent('ps-inventory:client:ItemBox', src, itemData2, "add", 2)
  sendToDiscord("Fishing", "CID: " .. xPlayer.PlayerData.citizenid .. " rolled 2 sushi" , "5763719")
end)


RegisterServerEvent('void-fish:sellSushi')
AddEventHandler('void-fish:sellSushi', function(money)
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(src)
    for i=1,5 do
      exports['ps-inventory']:RemoveItem(src, 'sushi', 1)
      Citizen.Wait(100)
    end
    local itemData = QBCore.Shared.Items['sushi']
    TriggerClientEvent('ps-inventory:client:ItemBox', src, itemData, "remove", 5)
    xPlayer.Functions.AddMoney("bank", tonumber(money))
end)

--[[RegisterServerEvent("void-fish:retreive:license")
AddEventHandler("void-fish:retreive:license", function()
    local src = source
	  local user = exports["void-base"]:getModule("Player"):GetUser(src)
	  local character = user:getCurrentCharacter()
    exports.ghmattimysql:execute('SELECT * FROM user_licenses WHERE `owner`= ? AND `type` = ? AND `status` = ?', {character.id, "Fishing", "1"}, function(data)
		if data[1] then
            TriggerClientEvent("void-fish:allowed", src, true)
        end
    end)
end)]]

local function fishingLoot(src,legal,illegal)
  local diceroll = math.random(1,50)
  local xPlayer = QBCore.Functions.GetPlayer(src)
  if legal then
    if diceroll ~= 5 then -- nice
        local whichFish = math.random(1, #Config.fish)
        if whichFish > 2 and math.random(1,2) == 1 then -- if it's a rare fish then we do a roll for a chance to lose it
            whichFish = math.random(1,2)
        end
        exports['ps-inventory']:AddItem(src, Config.fish[whichFish], 1)
        local itemData = QBCore.Shared.Items[Config.fish[whichFish]]
        TriggerClientEvent('ps-inventory:client:ItemBox', src, itemData, "add", 1)
        sendToDiscord("Fishing", "CID: " .. xPlayer.PlayerData.citizenid .. " caught a " .. itemData.name , "5763719")
    else
        local badFishRecieved = Config.badFish[math.random(1, #Config.badFish)]
        exports['ps-inventory']:AddItem(src, badFishRecieved, 1) 
        local itemData = QBCore.Shared.Items[badFishRecieved]
        TriggerClientEvent('ps-inventory:client:ItemBox', src, itemData, "add", 1)
        sendToDiscord("Fishing", "CID: " .. xPlayer.PlayerData.citizenid .. " caught a " .. itemData.name , "5763719")
    end
  elseif illegal then
      local whichFish = math.random(1, #Config.illegalfish)
      if whichFish > 2 and math.random(1,2) == 1 then -- if it's a rare fish then we do a roll for a chance to lose it
          whichFish = math.random(1,2)
      end
      local illegalFIshRecieved = Config.illegalfish[whichFish]
      exports['ps-inventory']:AddItem(src, illegalFIshRecieved, 1)
      local itemData = QBCore.Shared.Items[illegalFIshRecieved]
      TriggerClientEvent('ps-inventory:client:ItemBox', src, itemData, "add", 1)
      TriggerClientEvent('void-fish:client:alert',src,illegalFIshRecieved)
      sendToDiscord("Fishing", "CID: " .. xPlayer.PlayerData.citizenid .. " caught a " .. itemData.name , "5763719")
  end
end

RegisterServerEvent('void-fish:payoutForFishingCatch')
AddEventHandler('void-fish:payoutForFishingCatch', function(legal,illegal)
  local src = source
  fishingLoot(src,legal,illegal)
end)

RegisterServerEvent('void-fish:cutFish')
AddEventHandler('void-fish:cutFish', function(fishName)
    local count = Config.fishCutValue[fishName]
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(src)
   local itemData1 = QBCore.Shared.Items[fishName]
    exports['ps-inventory']:RemoveItem(src, fishName, 1)
    TriggerClientEvent('ps-inventory:client:ItemBox', src, itemData1, "remove", 1)
    exports['ps-inventory']:AddItem(src, 'cutfish', count)
    local itemData2 = QBCore.Shared.Items['cutfish']
    TriggerClientEvent('ps-inventory:client:ItemBox', src, itemData2, "add", count)
    sendToDiscord("Fish Processing", "CID: " .. xPlayer.PlayerData.citizenid .. " cut fish " .. fishName .. " and recieved " .. count .. "cut fish", "5763719")
end)


RegisterServerEvent('void-fish:removebait')
AddEventHandler('void-fish:removebait', function(legal,illegal)
  local src = source
  local xPlayer = QBCore.Functions.GetPlayer(src)
  if legal and not illegal then
    local itemData = QBCore.Shared.Items[Config.RequiredBait]
    exports['ps-inventory']:RemoveItem(src, Config.RequiredBait, 1)
    TriggerClientEvent('ps-inventory:client:ItemBox', src, itemData, "remove", 1)
  elseif not legal and illegal then
    local itemData = QBCore.Shared.Items[Config.RequiredBait]
    exports['ps-inventory']:RemoveItem(src, Config.IllegalBait, 1)
    TriggerClientEvent('ps-inventory:client:ItemBox', src, itemData, "remove", 1)
  end
end)



local function boxLoot(src,rareBoxType)
  local xPlayer = QBCore.Functions.GetPlayer(src)    
  local diceroll = 0
  
      if rareBoxType then
        local itemData2 = QBCore.Shared.Items['oceanchest']
        for i = 1,Config.AmountOfRareDrops do
          diceroll = math.random(1,#Config.dropItems)
          local lootRecieved = Config.dropItems[diceroll]
          local amountRecieved = Config.dropQuantity[lootRecieved]
          exports['ps-inventory']:AddItem(src, lootRecieved, amountRecieved)
          local itemData = QBCore.Shared.Items[lootRecieved]
          TriggerClientEvent('ps-inventory:client:ItemBox', src, itemData, "add",amountRecieved )
          sendToDiscord("Loot Box", "CID: " .. xPlayer.PlayerData.citizenid .. " recieved drop " .. lootRecieved, "5763719")
        end
        exports['ps-inventory']:RemoveItem(src, 'oceanchest', 1)
        TriggerClientEvent('ps-inventory:client:ItemBox', src, itemData2, "remove",1 )
      else
        diceroll = math.random(1,5)
        local lootRecieved = Config.dropItems[diceroll]
        local amountRecieved = Config.dropQuantity[lootRecieved]
        exports['ps-inventory']:AddItem(src, lootRecieved, amountRecieved)
        local itemData = QBCore.Shared.Items[lootRecieved]
        TriggerClientEvent('ps-inventory:client:ItemBox', src, itemData, "add",amountRecieved )
        

        local itemData2 = QBCore.Shared.Items['oceanlockbox']
        exports['ps-inventory']:RemoveItem(src, 'oceanlockbox', 1)
        TriggerClientEvent('ps-inventory:client:ItemBox', src, itemData2, "remove",1 )
        sendToDiscord("Loot Box", "CID: " ..  xPlayer.PlayerData.citizenid .. " recieved drop " .. lootRecieved, "5763719")
      end
end

RegisterServerEvent('void-fish:lootboxdrop')
AddEventHandler('void-fish:lootboxdrop', function(typeBox)
  local src = source
  boxLoot(src,typeBox)
end)



-----------OTHER FUNCTIONS----------
local function sellIlelgalFish(src,fishname)
  local xPlayer = QBCore.Functions.GetPlayer(src)    
  if not xPlayer then return end
  local item = xPlayer.Functions.GetItemByName(fishname)
  local amountToSell = item.amount
  local itemData = QBCore.Shared.Items[fishname]
  exports['ps-inventory']:RemoveItem(src, fishname, amountToSell)
  TriggerClientEvent('ps-inventory:client:ItemBox', src, itemData, "remove",amountToSell )

  local info = {worth = Config.illegalfishValue[fishname]}
  xPlayer.Functions.AddItem('markedbills', amountToSell, false, info)
  local itemData2 = QBCore.Shared.Items['markedbills']
  TriggerClientEvent('ps-inventory:client:ItemBox', src, itemData2, "add",amountToSell )
  sendToDiscord("Sell Illegal Fish", "CID: " ..  xPlayer.PlayerData.citizenid .. " sold " .. amountToSell .. " " .. fishname, "5763719")
end

RegisterNetEvent('void-fish:server:sellillegal')
AddEventHandler('void-fish:server:sellillegal', function(fish)
  sellIlelgalFish(source,fish)
end)




