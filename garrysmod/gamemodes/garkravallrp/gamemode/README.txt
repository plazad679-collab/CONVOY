GarkravallRP
============

Bienvenido a GarkravallRP, un framework modular de roleplay mágico para Garry's Mod.

Instalación
-----------
1. Copia la carpeta `garrysmod/gamemodes/garkravallrp` dentro de tu instalación de Garry's Mod.
2. Inicia el servidor y selecciona `GarkravallRP` como gamemode activo.
3. Asegúrate de que la carpeta `data` tenga permisos de escritura para que se generen archivos SQLite.

Configuración
-------------
- Edita `gamemode/config/settings.lua` para definir el driver de base de datos (sqlite o mysql), credenciales, salarios y colores de la interfaz.
- Personaliza módulos existentes modificando sus archivos dentro de `gamemode/modules/`.

Crear nuevos módulos
--------------------
1. Crea una nueva carpeta dentro de `gamemode/modules/` con el nombre del sistema.
2. Añade un archivo `sh_modulo.lua` (o similar) que contenga:

```
local MODULE = {}

function MODULE:Init()
    -- inicialización
end

Garkravall.RegisterModule("nombre", MODULE)
```

3. Los módulos pueden exponer funciones públicas, escuchar eventos mediante `Garkravall.AddInternalHook` y emitir eventos con `Garkravall.BroadcastEvent`.

Frontend
--------
- Todos los elementos de la interfaz se encuentran en `gamemode/ui/html/`.
- El HUD se crea con un panel `DHTML` y se comunica con Lua utilizando `DHTML:AddFunction`.

Comandos útiles
---------------
- Usa la consola del servidor para monitorizar mensajes `[Garkravall]`.
- Para depuración, puedes llamar a `lua_run_cl Garkravall.UI.Update({...})` desde el cliente.

Créditos
--------
- Diseño y desarrollo: Equipo Garkravall.
- Inspirado en el universo mágico de J.K. Rowling.
