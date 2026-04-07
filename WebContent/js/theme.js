const THEMES = ['theme-dark', 'theme-ocean', 'theme-forest'];
const THEME_NAMES = ['🎨 Dark', '🎨 Ocean', '🎨 Forest'];

function applyTheme(index) {
    document.body.classList.remove(...THEMES);
    document.body.classList.add(THEMES[index]);
    let btn = document.getElementById('theme-btn');
    if (btn) btn.innerText = THEME_NAMES[index];
    localStorage.setItem('quizAppTheme', index);
}

function initTheme() {
    let saved = localStorage.getItem('quizAppTheme');
    let idx = saved ? parseInt(saved) : 0;
    applyTheme(idx);
}

function cycleTheme() {
    let saved = localStorage.getItem('quizAppTheme');
    let idx = saved ? parseInt(saved) : 0;
    idx = (idx + 1) % 3;
    applyTheme(idx);
}

// Execute immediately to prevent flash
initTheme();
document.addEventListener('DOMContentLoaded', initTheme);
