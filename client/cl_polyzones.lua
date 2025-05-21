Citizen.CreateThread(function()
   
-- Cutting 

    exports["qb-target"]:AddBoxZone("fishing_cut", vector3(-3425.1, 974.35, 8.35), 2.5, 1, {
        name="fishing_cut",
        heading=0,
        debugPoly=false,
        minZ=6,
        maxZ=9, 
    }, {
            options = {
                {
                type = "client",
                action = function()
                    CutFishSpot()
                end,
                icon = "fas fa-fan",
                label = "Cut Fish",
                },
            },
            job = {"all"},
            distance = 1.5
        })
  

--Processing
    exports['qb-target']:AddBoxZone("fishing_sushi", vector3(-3426.88, 978.62, 8.35), 1, 2.5, {
        name="processfish",
        heading=0.88,
        debugPoly=false,
        minZ=6,
        maxZ=8.5,
        }, {
        options = {
            {
            type = "client",
            action = function()
                ProcessFishSpot()
            end,
            icon = "fas fa-utensils",
            label = "Process Cut Fish",
            },
        },
        job = {"all"},
        distance = 1.5
    })
end)



--Selling
exports["qb-target"]:AddBoxZone("fishing_sell", vector3(-1038.29, -1396.97, 5.55), 1, 1, {
    name="fishing_sell",
    heading=345,
    debugPoly=false,
    minZ=4.42,
    maxZ=6.42, 
}, {
        options = {
            {
            type = "client",
            action = function()
                SellSpotFish()
            end,
            icon = "fas fa-fish",
            label = "Sell Sushi",
            },
        },
        job = {"all"},
        distance = 1.5
    })

Citizen.CreateThread(function()
    local ped = makePed(
        Config.pedType ,
        Config.pedLocation,
        true,
        false,
        nil,	
        { "amb@code_human_cross_road@male@base", "base" },
        false
    )
end)


--Illegal Selling
exports["qb-target"]:AddBoxZone("illegalfishing_sell", vector3(-457.91, -2266.19, 8.52), 1, 1, {
    name="illegalfishing_sell",
    heading=345,
    debugPoly=false,
    minZ=7,
    maxZ=9, 
}, {
        options = {
            {
            type = "client",
            action = function()
                SellSpotIllegal()
            end,
            icon = "fas fa-fish",
            label = "Exotic Fish Sales",
            },
        },
        job = {"all"},
        distance = 1.5
    })

Citizen.CreateThread(function()
    local ped = makePed(
        Config.illegalpedType ,
        Config.illegalpedLocation,
        true,
        false,
        nil,	
        { "amb@code_human_cross_road@male@base", "base" },
        false
    )
end)


--functions
function ProcessFishSpot()
    TriggerEvent('void-fish:rollsushi')
end


function CutFishSpot()
    TriggerEvent('void-fish:cutFishingLoot')
end


function SellSpotFish()
    TriggerEvent('void-fish:client:sellSushi')
end

function SellSpotIllegal()
    TriggerEvent('void-fish:client:sellillegal')
end
