var timelineScrollInterval = null;
var profileMenuDisplayed = false;

var beginTimelineScrolling = function () {
	timelineScrollInterval = setInterval(function () {
		$('.timeline-body').animate({
			left: '-=1px'
		}, 100);
	}, 150);
}

var timelinePositionWithTimecode = function (seconds) {
	return (seconds / 5) * 12;
}

$(function () {

	$('.navbar a[href]').click(function (e) {
		e.preventDefault();

		var hash = $(this).attr('href');

		$('.container').hide(0);
		$(hash).show(0);
	});


	$('.social-form .send').click(function (e) {
		var message = $('.social-form textarea').val();
		// TODO : handle select
		calliOSFunction('postMessage', [message]);
	});

	$('.nav-profile').click(function (e) {
		// e.stopPropagation();
		if (profileMenuDisplayed) {
			$('.profile-nav').animate({ bottom: '-=150px' }, 400);
			profileMenuDisplayed = false;
		} else {
			$('.profile-nav').animate({ bottom: '+=150px' }, 400);
			profileMenuDisplayed = true;
		}
	});

	// $('.profile-nav').click(function (e) {
	// 	e.stopPropagation();
	// }) ;

	// $('.container').click(function (e) {
	// 	if (profileMenuDisplayed) {
	// 		$('.profile-nav').animate({ bottom: '-=150px' }, 400);
	// 		profileMenuDisplayed = false;
	// 	} 
	// })

});