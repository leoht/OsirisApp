var scroll_posXGrid = 0, scroll_xLastGrid = 0;

var scrollTouchBounds = function (offset, direction) {
	return (offset <= 0 && direction == 'left') 
			|| (offset + $('.scroller').width() >= window.innerWidth && direction == 'right');
};

$(function () {

	Hammer(document.getElementById('timeline-scroller')).on('drag', function (e) {
		switch(e.type) {
			case 'drag' :
				

				var offset = $('.scroller').offset().left;

				if (scrollTouchBounds(offset, e.gesture.direction)) return;

				scroll_posXGrid = e.gesture.deltaX + scroll_xLastGrid;

				$('.scroller').css('transform', 'translateX(' + scroll_posXGrid  +'px) translateZ(0px)' );
				$('.grid-timeline').css('transform', 'translateX(' + (-scroll_posXGrid)  +'px) translateZ(0px)' );
				break;
			case 'dragend' :
				scroll_xLastGrid = scroll_posXGrid;
				// $('.timeline-body').animate({ left: '-=100px' }, 200);
				break;
			
		}
	});

});