// SVG stuff
var range = document.getElementById('range');
var bg = document.getElementById('counter');
var ctx = ctx = bg.getContext('2d');
var imd = null;
var circ = Math.PI * 2;
var quart = Math.PI / 2;

ctx.beginPath();
ctx.strokeStyle = '#99CC33';
ctx.lineCap = 'square';
ctx.closePath();
ctx.fill();
ctx.lineWidth = 10.0;

imd = ctx.getImageData(0, 0, 240, 240);

var draw = function(current) {
    ctx.putImageData(imd, 0, 0);
    ctx.beginPath();
    ctx.arc(120, 120, 70, -(quart), ((circ) * current) - quart, false);
    ctx.stroke();
}

range.addEventListener('movemove', function() {
        draw(this.value / 100);
});
