# Plugins

Los plugins viven en `plugins/<nombre>/sh_plugin.lua`.

## Plantilla
```lua
return {
    name = "Mi Plugin",
    author = "Autor",
    version = "1.0",
    description = "Descripción",
    load_order = 1,
    server = {
        init = function()
            -- Código servidor
        end
    },
    client = {
        init = function()
            -- Código cliente
        end
    }
}
```

- Los plugins se cargan al iniciar el servidor en orden ascendente según `load_order`.
- Usa `HLX.Commands.Register`, `HLX.Magic.RegisterSpell` o `HLX.Items.Register` para extender el gamemode.
- El ejemplo `example_wave` añade `/wave` y el hechizo `salvio`.
