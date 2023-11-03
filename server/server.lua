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

RegisterNetEvent('p2p_Carwash:buy_wash')
AddEventHandler('p2p_Carwash:buy_wash', function(mode, data, index)
    local xPlayer = ESX.GetPlayerFromId(source)
    local canPurchase = false
    if index == 1 then
        canPurchase = xPlayer.getMoney() >= data.prices[mode]
    elseif index == 2 then
        canPurchase = xPlayer.getAccount('bank').money >= data.prices[mode]
    end
    if canPurchase then
        if index == 1 then
            xPlayer.removeMoney(data.prices[mode])
            color = "~g~"
        elseif index == 2 then
            xPlayer.removeAccountMoney('bank', data.prices[mode])
            color = "~b~"
        end
        TriggerClientEvent('esx:showNotification', source, Config.Translate('you_paid').." "..color..""..data.prices[mode].."$")
        TriggerClientEvent('p2p_Carwash:washCarWith_'..data.method.type, source, mode, data)
    else
        TriggerClientEvent('esx:showNotification', source, "~r~"..Config.Translate('no_money'))
    end
end)