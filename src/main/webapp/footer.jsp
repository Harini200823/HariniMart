<!-- Floating Chat Widget -->
<div id="chat-widget-container" style="position: fixed; bottom: 20px; right: 20px; z-index: 1000; font-family: Arial, sans-serif;">
    <button id="chat-toggle-btn" onclick="toggleChat()" style="background-color: #0d6efd; color: white; border: none; border-radius: 50px; padding: 12px 20px; cursor: pointer; box-shadow: 0 4px 6px rgba(0,0,0,0.1);">💬 HariniMart AI</button>
    
    <div id="chat-box" style="display: none; width: 320px; height: 400px; background: white; border-radius: 8px; box-shadow: 0 4px 12px rgba(0,0,0,0.15); flex-direction: column; overflow: hidden; margin-bottom: 10px;">
        <div style="background: #0d6efd; color: white; padding: 10px; font-weight: bold; display: flex; justify-content: space-between; align-items: center;">
            <span>HariniMart Assistant</span>
            <button onclick="toggleChat()" style="background: none; border: none; color: white; cursor: pointer; font-weight: bold; font-size: 16px;">✕</button>
        </div>
        <div id="chat-messages" style="flex: 1; padding: 10px; overflow-y: auto; font-size: 14px; background: #f8f9fa;">
            <div style="margin-bottom: 8px; background: #e2e3e5; padding: 8px; border-radius: 6px;">Hello! Ask me about HariniMart products, shipping, or returns.</div>
        </div>
        <div style="padding: 10px; border-top: 1px solid #ddd; display: flex;">
            <input type="text" id="chat-input" placeholder="Type a question..." style="flex: 1; padding: 8px; border: 1px solid #ccc; border-radius: 4px; outline: none;" onkeypress="handleKeyPress(event)">
            <button onclick="sendMessage()" style="background: #0d6efd; color: white; border: none; padding: 8px 12px; margin-left: 5px; border-radius: 4px; cursor: pointer;">Send</button>
        </div>
    </div>
</div>

<script>
    function toggleChat() {
        const box = document.getElementById('chat-box');
        box.style.display = box.style.display === 'none' ? 'flex' : 'none';
    }

    function handleKeyPress(e) {
        if (e.key === 'Enter') sendMessage();
    }

    async function sendMessage() {
        const input = document.getElementById('chat-input');
        const messages = document.getElementById('chat-messages');
        const text = input.value.trim();
        if (!text) return;

        // Append User Message
        messages.innerHTML += `<div style="margin-bottom: 8px; text-align: right;"><span style="background: #0d6efd; color: white; padding: 8px; border-radius: 6px; display: inline-block;">${text}</span></div>`;
        input.value = '';
        messages.scrollTop = messages.scrollHeight;

        try {
            const response = await fetch('${pageContext.request.contextPath}/api/chat', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ message: text })
            });
            const result = await response.json();
            
            let reply = "Sorry, I couldn't process that.";
            if (result.success && result.data) {
                reply = result.data.reply;
            }

            // Append Bot Reply
            messages.innerHTML += `<div style="margin-bottom: 8px;"><span style="background: #e2e3e5; color: #333; padding: 8px; border-radius: 6px; display: inline-block;">${reply}</span></div>`;
        } catch (err) {
            messages.innerHTML += `<div style="margin-bottom: 8px;"><span style="background: #f8d7da; color: #721c24; padding: 8px; border-radius: 6px; display: inline-block;">Error connecting to chatbot.</span></div>`;
        }
        messages.scrollTop = messages.scrollHeight;
    }
</script>