# Helix Base para Nanos World

Esta base está inspirada en el framework Helix y preparada para servir como punto de partida para servidores de rol en **Nanos World**.

## Características

- 🔌 Sincronización básica servidor/cliente
- 👤 Gestión de personajes con múltiples ranuras
- 🎒 Inventario ligero sincronizado
- 💬 Sistema de comandos con prefijo configurable
- 🧩 Sistema modular para ampliar funcionalidades
- 🖥️ HUD minimalista que muestra estado del personaje

## Estructura

```
helix_base/
├── Client/
│   ├── Controllers.lua
│   └── UI/
│       └── HUD.lua
├── Server/
│   ├── CharacterManager.lua
│   ├── Commands.lua
│   ├── Inventory.lua
│   └── PlayerManager.lua
├── Shared/
│   ├── Config.lua
│   └── Modules/
│       ├── Logger.lua
│       └── Utils.lua
├── index.lua
└── package.toml
```

## Uso

1. Copia la carpeta `helix_base` dentro de tu directorio de paquetes de Nanos World.
2. Inicia el servidor y asegúrate de cargar el paquete con `Package.Load("helix_base")` en tu `Server/Packages.lua`.
3. Conéctate al servidor y utiliza `/ayuda` para ver los comandos disponibles.

## Próximos pasos sugeridos

- Persistencia en base de datos para personajes e inventario.
- Sistema de facciones y trabajos.
- Integración con interfaz personalizada mediante WebUI.
- Expansión del HUD con datos vitales del jugador.

¡Disfruta construyendo tu experiencia de rol sobre esta base! ✨
