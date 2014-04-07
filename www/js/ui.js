var timelineScrollInterval = null;
var isTimelineScrolling = false;
var profileMenuDisplayed = false;
var movieDuration;
var pX, pY;
var displayingDocumentation = false;

var beginTimelineScrolling = function () {
	timelineScrollInterval = setInterval(function () {
		$('.timeline-body, .timeline .cursor').animate({
			left: '-=0.5px'
		}, 500);
	}, 1500);

	isTimelineScrolling = true;
}

var stopTimelineScrolling = function () {
	clearInterval(timelineScrollInterval);
	isTimelineScrolling = false;
}

var timelinePositionWithTimecode = function (seconds) {
	return (seconds * 87) / movieDuration;
};

var timelineWidthFromDuration = function (duration) {
	return 87 * duration / 900; // container width * total duration / seconds in 15 minutes
};

var addNoticeOnTimeline = function (timecode, category_nicename) {
	var offset = timelinePositionWithTimecode(timecode);
	var notifEl = $('<div>')
			.addClass('timeline-notice')
			.addClass('timeline-notice-'+category_nicename)
			.css('left', offset+'%');
	$('.timeline-body').append(notifEl);
	$('.timeline .cursor').animate({ left: notifEl.offset().left }, 300);
	console.log('Notif element added at timecode '+timecode+' (offset left : '+offset+'%)');
}

var slideToDocumentation = function () {
	// $('.timeline-last-notice').animate({
	// 	height: 250
	// }, 500);
	displayingDocumentation = true;
};

$(function () {

	movieDuration = 8600;

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
		e.stopPropagation();
		if (profileMenuDisplayed) {
			$('.profile-nav').animate({ bottom: '-=150px' }, 400);
			profileMenuDisplayed = false;
			calliOSFunction('profileMenuHidden', []);
		} else {
			$('.profile-nav').animate({ bottom: '+=150px' }, 400);
			profileMenuDisplayed = true;
			calliOSFunction('profileMenuDisplayed', []);
		}
	});

	$('.profile-nav').click(function (e) {
		e.stopPropagation();
	}) ;

	$('.container').click(function (e) {
		if (profileMenuDisplayed) {
			$('.profile-nav').animate({ bottom: '-=150px' }, 400);
			profileMenuDisplayed = false;
		} 
	})

	$('.timeline-body').css('width', timelineWidthFromDuration(movieDuration)+'%');

	$('.navbar-tabs a').bind('touchstart', function (e) {
		$('.navbar-tabs a').removeClass('active');
		$(this).addClass('active');
	});

	$('.view-grid').click(function (e) {
		$('.view-line-container').hide(0);
		$('.view-grid-container').show(0);
	});

	$('.view-line').click(function (e) {
		$('.view-grid-container').hide(0);
		$('.view-line-container').show(0);
	});


	$('.timeline-last-notice')
		.bind('touchstart', function (e) {
			e.preventDefault();
			pX = e.originalEvent.touches[0].pageX;
			pY = e.originalEvent.touches[0].pageY;
		})
		.bind('touchmove', function (e) {
			e.preventDefault();
			x = e.originalEvent.touches[0].pageX;
			y = e.originalEvent.touches[0].pageY;

			console.log(x, pX, y, pY);

			// touch slide bottom
			if (pY - y > 100 && !displayingDocumentation) {
				slideToDocumentation();
			}
		});

});