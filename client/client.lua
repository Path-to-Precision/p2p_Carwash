if Config.getSharedObject == "last" then
    ESX = exports["es_extended"]:getSharedObject()
elseif Config.getSharedObject == "old" then
    ESX = nil
	Citizen.CreateThread(function()
		while ESX == nil do
			TriggerEvent('esx:getSharedObject', function(obj) 
                ESX = obj 
            end)
			Citizen.Wait(0)
		end
	end)
end

local mainMenu = RageUI.CreateMenu(Config.Translate('mainMenuLabel'), Config.Translate('mainMenuDesc'))
local verrou = false
local additionTime = 0.0
local Index = 1
local isWashing = false
local loading = 0.0

mainMenu.Closed = function()
    exitMenu()
    open = false
end

function carwashMenu(data)
    if not open then open = true RageUI.Visible(mainMenu, true)
        Citizen.CreateThread(function()
            while open do
                RageUI.IsVisible(mainMenu, function()
                    if not isWashing then
                        RageUI.Button(Config.Translate('wash').." "..Config.Translate('basic'), nil, {RightLabel = "~g~"..data.prices[1].."$ ~s~→"}, true, {
                            onSelected = function()
                                mode = 1
                                verrou = true
                                if data.method.type == 'ped' then
                                    additionTime = data.method.ped.basic.time
                                elseif data.method.type == 'roller' then
                                    additionTime = data.method.roller.basic.time
                                end
                                ESX.ShowNotification(Config.Translate('you_selected').." ~b~"..Config.Translate('wash').." "..Config.Translate('basic'))
                            end
                        })
                        RageUI.Button(Config.Translate('wash').." "..Config.Translate('standard'), nil, {RightLabel = "~g~"..data.prices[2].."$ ~s~→"}, true, {
                            onSelected = function()
                                mode = 2
                                verrou = true
                                if data.method.type == 'ped' then
                                    additionTime = data.method.ped.standard.time
                                elseif data.method.type == 'roller' then
                                    additionTime = data.method.roller.standard.time
                                end
                                ESX.ShowNotification(Config.Translate('you_selected').." ~b~"..Config.Translate('wash').." "..Config.Translate('standard'))
                            end
                        })
                        RageUI.Button(Config.Translate('wash').." "..Config.Translate('premium'), nil, {RightLabel = "~g~"..data.prices[3].."$ ~s~→"}, true, {
                            onSelected = function()
                                mode = 3
                                verrou = true
                                if data.method.type == 'ped' then
                                    additionTime = ((data.method.ped.basic.time / 2) + (data.method.ped.standard.time / 2)) / 2
                                elseif data.method.type == 'roller' then
                                    additionTime = data.method.roller.premium.time
                                end
                                ESX.ShowNotification(Config.Translate('you_selected').." ~b~"..Config.Translate('wash').." "..Config.Translate('premium'))
                            end
                        })
                        RageUI.Line()
                        RageUI.List(Config.Translate('paiement'), {"~g~"..Config.Translate('cash').."~s~", "~b~"..Config.Translate('bank').."~s~"}, Index, nil, {}, true, {
                            onListChange = function(list) 
                                Index = list
                            end
                        })
                        if not verrou then
                            RageUI.Button(Config.Translate('confirm'), "~r~"..Config.Translate('wash_mode'), {Color = {BackgroundColor = {255, 0, 0, 100}}}, false, {})
                        else
                            RageUI.Button(Config.Translate('confirm'), nil, {RightBadge = RageUI.BadgeStyle.Tick, Color = {BackgroundColor = {120, 255, 0, 100}}}, true, {
                                onSelected = function()
                                    TriggerServerEvent('p2p_Carwash:buy_wash', mode, data, Index)
                                end
                            })
                        end
                    else
                        RageUI.Button(Config.Translate('wash').." "..Config.Translate('basic'), nil, {RightLabel = "~g~"..data.prices[1].."$ ~s~→"}, false, {})
                        RageUI.Button(Config.Translate('wash').." "..Config.Translate('standard'), nil, {RightLabel = "~g~"..data.prices[2].."$ ~s~→"}, false, {})
                        RageUI.Button(Config.Translate('wash').." "..Config.Translate('premium'), nil, {RightLabel = "~g~"..data.prices[3].."$ ~s~→"}, false, {})
                        RageUI.Line()
                        RageUI.List(Config.Translate('paiement'), {"~g~"..Config.Translate('cash').."~s~", "~b~"..Config.Translate('bank').."~s~"}, Index, nil, {}, false, {
                            onListChange = function(list) 
                                Index = list
                            end
                        })
                        RageUI.Button("Lavage en cours", nil, {Color = {BackgroundColor = {255, 0, 0, 100}}}, false, {})
                        RageUI.PercentagePanel(loading, Config.Translate('wash').." "..string.lower(Config.Translate('in_progress')).." ~b~"..math.floor(loading * 100).."%~s~", "", "", {})
                        if loading < 1.0 then
                            loading = loading + additionTime
                        else
                            loading = 0.0
                        end
                    end
                end)
                Citizen.Wait(0)
            end
        end)
    end
end

RegisterNetEvent('p2p_Carwash:washCarWith_ped')
AddEventHandler('p2p_Carwash:washCarWith_ped', function(mode, data)
    local vehicle = GetPlayersLastVehicle(PlayerPedId())
    local vehcoord = GetEntityCoords(vehicle)
    isWashing = true
    verrou = false
    mainMenu.Closable = false
    FreezeEntityPosition(vehicle, true)
    if mode == 1 then
        local npc = createPedCarwash(data.method.ped.basic.type)
        local prop = createPropCarwash(data.method.ped.basic.prop, npc)
        while not HasAnimDictLoaded(data.method.ped.basic.anim.dict) do 
            Citizen.Wait(100) 
        end
        TaskPlayAnim(npc, data.method.ped.basic.anim.dict, data.method.ped.basic.anim.name, 1.0, -1, -1, 50, 0, 0, 0, 0)               
        for i = 1, #data.method.ped.steps do
            local Position = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, data.method.ped.steps[i]))
            TaskGoToCoordAnyMeans(npc, Position, 0.1, 0, 0, 786603, 0)
            Citizen.Wait(2000)
            TaskTurnPedToFaceCoord(npc, GetEntityCoords(vehicle), 5000)
            Citizen.Wait(1500)
            RequestNamedPtfxAsset(data.method.ped.basic.particle.dict)
            while not HasNamedPtfxAssetLoaded(data.method.ped.basic.particle.dict) do 
                Citizen.Wait(100) 
            end
            UseParticleFxAssetNextCall(data.method.ped.basic.particle.dict)
            local particleEffect = StartParticleFxLoopedOnEntity(data.method.ped.basic.particle.name, prop, 0.2, 0.002, 0.0, 0.0, GetEntityHeading(npc), 160.0, 6.0, false, false, false)
            Citizen.Wait(1000)
            SetVehicleDirtLevel(vehicle, GetVehicleDirtLevel(vehicle) - 1)
        end
        SetVehicleDirtLevel(vehicle, 14.0)
        StopParticleFxLooped(data.method.ped.basic.particle.name)
        ClearPedSecondaryTask(npc)
        DeleteEntity(prop)
        exitMenu()
        TaskWanderStandard(npc, 10.0, 10)
        WashDecalsFromVehicle(vehicle, 1.0)
        Citizen.SetTimeout(10000, function()
            DeleteEntity(npc)
        end)
    elseif mode == 2 then
        local npc = createPedCarwash(data.method.ped.standard.type)
        for i = 1, #data.method.ped.steps do
            local Position = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, data.method.ped.steps[i]))
            TaskGoToCoordAnyMeans(npc, Position, 0.1, 0, 0, 786603, 0)
            Citizen.Wait(2000)
            TaskTurnPedToFaceCoord(npc, GetEntityCoords(vehicle), 5000)
            Citizen.Wait(1500)
            TaskStartScenarioInPlace(npc, data.method.ped.standard.anim, 0, true)
            Citizen.Wait(1000)
            SetVehicleDirtLevel(vehicle, GetVehicleDirtLevel(vehicle) - 1)
        end
        SetVehicleDirtLevel(vehicle, 14.0)
        ClearPedSecondaryTask(npc)
        exitMenu()
        TaskWanderStandard(npc, 10.0, 10)
        WashDecalsFromVehicle(vehicle, 1.0)
        Citizen.SetTimeout(10000, function()
            DeleteEntity(npc)
        end)
    elseif mode == 3 then
        local npc = createPedCarwash(data.method.ped.premium.type)
        local prop = createPropCarwash(data.method.ped.basic.prop, npc)
        while not HasAnimDictLoaded(data.method.ped.basic.anim.dict) do 
            Citizen.Wait(100) 
        end
        TaskPlayAnim(npc, data.method.ped.basic.anim.dict, data.method.ped.basic.anim.name, 1.0, -1, -1, 50, 0, 0, 0, 0)               
        for i = 1, #data.method.ped.steps do
            local Position = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, data.method.ped.steps[i]))
            TaskGoToCoordAnyMeans(npc, Position, 0.1, 0, 0, 786603, 0)
            Citizen.Wait(2000)
            TaskTurnPedToFaceCoord(npc, GetEntityCoords(vehicle), 5000)
            Citizen.Wait(1500)
            RequestNamedPtfxAsset(data.method.ped.basic.particle.dict)
            while not HasNamedPtfxAssetLoaded(data.method.ped.basic.particle.dict) do 
                Citizen.Wait(100) 
            end
            UseParticleFxAssetNextCall(data.method.ped.basic.particle.dict)
            local particleEffect = StartParticleFxLoopedOnEntity(data.method.ped.basic.particle.name, prop, 0.2, 0.002, 0.0, 0.0, GetEntityHeading(npc), 160.0, 6.0, false, false, false)
            Citizen.Wait(1000)
            SetVehicleDirtLevel(vehicle, GetVehicleDirtLevel(vehicle) - 1)
        end
        StopParticleFxLooped(data.method.ped.basic.particle.name)
        ClearPedSecondaryTask(npc)
        DeleteEntity(prop)
        TaskWanderStandard(npc, 10.0, 10)
        WashDecalsFromVehicle(vehicle, 1.0)
        Citizen.SetTimeout(10000, function()
            DeleteEntity(npc)
        end)
        local npc = createPedCarwash(data.method.ped.premium.type)
        for i = 1, #data.method.ped.steps do
            local Position = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, data.method.ped.steps[i]))
            TaskGoToCoordAnyMeans(npc, Position, 0.1, 0, 0, 786603, 0)
            Citizen.Wait(2000)
            TaskTurnPedToFaceCoord(npc, GetEntityCoords(vehicle), 5000)
            Citizen.Wait(1500)
            TaskStartScenarioInPlace(npc, data.method.ped.standard.anim, 0, true)
            Citizen.Wait(1000)
            SetVehicleDirtLevel(vehicle, GetVehicleDirtLevel(vehicle) - 1)
        end
        SetVehicleDirtLevel(vehicle, 14.0)
        ClearPedSecondaryTask(npc)
        exitMenu()
        TaskWanderStandard(npc, 10.0, 10)
        WashDecalsFromVehicle(vehicle, 1.0)
        Citizen.SetTimeout(10000, function()
            DeleteEntity(npc)
        end)
    end
end)

RegisterNetEvent('p2p_Carwash:washCarWith_roller')
AddEventHandler('p2p_Carwash:washCarWith_roller', function(mode, data)
    isWashing = true
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false )
    mainMenu.Closable = false
    TaskVehicleDriveToCoord(PlayerPedId(), vehicle, data.method.roller.position.entry.x, data.method.roller.position.entry.y, data.method.roller.position.entry.z, data.method.roller.speed, 5.0, GetHashKey(vehicle), 16777216, 1.0, true)
    Citizen.Wait(1000)
    local stopped = IsVehicleStopped(vehicle)
    while stopped == false do
        stopped = IsVehicleStopped(vehicle)
        Citizen.Wait(50)
    end
    local camera = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
    if mode == 1 then
        SetCamCoord(camera, data.method.roller.basic.camera.x, data.method.roller.basic.camera.y, data.method.roller.basic.camera.z)
        PointCamAtEntity(camera, PlayerPedId(), 0, 0, 0, 1)
        SetCamNearDof(camera, 10)
        RenderScriptCams(1, 1, 6500, 1, 1)
        SetCamShakeAmplitude(camera, 13.0)
        SetVehicleDoorOpen(vehicle, 0, false, false)
        SetVehicleDoorOpen(vehicle, 1, false, false)
        SetVehicleDoorOpen(vehicle, 2, false, false)
        SetVehicleDoorOpen(vehicle, 3, false, false)
        SetVehicleDoorOpen(vehicle, 4, false, false)
        SetVehicleDoorOpen(vehicle, 5, false, false)
        SetVehicleDoorOpen(vehicle, 6, false, false)
        SetVehicleDoorOpen(vehicle, 7, false, false)
        SetVehicleEngineOn(vehicle, false, false, true)
        Wait(8500)
    elseif mode == 2 then
        SetCamCoord(camera, data.method.roller.basic.camera.x, data.method.roller.basic.camera.y, data.method.roller.basic.camera.z)
        PointCamAtEntity(camera, PlayerPedId(), 0, 0, 0, 1)
        SetCamNearDof(camera, 10)
        RenderScriptCams(1, 1, 6500, 1, 1)
        SetCamShakeAmplitude(camera, 13.0)
        SetVehicleDoorOpen(vehicle, 0, false, false)
        SetVehicleDoorOpen(vehicle, 1, false, false)
        SetVehicleDoorOpen(vehicle, 2, false, false)
        SetVehicleDoorOpen(vehicle, 3, false, false)
        SetVehicleDoorOpen(vehicle, 4, false, false)
        SetVehicleDoorOpen(vehicle, 5, false, false)
        SetVehicleDoorOpen(vehicle, 6, false, false)
        SetVehicleDoorOpen(vehicle, 7, false, false)
        SetVehicleEngineOn(vehicle, false, false, true)
        Wait(8500)
        DoScreenFadeOut(1500)
        Wait(1300)
        RenderScriptCams(0, 1, 500, 1, 1)
        Wait(500)
        DoScreenFadeIn(4300)
        SetCamCoord(camera, data.method.roller.standard.camera.x, data.method.roller.standard.camera.y, data.method.roller.standard.camera.z)
        RenderScriptCams(1, 1, 4500, 1, 1)
        Wait(6600)
    elseif mode == 3 then
        SetCamCoord(camera, data.method.roller.basic.camera.x, data.method.roller.basic.camera.y, data.method.roller.basic.camera.z)
        PointCamAtEntity(camera, PlayerPedId(), 0, 0, 0, 1)
        SetCamNearDof(camera, 10)
        RenderScriptCams(1, 1, 6500, 1, 1)
        SetCamShakeAmplitude(camera, 13.0)
        SetVehicleDoorOpen(vehicle, 0, false, false)
        SetVehicleDoorOpen(vehicle, 1, false, false)
        SetVehicleDoorOpen(vehicle, 2, false, false)
        SetVehicleDoorOpen(vehicle, 3, false, false)
        SetVehicleDoorOpen(vehicle, 4, false, false)
        SetVehicleDoorOpen(vehicle, 5, false, false)
        SetVehicleDoorOpen(vehicle, 6, false, false)
        SetVehicleDoorOpen(vehicle, 7, false, false)
        SetVehicleEngineOn(vehicle, false, false, true)
        Wait(8500)
        DoScreenFadeOut(1500)
        Wait(1300)
        RenderScriptCams(0, 1, 500, 1, 1)
        Wait(500)
        DoScreenFadeIn(4300)
        SetCamCoord(camera, data.method.roller.standard.camera.x, data.method.roller.standard.camera.y, data.method.roller.standard.camera.z)
        RenderScriptCams(1, 1, 4500, 1, 1)
        Wait(6600)
        DoScreenFadeOut(1500)
        Wait(1500)
        RenderScriptCams(0, 1, 500, 1, 1)
        Wait(500)
        DoScreenFadeIn(1500)
        SetCamCoord(camera, data.method.roller.premium.camera.x, data.method.roller.premium.camera.y, data.method.roller.premium.camera.z)
        RenderScriptCams(1, 1, 7500, 1, 1)
        Wait(8500)
    end
    RenderScriptCams(0, 1, 5000, 1, 1)
    DestroyCam(camera, true)
    exitMenu()
    SetVehicleDoorShut(vehicle, 0, false)
    SetVehicleDoorShut(vehicle, 1, false)
    SetVehicleDoorShut(vehicle, 2, false)
    SetVehicleDoorShut(vehicle, 3, false)
    SetVehicleDoorShut(vehicle, 4, false)
    SetVehicleDoorShut(vehicle, 5, false)
    SetVehicleDoorShut(vehicle, 6, false)
    SetVehicleDoorShut(vehicle, 7, false)
    SetVehicleEngineOn(vehicle, true, false, true)
    TaskVehicleDriveToCoord(PlayerPedId(), vehicle, data.method.roller.position.exit.x, data.method.roller.position.exit.y, data.method.roller.position.exit.z, data.method.roller.speed, 5.0, GetHashKey(vehicle), 16777216, 1.0, true)
    SetVehicleDirtLevel(vehicle, 1.0)
end)

function createPedCarwash(name)
    local vehcoord = GetEntityCoords(GetPlayersLastVehicle(PlayerPedId()))
    local pedHash = GetHashKey(name)
    RequestModel(pedHash)
    while not HasModelLoaded(pedHash) do
        Citizen.Wait(1)
    end
    local npc = CreatePed(5, pedHash, vehcoord.x, vehcoord.y + 4.5, vehcoord.z, 1, true, true)
    SetEntityInvincible(npc, true)
    SetBlockingOfNonTemporaryEvents(npc, true)
    return npc
end

function createPropCarwash(name, npc)
    local prop = CreateObject(name, 0, 0, 0, true, true, true)
    AttachEntityToEntity(prop, npc, GetPedBoneIndex(npc, 28422), 0.05, -0.05, -0.05, 260.0, 160.0, 0.0, 1, 1, 0, 1, 0, 1)
    return prop
end

function exitMenu()
    FreezeEntityPosition(PlayerPedId(), false)
    FreezeEntityPosition(GetVehiclePedIsIn(PlayerPedId(), false), false)
    DisplayRadar(true)
    isWashing = false
    loading = 0.0
    verrou = false
    mainMenu.Closable = true
    ESX.ShowNotification(Config.Translate('thanks'))
    RageUI.CloseAll()
    open = false
end

Citizen.CreateThread(function()
    for k, v in pairs(Config.carwash) do
        if Config.blip.active then
            local blip = AddBlipForCoord(v.position.x, v.position.y, v.position.z)
            SetBlipSprite(blip, Config.blip.sprite)
            SetBlipDisplay(blip, 4)
            SetBlipScale(blip, Config.blip.scale)
            SetBlipColour(blip, Config.blip.color)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentSubstringPlayerName(Config.Translate('blipLabel'))
            EndTextCommandSetBlipName(blip)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        local wait = 900
        for k, v in pairs(Config.carwash) do
            local plyCoords = GetEntityCoords(PlayerPedId(), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, v.position.x, v.position.y, v.position.z)
            if dist <= 25 then
                wait = 1
                DrawMarker(Config.marker.type, v.position.x, v.position.y, v.position.z, 0.0, 0.0, 0.0, Config.marker.rotation.x, Config.marker.rotation.y, Config.marker.rotation.z, Config.marker.scale.x, Config.marker.scale.y, Config.marker.scale.z, Config.marker.color.r, Config.marker.color.g, Config.marker.color.b, Config.marker.color.a, Config.marker.jump, false, p19, Config.marker.rotate)
            end
            if dist <= 2.0 then
                wait = 1
                if IsPedSittingInAnyVehicle(PlayerPedId()) then
                    ESX.ShowHelpNotification(Config.Translate('markerLabel'))
                    if IsControlJustPressed(1, 47) then
                        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                        if GetPedInVehicleSeat(vehicle, -1) == PlayerPedId() then
                            FreezeEntityPosition(PlayerPedId(), true)
                            DoScreenFadeOut(1000)
                            Citizen.Wait(1000)
                            SetEntityCoords(vehicle, vector3(v.position.x, v.position.y, v.position.z))
                            SetEntityHeading(vehicle, v.position.h)
                            DisplayRadar(false)
                            Citizen.Wait(500)
                            DoScreenFadeIn(1000)
                            carwashMenu(v)
                        else
                            ESX.ShowNotification("~r~"..Config.Translate('notTheDriver'))
                        end
                    end
                else
                    ESX.ShowHelpNotification("~r~"..Config.Translate('markerLabelnotInACar'))
                end
            end 
        end
        Citizen.Wait(wait)
    end
end)