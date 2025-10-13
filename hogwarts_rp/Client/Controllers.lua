local Hogwarts = Package.GetExports("hogwarts_rp").Hogwarts
local Logger = Package.Require("Shared/Modules/Logger.lua")
local EventBus = Package.Require("Shared/Modules/EventBus.lua")
local GameplayConfig = Package.Require("Shared/Config/Gameplay.lua")

Logger:info("Hogwarts RP versión %s inicializando (cliente)", Hogwarts.Version)

local hud_ui = WebUI("hogwarts_hud", "file:///UI/hud.html", UIVisibilityMode.Always, false)
hud_ui:SetFocused(false)

local function send_to_ui(action, payload)
    hud_ui:CallEvent("hogwarts:ui_event", json.encode({ action = action, payload = payload }))
end

Events.Subscribe("KeyDown", function(key_name)
    if key_name == "F1" then
        hud_ui:SetVisibility(not hud_ui:IsVisible())
    end
end)

Events.SubscribeRemote("hogwarts:characters", function(characters)
    send_to_ui("characters:update", characters)
end)

Events.SubscribeRemote("hogwarts:create_character_success", function(character)
    send_to_ui("characters:created", character)
end)

Events.SubscribeRemote("hogwarts:create_character_failed", function(reason)
    send_to_ui("characters:create_failed", { reason = reason })
end)

Events.SubscribeRemote("hogwarts:spells_updated", function(spells)
    send_to_ui("spells:update", spells)
end)

WebUI.ListenForEvent("hogwarts:ui_ready", function()
    send_to_ui("config:update", {
        houses = Package.Require("Shared/Data/Houses.lua"),
        spells = Package.Require("Shared/Data/Spells.lua"),
        classes = Package.Require("Shared/Data/Classes.lua"),
        gameplay = GameplayConfig
    })
    Events.CallRemote("hogwarts:request_characters")
end)

WebUI.ListenForEvent("hogwarts:create_character", function(data_json)
    local payload = json.decode(data_json)
    Events.CallRemote("hogwarts:create_character", payload)
end)

WebUI.ListenForEvent("hogwarts:cast_spell", function(data_json)
    local payload = json.decode(data_json)
    Events.CallRemote("hogwarts:cast_spell", payload)
end)

return {
    UI = hud_ui
}
