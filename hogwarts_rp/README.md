# Hogwarts Roleplay Framework for Nanos World

Este paquete establece una base completa para crear un servidor de rol inspirado en el universo de Harry Potter dentro de **Nanos World**. Incluye integración con MySQL, un sistema de personajes modular y una interfaz rica construida con HTML, JavaScript y CSS.

## Características Clave

- 🧙 **Gestión modular de personajes** con casas, linajes mágicos, varitas y progresión académica.
- 🗄️ **Persistencia completa en MySQL** mediante un sistema de consultas asíncronas y migraciones versionadas.
- 🕮 **Lore configurable** (casas, asignaturas, hechizos, ubicaciones) en archivos compartidos para reutilizar tanto en servidor como cliente.
- 🪄 **Sistema de habilidades y hechizos** con cooldowns, afinidades y requisitos narrativos.
- 🏦 **Economía mágica** con galeones, sickles y knuts sincronizados con el inventario.
- 📚 **Planificador de clases** con soporte para horarios, asistencia y reputación.
- 🖥️ **WebUI cinematográfico** completamente personalizable con HTML + JS + CSS y soporte para múltiples pantallas (HUD, carta de Hogwarts, creación de personaje, grimorio).
- 🧩 **Arquitectura modular** que facilita añadir nuevas features (criaturas mágicas, misiones, mini-juegos).
- 🧪 **Sistema de pruebas y herramientas** para ejecutar migraciones y poblar datos de ejemplo.

## Estructura del Paquete

```
hogwarts_rp/
├── Client/
│   ├── Controllers.lua
│   └── UI/
│       ├── hud.html
│       ├── hud.js
│       └── hud.css
├── Server/
│   ├── index.lua
│   ├── Database/
│   │   └── MySQL.lua
│   ├── Controllers/
│   │   ├── CharacterController.lua
│   │   └── SpellController.lua
│   └── Services/
│       ├── CharacterService.lua
│       ├── HouseService.lua
│       ├── LoreService.lua
│       ├── ScheduleService.lua
│       ├── SpellService.lua
│       └── EconomyService.lua
├── Shared/
│   ├── Config/
│   │   ├── Database.lua
│   │   └── Gameplay.lua
│   ├── Data/
│   │   ├── Houses.lua
│   │   ├── Spells.lua
│   │   ├── Classes.lua
│   │   └── Locations.lua
│   ├── Modules/
│   │   ├── EventBus.lua
│   │   ├── Logger.lua
│   │   └── TableUtils.lua
│   └── Schema/
│       └── migrations.sql
├── Tools/
│   └── seed.lua
├── package.toml
└── index.lua
```

## Configuración Rápida

1. Ajusta las credenciales en `Shared/Config/Database.lua` para apuntar a tu servidor MySQL.
2. Ejecuta las migraciones iniciales copiando `Shared/Schema/migrations.sql` y aplicándolas en tu base de datos.
3. Coloca el paquete `hogwarts_rp` dentro de `Packages/` de tu servidor Nanos World y habilítalo en `Server/Packages.lua`.
4. Inicia tu servidor para que se creen automáticamente las tablas de caché y se carguen los datos base (casas, hechizos, ubicaciones).

## Migraciones y Seeders

- `Shared/Schema/migrations.sql` contiene la definición inicial de las tablas.
- `Tools/seed.lua` puede ejecutarse desde consola del servidor (`Package.Require("Tools/seed.lua"):Run()`) para poblar datos de ejemplo.

## Extender el Framework

- Añade nuevos hechizos modificando `Shared/Data/Spells.lua` y sobrescribiendo la lógica en `Server/Services/SpellService.lua`.
- Integra minijuegos o eventos estacionales registrando nuevos módulos en `Shared/Modules/EventBus.lua` y conectándolos mediante los servicios.
- Personaliza la interfaz editando los archivos en `Client/UI/` y comunicándote con el servidor a través del `EventBus` y `WebUI:Call`.

## Próximos Pasos Sugeridos

- Sistema de prefectos y staff con permisos avanzados.
- Integración con voz en proximidad y hechizos de comunicación.
- Minijuegos de Quidditch y duelos con rankings.
- Herramientas de administración dentro del juego para gestionar estudiantes y eventos.

> ⚡ "La magia comienza cuando tus jugadores pisan los pasillos de Hogwarts." ¡Construye tu experiencia única con esta base!
