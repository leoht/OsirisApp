var timelineScrollInterval;
var isTimelineScrolling = false;
var isTimelineSliding = false;
var profileMenuDisplayed = false;
var movieDuration;
var pX, pY, timelineStartX, timelineStartY;
var timelineSlidingEl;
var timelineStartLeft;
var displayingDocumentation = false;

var beginTimelineScrolling = function () {
	window.timelineScrollInterval = setInterval(function () {

		if (FAST_FORWARD || FAST_REWIND) {
			dT = '3.0';
			dir = FAST_FORWARD ? '-' : '+';
			console.log('yo')
		} else {
			dT = '0.4';
			dir = '-';
		}

		if (!isTimelineScrolling) return;
		$('.timeline-body, .timeline .cursor').animate({
			left: dir+'='+dT+'px'
		}, 0);
	}, 500);

	isTimelineScrolling = true;
}

var stopTimelineScrolling = function () {
	$('.timeline-body, .timeline .cursor').stop();
	window.clearInterval(window.timelineScrollInterval);
	isTimelineScrolling = false;
}

var timelinePositionWithTimecode = function (seconds) {
	return ((seconds * 87) / movieDuration) - 0.1;
};

var timelineOffsetWithTimecode = function (seconds) {
	return (- timelinePositionWithTimecode(seconds)) + 95;
};

var timelineWidthFromDuration = function (duration) {
	return 87 * duration / 500; // container width * total duration / seconds in 15 minutes
};

var addNoticeOnTimeline = function (timecode, category_nicename) {
	$('.timeline-notice').css('opacity', 0.7);
	var offset = timelinePositionWithTimecode(timecode);
	var notifEl = $('<div>')
			.addClass('timeline-notice')
			.addClass('timeline-notice-'+category_nicename)
			.css('left', offset+'%');
	$('.timeline-body').append(notifEl);
	$('.timeline .cursor').animate({ left: notifEl.offset().left + 2 }, 300);
	$('.display-notice-btn').show(0);
	console.log('Notif element added at timecode '+timecode+' (offset left : '+offset+'%)');
}

var slideToDocumentation = function () {
	// $('.timeline-last-notice').animate({
	// 	height: 250
	// }, 500);
	displayingDocumentation = true;
};

$(function () {

	movieDuration = 8645;

	$('.navbar-tabs a[href]').bind('touchstart', function (e) {
		e.preventDefault();

		var hash = $(this).attr('href');

		if (hash == '.container-doc') {
			$('.navbar-doc').fadeIn(500);
		} else {
			$('.navbar-doc ').hide(0);
		}

		$('.container').hide(0);
		$(hash).show(0);

		$('.navbar-tabs a').removeClass('active');
		$(this).addClass('active');
	});


	$('.social-form .send').bind('touchstart', function (e) {
		var message = $('.social-form textarea').val();
		// TODO : handle select
		calliOSFunction('postMessage', [ String(message) ]);
	});

	$('.nav-profile').bind('touchstart', function (e) {
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


	// Hammer(document.getElementById('timeline-body')).on('dragright', function (e) {
	// 	$('.timeline-body').css('right', e.deltaX)
	// });

	// Hammer(document.getElementById('timeline-body')).on('dragleft', function (e) {
	// 	$('.timeline-body').css('left', e.deltaX)
	// });

});