$(function () {

	$('.navbar a').click(function (e) {
		e.preventDefault();

		var hash = $(this).attr('href');

		$('.container').hide(0);
		$(hash).show(0);
	});

});