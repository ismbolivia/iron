
document.addEventListener('turbolinks:load', function () {
    var fullscreenBtn = document.getElementById('fullscreen-btn');
    if (fullscreenBtn) {
        fullscreenBtn.addEventListener('click', function () {
            var elem = document.querySelector(".main");
            if (!document.fullscreenElement) {
                if (elem.requestFullscreen) {
                    elem.requestFullscreen();
                } else if (elem.webkitRequestFullscreen) { /* Safari */
                    elem.webkitRequestFullscreen();
                } else if (elem.msRequestFullscreen) { /* IE11 */
                    elem.msRequestFullscreen();
                }
                fullscreenBtn.innerHTML = '<i class="fa fa-compress"></i>';
            } else {
                if (document.exitFullscreen) {
                    document.exitFullscreen();
                } else if (document.webkitExitFullscreen) { /* Safari */
                    document.webkitExitFullscreen();
                } else if (document.msExitFullscreen) { /* IE11 */
                    document.msExitFullscreen();
                }
                fullscreenBtn.innerHTML = '<i class="fa fa-expand"></i>';
            }
        });
    }
});

// Also listen for fullscreen change events to update the icon if the user presses ESC
function exitHandler() {
    var fullscreenBtn = document.getElementById('fullscreen-btn');
    if (fullscreenBtn) {
        if (!document.fullscreenElement && !document.webkitIsFullScreen && !document.mozFullScreen && !document.msFullscreenElement) {
            fullscreenBtn.innerHTML = '<i class="fa fa-expand"></i>';
        } else {
            fullscreenBtn.innerHTML = '<i class="fa fa-compress"></i>';
        }
    }
}

document.addEventListener('fullscreenchange', exitHandler);
document.addEventListener('webkitfullscreenchange', exitHandler);
document.addEventListener('mozfullscreenchange', exitHandler);
document.addEventListener('MSFullscreenChange', exitHandler);
