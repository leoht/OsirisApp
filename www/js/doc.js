var DOC_ARRAY = [];
var DOC_CATEGORIES = [];
var MOVIE_ID;
var isDocLoaded = false;
var showingDocumentationDetail = false;
var currentViewStep = 1;

var getDocumentation = function (movieId) {

	var url = ROOT_API_URL + '/movies/' + movieId + '/notice_categories.json';
	console.log('GET ' + url);
	$.ajax({
		type: 'GET',
		url: url,
		dataType: 'json',
		success: function (data) {
			$(data).each(function (i, category) {
				// only sub categories
				if (category.parent_id) {



					// no notice in this category?
					if (!(category.id in DOC_ARRAY)) {
						return;
					}

					DOC_ARRAY[category.id].title = category.title;
					DOC_ARRAY[category.id].parent_id = category.parent_id;
					
					$page = $('<div id="doc-category-'+category.id+'" class="doc-category doc-category-'+category.id+'"></div>');
					$slider = $('<div class="slider"></div>');
					$slider.append('<div class="slide-counter"><span class="current">1</span>/<span class="total"></span></div>')
					$slider.append('<div class="cat-icon cat-icon-'+category.parent_id+'"><img src="images/cat-icon-'+category.parent_id+'.png" /></div>')
					$slider.append('<div class="title with-font">'+category.title+'</div>');
					$slider.append('<div class="replay-btn" ></div>');

					$(DOC_ARRAY[category.id]).each(function (i, notice) {
						$slider.append('<div class="short-content short-content-'+(i+1)+'">'+notice.short_content+'</div>');
					});

					$page.append($slider);
					$page.css('display', 'none');
					$('.container-doc').append($page);
					
				}


			});
			console.log(DOC_ARRAY);
		}
	});
};

var getAllNotices = function (movieId) {
	var url = ROOT_API_URL + '/movies/' + movieId + '/notices.json';
	console.log('GET ' + url);
	$.ajax({
		type: 'GET',
		url: url,
		dataType: 'json',
		success: function (data) {
			$(data).each(function (i, notice) {
				
				if (notice.notice_category_id && notice.id != 1) {
					if (!(notice.notice_category_id in DOC_ARRAY)) {
						DOC_ARRAY[notice.notice_category_id] = [];
					}

					DOC_ARRAY[notice.notice_category_id].push(notice);
				}
			});

			getDocumentation(movieId);
		}
	});
};

var updateSliderListeners = function () {
	$('.additional-content .slider .item').unbind().bind('touchstart', function (e) {
		var n = $(this).attr('data-n');
		$('.slider .item').removeClass('active');
		$(this).addClass('active');
		$('.slider .short-content').hide(0);
		$('.slider .short-content-'+n).show(0);

		if ($('.additional-content .notice-2').is(':hidden')) {
			$('.additional-content .notice-1').hide(0);
			$('.additional-content .notice-2').show(0);
		} else {
			$('.additional-content .notice-1').show(0);
			$('.additional-content .notice-2').hide(0);
		}
			

		$('.doc-category, .container-home').animate({
			top: '0px'
		}, 300);
		$('.additional-content').animate({
			bottom: '-330px'
		}, 300);

		$('.slider .prev').removeClass('disabled');
	});
};

var addItemOnSlider = function (i, id) {
	var $item = $('<div class="item" data-n="'+(i+1)+'" data-notice-id="'+id+'"></div>');
	$item.appendTo('.additional-content .slider');

	if (i == 0)
		$item.addClass('active')

	updateSliderListeners();

};

var getCategoriesOfParent = function (parent, parent_name) {
	var url = ROOT_API_URL + '/movies/' + MOVIE_ID + '/notice_categories/' + parent + '.json';

	console.log(url);

	DOC_CATEGORIES[parent] = [];

	currentViewStep = 2;

	$.ajax({
		type: 'GET',
		url: url,
		dataType: 'json',
		success: function (data) {
			$('.doc-main').addClass('flipping');
			
			// $('.doc-breadcrumb .item-2').text(parent_name);
			// $('.doc-breadcrumb .item-2').show();

			setTimeout(function () {
				$('.doc-main').html('');
				$(data).each(function (i, category) {


					console.log(category);

					if (parent_name == 'themes') {
						var block = $('<div class="doc-block" data-subcategory-id="'+category.id+'" style="background: url(images/samples/doc/doc-block-sub-'+category.id+'.png) no-repeat center center; background-size: 170px 170px; ">');
					} else {
						var block = $('<div class="doc-block" data-subcategory-id="'+category.id+'" style="background: url(images/doc-block.png) no-repeat center center; background-size: 170px 170px; ">');
					}
					block.append('<div class="doc-block-title doc-block-title-sub">'+category.title+'</div><div class="doc-block-count">7 notices</div>');
					$('.doc-main').append(block);

					$('.doc-head').addClass('doc-head-'+parent_name);

					var catId = category.id;

					$(block).bind('touchstart', function (e) {
						var id = $(this).attr('data-subcategory-id');

						currentViewStep = 3;

						$('.doc-breadcrumb .item-1').text('Thèmes clés');

						$('.doc-home').fadeOut(300, function () {
							$('.doc-theme-deshumanisation').fadeIn(300);
							$('.doc-head').css('background', 'url(images/doc-title-deshu.png) no-repeat center center')
						});

					});

				});
				$('.doc-main').removeClass('flipping');
				

			}, 380);

		}
	});
}

var getNoticesOfCategory = function (category) {

	// var isTopLevelCategory = Number(category) <= 4;

	// $('.doc-breadcrumb .item-3').text(category).show(0);

	var url = ROOT_API_URL + '/movies/' + MOVIE_ID + '/notice_categories/' + category + '.json';

	console.log(url);

	$.ajax({
		type: 'GET',
		url: url,
		dataType: 'json',
		success: function (data) {
			$('.doc-main').html('');
			$(data).each(function (i, notice) {
				DOC_ARRAY[category] = notice;
				var block = $('<div class="doc-block" data-notice-id="'+notice.id+'">');
				block.append('<div class="doc-block-title">'+notice.title+'</div>')
				$('.doc-main').append(block)
			});
		}
	});
};


var resetDocScreen = function () {

	$('.doc-theme-deshumanisation').fadeOut(300);

	$('.doc-head').css('background', 'url(images/doc-title.png) no-repeat center center')

	$('.doc-main').addClass('flipping');

	$('.doc-image-slider').fadeOut(400);

	currentViewStep = 1;

	setTimeout(function () {
		$('.doc-home').show(0);
		$('.doc-main').html('').append("<div class='doc-block doc-movie-info'> \
				<div class='doc-block-title'>Fiche du film</div> \
	        </div> \
	        <div class='doc-block doc-themes' data-category-id='2' data-category='themes'> \
	        	<div class='doc-block-title'>Themes clés</div> \
	        </div> \
	        <div class='doc-block doc-analyse' data-category-id='4' data-category='analyses'> \
	        	<div class='doc-block-title'>Analyses</div> \
	        </div> \
	        <div class='doc-block doc-social'> \
	        	<div class='doc-block-title'>Communauté</div> \
	        </div> \
	        <div class='doc-block doc-anecdotes' data-category-id='5' data-category='anecdotes'> \
	        	<div class='doc-block-title'>Anecdotes</div> \
	        </div> \
	        <div class='doc-block doc-impact' data-category-id='1' data-category='impact'> \
	        	<div class='doc-block-title'>Impact<br />sur la culture</div> \
	        </div>");

		$('.doc-block[data-category-id]').bind('touchstart', function (e) {
			var id = $(this).attr('data-category-id');
			var cat = $(this).attr('data-category');
			getCategoriesOfParent(id, cat);
		});

		$('.doc-head').removeClass().addClass('doc-head');

		$('.doc-main').removeClass('flipping');

		if (showingDocumentationDetail) {
			unshowDocumentationDetail();
		}
	}, 380);

	$('.doc-breadcrumb .item-2').hide(0);
	$('.doc-breadcrumb .item-3').hide(0);
	
}

var unshowDocumentationDetail = function () {
	$('.doc-category.current').removeClass('current').animate({
		top: '-400px'
	}, 500, function () { $(this).hide(0); });
	$('.additional-content').animate({
		bottom: '-1000px'
	}, 500);
	$('.container-home').animate({
		top: 0
	}, 500);

	showingDocumentationDetail = false;
}

var nextDocSlide = function () {

};

var prevDocSlide = function () {
	
};

$(function () {
	$('.doc-block[data-category-id]').bind('touchstart', function (e) {
		var id = $(this).attr('data-category-id');
		var cat = $(this).attr('data-category');
		getCategoriesOfParent(id, cat);
	});



	$('.doc-breadcrumb .item-1').bind('touchstart', function (e) {

		switch (currentViewStep) {
			case 1:
			case 2:
				resetDocScreen();
				currentViewStep = 1;
				break;
			case 3:
				$('.doc-theme-deshumanisation').fadeOut(300, function () {
					$('.doc-home').fadeIn(0);
				});
				currentViewStep = 2;
				break;
			case 4:
				if (displayingDocumentation) { 
					unslideDocumentation();
					$('.navbar-doc').show(0);
					$('.container').hide(0);
					$('.container-doc').show(0);
				}
				if (showingDocumentationDetail) {
					unshowDocumentationDetail();
				}
				currentViewStep = 3;
				break;
			default:
				resetDocScreen();
		}
		
	});

	$('.additional-content .more').bind('touchstart', function (e) {
		$(this).hide(0);
		$(this).parents('.content').animate({ height: 540 }, 400);
		$(this).parents('.content').find('.less').show(0);
		$(this).parents('.content').addClass('open');
		e.stopPropagation();
		$(this).parents('.content').bind('touchstart', function (e) {
			e.stopPropagation();
			$('.less').hide(0);
			$(this).animate({ height: 167 }, 400);
			$(this).find('.more').show(0);
			$(this).removeClass('open');
			$(this).unbind();
		});
	});
	
	$('.additional-content .less').bind('touchstart', function (e) {
		$(this).hide(0);
		$(this).parents('.content').animate({ height: 167 }, 400);
		$(this).parents('.content').find('.more').show(0);
		$(this).parents('.content').removeClass('open');
	});

	updateSliderListeners();


	$('.doc-theme-deshumanisation .notices .deshu-notice').bind('touchstart', function (e) {

		var id = $(this).attr('data-theme-id');

		currentViewStep = 4;

		$('.additional-content').animate({
			bottom: '+=670px'
		}, 500);

		$('.doc-category-'+id).addClass('current').show(0).animate({
			top: '+=410px'
		}, 500);

		$('.slide-counter .total').text('7');

		$('.slider .item').remove();

		for (var i = 0 ; i < DOC_ARRAY[id].length ; i++) {
			if (typeof DOC_ARRAY[id] !== "undefined" && typeof DOC_ARRAY[id][i] !== "undefined") {
				addItemOnSlider(i, DOC_ARRAY[id][i].id);
			}
		}

		$('.doc-breadcrumb .item-1').text('Déshumanisation');

		showingDocumentationDetail = true;

		Hammer(document.getElementById('doc-category-'+id)).on('dragleft', function (e) {
			nextDocSlide();
		});
	});

});


