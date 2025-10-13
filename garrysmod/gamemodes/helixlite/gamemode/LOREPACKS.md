# Lorepacks

Un lorepack es una carpeta dentro de `lorepacks/` con al menos `sh_lore_config.lua` que retorna una tabla con metadatos.

## Estructura básica
```lua
return {
    name = "Nombre",
    description = "Descripción",
    factions = { id = { name = "", color = Color(), permissions = {} } },
    roles = { id = { weight = 0, inherits = "", permissions = {} } },
    items = { id = { ... } },
    spells = { id = { ... } },
    wands = { id = { ... } }
}
```

Todos los nombres pueden rebrandearse cambiando los campos `name` y `description`.

## Activación
- Ejecuta `/lorepack enable <id>` para cargarlo.
- `/lorepack disable <id>` lo desactiva.
- Las convars `hlx_enable_lorepack` y `hlx_lorepack_active` controlan el estado al inicio.

## Ejemplo Harry Potter
Incluye casas, roles especiales, hechizos clásicos y objetos como `potion_wiggenweld` y `chocolate_frog`.
