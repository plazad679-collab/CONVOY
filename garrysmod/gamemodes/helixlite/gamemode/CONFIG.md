# Configuración de HelixLite

Todas las opciones básicas se definen en `sh_config.lua`.

## Servidor
- `hlx_servername`: nombre mostrado en la interfaz.
- `hlx_enable_persistence`: activa o desactiva el guardado SQLite.
- `HLX.Config.MySQL`: tabla opcional con `host`, `user`, `password`, `database`, `port`, `socket` para activar tmysql4.

## Comandos
- `hlx_command_prefix`: prefijo de chat.

## Economía
- `hlx_currency_name`: nombre de la moneda (por defecto `Galleons`).
- `HLX.Config.CurrencyName`: utilizado por `HLX.Util.FormatMoney`.

## Inventario
- `hlx_inventory_slots`: número de slots cuando `HLX.Config.InventoryMode = "slots"`.
- `hlx_inventory_maxweight`: peso máximo cuando `InventoryMode = "peso"`.
- Cambia el modo editando `HLX.Config.InventoryMode`.

## Magia
- `hlx_magic_mana_base`: maná inicial por jugador.
- `hlx_magic_global_cooldown`: retraso global entre hechizos.
- Cada hechizo define su propio `cooldown` y `mana_cost`.

## Lorepacks
- `hlx_enable_lorepack`: permite cargar un lorepack.
- `hlx_lorepack_active`: nombre del lorepack activo.

Cualquier cambio en convars persistentes requiere reiniciar o ejecutar `reload` para aplicarse.
