# HelixLite

HelixLite es un gamemode base para experiencias de rol mágico inspirado en Hogwarts, pensado para ser ligero y extensible.

## Instalación
1. Copia la carpeta `helixlite` dentro de `garrysmod/gamemodes/`.
2. Inicia el servidor con `+gamemode helixlite`.
3. Asegúrate de que la carpeta `data/` del servidor sea escribible para que SQLite guarde la información.
4. Si usas `tmysql4`, define los datos de conexión en `sh_config.lua` o crea una tabla global `HLX.Config.MySQL` antes de cargar el gamemode.

## Lorepack Harry Potter
1. Activa la convar `hlx_enable_lorepack 1` y `hlx_lorepack_active harry_potter` antes de iniciar, o usa el comando `/lorepack enable harry_potter` en juego como administrador.
2. El lorepack agrega casas, roles, hechizos y objetos temáticos. Todos los nombres pueden cambiarse en `lorepacks/harry_potter/sh_lore_config.lua`.

## Cvars clave
- `hlx_servername`: nombre del servidor en HUD.
- `hlx_command_prefix`: prefijo de chat (por defecto `/`).
- `hlx_enable_persistence`: activa guardado en SQLite.
- `hlx_inventory_slots` / `hlx_inventory_maxweight`: modo de inventario.
- `hlx_magic_mana_base`: cantidad base de maná.
- `hlx_magic_global_cooldown`: cooldown global entre hechizos.

## Comandos rápidos
- Jugador: `/inv`, `/use <item>`, `/drop <item> <cantidad>`, `/cast <hechizo>`, `/charcreate <nombre> <casa|rol>`, `/charselect <id>`, `/chardelete <id>`.
- Admin: `/giveitem <steamid|me> <item> <cant>`, `/setfaction <steamid|me> <facción>`, `/setmoney <steamid|me> <cantidad>`, `/lorepack <enable|disable> harry_potter`.

## Prueba Rápida
1. Iniciar `gm_construct` con `+gamemode helixlite`.
2. Sin errores de consola al cargar.
3. Ejecutar `/lorepack enable harry_potter` (opcional), `/charcreate`, abrir `/inv`, equipar varita.
4. Lanzar `lumos`, `protego`, `expelliarmus` y verificar cooldowns y zonas.
5. Como admin, `/giveitem me potion_wiggenweld 1` y usarla.
6. Reiniciar servidor y confirmar persistencia (SQLite).

## Solución de problemas
- Verifica los logs en `data/helixlite/logs/`.
- Si SQLite falla, revisa permisos de escritura.
- Para MySQL asegúrate de cargar `tmysql4` y definir `HLX.Config.MySQL`.
