var SLIDER_CURRENT_IMAGE = 1;

$(function () {

	$('.additional-content .image.slider-click').bind('touchstart', function (e) {
		$('.doc-image-slider').fadeIn(400);	
	});


	$('.doc-image-slider .next, .doc-image-slider .prev').bind('touchstart', function (e) {
		e.stopPropagation();

		SLIDER_CURRENT_IMAGE = SLIDER_CURRENT_IMAGE == 1 ? 2 : 1;

		$('.doc-image-slider .image').attr('src', 'images/samples/doc/slider-image-'+SLIDER_CURRENT_IMAGE+'.jpg');

	});

	$('.doc-image-slider').bind('touchstart', function (e) {
		$('.doc-image-slider').fadeOut(400);
	});
});