int backgroundBlocks = 35; // Grootte van elk blok in de achtergrond
int xBackground = 17; // Aantal blokken in de breedte
int yBackground = 15; // Aantal blokken in de hoogte
int xApple = 1; //Appel x
int yApple = -1; //Appel y
int appleSize = 25; //Appel grootte
int score = 0; //Eindscore
int snakeLength = 1; //Lengte
int snakeSize = 30; //Snake grootte
int horizonKaart = xBackground * backgroundBlocks; //totaal X map
int verticaalKaart = yBackground * backgroundBlocks; //totaal Y map

float speed = 5; //slang snelheid
float dx = speed; //X change
float dy = 0; //Y change
float [] xSnake = new float [1792]; //17 x 15 = 255 //255 x 7(++) = 1792
float [] ySnake = new float [1792]; //15 x 17 = 255 //255 x 7(++) = 1792
float xScore = 200; //X-co score
float yScore = 250; //Y-co score
float xGO = 220; //X-co game over
float yGO = 320; //Y-co game over

boolean beginMoving = false; //Slang begin beweging
boolean gameOver = false; //Dood


String lastKey = ""; //Slaat keys op & begin startMoving();


void setup() {
  size(597, 526);  
  randomiseAppleLocation(); //Appels in de map spawnen
  drawBackgroundBlocks(); //Map tekenen 35x35 blokken  
  placeSnake(); //Slang op de map
}

void draw() {
  if (!gameOver) { //Spel actief
  snakeDirection(); //Slangrichting bepalen
  if (beginMoving) { //Kijken of de slang moet beginnen met bewegen
  snakePosition(); //Update de slang positie
  snakeCollision(); //Slang botsingen
  } 
  drawBackgroundBlocks(); //Achtergrond tekening
  drawApple(); //Appel tekening
  drawSnake(); //Slang tekening
  }else {
  gameOver();  //Voer gameover uit
  }
}

void drawBackgroundBlocks() { //Achtergrond
  noStroke(); //Geen lijnen tussen de map

  for (int i = 0; i < xBackground; i++) { //Breedte blokken
    for (int j = 0; j < yBackground; j++) { //Hoogte blokken

      int xWaarde = i * backgroundBlocks; //Breedte blokken x grootte van achtergrond blokken
      int yWaarde = j * backgroundBlocks; //Hoogte blokken x grootte van achtergrond blokken

      if ((i + j) % 2 == 0) { //Background kleur patroon
        fill(#06b500);
      } else {
        fill(#32e600);
      }
      rect(xWaarde, yWaarde, backgroundBlocks, backgroundBlocks); //Hokjes (i en j zorgen ervoor dat het zo een patroon is)
    }
  }
}

void drawApple() { //Appel tekenen
  
  fill(179, 0, 0); //Apple kleur
  ellipse(xApple, yApple, appleSize, appleSize); //Apple
  
  if (dist(xSnake[0]+17, ySnake[0]+17, xApple, yApple) < appleSize / 2 + 15){ //Als de afstand tussen het hoofd van de slang en de appel kleiner is dan de appel (15 px)
    snakeLength += 7; //Slang krijgt 7 slangdelen erbij (1hokje) als de distance tussen het hoofd en de appel 15 px is
    score++; //+1 score wanneer de distance tussen het hoofd en de appel 15 px is
    randomiseAppleLocation(); //Spawn appel op een random positie van de map als de distance tussen het hoofd en de appel 15 px is
  }
}

void randomiseAppleLocation(){ //Appel spawns
  int withinX = (horizonKaart - backgroundBlocks) / backgroundBlocks; //((17 x 35) - 35) / 35 (zodat het binnen de map spawned)
  int withinY = (verticaalKaart - backgroundBlocks) / backgroundBlocks; //((15 x 35) - 35) / 35 (zodat het binnen de map spawned)

  boolean validPosition = false;

  while (!validPosition) { //Blijft verder gaan tot appel positie valid is
    xApple = (int)(random(0, withinX)) * backgroundBlocks + backgroundBlocks / 2; //(random positie tussen 0 en x) (spawnen in de map) (spawnen in midden van hokje)
    yApple = (int)(random(0, withinY)) * backgroundBlocks + backgroundBlocks / 2; //(random positie tussen 0 en y) (spawnen in de map) (spawnen in midden van hokje)

    validPosition = true; 

    for (int i = 0; i < snakeLength; i++) {
      
      if (xApple == xSnake[i] + 17 && yApple == ySnake[i] + 17) { //Appel niet in slang spawnen
        validPosition = false; //Appelspawn = slang deel = validPosition false = break; (while)
        break; 
      }
    }
  }
}


void placeSnake(){ //Begin 1 hoofd elk slang deel begin op zelfde positie
 xSnake[0] = 350; // Hoofd x positie
  ySnake[0] = 350; // Hoofd y positie
  
  for (int i = 0; i < snakeLength; i++) { //Slang stuk bij einde van lichaams deel
    xSnake[i] = xSnake[0]; //X positie van elk stuk slang
    ySnake[i] = ySnake[0] + (snakeSize * i); //Y positie van elk stuk slang
  }
}

void drawSnake() { //Slang tekenen
  fill(98, 191, 245); //Snake kleur
  
  for (int i = 0; i < snakeLength; i++){
  ellipse(xSnake[i]+17, ySnake [i]+17, snakeSize, snakeSize); //arrays save x y van elk deel. 
  }

  fill(255, 255, 255); //Oogballen
  ellipse(xSnake[0]-3+17, ySnake[0]+9+17, 10, 10);
  ellipse(xSnake[0]-3+17, ySnake[0]-8+17, 10, 10);

  fill(133, 11, 122); //Ooglens
  ellipse(xSnake[0]-3+17, ySnake[0]+9+17, 5, 5);
  ellipse(xSnake[0]-3+17, ySnake[0]-8+17, 5, 5);
}

void snakePosition() { //Houdt slang positie bij
  for (int i = snakeLength; i > 0; i--){ //als i groter is dan 0 word elk slang deel verplaatst naar het deel daarvoor
  xSnake[i] = xSnake[i-1]; //Verplaats x deel met laatste x deel
  ySnake[i] = ySnake[i-1]; //Verplaats y deel met laatste y deel
  }
  xSnake[0] += dx; //x positie (-1 zorgt ervoor dat het niet in elkaar is)
  ySnake[0] += dy; //y positie (-1 zorgt ervoor dat het niet in elkaar is)
}

void startMoving(){ //Start slangbeweging
  beginMoving = true;
  snakeDirection(); //Knows moving direction
}

void keyPressed() {  
    if (keyCode == 37) {
    lastKey = "LEFT";
    startMoving(); //Als de linker arrow (37) wordt ingedrukt dat de slang naar links beweegt.
  } else if (keyCode == 38) {
    lastKey = "UP";
    startMoving(); //Als de up arrow (38) wordt ingedrukt dat de slang naar boven beweegt.
  } else if (keyCode == 39) {
    lastKey = "RIGHT";
    startMoving(); //Als de rechter arrow (39) wordt ingedrukt dat de slang naar rechts beweegt.
  } else if (keyCode == 40) {
    lastKey = "DOWN";
    startMoving(); //Als de down arrow (40) wordt ingedrukt dat de slang naar beneden beweegt.
  }
}


void snakeDirection() { //Richting bepalen
  if (xSnake[0] % 35 == 0 && ySnake[0] % 35 == 0) { //Laat het precies in de hokjes bewegen
    if (lastKey == "LEFT" && dx != speed) {
      dx = -speed; // Negative x waarden = links
      dy = 0; //Niet omhoog of omlaag
    } 
    else if (lastKey == "UP" && dy != speed) {
      dx = 0; //Niet links of rechts
      dy = -speed; //Negative y waarde = omhoog
    } 
    else if (lastKey == "RIGHT" && dx != -speed) {
      dx = speed; // positive x waarden = rechts
      dy = 0; //Niet omhoog of omlaag
    } 
    else if (lastKey == "DOWN" && dy != -speed) {
      dx = 0; // Niet naar links of rechts
      dy = speed; //positive y waarden = omlaag
    }
  }
}

void gameOver(){
  fill(#424744); //Donker grijze kleur
  textSize(50); //Tekst grote (50px)
  textAlign(CENTER); //Tekts in de midden van de map
  
   float xScore = width / 2; //score midden x
   float yScore = height / 2 - 30; //score 30 px hoger dan het midden
   float xGO = width / 2; //gameover text midden x
   float yGO = height / 2 + 30; //gameover text 30 px lager dan het midden 
   text("Score: " + score, xScore, yScore); //Text Score met de score van de amount of appels dat je hebt gegeten er naast

if (score < 10) { //Als je minder dan 10 appels hebt gegeten dan is de text "Quit the game." en als het 10 of hoger is dan zegt het "Game over!"
  text("Quit the game.", xGO, yGO);
} else if (score >= 10) {
  text("Game over!", xGO, yGO);
}
  
  noLoop(); //Zorgt ervoor dat de game helemaal stopt en de draw niet meer herhaalt want dan ben je dood
}

void snakeCollision(){ //Botsingen
  if (xSnake[0] < 0 || xSnake [0] >= horizonKaart || ySnake[0] < 0 || ySnake[0] >= verticaalKaart){ //Als xSnake kleiner is dan 0 of xSnake gelijk/groter is dan horizonKaart (zelfde met y)
  gameOver = true;
  }
  for (int i = 1; i < snakeLength; i++){ 
    if(xSnake[0] == xSnake[i] && ySnake[0] == ySnake[i]){ //Als de xSnake en ySnake van de hoofd van de slang gelijk zijn als de x en y van de lichaams delen dan is het spel afgelopen
    gameOver = true;
    }
  }
}
