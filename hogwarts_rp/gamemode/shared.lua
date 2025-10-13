GM.Name = "Hogwarts Roleplay"
GM.Author = "Wizarding Framework Team"
GM.Email = "hogwarts@example.com"
GM.Website = "https://hogwarts-roleplay.example.com"

DeriveGamemode("sandbox")

Hogwarts = Hogwarts or {}
Hogwarts.Version = Hogwarts.Version or "0.1.0"
Hogwarts.Config = Hogwarts.Config or {}
Hogwarts.Data = Hogwarts.Data or {}
Hogwarts.Modules = Hogwarts.Modules or {}
Hogwarts.Core = Hogwarts.Core or {}
Hogwarts.State = Hogwarts.State or {}

local loader = {}
loader.Root = string.format("%s/gamemode", GM.FolderName or "hogwarts_rp")

local function include_file(path)
    local file_name = string.GetFileFromFilename(path)

    if string.StartWith(file_name, "sh_") then
        if SERVER then
            AddCSLuaFile(path)
        end
        include(path)
    elseif string.StartWith(file_name, "cl_") then
        if SERVER then
            AddCSLuaFile(path)
        elseif CLIENT then
            include(path)
        end
    elseif string.StartWith(file_name, "sv_") then
        if SERVER then
            include(path)
        end
    else
        if SERVER then
            AddCSLuaFile(path)
        end
        include(path)
    end
end

function loader.IncludeFolder(folder)
    local search_path = string.format("%s/%s", loader.Root, folder)
    local entries, directories = file.Find(search_path .. "/*", "GAME")

    for _, file_name in ipairs(entries) do
        if string.EndsWith(string.lower(file_name), ".lua") then
            include_file(string.format("%s/%s", folder, file_name))
        end
    end

    for _, directory in ipairs(directories) do
        loader.IncludeFolder(string.format("%s/%s", folder, directory))
    end
end

Hogwarts.Loader = loader

function Hogwarts.PrintBanner()
    local banner = string.format([[\n===========================================\n  Hogwarts Roleplay Framework v%s\n===========================================\n]], Hogwarts.Version)
    MsgC(Color(202, 168, 72), banner)
end

return Hogwarts
