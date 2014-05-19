var SOCIAL_CURRENT_STEP = 1;
var socialCursorOriginalOffset = 0;
var socialCursor_posX = 0, socialCursor_xLast = 0;
var socialPostCurrentTimecode = 0;
var oldSocialCurrentTimecode = 0;
var publishOnFacebook = false;

var INTERVAL_CURRENT_SPRITE = 15;

String.prototype.lpad = function(padString, length) {
    var str = this;
    while (str.length < length)
        str = padString + str;
    return str;
}

var formatTimecode = function (seconds) {
	var s = Number(seconds);
	var m = parseInt(s / 60); s %= 60;
	var h = parseInt(m / 60); m %= 60;

	return String(h).lpad('0', 2) + ':' + String(m).lpad('0', 2) + ':' + String(s).lpad('0', 2);
};

var socialNextStep = function () {

	$('.container-social .step-'+SOCIAL_CURRENT_STEP).hide(0);
	SOCIAL_CURRENT_STEP++;
	$('.container-social .step-'+SOCIAL_CURRENT_STEP).show(0);
};

var socialPrevStep = function () {

	$('.container-social .step-'+SOCIAL_CURRENT_STEP).hide(0);
	SOCIAL_CURRENT_STEP--;
	$('.container-social .step-'+SOCIAL_CURRENT_STEP).show(0);
};


var resetIntervalCursor = function () {
	$('.interval-chooser .cursor').css('transform', 'none');
	$('.interval-chooser ').css('background-image', 'url(images/samples/interval/15.jpg)');
	socialPostCurrentTimecode = currentTimecode;
	$('.container-social .begin-time').text(formatTimecode(Number(socialPostCurrentTimecode) - 15));
	$('.container-social .end-time').text(formatTimecode(Number(socialPostCurrentTimecode) + 15));
	socialCursor_posX = 0;
	socialCursor_xLast = 0;
}

$(function () {
	var queue = new createjs.LoadQueue(false);

	var manifest = [];

	for (var i = 1 ; i <= 30 ; i++) {
		manifest.push({ id: i, src: 'images/samples/interval/'+i+'.jpg'})
	}

	queue.loadManifest(manifest);

	$('.step-3 .send').bind('touchstart', function (e) {
		var message = $('.social-form textarea').val();
		// TODO : handle select
		calliOSFunction('postMessage', [ String(message), publishOnFacebook ]);

		$('.container-social .step').hide(0);
		$('.container-social .step-1').show(0);
		$('.container').hide(0);
		$('.container-home').show(0);
	});

	$('.interval-chooser .reset').bind('touchstart', function (e) {
		resetIntervalCursor();
	});

	$('.publication-select .item').bind('touchstart', function (e) {
		$(this).toggleClass('checked');
	});

	$('.publication-select .item-fb').bind('touchstart', function (e) {
		publishOnFacebook = true;
	});

	// hide whatever will mess up with the keyboard appearence
	$('.container-social textarea, .doc-search input')
		.on('focus', function () {
			$('.navbar, .profile-nav').hide(0);
			$('.additional-content').hide(0);
			$('.container-social .step-2 .profile-image').animate({ top: '+=60px'}, 500);
		}).on('blur', function () {
			$('.navbar, .profile-nav').show(0);
			$('.additional-content').show(0);
			$('.container-social .step-2 .profile-image').animate({ top: '-=60px'}, 500);
		});;

	$('.container-social .go-back').bind('touchstart', function (e) {
		socialPrevStep();
	});

	Hammer(document.getElementById('social-interval-cursor')).on('drag dragend', function (e) {
		// console.log(e)

		socialCursorOriginalOffset = $('.timeline-body').offset().left;
		
		switch(e.type) {
			case 'drag' :
				$('.interval-chooser-mask').hide(0);
				socialCursor_posX = e.gesture.deltaX + socialCursor_xLast;
				$('#social-interval-cursor').css('opacity', 0.3);
				$('#social-interval-cursor').css('transform', 'translateX(' + socialCursor_posX  +'px) translateZ(0)' );
			
				break;
			case 'dragend' :
				$('.interval-chooser-mask').show(0);
				$('#social-interval-cursor').css('opacity', 1);
				socialCursor_xLast = socialCursor_posX;
				// $('.timeline-body').animate({ left: '-=100px' }, 200);
				break;
			
		}
		
	});

	Hammer(document.getElementById('social-interval-cursor')).on('dragright', function (e) {

		socialPostCurrentTimecode += 5;

		if (socialPostCurrentTimecode >= oldSocialCurrentTimecode + 50) {
			
			INTERVAL_CURRENT_SPRITE++;

			console.log(INTERVAL_CURRENT_SPRITE)

			$('.interval-chooser').css('background-image', 'url(images/samples/interval/'+(INTERVAL_CURRENT_SPRITE%30)+'.jpg)');

			// $('.container-social .begin-time').text(formatTimecode(socialPostCurrentTimecode - 15));
			// $('.container-social .end-time').text(formatTimecode(socialPostCurrentTimecode + 15));
			oldSocialCurrentTimecode = socialPostCurrentTimecode;
		}
		
	});

	Hammer(document.getElementById('social-interval-cursor')).on('dragleft', function (e) {

		socialPostCurrentTimecode -= 5;

		if (socialPostCurrentTimecode <= oldSocialCurrentTimecode - 50) {
			
			INTERVAL_CURRENT_SPRITE--;

			console.log(INTERVAL_CURRENT_SPRITE)

			$('.interval-chooser').css('background-image', 'url(images/samples/interval/'+(INTERVAL_CURRENT_SPRITE%30)+'.jpg)');

			// $('.container-social .begin-time').text(formatTimecode(socialPostCurrentTimecode - 15));
			// $('.container-social .end-time').text(formatTimecode(socialPostCurrentTimecode + 15));
			oldSocialCurrentTimecode = socialPostCurrentTimecode;
		}
	});
				
});
