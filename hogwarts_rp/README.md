# Hogwarts Roleplay Framework para Garry's Mod

Este gamemode sienta las bases para construir un servidor de rol ambientado en el universo de Harry Potter dentro de **Garry's Mod**. Incluye un sistema modular de personajes, grimorio, economía mágica y una interfaz cinematográfica desarrollada íntegramente en **HTML + CSS + JavaScript** que se renderiza mediante `DHTML`.

## Características principales

- 🧙 **Gestión modular de personajes** con linajes, asignación automática de casa según rasgos y persistencia local en formato JSON (extensible a MySQL).
- 🪄 **Grimorio dinámico** que sincroniza hechizos conocidos, comprueba restricciones narrativas y gestiona cooldowns.
- 🕮 **Lore configurable** (casas, clases, hechizos, ubicaciones) compartido entre cliente y servidor para mantener coherencia en la ambientación.
- 🖥️ **WebUI responsive** construida con web estándar, inyectada en el motor DHTML y comunicada con Lua mediante un bridge bidireccional.
- 🧩 **Arquitectura pensada para ampliaciones** con módulos independientes (`modules/`) fáciles de extender con nuevas mecánicas (misiones, criaturas, prefectos, etc.).
- 🗄️ **Abstracción de persistencia** lista para conectar con `mysqloo` o `tmysql4`, manteniendo un almacenamiento local por defecto.

## Estructura del gamemode

```
hogwarts_rp/
├── gamemode/
│   ├── cl_init.lua           # Punto de entrada del cliente
│   ├── init.lua              # Punto de entrada del servidor
│   ├── shared.lua            # Definiciones compartidas y loader dinámico
│   ├── config/               # Configuración de gameplay y base de datos
│   ├── core/                 # Utilidades (logger, event bus, red, etc.)
│   ├── data/                 # Tablas de lore compartidas (casas, hechizos, clases)
│   └── modules/              # Lógica modular (personajes, hechizos, interfaz, ...)
└── html/
    ├── ui.html               # Layout principal del HUD/menús
    ├── ui.css                # Estilos tematizados en Hogwarts
    └── ui.js                 # Lógica de interacción y bridge con Lua
```

## Puesta en marcha

1. Copia la carpeta `hogwarts_rp` dentro de `garrysmod/gamemodes/` en tu servidor o instalación dedicada.
2. Selecciona el gamemode `hogwarts_rp` en la configuración del servidor (`+gamemode hogwarts_rp`).
3. Arranca el servidor. Se creará la carpeta de datos `data/hogwarts_rp/characters/` donde se persisten los personajes.
4. Ingresa al servidor y presiona `F1` para abrir la interfaz. Desde allí podrás crear personajes y sincronizar el grimorio.

## Persistencia y base de datos

- Por defecto los personajes se guardan como archivos JSON individuales (`data/hogwarts_rp/characters/<steamid64>.json`).
- El archivo `gamemode/config/sh_database.lua` define las credenciales para habilitar una base de datos MySQL. Implementa tus adaptadores en `modules/characters/sv_character.lua` utilizando las funciones existentes como punto de extensión.

## Personalización de la UI

- Edita `html/ui.html`, `ui.css` y `ui.js` para adaptar la estética o añadir nuevas pantallas.
- La comunicación con Lua utiliza un bridge (`hogwarts_bridge`) registrado en `modules/interface/cl_ui.lua`. Puedes añadir nuevas acciones siguiendo el patrón `send('mi:accion', payload)` en JavaScript y manejándolas en Lua.

## Extender el framework

- Añade nuevos hechizos actualizando `gamemode/data/sh_spells.lua` y extendiendo la lógica en `modules/spells/`.
- Registra nuevas actividades académicas en `gamemode/data/sh_classes.lua` y utilízalas con `Hogwarts.Modules.Schedule`.
- Implementa nuevas economías mágicas o tiendas sobre el módulo `modules/economy/`.
- Usa `Hogwarts.Core.EventBus` para conectar sistemas (por ejemplo, reaccionar a `character_created` o `spell_cast`).

> ⚡ **"La magia comienza cuando tus jugadores pisan los pasillos de Hogwarts."** Usa esta base para llevar tu servidor de rol al siguiente nivel.
