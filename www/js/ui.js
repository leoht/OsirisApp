var timelineScrollInterval = null;
var isTimelineScrolling = false;
var isTimelineSliding = false;
var profileMenuDisplayed = false;
var movieDuration;
var pX, pY, timelineStartX, timelineStartY;
var timelineSlidingEl;
var timelineStartLeft;
var displayingDocumentation = false;
var aboutToSlideToDocumentation = false;
var xLast = 0, posX = 0, xLastGrid = 0, posXGrid = 0;
var timelineOriginalOffset;
var IS_LOGGED_IN = false;

var beginTimelineScrolling = function () {

	if (timelineScrollInterval == null) {
		window.timelineScrollInterval = setInterval(function () {

			if (FAST_FORWARD || FAST_REWIND) {
				dT = '8';
				dir = FAST_FORWARD ? '-' : '+';
				console.log('yo')
			} else {
				dT = '0.7';
				dir = '-';
			}

			if (!isTimelineScrolling) return;
			$('.timeline-body, .timeline .cursor').animate({
				left: dir+'='+dT+'px'
			}, 0);
		}, 500);
	}

	isTimelineScrolling = true;
}

var stopTimelineScrolling = function () {
	$('.timeline-body, .timeline .cursor').stop();
	isTimelineScrolling = false;
}

var timelinePositionWithTimecode = function (seconds) {
	return ((seconds * 86) / movieDuration) - 0.1;
};

var timelineOffsetWithTimecode = function (seconds) {
	return (- timelinePositionWithTimecode(seconds)) + 95;
};

var timelineWidthFromDuration = function (duration) {
	return 942 * duration / 600; // container width * total duration / seconds in 10 minutes
};

var noticeBarWidthFromDuration = function (duration) {
	return (timelineWidthFromDuration(movieDuration) * duration) / movieDuration;
};

var updateTimelineNoticeListeners = function () {
	$('.timeline-notice, .timeline-notice-block').bind('touchstart', function (e) {
		var id = $(this).attr('data-id');

		var n = NOTICES[id];
		var $el = $(this);

		CURRENT_VIEWED_NOTICE = id;

		$('.timeline-last-notice .title').text(n.title);
        $('.timeline-last-notice .content').text(n.short_content);
        $('.timeline-last-notice').attr('data-notice-id', id);
        $('.timeline-cat-icon').show(0);
        $('.timeline-cat-icon img').attr('src', 'images/cat-'+n.category+'.png');

        $('.container-home').css('background', 'url(images/samples/notices/'+id+'_big.jpg) no-repeat center top');
        $('.view-grid-container .timeline-last-notice').css('background', 'url(images/samples/notices/'+id+'_big.jpg) no-repeat center top');
        $('.timeline .cursor').css('transform', 'none').animate({ left: $el.offset().left + 2 }, 300);
        $('.timeline-notice, .timeline-notice-block').css('opacity', 1);
        $el.css('opacity', 0.3)
	});
};

var addNoticeOnTimeline = function (timecode, endTimecode, id, category_nicename, title) {
	$('.timeline-notice').css('opacity', 1);
	var offset = timelinePositionWithTimecode(timecode);
	var notifEl = $('<div>')
			.addClass('timeline-notice')
			.addClass('timeline-notice-'+category_nicename)
			.css('left', (offset-0.05)+'%')
			.attr('data-id', id);
	$('.timeline-body').append(notifEl);
	$('.timeline .cursor').css('transform', 'none').animate({ left: notifEl.offset().left + 2 }, 300);
	if (id > 0) $('.display-notice-btn').show(0);
	console.log('Notif element added at timecode '+timecode+' (offset left : '+offset+'%)');


	var noticeBlock = $('<div>')
		.attr('data-id', id)
		.addClass('timeline-notice-block')
		.addClass('timeline-notice-block-'+category_nicename)
		.attr('style', 'background-image: url(images/samples/notices/'+String(id)+'_big.jpg)');
	noticeBlock.append('<img class="icon" src="images/cat-'+category_nicename+'.png" />');
	noticeBlock.append('<div class="title">'+title+'</div>');

	if (id != 0) {
		noticeBlock.append('<div class="timeline-notice-time">'+formatTimecode(timecode)+'</div>');
		$('.grid-timeline').append(noticeBlock);
	}

	$('<div>').addClass('timeline-notice-bar')
			.addClass('timeline-notice-bar-'+category_nicename)
			.css('left', offset+'%')
			.css('width', noticeBarWidthFromDuration(endTimecode - timecode))
			.appendTo($('.timeline-body'));

	$('<div>').addClass('timeline-notice-title')
			.css('left', (offset-0.005)+'%')
			.text(title)
			.appendTo($('.timeline-body'));


	if (id != 0) {
		$('.grid-timeline').animate({
			width: '+=180px'
		}, 300);
		$('.view-grid-container .timeline-body-container').animate({
			scrollLeft: '+=200px'
		});

		if ($('.grid-timeline').width() > 700) {
			$('.scroller').show(0).animate({
				width: '-=40px'
			}, 300);
		}
	}

	updateTimelineNoticeListeners();
}

var slideToDocumentation = function () {
	$('.navbar-doc').fadeIn(500);
	$('.view-nav').hide(0);
	$('.additional-content').animate({
		bottom: '+=670px'
	}, 500);
	displayingDocumentation = true;
	$('.navbar-tabs a').removeClass('active');
	$('.nav-doc').addClass('active');
	$('.display-notice-btn').hide(0);
	$('.replay-btn').show(0);
	$('.socials').hide(0);
};

var unslideDocumentation = function () {
	$('.navbar-doc').hide(0);
	$('.view-nav').show(0);
	$('.additional-content').animate({
		bottom: '-=670px'
	}, 500);
	$('.container-home').animate({ top: 0 }, 300);
	$('.additional-content').animate({ bottom: '-1000px' }, 300);
	displayingDocumentation = false;
	// $('.navbar-tabs a').removeClass('active');
	// $('.nav-home').addClass('active');
	$('.display-notice-btn').show(0);
	$('.replay-btn').hide(0);
	$('.socials').show(0);
};

$(function () {

	movieDuration = 8645;

	$('.navbar-tabs a[href]').bind('touchstart', function (e) {
		e.preventDefault();

		var hash = $(this).attr('href');

		$('.navbar-tabs a').removeClass('active');
		$(this).addClass('active');

		if (hash == '.container-doc') {
			if (displayingDocumentation) unslideDocumentation();
			if (showingDocumentationDetail) {
				unshowDocumentationDetail();
				resetDocScreen();
			}

			$('.navbar-doc').show(0);
		} else {
			$('.navbar-doc ').hide(0);
		}

		if (hash == '.container-social' && !IS_LOGGED_IN) {
			$('.container').hide(0);
			$('.container-social-notlogged').show(0);

			if (displayingDocumentation) unslideDocumentation();

			return;
		}

		if (hash == '.container-social' && IS_LOGGED_IN) {

			socialPostCurrentTimecode = currentTimecode;
			$('.container-social .begin-time').text(formatTimecode(socialPostCurrentTimecode - 15));
			$('.container-social .end-time').text(formatTimecode(socialPostCurrentTimecode + 15));
	
		}

		if (hash == '.container-home' && displayingDocumentation) {
			unslideDocumentation();

			return;
		}

		$('.container').hide(0);
		$(hash).show(0);


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

	$('.timeline-body').css('width', timelineWidthFromDuration(movieDuration));

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
			if (pY - y < -20  && !displayingDocumentation) {
				aboutToSlideToDocumentation = true;
				displayingDocumentation = true;
				$('.timeline-last-notice').animate({ zoom: 1.1 }, 200);
				$('.container-home').css({ backgroundSize: '100%' }).animate({ backgroundSize: '110%' }, 200);
			}

			// cancel
			if (pY - y > 20  && aboutToSlideToDocumentation) {
				aboutToSlideToDocumentation = false;
				displayingDocumentation = false;
				$('.timeline-last-notice').animate({ zoom: 1 }, 200);
				$('.container-home').animate({ backgroundSize: '100%' }, 200);
			}
		})
		.bind('touchend', function (e) {
			
			
			if (aboutToSlideToDocumentation) {
				slideToDocumentation();
				aboutToSlideToDocumentation = false;
				$('.timeline-last-notice').animate({ zoom: 1 }, 200);
				$('.container-home').animate({ backgroundSize: '100%' }, 200);
			}
			
		});

	$('.additional-content')
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

			// scroll
			if (pY - y < -20) {
				var scroll = $('.additional-content').scrollTop();
				// $('body').scrollTop(scroll - 5);

				if ($('.container-home').offset().top >= 0 && !showingDocumentationDetail) return;
				if ($('.doc-category.current').offset().top >= 0 && showingDocumentationDetail) return;

				$('.container-home, .doc-category').animate({ top: '+=10px' }, 0);
				$('.additional-content').animate({ bottom: '-=10px' }, 0);
			}

			// scroll
			if (pY - y > 20) {
				var scroll = $('.additional-content').scrollTop();
				// $('body').scrollTop(scroll + 5);

				var bottom = $(window).height() - $('.additional-content').offset().top - $('.additional-content').height();
				console.log(bottom);
				if (bottom >= 50) return;

				$('.container-home, .doc-category').animate({ top: '-=10px' }, 0);
				$('.additional-content').animate({ bottom: '+=10px' }, 0);
			}
		});


	Hammer(document.getElementById('timeline-body')).on('drag dragend', function (e) {
		console.log(e)

		timelineOriginalOffset = $('.timeline-body').offset().left;
		
		switch(e.type) {
			case 'drag' :
				posX = e.gesture.deltaX + xLast;
				$('.timeline-body, .cursor').css('transform', 'translateX(' + posX  +'px) translateZ(0px)' );
				break;
			case 'dragend' :
				xLast = posX;
				// $('.timeline-body').animate({ left: '-=100px' }, 200);
				break;
			
		}
		
	});

	Hammer(document.getElementById('grid-timeline')).on('drag dragend', function (e) {
		if ($('.grid-timeline').offset().left > 0 && e.gesture.direction == 'right') {
			return;
		}

		switch(e.type) {
			case 'drag' :
				posXGrid = e.gesture.deltaX + xLastGrid;

				if ($('.grid-timeline').offset().left > 0 && e.gesture.direction == 'right') {
					return;
				}

				$('.grid-timeline').css('transform', 'translateX(' + posXGrid  +'px) translateZ(0px)' );
				// $('.chapter-timeline').css('transform', 'translateX(' + posXGrid  +'px)' );
				break;
			case 'dragend' :
				xLastGrid = posXGrid;
				// $('.timeline-body').animate({ left: '-=100px' }, 200);
				break;
			
		}
		
	});


});