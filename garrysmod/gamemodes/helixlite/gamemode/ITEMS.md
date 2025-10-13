# Sistema de Ítems

Registra ítems con `HLX.Items.Register(id, data)` en servidor.

## Campos
- `name`, `description`
- `stack`: `true` por defecto.
- `weight`: usado para inventario por peso.
- `equip`: si es `true`, se usa `OnEquip` en vez de consumir el ítem.
- `OnUse(ply, data)`, `OnDrop(ply, cantidad)`, `OnEquip(ply, data)` son callbacks opcionales.

Los ítems se guardan en SQLite y se replican mediante los mensajes de inventario.

El lorepack de ejemplo añade `wand_legendary`, `potion_wiggenweld` y `chocolate_frog`.
