<html>
    <link href="style.css" rel="stylesheet">
    <head>
        
    </head>
        

    <body style="background-color: rgb(1, 22, 139);" onload="onLoad()">
        <canvas id="canvas" width="500" height="500"></canvas>
        
        <img id="ninja" width="60" height="60" src="ninja_pic3.png" style="display: none;">

        <script>
            //           if(349.5 < 372 || 349.5 > 372 + 51.666666666666664){

            const canvas = document.getElementById('canvas');
            const ctx = canvas.getContext('2d');
            var phase = "waiting";
            var add = 0;
            var addX = 0;
            var addY = 0;
            var addMoveBack = 0;

            var lineTopY = 0;
            var loop = setInterval(animate, 10);
            var rectangleList = [];
            var activeRectangleList = [];
            var sticksList = [];
            var isSuccessfulTry = true;
            canvas.width = window.innerWidth-60;
            canvas.height = window.innerHeight;


            var startPointX = canvas.width/5;
            var ninjaX = startPointX - canvas.width/50;
            var ninjaY = canvas.height/2 - canvas.width/50;

            var img = document.getElementById("ninja");


            window.addEventListener("mousedown", function (event) {
                if(phase == "waiting"){
                    phase = "strech";
                }
            });

            window.addEventListener("mouseup", function (event) {
                if(phase == "strech"){
                    phase = "falling";
                    
                }
            });

            function animate() {
                // canvas.width = window.innerWidth;
                // canvas.height = window.innerHeight; 
                
                // if(phase == "strech"){
                //     strechLine();
                // } else if(phase == "falling"){
                //     dropTheLine();
                // }else if(phase == "walking"){

                // }


                switch(phase){
                    case "strech":
                        strechLine();
                        showNinja();
                        drawAllTheRectangle();
                        break;
                    case "falling":
                        dropTheLine();
                        showNinja();
                        drawAllTheRectangle();
                        break;
                    case "walking":
                        moveNinja()
                        drawSticks()
                        drawAllTheRectangle();
                        break;
                    case "ninjaFalling":
                        drawSticks()
                        dropNinjaAndTheStick()
                        showNinja();
                        drawAllTheRectangle();
                        break;
                    case "movingRectangles":
                        moveRectanglesStickNinja();
                        break;
                }
                
            }


            function strechLine(){
                ctx.clearRect(1,1,canvas.width+1,canvas.height);
                add += 1.5;
                ctx.strokeStyle = 'white';
                ctx.lineWidth = 3;
                ctx.beginPath();
                ctx.moveTo(startPointX, canvas.height / 2-3);
                //ctx.moveTo(canvas.width/5, canvas.height / 2 - 3);

                ctx.lineTo(startPointX, canvas.height/ 2-add);
                ctx.stroke();
                lineTopY = add;
            }


            function dropTheLine(){
                ctx.clearRect(1,1,canvas.width+1,canvas.height+1);
                addX += 0.025;
                //addY += 0.5;
                addXNext = addX + 0.02;

                let newAddX = Math.sin(addX)*lineTopY;
                let newAddY = Math.cos(addX)*lineTopY;
                let newAddYNext = Math.cos(addXNext)*lineTopY;

                // if next step will pass the line - calculate exact value
                if((newAddYNext+canvas.height/2)<=(canvas.height/2 + 3.2)){
                    newAddX = lineTopY;
                    newAddY = 1;
                }

                ctx.strokeStyle = 'white';
                ctx.lineWidth = 3;
                ctx.beginPath();
                ctx.moveTo(startPointX, canvas.height / 2-2);
                ctx.lineTo(startPointX + newAddX,  nY(newAddY+canvas.height / 2));
                ctx.stroke();
                
                if((newAddY+canvas.height/2)<=(canvas.height/2 + 3.2)){
                    phase = "walking";
                    sticksList.push(new Stick(newAddX));
                    isSuccessfulTry = checkIfTheTryIsSuccessful();
                    console.log("isSuccessfulTry:" + isSuccessfulTry)

                }
            }

            function checkIfTheTryIsSuccessful(){
                console.log("start")

                console.log(sticksList[sticksList.length-1].stickLength)
                console.log(activeRectangleList[1].space)
                console.log(activeRectangleList[1].width)
                console.log("end")
                if(sticksList[sticksList.length-1].stickLength < activeRectangleList[1].space || sticksList[sticksList.length-1].stickLength > activeRectangleList[1].space + activeRectangleList[1].width){
            
                    return false;
                }
                return true;
            }
            
            function nY(y){
                return canvas.height-y;
            }

            class Rectangle{
                constructor(){
                    this.heigth = canvas.height / 2;
                    this.width = canvas.width / (Math.floor(Math.random() * 30) + 20);
                    this.space = canvas.width / (Math.floor(Math.random() * 10) + 5);
                    this.posX = 0;
                }
            }

            class Stick{
                constructor(stickLength){
                    this.stickLength = stickLength;
                    this.startX = startPointX;
                }
            }

            function onLoad(){
                createRectangle();
                showNinja(startPointX - canvas.width/50, canvas.height/2 - canvas.width/50);
            }
            
            function createRectangle(){
                rectangleList = [new Rectangle(), new Rectangle(), new Rectangle(), new Rectangle(), new Rectangle()]
                activeRectangleList = rectangleList;
                //drawAllTheRectangle();

                //first time
                var totalSpace = startPointX;
                ctx.fillStyle = "green";

                var n = 0;
                for(var i of rectangleList){
                    if(n == 0){
                        i.posX = startPointX-i.width
                        ctx.fillRect(i.posX, canvas.height-i.heigth, i.width, i.heigth);
                        n += 1;
                    }else{
                        totalSpace += i.space;
                        ctx.fillRect(totalSpace, canvas.height-i.heigth, i.width, i.heigth);
                        i.posX = totalSpace;

                    }
                }

            }

            function drawAllTheRectangle(){
                // var new1 = new Rectangle();
                // ctx.fillStyle = "green";

                // ctx.fillRect(canvas.width/2, canvas.height-new1.heigth, new1.width, new1.heigth);

                ctx.fillStyle = "green";

                var n = 0;
                for(var i of rectangleList){
                    ctx.fillRect(i.posX, canvas.height-i.heigth, i.width, i.heigth);

                }
            }

            function showNinja(){
                ctx.drawImage(img, ninjaX, ninjaY, canvas.width/50, canvas.width/50);
            }

            function moveNinja(){
                ctx.clearRect(1,1,canvas.width+1,canvas.height+1);
                ninjaX += 1.5;
                ctx.drawImage(img, ninjaX, ninjaY, canvas.width/50, canvas.width/50);

                if(isSuccessfulTry){
                    if(ninjaX >= startPointX + activeRectangleList[1].space + activeRectangleList[1].width - canvas.width/50){
                        phase = "movingRectangles";
                    }
                }else if(ninjaX >= startPointX + sticksList[sticksList.length-1].stickLength){
                    phase = "ninjaFalling";
                }
            }

            function drawSticks(){
                var n = 0;
                for(var i of sticksList){
                    if(phase == "ninjaFalling" && n == sticksList.length-1)
                        return;

                    ctx.beginPath();
                    ctx.moveTo(i.startX, canvas.height / 2-3);
                    ctx.lineTo(i.startX + i.stickLength, canvas.height / 2-3);
                    ctx.stroke();
                    n++;
                }
            }

            function dropNinjaAndTheStick(){
                ctx.clearRect(1,1,canvas.width+1,canvas.height+1);
                // ninja fall
                ninjaY += 4;

                // stick fall
                let newAddX = Math.sin(addX)*lineTopY;
                let newAddY = Math.cos(addX)*lineTopY;

                if(newAddX >= 2){
                    addX += 0.025;

                    ctx.strokeStyle = 'white';
                    ctx.lineWidth = 3;
                    ctx.beginPath();
                    ctx.moveTo(startPointX, canvas.height / 2-2);
                    ctx.lineTo(startPointX + newAddX,  nY(newAddY+canvas.height / 2));
                    ctx.stroke();
                }else{
                    ctx.beginPath();
                    ctx.moveTo(startPointX, canvas.height / 2-2);
                    ctx.lineTo(startPointX + newAddX,  nY(newAddY+canvas.height / 2));
                    ctx.stroke();

                }

                if(ninjaY + canvas.width/50 > canvas.height && newAddX <= startPointX){
                    phase = "end";  
                }
            }

            function moveRectanglesStickNinja(){

                // move backwards Rectangles, stick, ninja. move backwards "moveBack"
                let moveBack = activeRectangleList[1].posX + activeRectangleList[1].width;

                var moveBackwards = 2.5;

                if(moveBack>startPointX){
                    //Rectangles
                    ctx.clearRect(1,1,canvas.width+1,canvas.height+1);
                    for(let i of rectangleList){
                        i.posX -= moveBackwards;
                        ctx.fillRect(i.posX, canvas.height-i.heigth, i.width, i.heigth);
                        //console.log(i.posX)
                    }

                    //stick
                    sticksList[sticksList.length-1].startX -= moveBackwards;
                    drawSticks();

                    //ninja
                    ninjaX -= moveBackwards;
                    showNinja()

                }else{
                    phase = "waiting";
                    add = 0;
                    addX = 0;
                    addY = 0;
                    ninjaX = startPointX - canvas.width/50;
                    console.log(activeRectangleList)

                    activeRectangleList = activeRectangleList.slice(1, activeRectangleList.length);
                    console.log(activeRectangleList)
                }
                
            }
            
        </script>

    </body>
    
</html>