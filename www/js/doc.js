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
				if (notice.notice_category_id == null) continue;

				DOC_ARRAY[notice.notice_category_id] = notice;
			});
		}
	});
};


var getCategoriesOfParent = function (parent) {
	var url = ROOT_API_URL + '/movies/' + MOVIE_ID + '/notice_categories/' + parent + '.json';

	console.log(url);

	DOC_CATEGORIES[parent] = [];

	$.ajax({
		type: 'GET',
		url: url,
		dataType: 'json',
		success: function (data) {
			$('.doc-main').html('');
			$(data).each(function (i, category) {
				console.log(category);
				var block = $('<div class="doc-block" data-subcategory-id="'+category.id+'">');
				block.append('<div class="doc-block-title">'+category.title+'</div>');
				$('.doc-main').append(block);

				$('.doc-block[data-subcategory-id]').bind('touchstart', function (e) {
					id = $(this).attr('data-subcategory-id');
					getNoticesOfCategory(id);
				});
			});

		}
	});
}

var getNoticesOfCategory = function (category) {

	// var isTopLevelCategory = Number(category) <= 4;

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

$(function () {
	$('.doc-block[data-category-id]').bind('touchstart', function (e) {
		var id = $(this).attr('data-category-id');
		getCategoriesOfParent(id);
	});
});


