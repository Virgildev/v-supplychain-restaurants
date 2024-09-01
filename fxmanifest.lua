fx_version 'cerulean'
game 'gta5'

author 'Virgil dawg straight up out the opps hood'
description 'Supply Chain/Business Script AKA thug asf'
version '1.0.0'

lua54 'yes'

shared_scripts {
    '@ox_lib/init.lua',
    'configs/*.lua',
}

client_scripts {
    'client/*.lua'
}

server_scripts {
    'server/*.lua',
    '@oxmysql/lib/MySQL.lua'
}

