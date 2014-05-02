var map_posXGrid = 0, map_xLastGrid = 0;
var CURRENT_COL = 0;

var addNoticeOnMap = function (timecode, id, cat, title, missed) {
	var $n = $('<div class="map-notice" data-id="'+id+'"></div>');
	$n.css('background', 'url(images/samples/notices/'+id+'_big.jpg) no-repeat');
	$n.css('background-size', 'cover');

	if (missed) {
		$n.addClass('missed');
	}

	$n.append('<img class="icon" src="images/cat-'+cat+'.png" /><div class="title">'+title+'</div>');

	var col = parseInt(timecode / 400) + 1; // 10 minutes per col ( ? )

	if (col != CURRENT_COL) {
		CURRENT_COL = col;
		var $wrapper = $('<div class="map-col-wrapper"></div>');
		$wrapper.append($n);
		var $col = $('<div class="map-col"></div>');
		$col.append($wrapper);

		$('.map-main').append($col);
	} else {
		$('.map-col:last-child').find('.map-col-wrapper').append($n);
	}
}

var mapDragHandler = function (e) {
	if ($('.map-main').offset().left > 0 && e.gesture.direction == 'right') {
		return;
	}

	switch(e.type) {
		case 'drag' :
			map_posXGrid = e.gesture.deltaX + map_xLastGrid;

			if ($('.map-main, .map-timeline').offset().left > 0 && e.gesture.direction == 'right') {
				return;
			}

			$('.map-main, .map-timeline').css('transform', 'translateX(' + map_posXGrid  +'px) translateZ(0)' );
			// $('.chapter-timeline').css('transform', 'translateX(' + posXGrid  +'px)' );
			break;
		case 'dragend' :
			map_xLastGrid = map_posXGrid;
			// $('.timeline-body').animate({ left: '-=100px' }, 200);
			break;
		
	}	
};

$(function () {
	$('.nav-roadmap').bind('touchstart', function (e) {
		$('.navbar-doc').hide(0);
		$('.container').hide(0);
		$('.container-map').show(0);
		$('.container').click();
		$('.navbar a').removeClass('active');
	});

	$('.select-view div').bind('touchstart', function (e) {
		$('.select-view div').removeClass('selected');
		$(this).addClass('selected');
	});

	$('.select-view .view-missed').bind('touchstart', function (e) {
		$('.map-notice').hide(0);
		$('.map-notice.missed').show(0);
	});

	$('.select-view .view-seen').bind('touchstart', function (e) {
		$('.map-notice').show(0);
		$('.map-notice.missed').hide(0);
	});


	Hammer(document.getElementById('map-main')).on('drag dragend', mapDragHandler);
	Hammer(document.getElementById('map-timeline')).on('drag dragend', mapDragHandler);
});