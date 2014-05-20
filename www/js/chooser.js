var x, y, pX, pY;
var isMoving = false;
var currentNotice = 5;

var processNotices = function (data) {
		var a = 5;
		$(data).each(function (i, el) {
			var $notice = $('<div class="sample-notice sample-notice-'+a+'" style="z-index:'+(a*10)+'"></div>')
							.append('<div class="image" style="background-image: url(images/samples/chooser/'+(el.id)+'.jpg);" /></div>')
							.append('<div class="heading"><img class="cat-icon" width="40" height="40" src="images/notif-picto-impact@2x.png" /><div class="with-font">'+el.title+'</div></div>')
							.append('<p class="content">'+el.teasing+'</p>')
							.append('<div class="counter with-font">'+(i+1)+' / 5</div>');

			$('.notice-slider').append($notice);
			a--;
		});
	};

$(function () {

	var yes = function () {
		if (isMoving) return;

		isMoving = true;
		$('.sample-notice-'+currentNotice).animate({ left: '+=1000px' }, 400, function () { isMoving = false; });

		currentNotice--;

		calliOSFunction('yes', []);

		if (currentNotice == 0) {
			setTimeout(function() {
				calliOSFunction('goToMovieView', []);
			}, 800);
		}
	};

	var no = function () {
		if (isMoving) return;

		isMoving = true;
		$('.sample-notice-'+currentNotice).animate({ left: '-=1000px' }, 400, function () { isMoving = false; });

		currentNotice--;

		calliOSFunction('no', []);

		if (currentNotice == 0) {
			setTimeout(function() {
				calliOSFunction('goToMovieView', []);
			}, 800);
		}
	};

	

	$('.yes').bind('touchstart', function () {
		yes();
	});

	$('.no').bind('touchstart', function () {
		no();
	})

	$('body')
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

			// touch slide left
			if (pX - x > 300) {
				console.log('left');
				no();
			}
			// touch slide right
			if (pX - x < -300) {
				console.log('right');
				yes();
			}
		});

});