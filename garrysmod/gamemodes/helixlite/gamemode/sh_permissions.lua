--[[
    Permisos y roles de HelixLite.
]]

HLX.Permissions = HLX.Permissions or {}
HLX.Permissions.Roles = {
    owner = { weight = 100, inherits = "admin", permissions = {"*"} },
    admin = { weight = 90, inherits = "mod", permissions = {"hlx.manage", "hlx.punish"} },
    mod = { weight = 80, inherits = "prefect", permissions = {"hlx.kick", "hlx.freeze"} },
    prefect = { weight = 70, inherits = "professor", permissions = {"hlx.prefect"} },
    professor = { weight = 60, inherits = "auror", permissions = {"hlx.professor"} },
    auror = { weight = 55, inherits = "student", permissions = {"hlx.defense"} },
    student = { weight = 50, inherits = "user", permissions = {"hlx.learn"} },
    user = { weight = 10, inherits = nil, permissions = {"hlx.basic"} }
}

function HLX.Permissions.Get(role)
    return HLX.Permissions.Roles[string.lower(role or "")]
end

local function hasPermission(roleData, permission)
    if not roleData then return false end
    for _, perm in ipairs(roleData.permissions or {}) do
        if perm == "*" or perm == permission then
            return true
        end
    end
    if roleData.inherits then
        return hasPermission(HLX.Permissions.Get(roleData.inherits), permission)
    end
    return false
end

function HLX.Permissions.HasPerm(ply, permission)
    if not IsValid(ply) then return false end
    if ply:IsSuperAdmin() then return true end
    local role = string.lower(ply:GetNWString("hlx_role", "user"))
    local roleData = HLX.Permissions.Get(role)
    return hasPermission(roleData, permission)
end

function HLX.Permissions.CanUser(role, permission)
    local roleData = HLX.Permissions.Get(role)
    return hasPermission(roleData, permission)
end

return HLX.Permissions
