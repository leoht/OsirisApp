var DOC_ARRAY = [];
var DOC_CATEGORIES = [];
var MOVIE_ID;
var isDocLoaded = false;

var getDocumentation = function (movieId) {

	var url = ROOT_API_URL + '/movies/' + movieId + '/notices.json';
	console.log(url);
	$.ajax({
		type: 'GET',
		url: url,
		dataType: 'json',
		success: function (data) {
			$(data).each(function (i, notice) {
				// no category ? skip it.
				if (notice.notice_category_id != null) {
					DOC_ARRAY[notice.notice_category_id] = notice;
				}
			});
		}
	});
};


var getCategoriesOfParent = function (parent, parent_name) {
	var url = ROOT_API_URL + '/movies/' + MOVIE_ID + '/notice_categories/' + parent + '.json';

	console.log(url);

	DOC_CATEGORIES[parent] = [];

	$.ajax({
		type: 'GET',
		url: url,
		dataType: 'json',
		success: function (data) {
			$('.doc-main').addClass('flipping');
			
			$('.doc-breadcrumb .item-2').text(parent_name);
			$('.doc-breadcrumb .item-2').show();

			setTimeout(function () {
				$('.doc-main').html('');
				$(data).each(function (i, category) {

					console.log(category);
					var block = $('<div class="doc-block" data-subcategory-id="'+category.id+'">');
					block.append('<div class="doc-block-title">'+category.title+'</div>');
					$('.doc-main').append(block);

					$('.doc-head').addClass('doc-head-'+parent_name);

					$('.doc-block[data-subcategory-id]').bind('touchstart', function (e) {
						id = $(this).attr('data-subcategory-id');
						getNoticesOfCategory(id);
					});
				});
				$('.doc-main').removeClass('flipping');
				

			}, 400);

		}
	});
}

var getNoticesOfCategory = function (category) {

	// var isTopLevelCategory = Number(category) <= 4;

	$('.doc-breadcrumb .item-3').text(category).show(0);

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

	$('.doc-main').addClass('flipping');

	setTimeout(function () {
		$('.doc-main').html('').append("<div class='doc-block doc-movie-info'> \
	        </div> \
	        <div class='doc-block doc-themes' data-category-id='2' data-category='themes'> \
	        </div> \
	        <div class='doc-block doc-analyse' data-category-id='4' data-category='analyses'> \
	        </div> \
	        <div class='doc-block doc-impact' data-category-id='1' data-category='impact'> \
	        </div> \
	        <div class='doc-block doc-anecdotes' data-category-id='5' data-category='anecdotes'> \
	        </div> \
	        <div class='doc-block doc-social'> \
	        </div>");

		$('.doc-block[data-category-id]').bind('touchstart', function (e) {
			var id = $(this).attr('data-category-id');
			var cat = $(this).attr('data-category');
			getCategoriesOfParent(id, cat);
		});

		$('.doc-head').removeClass().addClass('doc-head');

		$('.doc-main').removeClass('flipping');
	}, 400);

	$('.doc-breadcrumb .item-2').hide(0);
	$('.doc-breadcrumb .item-3').hide(0);
	
}

$(function () {
	$('.doc-block[data-category-id]').bind('touchstart', function (e) {
		var id = $(this).attr('data-category-id');
		var cat = $(this).attr('data-category');
		getCategoriesOfParent(id, cat);
	});

	$('.doc-breadcrumb .item-1').bind('touchstart', function (e) {
		resetDocScreen();
	});
});


