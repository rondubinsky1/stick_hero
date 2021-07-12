
function playTheGame(){
    if(phase=="waiting"){
        mousedownEvent();
    }else if(add > activeRectangleList[1].space + (activeRectangleList[1].width / 2 - middleWidth/2)){
        mouseupEvent(); 
    }
}


function mousedownEvent() {
    var clickEvent = document.createEvent ('MouseEvents');
    clickEvent.initEvent ("mousedown", true, true);
    document.body.dispatchEvent (clickEvent);
}

function mouseupEvent() {
    var clickEvent = document.createEvent ('MouseEvents');
    clickEvent.initEvent ("mouseup", true, true);
    document.body.dispatchEvent (clickEvent);
}


var start = setInterval(playTheGame, 10)