# API de Magia

## Registro de hechizos
```lua
HLX.Magic.RegisterSpell("id", {
    name = "Nombre visible",
    incantation = "Palabra clave",
    cooldown = 5,
    mana_cost = 15,
    school = "charm" | "defense" | "utility",
    min_year = 1,
    min_rank = "prefect", -- opcional
    server = {
        CanCast = function(ply, ctx) return true end,
        OnCast = function(ply, trace) return true end
    },
    client = {
        OnFX = function(ply, ctx) end
    }
})
```
- `ctx` puede incluir `trace`, `HitPos` o datos personalizados.
- Devuelve `false` en `OnCast` para cancelar la ejecución.

## Registro de varitas
```lua
HLX.Magic.RegisterWand("id", {
    name = "Varita",
    wood = "Madera",
    core = "Núcleo",
    length = 12,
    flexibility = "Media",
    affinities = { defense = 0.2 },
    rarity = "common"
})
```
- Las afinidades reducen el coste de maná en porcentaje.

## Sistema de maná
- `HLX.Config.ManaBase`: cantidad base.
- `HLX.Wands.GetAffinity(ply, school)`: bonificador aplicado.
- Los valores se guardan por personaje.

## Hooks mágicos
- `HLX:SpellCast(ply, spellID, trace)`
- `HLX:WandAssigned(ply, wandID)`
- `HLX:PotionBrewed(ply, potionID)`

## Pociones
Usa `HLX.Potions.RegisterRecipe(id, data)` en `sh_potions.lua` para añadir recetas.
```lua
HLX.Potions.RegisterRecipe("wiggenweld", {
    time = 10,
    ingredients = { herb = 2, water = 1 },
    result = "potion_wiggenweld"
})
```

## Escobas
- `HLX.Brooms.Toggle(ply, state)` controla el estado.
- `HLX.Brooms.CanUse(ply)` valida zonas seguras.

## Zonas y reglas
- Registra zonas con `HLX.Zones.Register(id, data)` en `sh_zones.lua`.
- Usa `HLX.Rules.CanCastSpell(ply, spellID)` para validar restricciones personalizadas.
