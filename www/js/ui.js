var timelineScrollInterval = null;

var beginTimelineScrolling = function () {
	timelineScrollInterval = setInterval(function () {
		$('.timeline-body').animate({
			left: '-=1px'
		}, 20);
	}, 100);
}

var timelinePositionWithTimecode = function (seconds) {
	return (seconds / 5) * 12;
}

$(function () {

	$('.navbar a').click(function (e) {
		e.preventDefault();

		var hash = $(this).attr('href');

		$('.container').hide(0);
		$(hash).show(0);
	});

	

});