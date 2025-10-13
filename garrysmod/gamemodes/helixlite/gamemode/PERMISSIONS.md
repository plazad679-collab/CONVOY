# Permisos y roles

Los roles se definen en `sh_permissions.lua`.

## Campos de rol
- `weight`: prioridad (mayor = más alto).
- `inherits`: rol del cual se heredan permisos.
- `permissions`: lista de cadenas (`"*"` concede todo).

## Helpers
- `HLX.Permissions.HasPerm(ply, perm)`
- `HLX.Permissions.CanUser(role, perm)`

Roles por defecto: `owner`, `admin`, `mod`, `prefect`, `professor`, `auror`, `student`, `user`.

Los lorepacks pueden sobrescribir o añadir roles extra.
