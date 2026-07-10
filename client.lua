local drawDistance = 20.0
local drawDistanceSq = drawDistance * drawDistance
local holdKey = 344
local idleWait = 250
local hideIdsWhenTargetInVehicle = true
local hideIdsWhenLocalInVehicle = true

CreateThread(function()
    while true do
        if not IsControlPressed(0, holdKey) then
            Wait(idleWait)
        else
            local myPlayerId = PlayerId()
            local myPed = PlayerPedId()
            if myPed ~= 0 and (not hideIdsWhenLocalInVehicle or not IsPedInAnyVehicle(myPed, false)) then
                local myCoords = GetEntityCoords(myPed)
                local players = GetActivePlayers()

                SetTextFont(0)
                SetTextProportional(1)
                SetTextScale(0.35, 0.35)
                SetTextColour(255, 255, 255, 215)
                SetTextEdge(1, 0, 0, 0, 255)
                SetTextCentre(true)

                for _, player in ipairs(players) do
                    if player ~= myPlayerId then
                        local ped = GetPlayerPed(player)
                        if ped ~= 0 and DoesEntityExist(ped) and (not hideIdsWhenTargetInVehicle or not IsPedInAnyVehicle(ped, false)) then
                            local coords = GetEntityCoords(ped)
                            local dx = myCoords.x - coords.x
                            local dy = myCoords.y - coords.y
                            local dz = myCoords.z - coords.z
                            if (dx * dx + dy * dy + dz * dz) < drawDistanceSq then
                                local onScreen, x, y = World3dToScreen2d(coords.x, coords.y, coords.z + 1.0)
                                if onScreen then
                                    SetTextOutline()
                                    BeginTextCommandDisplayText("STRING")
                                    AddTextComponentSubstringPlayerName("ID: " .. GetPlayerServerId(player))
                                    EndTextCommandDisplayText(x, y)
                                end
                            end
                        end
                    end
                end
            end
            Wait(0)
        end
    end
end)
