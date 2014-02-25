$(function () {

	$('#forward')
		.bind('touchstart', function (e) {
			e.preventDefault();
			calliOSFunction('toggleFastForward', []);
		}).bind('touchend', function () {
			calliOSFunction('toggleFastForward', []);
		});

	$('#rewind')
		.bind('touchstart', function (e) {
			e.preventDefault();
			calliOSFunction('toggleFastRewind', []);
		}).bind('touchend', function () {
			calliOSFunction('toggleFastRewind', []);
		});

	$('#play')
		.bind('touchstart', function (e) {
			e.preventDefault();
			calliOSFunction('togglePlayPause', []);
		});
})