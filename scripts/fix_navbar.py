import os
import re

files_to_fix = [
    'c:/Users/Lenovo/OneDrive/Desktop/OnlineQuizSystem/WebContent/dashboard.jsp',
    'c:/Users/Lenovo/OneDrive/Desktop/OnlineQuizSystem/WebContent/quiz.jsp',
    'c:/Users/Lenovo/OneDrive/Desktop/OnlineQuizSystem/WebContent/result.jsp',
    'c:/Users/Lenovo/OneDrive/Desktop/OnlineQuizSystem/WebContent/notes-core.jsp',
    'c:/Users/Lenovo/OneDrive/Desktop/OnlineQuizSystem/WebContent/notes-oop.jsp',
    'c:/Users/Lenovo/OneDrive/Desktop/OnlineQuizSystem/WebContent/notes-advanced.jsp',
    'c:/Users/Lenovo/OneDrive/Desktop/OnlineQuizSystem/WebContent/notes-misc.jsp',
    'c:/Users/Lenovo/OneDrive/Desktop/OnlineQuizSystem/WebContent/flashcards.jsp',
    'c:/Users/Lenovo/OneDrive/Desktop/OnlineQuizSystem/WebContent/profile.jsp'
]

css_to_add = """
.profile-circle-wrapper {
    position: relative;
    display: inline-block;
    margin-right: 8px;
}

.profile-circle {
    width: 42px;
    height: 42px;
    border-radius: 50%;
    background: linear-gradient(135deg, #667eea, #764ba2);
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 16px;
    font-weight: 600;
    color: white;
    cursor: pointer;
    border: 2px solid rgba(255,255,255,0.25);
    transition: transform 0.2s;
    text-decoration: none;
}

.profile-circle:hover {
    transform: scale(1.08);
    box-shadow: 0 4px 15px rgba(102,126,234,0.5);
}

.profile-username-tag {
    position: absolute;
    top: 46px;
    left: 8px;
    background: rgba(255,255,255,0.10);
    backdrop-filter: blur(8px);
    border: 1px solid rgba(255,255,255,0.15);
    border-radius: 20px;
    padding: 3px 10px;
    font-size: 11px;
    color: var(--text-color, rgba(0,0,0,0.85));
    white-space: nowrap;
    pointer-events: none;
    z-index: 100;
}
/* Ensure dark theme readable */
[data-theme='dark'] .profile-username-tag {
    color: rgba(255,255,255,0.85);
}
"""

with open('c:/Users/Lenovo/OneDrive/Desktop/OnlineQuizSystem/WebContent/css/themes.css', 'a', encoding='utf-8') as f:
    f.write("\n" + css_to_add)

profile_html_replacement = """<div class="profile-circle-wrapper">
    <a href="ProfileServlet" class="profile-circle">
        <%= session.getAttribute("username") != null ? ((String)session.getAttribute("username")).substring(0,1).toUpperCase() : "U" %>
    </a>
    <div class="profile-username-tag"><%= session.getAttribute("username") %></div>
</div>"""

for filepath in files_to_fix:
    if not os.path.exists(filepath):
        print("Not found:", filepath)
        continue
    
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    # 1. Substitute the old wrapper <a> around ProfileServlet
    # We will look for <a href="ProfileServlet"...> ... </a>
    # The regex needs to handle multiline.
    pattern = r'<a[^>]*href="ProfileServlet"[^>]*>.*?</a>'
    content = re.sub(pattern, profile_html_replacement, content, flags=re.DOTALL)
    
    # 2. Remove the welcome text span
    # Could be: <span style="...">Welcome, <%= session.getAttribute("username") %>!</span>
    # Or      : <span class="...">Welcome, ...</span>
    # Or      : <span>Welcome, ...</span>
    welcome_pattern = r'<span[^>]*>\s*Welcome,\s*(<%=.*?%>|\$\{.*?\})\s*!\s*</span>'
    content = re.sub(welcome_pattern, '', content, flags=re.DOTALL)

    # Alternative if it's text outside <span>:
    text_pattern = r'Welcome,\s*(<%=.*?%>|\$\{.*?\})\s*!'
    content = re.sub(text_pattern, '', content, flags=re.DOTALL)
    
    with open(filepath, 'w', encoding='utf-8') as f:
        f.write(content)

print("done")
