var movieDuration = 0;
var isPaused = true;

$(function () {

	$('.play, .pause')
		.bind('touchstart', function (e) {
			e.preventDefault();
			isPaused = !isPaused;

			if (!isTimelineScrolling) {
				$('.play').hide(0);
				$('.pause').show(0);
				beginTimelineScrolling();
			} else {
				$('.pause').hide(0);
				$('.play').show(0);
				stopTimelineScrolling();
			}

			calliOSFunction('togglePlayPause', []);
		});

})