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
			$('.doc-main').html('');
			$(data).each(function (i, category) {
				console.log(category);
				var block = $('<div class="doc-block" data-subcategory-id="'+category.id+'">');
				block.append('<div class="doc-block-title">'+category.title+'</div>');
				$('.doc-main').append(block);

				$('.doc-head').addClass('doc-head-themes');

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


var resetDocScreen = function () {

	$('.doc-main').animate({ left: '+=1000px' }, 300, function () {
		$('.doc-main').html('').append("<div class='doc-block doc-movie-info'> \
	          <div class='doc-block-title'>Fiche du film</div> \
	        </div> \
	        <div class='doc-block doc-themes' data-category-id='2' data-category='themes'> \
	          <div class='doc-block-title'>Thèmes clés</div> \
	        </div> \
	        <div class='doc-block doc-analyse' data-category-id='4' data-category='analyses'> \
	          <div class='doc-block-title'>Analyses</div> \
	        </div> \
	        <div class='doc-block doc-impact' data-category-id='1' data-category='impact'> \
	          <div class='doc-block-title'>Impact sur la culture</div> \
	        </div> \
	        <div class='doc-block doc-anecdotes' data-category-id='5' data-category='anecdotes'> \
	          <div class='doc-block-title'>Anecdotes</div> \
	        </div> \
	        <div class='doc-block doc-social'> \
	          <div class='doc-block-title'>Communauté</div> \
	        </div>");

		$('.doc-block[data-category-id]').bind('touchstart', function (e) {
			var id = $(this).attr('data-category-id');
			var cat = $(this).attr('data-category');
			getCategoriesOfParent(id, cat);
		});

		$('.doc-head').removeClass().addClass('doc-head');

		$('.doc-main').animate({
			left: '-=2000px'
		}, 0).animate({
			left: '+=1000px'
		}, 300);
	})

	
}

$(function () {
	$('.doc-block[data-category-id]').bind('touchstart', function (e) {
		var id = $(this).attr('data-category-id');
		var cat = $(this).attr('data-category');
		getCategoriesOfParent(id, cat);
	});

	$('.navbar-doc .title').bind('touchstart', function (e) {
		resetDocScreen();
	});
});


