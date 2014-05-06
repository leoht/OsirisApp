var scroll_posXGrid = 0, scroll_xLastGrid = 0;

$(function () {

	Hammer(document.getElementById('timeline-scroller')).on('drag', function (e) {
		switch(e.type) {
			case 'drag' :
				scroll_posXGrid = e.gesture.deltaX + scroll_xLastGrid;

				if (-scroll_posXGrid < 0 ) return;

				console.log(scroll_posXGrid)

				$('.scroller').css('transform', 'translateX(' + scroll_posXGrid  +'px) translateZ(0px)' );
				$('.grid-timeline').css('transform', 'translateX(' + (-scroll_posXGrid)  +'px)' );
				break;
			case 'dragend' :
				scroll_xLastGrid = scroll_posXGrid;
				// $('.timeline-body').animate({ left: '-=100px' }, 200);
				break;
			
		}
	});

});