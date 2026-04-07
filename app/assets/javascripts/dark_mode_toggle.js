
document.addEventListener('turbolinks:load', function () {
    var darkModeBtn = document.getElementById('dark-mode-btn');
    var body = document.body;

    // Helper function to update the button icon
    function updateIcon(isDark) {
        if (!darkModeBtn) return;
        if (isDark) {
            darkModeBtn.innerHTML = '<i class="fa fa-sun-o"></i>';
        } else {
            darkModeBtn.innerHTML = '<i class="fa fa-moon-o"></i>';
        }
    }

    // Check for saved preference
    var savedTheme = localStorage.getItem('theme');
    if (savedTheme === 'dark') {
        body.classList.add('dark-mode');
        updateIcon(true);
    } else {
        updateIcon(false);
    }

    if (darkModeBtn) {
        darkModeBtn.addEventListener('click', function () {
            body.classList.toggle('dark-mode');

            // Check if dark mode is now active
            if (body.classList.contains('dark-mode')) {
                localStorage.setItem('theme', 'dark');
                updateIcon(true);
            } else {
                localStorage.setItem('theme', 'light');
                updateIcon(false);
            }
        });
    }
});
