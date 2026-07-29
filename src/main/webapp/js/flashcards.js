let cards = [];
let filtered = [];
let currentIndex = 0;
let knownCards = new Set();
let isFlipped = false;
let sessionStartTime = Date.now();
let reviewTimerInterval;

document.addEventListener("DOMContentLoaded", () => {
    loadCards('all');
    startTimer();
});

function loadCards(category) {
    document.getElementById("fc-loading").style.display = "block";
    document.querySelector(".flashcard-scene").style.display = "none";

    fetch('FlashcardServlet?category=' + category)
        .then(response => response.json())
        .then(data => {
            if (data.error === "unauthorized") {
                window.location.href = "login.jsp";
                return;
            }
            cards = data;
            filterCategory(category);
            document.getElementById("fc-loading").style.display = "none";
            document.querySelector(".flashcard-scene").style.display = "block";
        })
        .catch(err => {
            console.error(err);
            document.getElementById("fc-loading").innerText = "Error loading flashcards.";
        });
}

function renderCard() {
    if (filtered.length === 0) {
        document.querySelector(".flashcard-scene").style.display = "none";
        document.getElementById("fc-loading").style.display = "block";
        document.getElementById("fc-loading").innerText = "No cards found for this category.";
        return;
    }

    const card = filtered[currentIndex];
    isFlipped = false;
    document.querySelector('.flashcard').classList.remove('flipped');

    // Front update
    let badgeClass = "badge-misc";
    if (card.category === 'core') badgeClass = "badge-core";
    if (card.category === 'oop') badgeClass = "badge-oop";
    if (card.category === 'advanced') badgeClass = "badge-advanced";

    document.getElementById("fc-badge").className = "flashcard-badge " + badgeClass;
    document.getElementById("fc-badge").innerText = card.category;
    document.getElementById("fc-number").innerText = (currentIndex + 1) + " / " + filtered.length;

    // Extract code snippet if present inside <pre>
    let qText = card.question;
    let codeStr = "";
    if (qText.includes("<pre>")) {
        let parts = qText.split("<pre>");
        qText = parts[0];
        let codeClose = parts[1].indexOf("</pre>");
        codeStr = parts[1].substring(0, codeClose);
    }

    document.getElementById("fc-question").innerText = qText;
    const codeEl = document.getElementById("fc-code");
    if (codeStr.trim().length > 0) {
        codeEl.style.display = "block";
        codeEl.innerText = codeStr.trim().replace(/<br>/g, "\n");
    } else {
        codeEl.style.display = "none";
    }

    // Back update
    document.getElementById("fc-answer").innerText = card.correctAnswer;
    const optionsHtml = [card.option1, card.option2, card.option3, card.option4].map(opt => {
        let cls = opt === card.correctAnswer ? "flashcard-option correct" : "flashcard-option";
        return `<div class="${cls}">${opt}</div>`;
    }).join("");
    document.getElementById("fc-options").innerHTML = optionsHtml;

    // Explanation
    document.getElementById("fc-explanation").innerText = "Explanation: This is a fundamental Java concept. Keep practicing to memorize the syntax and rules.";

    // Progress
    let ptg = ((currentIndex + 1) / filtered.length) * 100;
    document.getElementById("fc-progress-fill").style.width = ptg + "%";
    document.getElementById("fc-progress-text").innerText = `Card ${currentIndex + 1} of ${filtered.length}`;

    // Buttons
    document.getElementById("btn-prev").disabled = (currentIndex === 0);
}

function flipCard() {
    if (filtered.length === 0) return;
    isFlipped = !isFlipped;
    document.querySelector('.flashcard').classList.toggle('flipped');
}

function nextCard() {
    if (currentIndex < filtered.length - 1) {
        currentIndex++;
        renderCard();
    } else {
        showCompletionScreen();
    }
}

function prevCard() {
    if (currentIndex > 0) {
        currentIndex--;
        renderCard();
    }
}

function markKnown() {
    knownCards.add(currentIndex);
    document.querySelector('.flashcard-scene').classList.add('known-pulse');
    setTimeout(() => {
        document.querySelector('.flashcard-scene').classList.remove('known-pulse');
        nextCard();
    }, 400);
}

function shuffleCards() {
    for (let i = filtered.length - 1; i > 0; i--) {
        const j = Math.floor(Math.random() * (i + 1));
        [filtered[i], filtered[j]] = [filtered[j], filtered[i]];
    }
    currentIndex = 0;
    knownCards.clear();
    renderCard();
}

function filterCategory(cat) {
    if (cat === 'all') {
        filtered = [...cards];
    } else {
        filtered = cards.filter(c => c.category === cat);
    }
    currentIndex = 0;
    knownCards.clear();
    renderCard();
}

// Global Category Select
function onCategoryChange() {
    let val = document.getElementById("cat-select").value;
    filterCategory(val);
}

function showCompletionScreen() {
    clearInterval(reviewTimerInterval);
    document.getElementById("completion-overlay").classList.add("active");
    document.getElementById("c-total").innerText = filtered.length;
    document.getElementById("c-known").innerText = knownCards.size;
    document.getElementById("c-unknown").innerText = filtered.length - knownCards.size;
    let acc = filtered.length > 0 ? Math.round((knownCards.size / filtered.length) * 100) : 0;
    document.getElementById("c-accuracy").innerText = acc + "%";

    if (acc >= 70 && window.confetti) {
        confetti({ particleCount: 150, spread: 80, origin: { y: 0.6 } });
    }

    // Set Quiz Link
    let cat = document.getElementById("cat-select").value;
    document.getElementById("c-quiz-link").href = "QuizServlet?category=" + cat;
}

function reviewUnknown() {
    if (knownCards.size === filtered.length) {
        alert("You know all the cards!");
        return;
    }
    filtered = filtered.filter((_, idx) => !knownCards.has(idx));
    currentIndex = 0;
    knownCards.clear();
    document.getElementById("completion-overlay").classList.remove("active");
    startTimer();
    renderCard();
}

function restartSession() {
    document.getElementById("completion-overlay").classList.remove("active");
    startTimer();
    shuffleCards();
}

function toggleStats() {
    document.getElementById("stats-panel").classList.toggle("open");
    if (document.getElementById("stats-panel").classList.contains("open")) {
        updateStatsView();
    }
}

function startTimer() {
    sessionStartTime = Date.now();
    reviewTimerInterval = setInterval(() => {
        let diff = Math.floor((Date.now() - sessionStartTime) / 1000);
        let m = Math.floor(diff / 60).toString().padStart(2, '0');
        let s = (diff % 60).toString().padStart(2, '0');
        let el = document.getElementById("session-time");
        if (el) el.innerText = m + ":" + s;
    }, 1000);
}

function updateStatsView() {
    let total = filtered.length;
    let known = knownCards.size;
    let pct = total > 0 ? Math.round((known / total) * 100) : 0;

    document.getElementById("stats-donut").style.setProperty('--p', pct + '%');
    document.getElementById("stats-donut-text").innerText = pct + '%';
    document.getElementById("stats-known").innerText = known;
    document.getElementById("stats-unknown").innerText = total - known;

    let cats = {};
    filtered.forEach(c => cats[c.category] = (cats[c.category] || 0) + 1);
    document.getElementById("stats-breakdown").innerHTML = Object.keys(cats).map(k => `<div>${k}: ${cats[k]}</div>`).join("");
}

// Diff dot rating purely visual logic
function rateDifficulty(level) {
    for (let i = 1; i <= 5; i++) {
        let el = document.getElementById("diff-dot-" + i);
        if (i <= level) el.classList.add("active");
        else el.classList.remove("active");
    }
}

document.addEventListener('keydown', (e) => {
    // Ignore if input is focused, though we have none on this page, good practice
    if (document.activeElement.tagName === 'INPUT' || document.activeElement.tagName === 'TEXTAREA') return;

    if (e.key === 'ArrowRight') nextCard();
    if (e.key === 'ArrowLeft') prevCard();
    if (e.key === ' ') {
        e.preventDefault();
        flipCard();
    }
    if (e.key === 'Enter') markKnown();
});
