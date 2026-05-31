/* ==========================================
   TechVeda Website Interactions & Scripting
   ========================================== */

document.addEventListener('DOMContentLoaded', () => {
    initNavigation();
    initHeroCarousel();
    initCourseLibrary();
    initAISimulator();
});

/* ------------------------------------------
   1. NAVIGATION INTERACTIONS
   ------------------------------------------ */
function initNavigation() {
    const header = document.getElementById('header');
    const menuToggle = document.getElementById('menu-toggle');
    const navMenu = document.getElementById('nav-menu');
    const navLinks = document.querySelectorAll('.nav-link');
    
    // Add background class on scroll
    window.addEventListener('scroll', () => {
        if (window.scrollY > 50) {
            header.classList.add('scrolled');
        } else {
            header.classList.remove('scrolled');
        }
        
        // Highlight active link on scroll
        let currentSection = '';
        const sections = document.querySelectorAll('section');
        sections.forEach(section => {
            const sectionTop = section.offsetTop - 120;
            const sectionHeight = section.clientHeight;
            if (window.scrollY >= sectionTop && window.scrollY < sectionTop + sectionHeight) {
                currentSection = section.getAttribute('id');
            }
        });
        
        navLinks.forEach(link => {
            link.classList.remove('active');
            if (link.getAttribute('href') === `#${currentSection}`) {
                link.classList.add('active');
            }
        });
    });
    
    // Toggle Mobile Menu
    menuToggle.addEventListener('click', () => {
        navMenu.classList.toggle('active');
        menuToggle.classList.toggle('active');
    });
    
    // Close menu when clicking link
    navLinks.forEach(link => {
        link.addEventListener('click', () => {
            navMenu.classList.remove('active');
            menuToggle.classList.remove('active');
        });
    });
}

/* ------------------------------------------
   2. HERO PHONE CAROUSEL
   ------------------------------------------ */
function initHeroCarousel() {
    const screens = document.querySelectorAll('.screen-img');
    const indicators = document.querySelectorAll('.indicator');
    let currentIndex = 0;
    let carouselInterval;
    
    function showSlide(index) {
        screens.forEach(screen => screen.classList.remove('active'));
        indicators.forEach(indicator => indicator.classList.remove('active'));
        
        screens[index].classList.add('active');
        indicators[index].classList.add('active');
        currentIndex = index;
    }
    
    function startInterval() {
        carouselInterval = setInterval(() => {
            let nextIndex = (currentIndex + 1) % screens.length;
            showSlide(nextIndex);
        }, 4000);
    }
    
    function resetInterval() {
        clearInterval(carouselInterval);
        startInterval();
    }
    
    // Indicator clicks
    indicators.forEach((indicator, index) => {
        indicator.addEventListener('click', () => {
            showSlide(index);
            resetInterval();
        });
    });
    
    // Phone screen clicks
    const phoneScreen = document.querySelector('.phone-screen');
    phoneScreen.addEventListener('click', () => {
        let nextIndex = (currentIndex + 1) % screens.length;
        showSlide(nextIndex);
        resetInterval();
    });
    
    // Start carousel
    startInterval();
}

/* ------------------------------------------
   3. INTERACTIVE COURSE HUB
   ------------------------------------------ */
const coursesData = [
    // Basics Category
    {
        title: "C Programming",
        category: "basics",
        subtitle: "Foundations & core syntax",
        image: "assets/courses/c-programming.jpg",
        accent: "#3B82F6",
        accentRGB: "59, 130, 246"
    },
    // App Dev Category
    {
        title: "Dart",
        category: "app_dev",
        subtitle: "Language essentials & OOP",
        image: "assets/courses/dart.png",
        accent: "#8B5CF6",
        accentRGB: "139, 92, 246"
    },
    {
        title: "Flutter",
        category: "app_dev",
        subtitle: "UI toolkit introduction",
        image: "assets/courses/flutter.png",
        accent: "#8B5CF6",
        accentRGB: "139, 92, 246"
    },
    {
        title: "Flutter Basics",
        category: "app_dev",
        subtitle: "Widgets, state & layouts",
        image: "assets/courses/flutter1.png",
        accent: "#8B5CF6",
        accentRGB: "139, 92, 246"
    },
    {
        title: "Android",
        category: "app_dev",
        subtitle: "Java for Android apps",
        image: "assets/courses/android.jpeg",
        accent: "#8B5CF6",
        accentRGB: "139, 92, 246"
    },
    // Python Category
    {
        title: "Learn Python",
        category: "python",
        subtitle: "Core Python & scripts",
        image: "assets/courses/python.jpg",
        accent: "#06B6D4",
        accentRGB: "6, 182, 212"
    },
    {
        title: "Web Python",
        category: "python",
        subtitle: "Backend servers & REST APIs",
        image: "assets/courses/webpython.jpg",
        accent: "#06B6D4",
        accentRGB: "6, 182, 212"
    },
    // Hacking Category
    {
        title: "Python for Hackers",
        category: "hacking",
        subtitle: "Offensive scripting basics",
        image: "assets/courses/pythonHacker.jpg",
        accent: "#F87171",
        accentRGB: "248, 113, 113"
    },
    {
        title: "Ethical Hacking Roadmap",
        category: "hacking",
        subtitle: "Career tracks & credentials",
        image: "assets/courses/ethicalHacking.jpg",
        accent: "#F87171",
        accentRGB: "248, 113, 113"
    },
    {
        title: "Kali Linux Commands",
        category: "hacking",
        subtitle: "Shell terminal reference sheet",
        image: "assets/courses/kali.jpeg",
        accent: "#F87171",
        accentRGB: "248, 113, 113"
    },
    {
        title: "Learn Python (Hacking edition)",
        category: "hacking",
        subtitle: "Security scripting tools",
        image: "assets/courses/neonPython.jpeg",
        accent: "#F87171",
        accentRGB: "248, 113, 113"
    },
    // Databases Category
    {
        title: "MySQL",
        category: "database",
        subtitle: "Relational queries & tables",
        image: "assets/courses/MySQL.png",
        accent: "#10B981",
        accentRGB: "16, 185, 129"
    },
    {
        title: "MongoDB",
        category: "database",
        subtitle: "NoSQL document stores",
        image: "assets/courses/MongoDB1.jpg",
        accent: "#10B981",
        accentRGB: "16, 185, 129"
    },
    {
        title: "PostgreSQL",
        category: "database",
        subtitle: "Advanced relational setups",
        image: "assets/courses/PostgreSQL-Tutorial.png",
        accent: "#10B981",
        accentRGB: "16, 185, 129"
    },
    {
        title: "SQLite",
        category: "database",
        subtitle: "Local embedded databases",
        image: "assets/courses/sqlite.jpg",
        accent: "#10B981",
        accentRGB: "16, 185, 129"
    }
];

function initCourseLibrary() {
    const coursesGrid = document.getElementById('courses-grid');
    const searchInput = document.getElementById('course-search');
    const pills = document.querySelectorAll('#filter-pills .pill');
    
    let activeCategory = 'all';
    let searchQuery = '';
    
    function renderCourses() {
        coursesGrid.innerHTML = '';
        
        const filtered = coursesData.filter(course => {
            const matchesCategory = (activeCategory === 'all' || course.category === activeCategory);
            const matchesSearch = course.title.toLowerCase().includes(searchQuery) || 
                                  course.subtitle.toLowerCase().includes(searchQuery);
            return matchesCategory && matchesSearch;
        });
        
        if (filtered.length === 0) {
            coursesGrid.innerHTML = `
                <div class="no-results glass-card">
                    <h3>No Courses Found</h3>
                    <p>Try searching for a different keyword or topic!</p>
                </div>
            `;
            return;
        }
        
        filtered.forEach(course => {
            const card = document.createElement('div');
            card.className = 'course-card glass-card';
            card.style.setProperty('--card-accent', course.accent);
            card.style.setProperty('--accent-rgb', course.accentRGB);
            
            card.innerHTML = `
                <div class="course-image-wrapper">
                    <img src="${course.image}" alt="${course.title}" class="course-img" loading="lazy">
                </div>
                <div class="course-accent-line"></div>
                <div class="course-info">
                    <span class="course-category-tag">${course.category.replace('_', ' ')}</span>
                    <h3 class="course-card-title">${course.title}</h3>
                    <p class="course-card-subtitle">${course.subtitle}</p>
                </div>
            `;
            coursesGrid.appendChild(card);
        });
    }
    
    // Category pill clicks
    pills.forEach(pill => {
        pill.addEventListener('click', () => {
            pills.forEach(p => p.classList.remove('active'));
            pill.classList.add('active');
            activeCategory = pill.getAttribute('data-category');
            renderCourses();
        });
    });
    
    // Search input handler
    searchInput.addEventListener('input', (e) => {
        searchQuery = e.target.value.toLowerCase().trim();
        renderCourses();
    });
    
    // Initial Render
    renderCourses();
}

/* ------------------------------------------
   4. TECHVEDA AI SIMULATOR
   ------------------------------------------ */
const chatbotAnswers = {
    "explain-pointers": {
        query: "Explain pointers in C simply",
        response: `Pointers in **C** are actually extremely simple! Think of a variable as a storage box, and a **pointer** as a slip of paper containing the **street address** of that box.

Rather than copying the entire box (which takes up memory), you just pass the address. 

Here is a short explanation:
1. **Declare a pointer**: Use \`*\`
   \`\`\`c
   int age = 20;
   int *ptr = &age; // '&' gets the address of age
   \`\`\`
2. **Read the value**: Use \`*\` (called *dereferencing*)
   \`\`\`c
   printf("%d", *ptr); // Outputs 20
   \`\`\`
Pointers let you directly alter memory, build links between data, and make your code run exceptionally fast!`
    },
    "flutter-state": {
        query: "What is a Stateful vs Stateless Widget in Flutter?",
        response: `Great question! The core rule of Flutter is: **Everything is a Widget.** The difference comes down to whether the widget needs to rebuild dynamically.

Here is the quick breakdown:

| Aspect | **StatelessWidget** | **StatefulWidget** |
|---|---|---|
| **Mutability** | Immutable (cannot change) | Mutable (rebuilds dynamically) |
| **State** | No internal state. Renders once | Tracks state. Rebuilds on \`setState()\` |
| **Examples** | \`Text\`, \`Icon\`, \`Container\` | \`Checkbox\`, \`Slider\`, \`TextField\` |

**Rule of Thumb:**
- Use a **Stateless** widget if the screen elements stay exactly the same.
- Use a **Stateful** widget if the user interacts with the UI and updates values (like adding to a cart or changing themes).`
    },
    "python-comprehension": {
        query: "Show me an example of Python list comprehension",
        response: `**List comprehension** is a sleek, one-line syntax in Python to create new lists from existing ones. It replaces boring multi-line \`for\` loops!

**Normal For Loop:**
\`\`\`python
squares = []
for x in range(1, 6):
    squares.append(x**2)
# Result: [1, 4, 9, 16, 25]
\`\`\`

**List Comprehension Equivalent:**
\`\`\`python
squares = [x**2 for x in range(1, 6)]
# Result: [1, 4, 9, 16, 25]
\`\`\`

You can even add condition filters!
\`\`\`python
evens = [x for x in range(10) if x % 2 == 0]
# Result: [0, 2, 4, 6, 8]
\`\`\`
It keeps your code neat, short, and highly readable.`
    },
    "sql-injection": {
        query: "How do databases prevent SQL injection?",
        response: `**SQL Injection (SQLi)** is a web vulnerability where an attacker injects malicious SQL statements into input fields to bypass auth or steal records.

**The Threat:**
Imagine a query that concatenates inputs:
\`\`\`sql
SELECT * FROM users WHERE name = '` + "attacker' OR '1'='1" + `';
\`\`\`
This query always returns true, exposing user records!

**The Defense:**
To prevent this, modern systems use **Parameterized Queries** (also called Prepared Statements).
- Instead of pasting inputs directly into the query, developers use placeholders (\`?\`).
- The database compiles the SQL query structure *first*, and then binds the input value.
- Even if the input is \`OR '1'='1\`, it is treated strictly as a string literal, not executable SQL.

In Flutter, local SQLite packages and Cloud Firestore queries block SQL injection automatically!`
    }
};

function initAISimulator() {
    const chatMessages = document.getElementById('chat-messages');
    const chatInput = document.getElementById('chat-input');
    const chatForm = document.getElementById('chat-form');
    const typingIndicator = document.getElementById('typing-indicator');
    const chips = document.querySelectorAll('.prompt-chips .chip');
    
    let isTyping = false;
    
    function scrollChat() {
        chatMessages.scrollTop = chatMessages.scrollHeight;
    }
    
    function formatMarkdown(text) {
        // Simple Markdown parser for styling bold & code in simulator
        return text
            .replace(/\*\*(.*?)\*\*/g, '<strong>$1</strong>')
            .replace(/`([^`]+)`/g, '<code class="inline-code">$1</code>')
            .replace(/```(\w+)?\n([\s\S]+?)```/g, '<pre><code class="block-code">$2</code></pre>')
            .replace(/\n/g, '<br>');
    }
    
    function addMessage(text, sender) {
        const msgDiv = document.createElement('div');
        msgDiv.className = `message ${sender}`;
        
        const time = new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
        
        msgDiv.innerHTML = `
            <div class="message-text">${formatMarkdown(text)}</div>
            <span class="message-time">${time}</span>
        `;
        
        chatMessages.appendChild(msgDiv);
        scrollChat();
    }
    
    function simulateBotResponse(promptKey) {
        if (isTyping) return;
        
        isTyping = true;
        typingIndicator.classList.add('active');
        scrollChat();
        
        const data = chatbotAnswers[promptKey];
        const responseText = data ? data.response : `Hi there! That's a great question.

In the **TechVeda** mobile app, you can ask me any custom coding question, database query, or security concept, and I will generate a fully custom answer in real-time powered by **Gemini Flash**.

Feel free to try any of the predefined interactive chips on the left for a fully formatted syllabus breakdown!`;
        
        setTimeout(() => {
            typingIndicator.classList.remove('active');
            isTyping = false;
            addMessage(responseText, 'received');
        }, 1500);
    }
    
    // Chip Clicks
    chips.forEach(chip => {
        chip.addEventListener('click', () => {
            if (isTyping) return;
            const promptKey = chip.getAttribute('data-prompt');
            const question = chatbotAnswers[promptKey].query;
            
            addMessage(question, 'sent');
            simulateBotResponse(promptKey);
        });
    });
    
    // User custom submit
    chatForm.addEventListener('submit', (e) => {
        e.preventDefault();
        if (isTyping) return;
        
        const userText = chatInput.value.trim();
        if (!userText) return;
        
        chatInput.value = '';
        addMessage(userText, 'sent');
        
        // Check if query matches any chip keywords, otherwise general demo reply
        let matchedKey = null;
        if (userText.toLowerCase().includes('pointer') || userText.toLowerCase().includes(' c ')) {
            matchedKey = 'explain-pointers';
        } else if (userText.toLowerCase().includes('flutter') || userText.toLowerCase().includes('widget')) {
            matchedKey = 'flutter-state';
        } else if (userText.toLowerCase().includes('python') && userText.toLowerCase().includes('comprehension')) {
            matchedKey = 'python-comprehension';
        } else if (userText.toLowerCase().includes('injection') || userText.toLowerCase().includes('sql')) {
            matchedKey = 'sql-injection';
        }
        
        simulateBotResponse(matchedKey);
    });
}
