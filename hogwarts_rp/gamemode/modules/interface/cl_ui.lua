local Interface = {}
Interface.Visible = false
Interface.Panel = nil
Interface.LastCharacters = {}
Interface.Ready = false
Interface.Queue = {}

local Net = Hogwarts.Core.Net
local State = Hogwarts.State

local function load_asset(path)
    return file.Read(string.format("%s/%s", GM.FolderName or "hogwarts_rp", path), "GAME") or ""
end

function Interface:BuildDocument()
    local html = load_asset("html/ui.html")
    local css = load_asset("html/ui.css")
    local js = load_asset("html/ui.js")
    html = html:gsub("{{CSS}}", css:gsub("%%", "%%%%"))
    html = html:gsub("{{JS}}", js:gsub("%%", "%%%%"))
    return html
end

function Interface:CreatePanel()
    if IsValid(self.Panel) then return end

    self.Panel = vgui.Create("DHTML")
    self.Panel:SetSize(ScrW() * 0.8, ScrH() * 0.8)
    self.Panel:Center()
    self.Panel:SetVisible(false)
    self.Panel:SetHTML(self:BuildDocument())

    self.Panel:AddFunction("hogwarts_bridge", "Ready", function()
        self:OnReady()
    end)

    self.Panel:AddFunction("hogwarts_bridge", "Send", function(action, payload)
        self:Handle(action, payload)
    end)
end

function Interface:Initialize()
    self:CreatePanel()

    hook.Add("PlayerButtonDown", "Hogwarts.ToggleUI", function(ply, button)
        if ply ~= LocalPlayer() then return end
        if button == KEY_F1 then
            self:Toggle()
        end
    end)
end

function Interface:Toggle(force)
    if not IsValid(self.Panel) then return end
    if force ~= nil then
        self.Visible = force
    else
        self.Visible = not self.Visible
    end

    self.Panel:SetVisible(self.Visible)
    if self.Visible then
        self.Panel:RequestFocus()
    end
    gui.EnableScreenClicker(self.Visible)
end

function Interface:Push(action, payload)
    if not IsValid(self.Panel) or not self.Ready then
        table.insert(self.Queue, { action = action, payload = payload })
        return
    end
    local json = util.TableToJSON(payload or {}, false)
    local js = string.format("window.hogwarts.receive('%s', %s);", action, json)
    self.Panel:QueueJavascript(js)
end

function Interface:OnReady()
    self.Ready = true
    self:Push("config:update", {
        houses = Hogwarts.Modules.Lore:GetHouses(),
        spells = Hogwarts.Modules.Lore:GetSpells(),
        classes = Hogwarts.Modules.Lore:GetClasses(),
        gameplay = Hogwarts.Config.Gameplay
    })
    for _, event in ipairs(self.Queue) do
        self:Push(event.action, event.payload)
    end
    self.Queue = {}
    net.Start(Net.Messages.CharactersRequest)
    net.SendToServer()
end

local function send_to_server(message, payload)
    net.Start(message)
    net.WriteTable(payload or {})
    net.SendToServer()
end

function Interface:Handle(action, payload_json)
    local payload = util.JSONToTable(payload_json or "{}") or {}
    if action == "characters:create" then
        send_to_server(Net.Messages.CharacterCreated, payload)
    elseif action == "characters:select" then
        send_to_server(Net.Messages.CharacterSelect, payload)
        if payload.id then
            local character = nil
            for _, stored in ipairs(State.characters or {}) do
                if stored.id == payload.id then
                    character = stored
                    break
                end
            end
            if character then
                hook.Run("Hogwarts.CharacterSelected", character)
            end
        end
    elseif action == "spells:cast" then
        send_to_server(Net.Messages.SpellCast, payload)
    elseif action == "ui:toggle" then
        self:Toggle()
    end
end

Hogwarts.Modules.Interface = Interface

return Interface
