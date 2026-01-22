// DISCLAIMER: This script automates actions on Facebook which may violate their Terms of Service.
// Use at your own risk. Aggressive use may result in temporary or permanent account restrictions.
// This is provided for educational purposes only.

// Enhanced with fingerprint masking techniques:
// - Randomized delays to simulate human-like timing variations.
// - Randomized order of processing friends to avoid sequential patterns.
// - Simulated mouse movements and clicks for more natural interaction (using synthetic events).
// - User-agent spoofing (limited effect in console, but added for completeness).
// - Error handling with retries and backoffs to mimic user behavior.

// Note: True browser fingerprint masking typically requires extensions or headless browsers (e.g., Puppeteer with plugins).
// In a console snippet, we can only approximate behavioral masking to reduce detection risks.

const KEEP_NAMES = [
    // checked against an "include" of the full text of a person's full name,
    // so just putting last names is the best bet here
]

const DRY_RUN = false

// Helper to generate random delay (ms) in a human-like range (e.g., 200-800ms)
const randomDelay = (min = 200, max = 800) => Math.floor(Math.random() * (max - min + 1)) + min;

// Shuffle array to randomize order
const shuffleArray = (array) => {
    for (let i = array.length - 1; i > 0; i--) {
        const j = Math.floor(Math.random() * (i + 1));
        [array[i], array[j]] = [array[j], array[i]];
    }
    return array;
}

// Simulate mouse movement to an element (basic approximation)
const simulateMouseMove = (element) => {
    const rect = element.getBoundingClientRect();
    const event = new MouseEvent('mousemove', {
        clientX: rect.left + Math.random() * rect.width,
        clientY: rect.top + Math.random() * rect.height,
        bubbles: true,
        cancelable: true
    });
    document.dispatchEvent(event);
}

// Simulate human click with event dispatch
const simulateClick = (element) => {
    simulateMouseMove(element);
    const event = new MouseEvent('click', { bubbles: true, cancelable: true });
    element.dispatchEvent(event);
}

const unfriendAll = async () => {
    console.log('Starting new unfriend group...');
    return new Promise(async resolve => {
        let listedFriends = Array.from(document.querySelectorAll("div[aria-label=\"More\"]"));
        listedFriends = shuffleArray(listedFriends); // Randomize order
        for (let i = 0; i < listedFriends.length; i++) {
            const person = listedFriends[i];
            const nameContainer = person.parentElement.parentElement.parentElement.parentElement;
            const name = nameContainer.innerText.split("\n")[0];
            if (!KEEP_NAMES.some(n => name.includes(n))) {
                console.log(`%cDeleting ${name}`, "color:red");
                await unfriend(person);
            }
            // Occasional longer pause every few actions to simulate breaks
            if (i % 5 === 0 && i !== 0) {
                await new Promise(res => setTimeout(res, randomDelay(1000, 3000)));
            }
        }
        resolve();
    });
}

async function unfriend(person) {
    if (DRY_RUN) return;
    let attempts = 0;
    while (attempts < 3) { // Retry logic with backoff
        try {
            simulateClick(person);
            await new Promise(res => setTimeout(res, randomDelay()));
            await clickUnfriend();
            await new Promise(res => setTimeout(res, randomDelay()));
            await confirmUnfriend();
            await new Promise(res => setTimeout(res, randomDelay()));
            return;
        } catch (error) {
            console.error(`Error unfriending, retrying... (${attempts + 1})`);
            attempts++;
            await new Promise(res => setTimeout(res, randomDelay(500, 2000) * attempts)); // Exponential backoff
        }
    }
    console.error('Failed after retries.');
}

async function clickUnfriend() {
    const menu = document.querySelector("div[role=menu]");
    if (!menu) throw new Error('Menu not found');
    const menuItems = menu.querySelectorAll("div[role=menuitem]");
    const unfriendOption = menuItems[menuItems.length - 1];
    simulateClick(unfriendOption);
}

async function confirmUnfriend() {
    const confirm = document.querySelector("div[aria-label=Confirm]");
    if (!confirm) throw new Error('Confirm button not found');
    simulateClick(confirm);
}

const main = async () => {
    // Spoof user-agent (note: this doesn't change the actual UA, but can be used in fetches if needed; limited in console)
    Object.defineProperty(navigator, 'userAgent', {
        value: 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
        writable: false
    });
    await unfriendAll();
    if (!DRY_RUN) {
        // Random wait before reload to avoid pattern
        await new Promise(res => setTimeout(res, randomDelay(1000, 5000)));
        location.reload();
    }
}

main();