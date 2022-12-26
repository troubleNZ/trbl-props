local Things = {}
local i = 0

-- // Methods
local function CreateProps()
	for k,v in pairs(Config.Props) do
        RequestModel(GetHashKey(v.model))
        while not HasModelLoaded(GetHashKey(v.model)) do
            Wait(1)
        end
		Things[i] = CreateObject(GetHashKey(v.model),v.coords.x, v.coords.y, v.coords.z,false,false,false)
		SetEntityHeading(Things[i],v.coords.w)
		FreezeEntityPosition(Things[i], true)
        SetEntityCollision(Things[i],v.collision,v.physics)
    end
end

local function UnloadProps()
	if Config.Verbose then print("^5trbl-props^7: ^3UnloadProps^7() ^2Clearing area of spawned props^7") end
    for i = 1, #Things do  destroyModel(GetEntityModel(GetHashKey(i.prop))) DeleteObject(Things[i]) end
    Things = {}
end

function destroyModel(model) 
    if Config.Verbose then print("^55trbl-props^7: ^Destroy Model^7: '^6"..model.."^7'") end 
    SetModelAsNoLongerNeeded(model) 
end

-- // Thread
CreateThread(function()
	if Config.EnablePropSpawn == true then
		CreateProps()
	end
end)

-- // Events
RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    isLoggedIn = true
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    isLoggedIn = false
    UnloadProps()
end)

RegisterNetEvent('onResourceStart', function(resource)
	if resource == GetCurrentResourceName() then
		Wait(200)
		isLoggedIn = true
        if Config.Verbose then print("^5@trbl-props^7: ^3Resource Started ^7") end
	end
end)

RegisterNetEvent('onResourceStop', function(resource) 
    if resource == GetCurrentResourceName() then
        for _, v in pairs(Config.Props) do destroyModel(GetEntityModel(GetHashKey(v.model))) DeleteObject(_) end  Things = {}
    end
end)