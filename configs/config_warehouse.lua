Config = {}

/*

░██╗░░░░░░░██╗░█████╗░██████╗░███████╗██╗░░██╗░█████╗░██╗░░░██╗░██████╗███████╗
░██║░░██╗░░██║██╔══██╗██╔══██╗██╔════╝██║░░██║██╔══██╗██║░░░██║██╔════╝██╔════╝
░╚██╗████╗██╔╝███████║██████╔╝█████╗░░███████║██║░░██║██║░░░██║╚█████╗░█████╗░░
░░████╔═████║░██╔══██║██╔══██╗██╔══╝░░██╔══██║██║░░██║██║░░░██║░╚═══██╗██╔══╝░░
░░╚██╔╝░╚██╔╝░██║░░██║██║░░██║███████╗██║░░██║╚█████╔╝╚██████╔╝██████╔╝███████╗
░░░╚═╝░░░╚═╝░░╚═╝░░╚═╝╚═╝░░╚═╝╚══════╝╚═╝░░╚═╝░╚════╝░░╚═════╝░╚═════╝░╚══════╝
*/

Config.Core = 'qbox' -- qbcore or qbox
Config.Inventory = 'ox' -- qb or ox (honestly not a clue if qb inventory works, please reach out if issues)
Config.Target = 'ox' -- qb or ox
Config.Progress = 'ox' -- its ox get fucked
Config.Notify = 'ox' -- its ox get fucked
Config.Menu = 'ox' -- its ox get fucked

-- Restaurant Configuration
Config.Restaurants = {
    [1] = {
        name = "Tequi-la-la",
        job = "police",
        position = vector3(-575.4901, 289.0903, 77.9936), -- Adjust as needed
        delivery = vector3(-558.17, 301.81, 83.58),
        deliveryFoot = vector3(-561.87, 294.19, 86.49),
        heading = 90.0
    },
    -- add more here
}

-- Add warehouse locations, idk why youd use more than one
Config.WarehousesLocation = {
    {
        position = vector3(1241.00, -3115.76, 4.52),
        heading = 91.52,
        pedhash = 's_m_y_construct_02',
    }
}

-- Warehouse Configuration
Config.Warehouses = {
    {
        forkliftPosition = vector3(1225.97, -3188.33, 5.52),
        pallets = {
            vector3(1220.43, -3188.02, 4.52),
            vector3(1219.50, -3182.24, 4.52),
            vector3(1221.62, -3195.49, 4.52)
        },
        deliveryMarker = { -- Delivery marker for Warehouse 1
            position = vector3(1238.0282, -3155.8708, 6.0997),
            radius = 4.0
        },
        truck = {
            model = 'phantom',
            position = vector4(1290.1298, -3134.9062, 5.9064, 358.0195) -- Adjust as needed
        },
        trailer = {
            model = 'trailers3',
            position = vector4(1289.5369, -3153.1648, 5.9064, 359.3230) -- Adjust as needed
        }
    },
    {
        forkliftPosition = vector3(1226.6061, -3130.2217, 5.5277),
        pallets = {
            vector3(1221.4413, -3133.3848, 4.5277),
            vector3(1221.3192, -3129.9758, 4.5277),
            vector3(1218.3257, -3131.8977, 4.5277)
        },
        deliveryMarker = { -- Delivery marker for Warehouse 2
            position = vector3(1237.7931, -3135.7043, 6.0997), -- Example position for Warehouse 2 delivery
            radius = 7.0
        },
        truck = {
            model = 'phantom',
            position = vector4(1290.1298, -3134.9062, 5.9064, 358.0195) -- Adjust as needed
        },
        trailer = {
            model = 'trailers3',
            position = vector4(1289.5369, -3153.1648, 5.9064, 359.3230) -- Adjust as needed
        }
    }
    -- Add more warehouses as needed
}

Config.maxBoxes = 3 -- Max amount of boxes the player has to drag inside, you can easily make it a math.random - example: Config.maxBoxes = math.random(3,5)

-- Items Configuration for Each Restaurant - ORDERING
Config.Items = {
    ["police"] = {
        ["water"] = {name = "Water", price = 10},
        ["bread"] = {name = "Bread", price = 5},
        ["raw_beef"] = {name = "Raw Beef", price = 15},
        ["mozzarella"] = {name = "Mozzarella", price = 7},
        ["onion"] = {name = "Onion", price = 4},
        ["beer"] = {name = "Beer", price = 6},
        ["cheddar_cheese"] = {name = "Cheddar Cheese", price = 8},
        ["dough"] = {name = "Dough", price = 3},
        ["salt"] = {name = "Salt", price = 2},
        ["potatoes"] = {name = "Potatoes", price = 6},
        ["bacon"] = {name = "Bacon", price = 8},
        ["sour_cream"] = {name = "Sour Cream", price = 5},
        ["sprunk"] = {name = "Sprunk", price = 4},
        ["grenadine"] = {name = "Grenadine", price = 5},
        ["ice"] = {name = "Ice", price = 2},
        ["strawberry"] = {name = "Strawberry", price = 7},
        ["tequila"] = {name = "Tequila", price = 12},
        ["whiskey"] = {name = "Whiskey", price = 12},
        ["bitters"] = {name = "Bitters", price = 6},
        ["orange"] = {name = "Orange", price = 6},
        ["cola"] = {name = "Cola", price = 4},
        ["mint"] = {name = "Mint", price = 3},
        ["vodka"] = {name = "Vodka", price = 12},
        ["rum"] = {name = "Rum", price = 10}
    },
    -- add more here
}

Config.DriverPayPrec = 0.1 --precent of the order the driver gets, if you want to redo the way pricing is done go to server/sv_processing about line 220

Config.CarryBoxProp = 'ng_proc_box_01a' -- prop the player carries when carrying boxes inside the resturant for delivery


--[[ 
███████╗███████╗██╗     ██╗     ███████╗██████╗ 
██╔════╝██╔════╝██║     ██║     ██╔════╝██╔══██╗
███████╗█████╗  ██║     ██║     █████╗  ██████╔╝
╚════██║██╔══╝  ██║     ██║     ██╔══╝  ██╔══██╗
███████║███████╗███████╗███████╗███████╗██║  ██║
╚══════╝╚══════╝╚══════╝╚══════╝╚══════╝╚═╝  ╚═╝
]]

-- ANY ITEMS SOLD TO THIS PERSON AUTO GO TO THE WAREHOUSE'S STOCK!!!!!!!!!!!!!!!!!!!!!!

-- Define the ped model
Config.PedModel = "a_m_m_farmer_01"

-- Define the ped and target location
Config.Location = {
    coords = vector3(2564.3635, 4680.3677, 33.0768),
    heading = 46.2758
}

-- Blip for the purchaser
Config.SellerBlip = {
    label = 'Fruit Buyer',
    coords = vector3(2564.3635, 4680.3677, 33.0768),
    blipSprite = 1,
    blipColor = 1,
    blipScale = 0.8,
}

-- Animation while selling to the ped
Config.SellingAnimDict = 'missheistdockssetup1ig_12@idle_b'
Config.SellingAnimName = 'talk_gantry_idle_b_worker1'

-- Progress time for selling
Config.SellProgress = 10000

-- Purchaser and their prices
Config.ItemsFarming = {
    ['lime'] = {label = 'Lime', price = 4},
    ['orange'] = {label = 'Orange', price = 4},
    ['coconut'] = {label = 'Coconut', price = 4},
    ['pineapple'] = {label = 'Pineapple', price = 4},
    ['broccoli'] = {label = 'Broccoli', price = 4},
    ['cabbage'] = {label = 'Cabbage', price = 4},
    ['carrots'] = {label = 'Carrots', price = 4},
    ['lettuce'] = {label = 'Lettuce', price = 4},
    ['spinach'] = {label = 'Spinach', price = 4},
    ['milk'] = {label = 'Milk', price = 4},
    ['egg'] = {label = 'Eggs', price = 4},
    ['onion'] = {label = 'Onion', price = 4},
    ['mushroom'] = {label = 'Mushroom', price = 4},
    ['potato'] = {label = 'Potato', price = 4},
    ['tomato'] = {label = 'Tomato', price = 4},
    ['raspberries'] = {label = 'Raspberries', price = 4},
    ['cherry'] = {label = 'Cherry', price = 4},
    ['corn'] = {label = 'Corn', price = 4},
    ['peach'] = {label = 'Peach', price = 4},
    ['banana'] = {label = 'Banana', price = 4},
    ['strawberry'] = {label = 'Strawberry', price = 4},
    ['mint'] = {label = 'Mint', price = 4},
    ['lemon'] = {label = 'Lemon', price = 4},
    ['mango'] = {label = 'Mango', price = 4},
    ['watermelon'] = {label = 'Watermelon', price = 4},
    ['water'] = {label = 'Water', price = 4},
}