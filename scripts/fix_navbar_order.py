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
.navbar, .nav, header {
    padding-bottom: 24px !important;
    overflow: visible !important;
    position: relative;
    z-index: 500;
}
.navbar-right {
    overflow: visible !important;
    display: flex;
    align-items: center;
    gap: 12px;
}
.profile-circle-wrapper {
    position: relative;
    display: inline-flex;
    flex-direction: column;
    align-items: center;
    margin-left: 4px;
}
.profile-circle {
    width: 44px;
    height: 44px;
    border-radius: 50%;
    background: linear-gradient(135deg, #f093fb, #f5576c);
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 18px;
    font-weight: 700;
    color: #ffffff;
    cursor: pointer;
    border: 2.5px solid rgba(255, 255, 255, 0.40);
    text-decoration: none;
    transition: transform 0.2s, box-shadow 0.2s;
    text-transform: uppercase;
    line-height: 1;
    flex-shrink: 0;
    box-shadow: 0 3px 12px rgba(240, 147, 251, 0.45);
}
.profile-circle:hover {
    transform: scale(1.10);
    box-shadow: 0 6px 20px rgba(240, 147, 251, 0.60);
}
.profile-username-tag {
    position: absolute;
    top: 48px;
    left: 50%;
    transform: translateX(-50%);
    background: rgba(240, 147, 251, 0.15);
    backdrop-filter: blur(10px);
    border: 1px solid rgba(240, 147, 251, 0.30);
    border-radius: 20px;
    padding: 3px 12px;
    font-size: 11px;
    font-weight: 500;
    color: rgba(255, 255, 255, 0.90);
    white-space: nowrap;
    pointer-events: none;
    z-index: 200;
    text-align: center;
}
.theme-dark .profile-circle {
    border-color: rgba(255, 255, 255, 0.35);
    box-shadow: 0 3px 12px rgba(240, 147, 251, 0.50);
}
.theme-ocean .profile-circle {
    border-color: rgba(125, 211, 252, 0.45);
    box-shadow: 0 3px 12px rgba(240, 147, 251, 0.45);
}
.theme-forest .profile-circle {
    border-color: rgba(134, 239, 172, 0.45);
    box-shadow: 0 3px 12px rgba(240, 147, 251, 0.45);
}
"""

with open('c:/Users/Lenovo/OneDrive/Desktop/OnlineQuizSystem/WebContent/css/themes.css', 'r', encoding='utf-8') as f:
    css_content = f.read()

# Replace old profile wrapper configs safely
css_content = re.sub(r'\.profile-circle-wrapper[\s\S]*', css_to_add, css_content)
with open('c:/Users/Lenovo/OneDrive/Desktop/OnlineQuizSystem/WebContent/css/themes.css', 'w', encoding='utf-8') as f:
    f.write(css_content)

for filepath in files_to_fix:
    if not os.path.exists(filepath):
        print(f"File {filepath} not found.")
        continue
    
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    theme_btn_match = re.search(r'(<button[^>]*cycleTheme[^>]*>.*?</button>)', content, flags=re.DOTALL)
    logout_btn_match = re.search(r'(<a[^>]*LogoutServlet[^>]*>.*?</a>)', content, flags=re.DOTALL)
    
    if not theme_btn_match or not logout_btn_match:
        print("Couldn't find buttons in", filepath)
        continue

    theme_btn_html = theme_btn_match.group(1)
    logout_btn_html = logout_btn_match.group(1)
    
    new_right_nav = f'''<div class="navbar-right">
    {theme_btn_html}
    {logout_btn_html}
    <%
        String username = "";
        String initial = "U";
        if (session != null && session.getAttribute("username") != null) {{
            username = (String) session.getAttribute("username");
            if (username != null && !username.isEmpty()) {{
                initial = String.valueOf(username.charAt(0)).toUpperCase();
            }}
        }}
    %>
    <div class="profile-circle-wrapper">
        <a href="ProfileServlet" class="profile-circle" title="View Profile">
            <%= initial %>
        </a>
        <div class="profile-username-tag"><%= username %></div>
    </div>
</div>'''
    
    # Locate the old container div
    # It might be: <div style="display: flex; align-items: center; gap: 15px;">...</div>
    # Let's match from <div up to its matching </div> that contains the logout button
    # Because there might be nested divs, regex might fail on `</div>`.
    # But wait, our previous right nav was exactly one level deep EXCEPT for `.profile-circle-wrapper`!
    # A safe pattern is strictly matching the exact `display: flex` container that has `LogoutServlet`.
    
    # Another approach: find the opening div, and just replace everything inside and itself.
    nav_right_pattern = r'<div\s+[^>]*?display:\s*flex;\s*align-items:\s*center.*?<a\s+href="LogoutServlet".*?</a>\s*</div>\s*(<!--.*?-->)?'
    # Wait, the closing </div> of profile-circle-wrapper is BEFORE logout. So the last closing tag is just the `</div>` of the flex parent.
    content = re.sub(nav_right_pattern, new_right_nav, content, flags=re.DOTALL)
    
    with open(filepath, 'w', encoding='utf-8') as f:
        f.write(content)

print("Navbar fix complete.")
