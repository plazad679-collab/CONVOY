window.Garkravall = (function () {
    const state = {
        health: 100,
        maxHealth: 100,
        mana: 100,
        money: 0,
        house: 'Sin asignar',
        characters: []
    };

    const hudHealth = document.getElementById('hud-health');
    const hudMana = document.getElementById('hud-mana');
    const hudMoney = document.getElementById('hud-money');
    const hudHouse = document.getElementById('hud-house');
    const hudName = document.getElementById('hud-name');
    const characterList = document.getElementById('character-list');

    function updateBars() {
        const healthPercent = Math.max(0, Math.min(100, (state.health / state.maxHealth) * 100));
        hudHealth.style.width = healthPercent + '%';
        hudMana.style.width = state.mana + '%';
        hudMoney.textContent = state.money;
        hudHouse.textContent = 'Casa: ' + state.house;
    }

    function renderCharacters() {
        characterList.innerHTML = '';
        state.characters.forEach(function (character, index) {
            const li = document.createElement('li');
            li.textContent = `${character.name} - ${character.house} (${character.year}º año)`;
            li.addEventListener('click', function () {
                if (window.garkravall && window.garkravall.selectCharacter) {
                    window.garkravall.selectCharacter(index + 1);
                }
            });
            characterList.appendChild(li);
        });
    }

    document.querySelectorAll('.house').forEach(function (button) {
        button.addEventListener('click', function () {
            const house = button.dataset.house;
            if (window.garkravall && window.garkravall.selectHouse) {
                window.garkravall.selectHouse(house);
            }
        });
    });

    document.querySelectorAll('.spell').forEach(function (button) {
        button.addEventListener('click', function () {
            const spell = button.dataset.spell;
            if (window.garkravall && window.garkravall.requestSpell) {
                window.garkravall.requestSpell(spell);
            }
        });
    });

    return {
        update: function (payload) {
            if (payload.name) {
                hudName.textContent = payload.name;
            }
            if (typeof payload.money === 'number') {
                state.money = payload.money;
            }
            if (payload.house) {
                state.house = payload.house;
            }
            if (typeof payload.health === 'number') {
                state.health = payload.health;
            }
            if (typeof payload.maxHealth === 'number') {
                state.maxHealth = payload.maxHealth;
            }
            if (typeof payload.mana === 'number') {
                state.mana = payload.mana;
            }
            if (Array.isArray(payload.characters)) {
                state.characters = payload.characters;
                renderCharacters();
            }
            updateBars();
        }
    };
})();
