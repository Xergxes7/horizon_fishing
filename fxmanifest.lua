--[[ FX Information ]]--
fx_version 'cerulean'
lua54 'yes'
game 'gta5' 

--[[ Resource Information ]]--
name 'Horizon Fishing'
author 'Xergxes7'
description 'A basic Fishing Script for QBCore'
version '1.2.2'

--[[ Manifest ]]--
dependencies {
    'ox_lib',
    'jim_bridge',
    'qb-core',
    'ps-inventory'
}


shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
        --Jim Bridge
        '@jim_bridge/starter.lua',
        '@jim_bridge/shared/*',
}

client_scripts {
    'client/cl_fish.lua',
    'client/cl_polyzones.lua',
}

server_scripts {
    'server/sv_fish.lua',
}


