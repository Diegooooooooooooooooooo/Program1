int getal;

void setup(){

println(functie(16,32));
getal = functie(32,64);
println(getal);
}

void draw(){

}

int functie(int hoeveelheid1, int hoeveelheid2){
  int antwoord;
 antwoord = (hoeveelheid1 + hoeveelheid2) / 2;
  return antwoord;
  
  }
