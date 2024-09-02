Businesses = {}

--[[

██████╗░██╗░░░██╗░██████╗██╗███╗░░██╗███████╗░██████╗░██████╗███████╗░██████╗
██╔══██╗██║░░░██║██╔════╝██║████╗░██║██╔════╝██╔════╝██╔════╝██╔════╝██╔════╝
██████╦╝██║░░░██║╚█████╗░██║██╔██╗██║█████╗░░╚█████╗░╚█████╗░█████╗░░╚█████╗░
██╔══██╗██║░░░██║░╚═══██╗██║██║╚████║██╔══╝░░░╚═══██╗░╚═══██╗██╔══╝░░░╚═══██╗
██████╦╝╚██████╔╝██████╔╝██║██║░╚███║███████╗██████╔╝██████╔╝███████╗██████╔╝
╚═════╝░░╚═════╝░╚═════╝░╚═╝╚═╝░░╚══╝╚══════╝╚═════╝░╚═════╝░╚══════╝╚═════╝░
]]


-- You can go to client line 208 and edit it yourself.
Businesses.ResturantBillingEvent = "okokBilling:ToggleCreateInvoice" -- Event for the resturant worker to open when they target the register
Businesses.CustomerBillingEvent = "okokBilling:ToggleMyInvoices" -- Event for the customer worker to open when they target the register

Businesses.Businesses = {
    police = {
        jobDisplay = "Tequi-la-la", -- The displayed name of the job
        menu = "https://fredsburger.com/wp-content/uploads/2022/09/New-Menu-DarkNP.jpg",

        clockin = {
            coords = vector4(-574.6028, 293.2412, 79.0848, 170.42),
            dimensions = { width = 1.5, length = 0.6, height = 0.6 } -- Dimensions for clockin area
        },

        registers = {
            { coords = vector4(-560.6277, 289.1854, 82.2762, 265.7998), Prop = true },
            { coords = vector4(-562.9647, 287.4845, 82.3816, 85.77) },
            { coords = vector4(-569.1837, 279.0217, 77.8908, 85.77) },
            { coords = vector4(-562.7801, 279.0732, 82.8374, 85.77) },
            { coords = vector4(-569.1209, 284.8946, 77.4955, 85.77) },
            -- Additional registers can be added here
        },

        trays = {
            { coords = vector4(-560.7372, 287.3317, 82.7763, 265.09) },
            { coords = vector4(-560.8357, 286.0503, 82.7763, 265.6981) },
            { coords = vector4(-561.0045, 284.7722, 82.7763, 265.6981) },
            { coords = vector4(-565.4274, 278.9019, 78.2175, 175.6981) },
            { coords = vector4(-569.9479, 279.3834, 78.2175, 175.6981) },
            -- Additional trays can be added here
        },

        storage = {
            {
                coords = vector4(-568.4628, 276.3576, 77.9415, 265.01),
                targetLabel = "Open Tequi-la-la Shelf",
                inventory = {
                    slots = 20, -- Number of inventory slots
                    weight = 5000 -- Maximum weight in KG
                },
                dimensions = { width = 1.9, length = 1.6, height = 0.6 } -- Storage dimensions
            },
            -- Additional storage locations can be added here
        },

        CookLoco = {
            {
                coords = vector4(-567.9035, 278.7028, 77.7175, 175.88),
                targetLabel = "Prepare Drinks",
                dimensions = { width = 1.5, length = 0.6, height = 0.5 },
                animation = { dict = "mini@repair", name = "fixing_a_ped" },
                items = {
                    {
                        item = "water",
                        amount = 1,
                        time = 8000, -- Time to prepare the item in milliseconds
                        progressLabel = "Preparing Water",
                        requiredItems = {
                            { item = "water", amount = 1 }
                        },
                        icon = "fas fa-water"
                    },
                    -- Additional items can be added here
                }
            },
            -- Additional preparation stations can be added here
        },

        chairs = {
            { coords = vector4(-557.53, 291.36, 82.48, 262.93) },
            { coords = vector4(-556.76, 292.01, 82.48, 173.72) },
            { coords = vector4(-555.88, 291.23, 82.48, 86.06) },
            { coords = vector4(-559.79, 289.54, 82.48, 87.56) },
            { coords = vector4(-559.78, 287.97, 82.48, 82.17) },
            { coords = vector4(-559.92, 287.01, 82.48, 84.27) },
            { coords = vector4(-559.98, 285.88, 82.48, 81.21) },
            { coords = vector4(-555.10, 278.47, 82.48, 257.99) },
            { coords = vector4(-554.2, 277.39, 82.48, 358.66) },
            { coords = vector4(-553.31, 278.28, 82.48, 77.46) },
            { coords = vector4(-563.40, 284.8, 85.65, 84.0) },
            { coords = vector4(-563.35, 285.75, 85.65, 80.8) },
            { coords = vector4(-563.25, 286.72, 85.65, 83.29) },
            { coords = vector4(-573.61, 285.68, 79.13, 0.53) },
            { coords = vector4(-572.44, 285.58, 79.13, 349.48) },
            { coords = vector4(-570.83, 290.47, 79.13, 79.16) },
            { coords = vector4(-569.47, 282.7, 77.98, 216.86) },
            { coords = vector4(-568.3, 282.5, 77.98, 129.63) },
            { coords = vector4(-568.59, 281.23, 77.98, 25.97) },
            { coords = vector4(-569.66, 281.58, 77.98, 297.87) },
            { coords = vector4(-569.97, 280.13, 77.98, 173.31) },
            { coords = vector4(-569.1, 280.09, 77.98, 174.81) },
            { coords = vector4(-566.8, 279.98, 77.98, 177.81) },
            { coords = vector4(-565.85, 279.84, 77.98, 175.55) },
            { coords = vector4(-564.75, 279.76, 77.98, 172.5) },
            { coords = vector4(-564.99, 282.36, 77.98, 122.77) },
            { coords = vector4(-566.17, 282.55, 77.98, 215.55) },
            { coords = vector4(-566.41, 281.39, 77.98, 301.22) },
            { coords = vector4(-565.3, 281.14, 77.98, 34.99) },
            { coords = vector4(-558.93, 290.69, 85.38, 175.0) },
            { coords = vector4(-559.77, 290.59, 85.38, 179.22) },
            { coords = vector4(-560.92, 290.74, 85.38, 177.81) },
            { coords = vector4(-561.75, 290.81, 85.38, 174.78) },
            -- Additional chairs can be added here
        },

        blip = {  -- Added blip configuration
            sprite = 93,   -- Change this to the desired blip sprite
            scale = 1.0,   -- Adjust the size of the blip
            color = 4      -- Change this to the desired blip color
        }
    },
    -- Additional businesses can be added here
}
