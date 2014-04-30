var SOCIAL_CURRENT_STEP = 1;
var socialCursorOriginalOffset = 0;
var socialCursor_posX = 0, socialCursor_xLast = 0;
var socialPostCurrentTimecode = 0;

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
	console.log(SOCIAL_CURRENT_STEP)
	$('.container-social .step-'+SOCIAL_CURRENT_STEP).hide(0);
	SOCIAL_CURRENT_STEP++;
	$('.container-social .step-'+SOCIAL_CURRENT_STEP).show(0);

};


var resetIntervalCursor = function () {
	$('.interval-chooser .cursor').css('transform', 'none');
	socialPostCurrentTimecode = currentTimecode;
	$('.container-social .begin-time').text(formatTimecode(socialPostCurrentTimecode - 15));
	$('.container-social .end-time').text(formatTimecode(socialPostCurrentTimecode + 15));
}

$(function () {
	// $('.social-form .send').bind('touchstart', function (e) {
	// 	var message = $('.social-form textarea').val();
	// 	// TODO : handle select
	// 	calliOSFunction('postMessage', [ String(message) ]);
	// });

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

	Hammer(document.getElementById('social-interval-cursor')).on('drag dragend', function (e) {
		// console.log(e)

		socialCursorOriginalOffset = $('.timeline-body').offset().left;
		
		switch(e.type) {
			case 'drag' :
				socialCursor_posX = e.gesture.deltaX + socialCursor_xLast;
				$('#social-interval-cursor').css('transform', 'translateX(' + socialCursor_posX  +'px)' );
			
				break;
			case 'dragend' :
				socialCursor_xLast = socialCursor_posX;
				// $('.timeline-body').animate({ left: '-=100px' }, 200);
				break;
			
		}
		
	});

	Hammer(document.getElementById('social-interval-cursor')).on('dragright', function (e) {

		socialPostCurrentTimecode += 5;
		$('.container-social .begin-time').text(formatTimecode(socialPostCurrentTimecode - 15));
		$('.container-social .end-time').text(formatTimecode(socialPostCurrentTimecode + 15));
	});

	Hammer(document.getElementById('social-interval-cursor')).on('dragleft', function (e) {

		socialPostCurrentTimecode -= 5;
		$('.container-social .begin-time').text(formatTimecode(socialPostCurrentTimecode - 15));
		$('.container-social .end-time').text(formatTimecode(socialPostCurrentTimecode + 15));
	});
				
});
