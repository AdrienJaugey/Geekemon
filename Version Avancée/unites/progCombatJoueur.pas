unit progCombatJoueur;

interface
uses
  System.SysUtils,
  ProgCombatAdversaire,
  TypePerso;

function attaque (attaquant : string;nom : string ; pv : real; force : integer; agi : integer; carac : caracteristique) : real;
function capture(pv : real; pvmax : real) : boolean ;
function potion(pv : real; pvmax : real; niveau : integer): real;
function coupCritique(attaquant: string;agilite : integer):real;
function attaqueElementaire(attaquant : string;nom : string ; pv : real; force : integer; agi : integer; carac : caracteristique;element1 : integer ; element2 : integer): real ;
procedure Fin(var perso : joueur; var adversaire : pnj ; var geekedex : pokedex);
implementation
uses
  Localisation;

function coupCritique(attaquant : string ; agilite : integer):real; //fonction permettant de faire des coup critique influencer par le taux d'agilite
var
chance : real;
Begin
  chance := 0.5*agilite;
  randomize();
  if random(100)+1 <= chance then
  begin
  Result := 1.5;
  writeln(attaquant,' a fait un coup critique !');
  end
  else Result := 1.0;
End;

function attaque (attaquant : string;nom : string ; pv : real; force : integer; agi : integer; carac : caracteristique) : real;  //Fonction qui permet de déterminer les dégats en fonction des type des geekemons
var
  degats : real;
begin
  randomize;
  if carac = agilite then
  degats := (agi*2+random(11))*coupCritique(attaquant,agi)       //Cas où le geekemons est de type agilite
  else
  degats := (force*3+random(11))*coupCritique(attaquant,agi) ;   //Cas où le geekemon est de type force
  writeln(nom,' a subit ',degats:0:2,' dégats');
  pv := pv - degats;
  result := pv;
end;

function capture(pv : real;pvmax : real) : boolean ;    //Fonction permttant de savoir si la tentative de capture à réussi ou pas
var
  chance : real;
  reussi : integer;
begin
  randomize;
  reussi := random(100)+1;
  if pv> pvmax/2 then                   // Lorsque le geekemon sauvage a plus de la moitier de ses pv la chance est faible
  begin
      chance := 15*(1+((pvmax-pv)/pvmax));
  end
  else
    chance := 40*(1+((pvmax-pv)/pvmax));         //Lorsque le geekemons à moin de la moitier de ses pv la chance augmente considérablement
  if chance > reussi then
  begin
    writeln('vous avez capturé le Geekemon. Bravo !');
    result := true;
  end
  else
  begin
    writeln('La capture du Geekemon à échoué...') ;
    result := false
  end;
  end;
function potion(pv : real;pvmax : real; niveau : integer): real;     //Fonction permettant de déterminer la valeur des soins de la potion influencé en fonction du niveau
var
  potion : integer;
begin
  potion := 60+20*niveau;
  if pv < pvmax-potion then
  begin
    result :=  potion  ;
  end
  else
  begin
    result := (pvmax - pv) ;
  end;
end;
function attaqueElementaire(attaquant : string;nom : string ; pv : real; force : integer; agi : integer; carac : caracteristique;element1 : integer ; element2 : integer): real; //fonction permettant de déterminer de la valeur de l'attaque élementaire d'un geekemon lorsqu'il tape sur un élement fort, faible ou neutre
var
  degats : real;
begin
  if (element1 = 2*element2) OR ((element1=2)AND (element2=8))   then          //Element 2  = Eau, Element 4 = Feu, Element 8 = Plante
  begin
    writeln('c''est super efficace !');
    randomize;
    if carac = agilite then                                                   //Augmente les dégats lorsque l'on tape sur un élement plus faible que le sien
    degats := 1.5*(agi*2.5+random(11))*coupCritique(attaquant,agi)
    else
    degats := 1.5*(force*3.5+random(11))*coupCritique(attaquant,agi) ;
    writeln(nom,' a subit ',degats:0:2,' dégats');
  end
  else
  if (element1 = element2/2) OR ((element1=8)AND (element2=2))then
  begin
    writeln('ce n''est pas très efficace !');
    randomize;
    if carac = agilite then                                                   //Réduit les dégat lorque l'on tape sur un élement plus fort que le sien
    degats := (agi*2.5+random(11))*coupCritique(attaquant,agi)/1.5
    else
    degats := (force*3.5+random(11))*coupCritique(attaquant,agi)/1.5 ;
    writeln(nom,' a subit ',degats:0:2,' dégats');
  end
  else
  begin
    if carac = agilite then
    degats := (agi*2.5+random(11))*coupCritique(attaquant,agi)
    else                                                                  //N'influence pas les dégats lorsque les élement sont identique
    degats := (force*3.5+random(11))*coupCritique(attaquant,agi) ;
    writeln(nom,' a subit ',degats:0:2,' dégats');
  end;
  pv := pv - degats;
  result := pv;


end;
procedure Fin(var perso : joueur; var adversaire : pnj ; var geekedex : pokedex);    //Procedure de fin de quete principale avec récompense après avoir battu le dernier boss
var
rep : integer;
begin
  writeln(adversaire[10].nom,' : - Tu m''a peut-être battu cette fois mais je reste le plus fort !!!!');
  if perso.quete = false then  //Regarde si la quete a déjà été réaliser une fois
  begin
  Writeln('Secrétaire : - Bien joué tu as vaincu le Chimiste Fou, grace à toi aucune expérience ne sera jamais réalisé sur les geekemons!!');
  writeln;
  Writeln('Professeur Ramp : - Bien joué ',perso.pseudo,' pour te récompenser je vais augmenter le gain d''expérience de tes geekemons par 2 et tu obtien le titre de maitre de l''iut');
  perso.quete := true;        //Multiplie les stats par 2 en cas de première victoire contre le boss
  perso.pseudo := 'Maitre IUT '+perso.pseudo;
  end;
  readln;
  choisirSalle(perso,adversaire,geekedex);

end;
end.
