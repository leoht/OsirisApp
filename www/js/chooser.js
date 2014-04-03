var x, y, pX, pY;
var isMoving = false;
var currentNotice = 5;

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

	$('.yes').bind('click', function () {
		yes();
	});

	$('.no').bind('click', function () {
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