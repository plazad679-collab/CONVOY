--[[
    Tema de interfaz personalizado.
]]

surface.CreateFont("HLX_Title", {
    font = "Cinzel",
    size = 28,
    weight = 500
})

surface.CreateFont("HLX_Text", {
    font = "Trebuchet MS",
    size = 18,
    weight = 400
})

HLX.Derma = HLX.Derma or {}

function HLX.Derma.PaintPanel(panel, w, h)
    draw.RoundedBox(8, 0, 0, w, h, Color(15, 15, 25, 220))
end

function HLX.Derma.PaintButton(panel, w, h)
    local color = panel:IsDown() and Color(80, 120, 200) or Color(120, 160, 255)
    draw.RoundedBox(6, 0, 0, w, h, color)
    draw.SimpleText(panel:GetText(), "HLX_Text", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end
