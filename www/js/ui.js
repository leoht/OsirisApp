var timelineScrollInterval;
var isTimelineScrolling = false;
var isTimelineSliding = false;
var profileMenuDisplayed = false;
var movieDuration;
var pX, pY, timelineStartX, timelineStartY;
var timelineSlidingEl;
var timelineStartLeft;
var displayingDocumentation = false;
var xLast = 0, posX = 0, xLastGrid = 0, posXGrid = 0;
var timelineOriginalOffset;
var IS_LOGGED_IN = false;

var beginTimelineScrolling = function () {
	window.timelineScrollInterval = setInterval(function () {

		if (FAST_FORWARD || FAST_REWIND) {
			dT = '3.4';
			dir = FAST_FORWARD ? '-' : '+';
			console.log('yo')
		} else {
			dT = '0.2';
			dir = '-';
		}

		if (!isTimelineScrolling) return;
		$('.timeline-body, .timeline .cursor, .chapter-timeline, .notice-grid .slider').animate({
			left: dir+'='+dT+'px'
		}, 0);
	}, 350);

	isTimelineScrolling = true;
}

var stopTimelineScrolling = function () {
	$('.timeline-body, .timeline .cursor').stop();
	window.clearInterval(window.timelineScrollInterval);
	isTimelineScrolling = false;
}

var timelinePositionWithTimecode = function (seconds) {
	return ((seconds * 95) / movieDuration) - 0.1;
};

var timelineOffsetWithTimecode = function (seconds) {
	return (- timelinePositionWithTimecode(seconds)) + 95;
};

var timelineWidthFromDuration = function (duration) {
	return 95 * duration / 500; // container width * total duration / seconds in 15 minutes
};

var updateTimelineNoticeListeners = function () {
	$('.timeline-notice').bind('touchstart', function (e) {
		var id = $(this).attr('data-id');

		var n = NOTICES[id];
		var $el = $(this);

		$('.timeline-last-notice .title').text(n.title);
        $('.timeline-last-notice .content').text(n.short_content);
        $('.timeline-last-notice').attr('data-notice-id', id);
        $('.timeline-cat-icon').show(0);
        $('.timeline-cat-icon img').attr('src', 'images/cat-'+n.category+'.png');
        $('.view-line-container .timeline-last-notice .title').css('color', '#'+n.color);
        $('.container-home').css('background', 'url(images/samples/notices/'+id+'_big.jpg) no-repeat center top');
        $('.view-grid-container .timeline-last-notice').css('background', 'url(images/samples/notices/'+id+'_big.jpg) no-repeat center top');
        $('.timeline .cursor').css('transform', 'none').animate({ left: $el.offset().left + 2 }, 300);
        $('.timeline-notice').css('opacity', 0.7);
        $el.css('opacity', 1)
	});
};

var addNoticeOnTimeline = function (timecode, endTimecode, id, category_nicename) {
	$('.timeline-notice').css('opacity', 0.7);
	var offset = timelinePositionWithTimecode(timecode);
	var notifEl = $('<div>')
			.addClass('timeline-notice')
			.addClass('timeline-notice-'+category_nicename)
			.css('left', offset+'%')
			.attr('data-id', id);
	$('.timeline-body').append(notifEl);
	$('.timeline .cursor').css('transform', 'none').animate({ left: notifEl.offset().left + 2 }, 300);
	$('.display-notice-btn').show(0);
	console.log('Notif element added at timecode '+timecode+' (offset left : '+offset+'%)');

	$('.notice-grid .slider').append('<div class="chapter-section"></div>');

	var noticeBlock = $('<div>')
		.addClass('notice-block')
		.addClass('notice-block-'+category_nicename);
	$('.chapter-section:last-child').append(noticeBlock);

	$('<div>').addClass('timeline-notice-bar')
			.addClass('timeline-notice-bar-'+category_nicename)
			.css('left', offset+'%')
			.css('width', timelineWidthFromDuration(endTimecode - timecode))
			.appendTo($('.timeline-body'));

	updateTimelineNoticeListeners();
}

var slideToDocumentation = function () {
	$('.navbar-doc').fadeIn(500);
	$('.additional-content').animate({
		bottom: '+=360px'
	}, 500);
	displayingDocumentation = true;
};

$(function () {

	movieDuration = 8645;

	$('.navbar-tabs a[href]').bind('touchstart', function (e) {
		e.preventDefault();

		var hash = $(this).attr('href');

		$('.navbar-tabs a').removeClass('active');
		$(this).addClass('active');

		if (hash == '.container-doc') {
			$('.navbar-doc').fadeIn(500);
		} else {
			$('.navbar-doc ').hide(0);
		}

		if (hash == '.container-social' && !IS_LOGGED_IN) {
			$('.container').hide(0);
			$('.container-social-notlogged').show(0);
			return;
		}

		$('.container').hide(0);
		$(hash).show(0);


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

	$('.view-grid').bind('touchstart', function (e) {
		$('.view-nav .view-line').removeClass('active');
		$(this).addClass('active');
		$('.view-line-container').hide(0);
		$('.view-grid-container').show(0);
	});

	$('.view-line').bind('touchstart', function (e) {
		$('.view-nav .view-grid').removeClass('active');
		$(this).addClass('active');
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

	Hammer(document.getElementById('timeline-body')).on('drag dragend', function (e) {
		console.log(e)

		timelineOriginalOffset = $('.timeline-body').offset().left;
		
		switch(e.type) {
			case 'drag' :
				posX = e.gesture.deltaX + xLast;
				$('.timeline-body, .cursor').css('transform', 'translateX(' + posX  +'px)' );
				break;
			case 'dragend' :
				xLast = posX;
				// $('.timeline-body').animate({ left: '-=100px' }, 200);
				break;
			
		}
		
	});

	Hammer(document.getElementById('notice-grid-slider')).on('drag dragend', function (e) {
		if ($('.notice-grid .slider').offset().left > 0 && e.gesture.direction == 'right') {
			return;
		}

		switch(e.type) {
			case 'drag' :
				posXGrid = e.gesture.deltaX + xLastGrid;

				if ($('.notice-grid .slider').offset().left > 0 && e.gesture.direction == 'right') {
					return;
				}

				$('.notice-grid .slider').css('transform', 'translateX(' + posXGrid  +'px)' );
				$('.chapter-timeline').css('transform', 'translateX(' + posXGrid  +'px)' );
				break;
			case 'dragend' :
				xLastGrid = posXGrid;
				// $('.timeline-body').animate({ left: '-=100px' }, 200);
				break;
			
		}
		
	});


});