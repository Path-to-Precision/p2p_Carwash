Config = {
    Translate = TranslateCap, -- TranslateCap : es_extended version >= 1.9.0 / _U : es_extended version < 1.9.0
    Locale = GetConvar('esx:locale', 'fr'),
    getSharedObject = "last", -- last : es_extended version >= 1.9.0 / old : es_extended version < 1.9.0
    carwash = {
        {
            position = {x = 175.96, y = -1736.58, z = 28.71, h = 266.45},
            prices = {25, 50, 100},
            method = {
                type = 'ped', -- roller : si il n'y a pas de place pour les peds / roller : if there is no place for peds
                ped = {       -- ped : animation avec les peds / ped : animation with peds
                    basic = {
                        type = 's_m_m_ccrew_01', -- https://docs.fivem.net/docs/game-references/ped-models/
                        prop = 'prop_blox_spray', -- https://gtahash.ru/
                        particle = {
                            dict = 'scr_bike_business',
                            name = 'scr_bike_spraybottle_spray'
                        },
                        anim = {
                            dict = 'weapons@first_person@aim_rng@generic@projectile@shared@core',
                            name = 'idlerng_med'
                        },
                        time = 0.0004803,
                    },
                    standard = {
                        type = 's_m_m_gaffer_01', -- https://docs.fivem.net/docs/game-references/ped-models/
                        anim = 'WORLD_HUMAN_MAID_CLEAN',
                        time = 0.000474,
                    },
                    premium = {
                        type = 's_m_y_winclean_01', -- https://docs.fivem.net/docs/game-references/ped-models/
                        -- premium est la combinaison des phases 'basic' et 'standard'
                        -- premium is the combination of the 'basic' and 'standard' phases
                    },
                    steps = { -- https://docs.fivem.net/natives/?_0xFB71170B7E76ACBA
                        [1] = "wheel_lf",
                        [2] = "wheel_lr",
                        [3] = "wheel_rf",
                        [4] = "wheel_rr",
                        [5] = "window_rf"
                    },
                },
                roller = {
                    position = {
                        entry = {x = 175.96, y = -1736.58, z = 28.71},
                        exit = {x = 184.97, y = -1736.45, z = 29.27}
                    },
                    speed = 4.0,
                    basic = {
                        time = 0.0008275,
                        camera = {x = 185.39, y = -1731.78, z = 29.27}
                    },
                    standard = {
                        time = 0.00059,
                        camera = {x = 178.19, y = -1740.09, z = 29.5}
                    },
                    premium = {
                        time = 0.000385,
                        camera = {x = 172.06, y = -1741.99, z = 29.27}
                    },
                },
            },
        },
        {
            position = {x = 42.92, y = -1391.88, z = 29.41, h = 85.03},
            prices = {25, 50, 100},
            method = {
                type = 'roller', -- roller : si il n'y a pas de place pour les peds / roller : if there is no place for peds
                ped = {       -- ped : animation avec les peds / ped : animation with peds
                    basic = {
                        type = 's_m_m_ccrew_01', -- https://docs.fivem.net/docs/game-references/ped-models/
                        prop = 'prop_blox_spray', -- https://gtahash.ru/
                        particle = {
                            dict = 'scr_bike_business',
                            name = 'scr_bike_spraybottle_spray'
                        },
                        anim = {
                            dict = 'weapons@first_person@aim_rng@generic@projectile@shared@core',
                            name = 'idlerng_med'
                        },
                        time = 0.0004803,
                    },
                    standard = {
                        type = 's_m_m_gaffer_01', -- https://docs.fivem.net/docs/game-references/ped-models/
                        anim = 'WORLD_HUMAN_MAID_CLEAN',
                        time = 0.000474,
                    },
                    premium = {
                        type = 's_m_y_winclean_01', -- https://docs.fivem.net/docs/game-references/ped-models/
                        -- premium est la combinaison des phases 'basic' et 'standard'
                        -- premium is the combination of the 'basic' and 'standard' phases
                    },
                    steps = { -- https://docs.fivem.net/natives/?_0xFB71170B7E76ACBA
                        [1] = "wheel_lf",
                        [2] = "wheel_lr",
                        [3] = "wheel_rf",
                        [4] = "wheel_rr",
                        [5] = "window_rf"
                    },
                },
                roller = {
                    position = {
                        entry = {x = 21.09, y = -1391.97, z = 29.8},
                        exit = {x = -8.309, y = -1392.28, z = 29.3}
                    },
                    speed = 4.0,
                    basic = {
                        time = 0.0008275,
                        camera = {x = 15.25, y = -1392.20, z = 31.99}
                    },
                    standard = {
                        time = 0.00059,
                        camera = {x = 17.97, y = -1394.04, z = 28.73}
                    },
                    premium = {
                        time = 0.000385,
                        camera = {x = 24.46, y = -1389.37, z = 32.86}
                    },
                },
            },
        },
        {
            position = {x = -699.86, y = -926.69, z = 19.01, h = 184.25},
            prices = {25, 50, 100},
            method = {
                type = 'roller', -- roller : si il n'y a pas de place pour les peds / roller : if there is no place for peds
                ped = {       -- ped : animation avec les peds / ped : animation with peds
                    basic = {
                        type = 's_m_m_ccrew_01', -- https://docs.fivem.net/docs/game-references/ped-models/
                        prop = 'prop_blox_spray', -- https://gtahash.ru/
                        particle = {
                            dict = 'scr_bike_business',
                            name = 'scr_bike_spraybottle_spray'
                        },
                        anim = {
                            dict = 'weapons@first_person@aim_rng@generic@projectile@shared@core',
                            name = 'idlerng_med'
                        },
                        time = 0.0004803,
                    },
                    standard = {
                        type = 's_m_m_gaffer_01', -- https://docs.fivem.net/docs/game-references/ped-models/
                        anim = 'WORLD_HUMAN_MAID_CLEAN',
                        time = 0.000474,
                    },
                    premium = {
                        type = 's_m_y_winclean_01', -- https://docs.fivem.net/docs/game-references/ped-models/
                        -- premium est la combinaison des phases 'basic' et 'standard'
                        -- premium is the combination of the 'basic' and 'standard' phases
                    },
                    steps = { -- https://docs.fivem.net/natives/?_0xFB71170B7E76ACBA
                        [1] = "wheel_lf",
                        [2] = "wheel_lr",
                        [3] = "wheel_rf",
                        [4] = "wheel_rr",
                        [5] = "window_rf"
                    },
                },
                roller = {
                    position = {
                        entry = {x = -699.87, y = -932.33, z = 19.01},
                        exit = {x = -699.78, y = -940.56, z = 19.01}
                    },
                    speed = 4.0,
                    basic = {
                        time = 0.0008275,
                        camera = {x = -700.06, y = -945.65, z = 19.01}
                    },
                    standard = {
                        time = 0.00059,
                        camera = {x = -697.72, y = -939.09, z = 18.8}
                    },
                    premium = {
                        time = 0.000385,
                        camera = {x = -698.01, y = -925.27, z = 19.02}
                    },
                },
            },
        },
        {
            position = {x = -218.37, y = 6201.34, z = 31.48, h = 226.77},
            prices = {25, 50, 100},
            method = {
                type = 'ped', -- roller : si il n'y a pas de place pour les peds / roller : if there is no place for peds
                ped = {       -- ped : animation avec les peds / ped : animation with peds
                    basic = {
                        type = 's_m_m_ccrew_01', -- https://docs.fivem.net/docs/game-references/ped-models/
                        prop = 'prop_blox_spray', -- https://gtahash.ru/
                        particle = {
                            dict = 'scr_bike_business',
                            name = 'scr_bike_spraybottle_spray'
                        },
                        anim = {
                            dict = 'weapons@first_person@aim_rng@generic@projectile@shared@core',
                            name = 'idlerng_med'
                        },
                        time = 0.0004803,
                    },
                    standard = {
                        type = 's_m_m_gaffer_01', -- https://docs.fivem.net/docs/game-references/ped-models/
                        anim = 'WORLD_HUMAN_MAID_CLEAN',
                        time = 0.000474,
                    },
                    premium = {
                        type = 's_m_y_winclean_01', -- https://docs.fivem.net/docs/game-references/ped-models/
                        -- premium est la combinaison des phases 'basic' et 'standard'
                        -- premium is the combination of the 'basic' and 'standard' phases
                    },
                    steps = { -- https://docs.fivem.net/natives/?_0xFB71170B7E76ACBA
                        [1] = "wheel_lf",
                        [2] = "wheel_lr",
                        [3] = "wheel_rf",
                        [4] = "wheel_rr",
                        [5] = "window_rf"
                    },
                },
                roller = {
                    position = {
                        entry = {x = -218.37, y = 6201.34, z = 31.48},
                        exit = {x = -215.51, y = 6193.38, z = 31.48}
                    },
                    speed = 4.0,
                    basic = {
                        time = 0.0008275,
                        camera = {x = -214.8, y = 6191.9, z = 33.47}
                    },
                    standard = {
                        time = 0.00059,
                        camera = {x = -215.01, y = 6199.37, z = 32.13}
                    },
                    premium = {
                        time = 0.000385,
                        camera = {x = -206.5, y = 6198.93, z = 31.48}
                    },
                },
            },
        },
    },
    blip = { -- https://docs.fivem.net/docs/game-references/blips/
        active = true,
        sprite = 100,
        color = 53,
        scale = 0.6
    },
    marker = {
        type = 36, -- https://docs.fivem.net/docs/game-references/markers/
        rotation = {
            x = 0.0,
            y = 0.0,
            z = 0.0
        },
        scale = {
            x = 0.9,
            y = 0.9,
            z = 0.9
        },
        color = { -- https://www.rapidtables.com/web/color/RGB_Color.html
            r = 0,
            g = 125,
            b = 255,
            a = 255
        },
        jump = false,
        rotate = true
    },
}