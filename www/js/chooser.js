var x, y, pX, pY;
var isMoving = false;

$(function () {

	var yes = function () {
		if (isMoving) return;

		isMoving = true;
		$('.sample-notice').animate({ left: '+=1000px' }, 400, function () { isMoving = false; });
	};

	var no = function () {
		if (isMoving) return;

		isMoving = true;
		$('.sample-notice').animate({ left: '-=1000px' }, 400, function () { isMoving = false; });
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