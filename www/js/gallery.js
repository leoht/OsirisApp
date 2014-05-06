var SLIDER_CURRENT_IMAGE = 1;
var imageSlider_x = 0, imageSlider_pX = 0;
var imageSliderSliding = false;
var sliderData = [];
sliderData[1] = { title: 'Saturne dévorant ses enfants', author: 'Rubens', year: '1636'};
sliderData[2] = { title: 'Saturne dévorant son enfant', author: 'Goya', year: '1819 - 1823'};

var switchImage = function () {
	SLIDER_CURRENT_IMAGE = SLIDER_CURRENT_IMAGE == 1 ? 2 : 1;

	$('.doc-image-slider .image').attr('src', 'images/samples/doc/slider-image-'+SLIDER_CURRENT_IMAGE+'.jpg');
	$('.doc-image-slider .legend .title').text(sliderData[SLIDER_CURRENT_IMAGE].title);
	$('.doc-image-slider .legend .author').text(sliderData[SLIDER_CURRENT_IMAGE].author);
	$('.doc-image-slider .legend .year').text(sliderData[SLIDER_CURRENT_IMAGE].year);
};

$(function () {

	$('.additional-content .image.slider-click').bind('touchstart', function (e) {
		$('.doc-image-slider').fadeIn(400);	
	});


	$('.doc-image-slider .next, .doc-image-slider .prev').bind('touchstart', function (e) {
		e.stopPropagation();

		switchImage();
	});

	$('.doc-image-slider .close').bind('touchstart', function (e) {
		$('.doc-image-slider').fadeOut(400);
	});

	$('.doc-image-slider')
		.bind('touchstart', function (e) {
			e.preventDefault();
			imageSlider_pX = e.originalEvent.touches[0].pageX;
		})
		.bind('touchmove', function (e) {
			
			e.preventDefault();
			imageSlider_x = e.originalEvent.touches[0].pageX;

			if (!imageSliderSliding && (imageSlider_x > imageSlider_pX + 100 || imageSlider_x < imageSlider_pX - 100)) {
				switchImage();
				imageSliderSliding = true;
			}
		})
		.bind('touchend', function (e) { imageSliderSliding = false; });
});