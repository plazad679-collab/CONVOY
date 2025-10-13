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

let state = {
    houses: {},
    spells: [],
    classes: [],
    characters: [],
    selectedCharacter: null
};

function showApp() {
    app.classList.remove('hidden');
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
            <p>${character.house} · ${character.year}º curso</p>
        `;
        card.addEventListener('click', () => selectCharacter(character));
        characterList.appendChild(card);
    });
}

function renderSpells() {
    spellList.innerHTML = '';
    if (!state.selectedCharacter) {
        return;
    }

    state.spells.forEach((spell) => {
        const item = document.createElement('li');
        item.className = 'spell-item';
        item.innerHTML = `
            <span>
                <strong>${spell.spell_id.toUpperCase()}</strong>
                <small>${spell.proficiency}</small>
            </span>
            <button data-spell="${spell.spell_id}">Lanzar</button>
        `;
        item.querySelector('button').addEventListener('click', () => castSpell(spell.spell_id));
        spellList.appendChild(item);
    });
}

function renderSchedule() {
    scheduleContent.innerHTML = '';
    if (!state.selectedCharacter) {
        return;
    }

    const schedule = state.selectedCharacter.schedule?.classes || [];
    schedule.forEach((entry) => {
        const div = document.createElement('div');
        div.className = 'schedule-entry';
        div.innerHTML = `
            <strong>${entry.class_id}</strong>
            <p>${entry.day_of_week} · ${entry.starts_at}</p>
        `;
        scheduleContent.appendChild(div);
    });
}

function selectCharacter(character) {
    state.selectedCharacter = character;
    characterName.textContent = `${character.first_name} ${character.last_name}`;
    characterHouse.textContent = `${character.house} · ${character.year}º curso`;
    currencyGaleons.textContent = character.currency_galeons || 0;
    currencySickles.textContent = character.currency_sickles || 0;
    currencyKnuts.textContent = character.currency_knuts || 0;
    renderCharacters();
    renderSpells();
    renderSchedule();
}

function toggleModal(show) {
    modal.classList.toggle('hidden', !show);
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

function castSpell(spellId) {
    if (!state.selectedCharacter) {
        return;
    }
    Events.Call('hogwarts:cast_spell', JSON.stringify({
        character_id: state.selectedCharacter.id,
        spell_id: spellId
    }));
}

createCharacterBtn.addEventListener('click', () => toggleModal(true));
modalClose.addEventListener('click', () => toggleModal(false));

createCharacterForm.addEventListener('submit', (event) => {
    event.preventDefault();
    const payload = gatherFormData(createCharacterForm);
    Events.Call('hogwarts:create_character', JSON.stringify(payload));
});

window.Events = window.Events || {
    Call(name, payload) {
        if (typeof window.CallEvent === 'function') {
            window.CallEvent(name, payload);
        }
    }
};

window.addEventListener('DOMContentLoaded', () => {
    showApp();
    if (typeof window.CallEvent === 'function') {
        window.CallEvent('hogwarts:ui_ready', '{}');
    }
});

function handleUIEvent(event) {
    const data = JSON.parse(event);
    switch (data.action) {
        case 'config:update':
            state.houses = data.payload.houses;
            state.spells = data.payload.spells;
            state.classes = data.payload.classes;
            break;
        case 'characters:update':
            state.characters = data.payload || [];
            if (state.characters.length > 0) {
                selectCharacter(state.characters[0]);
            }
            renderCharacters();
            break;
        case 'characters:created':
            state.characters.push(data.payload);
            selectCharacter(data.payload);
            renderCharacters();
            toggleModal(false);
            break;
        case 'characters:create_failed':
            alert('No se pudo crear el personaje: ' + data.payload.reason);
            break;
        case 'spells:update':
            state.spells = data.payload || [];
            renderSpells();
            break;
        default:
            console.warn('Evento UI no manejado', data.action);
    }
}

window.AddEvent('hogwarts:ui_event', handleUIEvent);
