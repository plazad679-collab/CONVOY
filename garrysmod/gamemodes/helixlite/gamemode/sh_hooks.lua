--[[
    Sistema de hooks personalizado para HelixLite.
]]

HLX = HLX or {}
HLX.Hooks = HLX.Hooks or {}

local hookMeta = HLX.Hooks
hookMeta.List = hookMeta.List or {}

local function buildIdentifier(name)
    return "HLX_" .. name
end

--- Registra un hook personalizado.
function hookMeta.Add(name, identifier, func)
    hook.Add(name, buildIdentifier(identifier), func)
    hookMeta.List[name] = hookMeta.List[name] or {}
    hookMeta.List[name][identifier] = func
end

--- Ejecuta un hook personalizado.
function hookMeta.Run(name, ...)
    return hook.Run(name, ...)
end

--- Hooks mágicos predefinidos para referencia.
hookMeta.Events = {
    "HLX:SpellCast",
    "HLX:WandAssigned",
    "HLX:PotionBrewed",
    "HLX:HouseSorted",
    "HLX:BroomMounted"
}

return hookMeta
