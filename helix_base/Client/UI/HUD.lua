local Helix = Package.GetExports("helix_base").Helix
local Logger = Helix.Logger

local hud_enabled = true
local padding = Vector2D(24, 24)
local line_height = 18

local colors = {
    background = Color(12, 15, 26, 180),
    text = Color.WHITE,
    accent = Color(124, 92, 255)
}

local function draw_panel()
    if not hud_enabled or not Helix.Client then
        return
    end

    if not Helix.Client.Ready then
        Render:DrawText(padding, "Sincronizando con el servidor...", colors.text, 16)
        return
    end

    local y = padding.Y
    local x = padding.X

    local framework = Helix.Client.Config or {}
    local name = framework.Name or "Helix Base"
    local version = framework.Version or "0.0.0"

    Render:DrawBox(Vector2D(x - 12, y - 12), Vector2D(260, 130), colors.background)
    Render:DrawText(Vector2D(x, y), string.format("%s v%s", name, version), colors.accent, 18)
    y = y + line_height * 2

    if Helix.Client.Character then
        Render:DrawText(Vector2D(x, y), string.format("Personaje: %s", Helix.Client.Character.name or "Sin nombre"), colors.text, 16)
    else
        Render:DrawText(Vector2D(x, y), "Personaje: Ninguno", colors.text, 16)
    end
    y = y + line_height

    Render:DrawText(Vector2D(x, y), string.format("Inventario: %d/%d", #Helix.Client.Inventory, Helix.Config.Inventory.Slots), colors.text, 16)
    y = y + line_height

    Render:DrawText(Vector2D(x, y), string.format("Permiso: %s", Helix.Config.Permissions.Default), colors.text, 16)
end

Events.Subscribe("Render", draw_panel)

Events.Subscribe("KeyUp", function(key)
    if key ~= KeyboardKey.F6 then
        return
    end
    hud_enabled = not hud_enabled
    Logger:info("HUD %s", hud_enabled and "activado" or "desactivado")
end)

return {}
