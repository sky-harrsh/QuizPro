import re

files = [
    'c:/Users/Lenovo/OneDrive/Desktop/OnlineQuizSystem/WebContent/notes-core.jsp',
    'c:/Users/Lenovo/OneDrive/Desktop/OnlineQuizSystem/WebContent/notes-advanced.jsp'
]

scrollbar_js = """
<button id="scrollTopBtn" onclick="window.scrollTo({top:0,behavior:'smooth'})"
    style="display:none; position:fixed; bottom:32px; right:32px;
           width:48px; height:48px; border-radius:50%;
           background:linear-gradient(135deg,#667eea,#764ba2);
           color:white; font-size:20px; border:none; cursor:pointer;
           box-shadow:0 4px 15px rgba(102,126,234,0.4); z-index:999;">
    &#8679;
</button>

<script>
window.addEventListener('scroll', function() {
    const btn = document.getElementById('scrollTopBtn');
    if (window.scrollY > 300) {
        btn.style.display = 'block';
    } else {
        btn.style.display = 'none';
    }
});
</script>

<div id="scrollProgress"
    style="position:fixed; top:0; left:0; height:3px; width:0%;
           background:linear-gradient(90deg,#667eea,#764ba2);
           z-index:9999; transition:width 0.1s;">
</div>

<script>
window.addEventListener('scroll', function() {
    const winScroll = document.documentElement.scrollTop || document.body.scrollTop;
    const height = document.documentElement.scrollHeight
                 - document.documentElement.clientHeight;
    const scrolled = height > 0 ? (winScroll / height) * 100 : 0;
    const prog = document.getElementById('scrollProgress');
    if(prog) prog.style.width = scrolled + '%';
});
</script>
"""

new_css = """
.chapters-container {
    display: flex;
    flex-direction: column;        /* vertical stack */
    gap: 32px;                     /* space between chapters */
    max-width: 900px;
    margin: 0 auto;
    padding: 24px 20px 60px 20px;
    overflow-x: hidden;            /* no horizontal scroll */
    overflow-y: visible;           /* normal vertical scroll */
}
.chapter-card {
    width: 100%;                   /* full width */
    min-width: 0;                  /* prevent overflow */
    background: var(--bg-card, white);
    color: var(--text-color, #1e293b);
    border-radius: 16px;
    padding: 32px;
    box-shadow: 0 2px 12px rgba(0,0,0,0.08);
    border: 1px solid rgba(0,0,0,0.06);
    box-sizing: border-box;
}
body {
    overflow-x: hidden;
    overflow-y: auto;              /* normal vertical scroll */
}
.notes-wrapper {
    overflow-x: hidden;
    overflow-y: auto;
}
"""

for file in files:
    with open(file, 'r', encoding='utf-8') as f:
        content = f.read()
        
    # Replace the old CSS
    content = re.sub(r'\.notes-container\s*\{[^}]*\}', '', content)
    content = re.sub(r'\.chapter-card\s*\{[^}]*\}', '', content)
    
    # Inject new CSS
    content = content.replace('</style>', new_css + '\n</style>')
    
    # Replace notes-container with chapters-container
    content = content.replace('<div class="notes-container">', '<div class="chapters-container">')
    
    # Append scrollbar features before closing body
    if 'id="scrollTopBtn"' not in content:
        content = content.replace('</body>', scrollbar_js + '\n</body>')
        
    with open(file, 'w', encoding='utf-8') as f:
        f.write(content)
        
print("Transformation finished.")
