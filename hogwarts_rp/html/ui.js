(() => {
    const app = document.getElementById('app');
    const characterList = document.getElementById('character-list');
    const spellList = document.getElementById('spell-list');
    const scheduleContent = document.getElementById('schedule-content');
    const modal = document.getElementById('modal');
    const modalClose = document.getElementById('modal-close');
    const createCharacterBtn = document.getElementById('create-character-btn');
    const createCharacterForm = document.getElementById('create-character-form');
    const characterName = document.getElementById('character-name');
    const characterHouse = document.getElementById('character-house');
    const currencyGaleons = document.getElementById('currency-galeons');
    const currencySickles = document.getElementById('currency-sickles');
    const currencyKnuts = document.getElementById('currency-knuts');
    const notification = document.getElementById('notification');

    const state = {
        houses: {},
        spellDefinitions: [],
        knownSpells: [],
        classes: [],
        characters: [],
        selectedCharacter: null
    };

    function send(action, payload = {}) {
        if (window.hogwarts_bridge && typeof window.hogwarts_bridge.Send === 'function') {
            window.hogwarts_bridge.Send(action, JSON.stringify(payload));
        }
    }

    function showApp() {
        app.classList.remove('hidden');
    }

    function toggleModal(show) {
        modal.classList.toggle('hidden', !show);
    }

    function showNotification(type, message) {
        notification.textContent = message;
        notification.className = `notification ${type}`;
        notification.classList.remove('hidden');
        setTimeout(() => notification.classList.add('hidden'), 4000);
    }

    function renderCharacters() {
        characterList.innerHTML = '';
        state.characters.forEach((character) => {
            const card = document.createElement('div');
            card.className = 'character-card';
            if (state.selectedCharacter && state.selectedCharacter.id === character.id) {
                card.classList.add('active');
            }
            card.innerHTML = `
                <h3>${character.first_name} ${character.last_name}</h3>
                <p>${character.house || 'Sin casa'} · ${character.year || 1}º curso</p>
            `;
            card.addEventListener('click', () => {
                send('characters:select', { id: character.id });
            });
            characterList.appendChild(card);
        });
    }

    function renderSpells() {
        spellList.innerHTML = '';
        if (!state.selectedCharacter) {
            return;
        }

        const knownSpells = (state.selectedCharacter && state.selectedCharacter.spells) || state.knownSpells || [];
        knownSpells.forEach((spell) => {
            const item = document.createElement('li');
            item.className = 'spell-item';
            const definition = state.spellDefinitions.find((entry) => entry.id === (spell.spell_id || spell.id));
            const label = definition ? definition.name : (spell.spell_id || spell.id);
            item.innerHTML = `
                <span>
                    <strong>${label}</strong>
                    <small>${spell.proficiency || ''}</small>
                </span>
                <button data-spell="${spell.spell_id || spell.id}">Lanzar</button>
            `;
            item.querySelector('button').addEventListener('click', () => {
                send('spells:cast', {
                    character_id: state.selectedCharacter.id,
                    spell_id: spell.spell_id || spell.id
                });
            });
            spellList.appendChild(item);
        });
    }

    function renderSchedule() {
        scheduleContent.innerHTML = '';
        if (!state.selectedCharacter) {
            return;
        }
        const schedule = (state.selectedCharacter.schedule && state.selectedCharacter.schedule.classes) || [];
        schedule.forEach((entry) => {
            const div = document.createElement('div');
            div.className = 'schedule-entry';
            div.innerHTML = `
                <strong>${entry.class_id}</strong>
                <p>${entry.day_of_week || ''} · ${entry.starts_at || ''}</p>
            `;
            scheduleContent.appendChild(div);
        });
    }

    function selectCharacter(character) {
        state.selectedCharacter = character;
        characterName.textContent = `${character.first_name} ${character.last_name}`;
        characterHouse.textContent = `${character.house || 'Sin casa'} · ${character.year || 1}º curso`;
        const currency = character.currency || {};
        currencyGaleons.textContent = currency.galeons || 0;
        currencySickles.textContent = currency.sickles || 0;
        currencyKnuts.textContent = currency.knuts || 0;
        renderCharacters();
        renderSpells();
        renderSchedule();
    }

    function gatherFormData(form) {
        const formData = new FormData(form);
        const traits = [];
        form.querySelectorAll('input[name="traits"]:checked').forEach((input) => traits.push(input.value));
        return {
            first_name: formData.get('first_name'),
            last_name: formData.get('last_name'),
            blood_status: formData.get('blood_status'),
            patronus: formData.get('patronus'),
            traits
        };
    }

    function handleAction(action, payload) {
        switch (action) {
            case 'config:update':
                state.houses = payload.houses || {};
                state.spellDefinitions = payload.spells || [];
                state.classes = payload.classes || [];
                break;
            case 'characters:update':
                state.characters = payload || [];
                renderCharacters();
                break;
            case 'characters:created':
                state.characters.push(payload);
                selectCharacter(payload);
                state.knownSpells = payload.spells || [];
                toggleModal(false);
                showNotification('success', '¡Personaje creado con éxito!');
                break;
            case 'characters:create_failed':
                showNotification('error', `No se pudo crear el personaje: ${payload.reason}`);
                break;
            case 'characters:selected':
                selectCharacter(payload);
                state.knownSpells = payload.spells || state.knownSpells;
                break;
            case 'spells:update':
                state.knownSpells = payload || [];
                if (state.selectedCharacter) {
                    state.selectedCharacter.spells = state.knownSpells;
                }
                renderSpells();
                break;
            case 'spells:cast_success':
                showNotification('success', 'Hechizo lanzado correctamente');
                break;
            case 'spells:cast_failed':
                showNotification('error', `No se pudo lanzar el hechizo: ${payload.reason}`);
                break;
            default:
                console.warn('Evento no manejado', action, payload);
        }
    }

    window.hogwarts = {
        receive(action, payload) {
            handleAction(action, payload || {});
        }
    };

    createCharacterBtn.addEventListener('click', () => toggleModal(true));
    modalClose.addEventListener('click', () => toggleModal(false));

    createCharacterForm.addEventListener('submit', (event) => {
        event.preventDefault();
        const payload = gatherFormData(createCharacterForm);
        send('characters:create', payload);
    });

    document.addEventListener('keydown', (event) => {
        if (event.key === 'Escape' && !modal.classList.contains('hidden')) {
            toggleModal(false);
        }
    });

    document.addEventListener('DOMContentLoaded', () => {
        showApp();
        if (window.hogwarts_bridge && typeof window.hogwarts_bridge.Ready === 'function') {
            window.hogwarts_bridge.Ready();
        }
    });
})();
