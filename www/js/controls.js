var movieDuration = 0;
var isPaused = true;

$(function () {

	$('.play')
		.bind('touchstart', function (e) {
			e.preventDefault();
			isPaused = !isPaused;
			calliOSFunction('togglePlayPause', []);

			if (!isPaused) {
				$('.video-controls #play').css('background-image', 'url(../images/pause.png);');
				beginTimelineScrolling();
			} else {
				$('.video-controls #play').css('background-image', 'url(../images/play.png);');
				stopTimelineScrolling();
			}
		});

})