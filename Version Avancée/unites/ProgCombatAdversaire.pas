unit ProgCombatAdversaire;

interface
uses
TypePerso;
function action():integer ;
procedure changeGeekemonAdv(var gkmn1 : geekemon;var gkmn2 : geekemon;var gkmn3 : geekemon;var gkmn4 : geekemon);
procedure niveauAdv(var adv : dresseur; perso : joueur);
procedure statsdresseur (var adversaire : dresseur);
function niveauMoyen(perso: joueur) : integer;
procedure bossFinal(var adversaire : dresseur);
implementation
uses
progCombatJoueur;
function action () : integer ;      //Determine un chiffre entre 0 et 1 qui détermine l'action de l'adversaire

begin
  randomize;
 result := random(2)
end;

procedure changeGeekemonAdv(var gkmn1 : geekemon;var gkmn2 : geekemon;var gkmn3 : geekemon;var gkmn4 : geekemon); //Procedure qui échanage les geekemons adverser au fur et à mesure que ceux ci meurt
var
  gkmntemp : geekemon ;
begin
  gkmntemp := gkmn1 ;
  gkmn1 := gkmn2;
  gkmn2:=gkmn3;
  gkmn3:=gkmn4;
  gkmn4:=gkmn1;
end;
function niveauMoyen(perso: joueur) : integer;    //Calcul le niveau moyen de l'quipe du joueur afin de modifier les niveau des geekemons adverse en fonction de celui-ci
var
 somme,moyen,i,j : integer;
begin
  somme := 0;
  moyen := 0;
  j := 0;
  for i := 1 to 4 do
  begin
    if not(perso.equipe[i].id = 0) then
    begin
    somme := somme + perso.equipe[i].niveau;   //Calcul la somme des niveau et compte le nombre de geekemons que l'on possède
    j := j+1;
    end;
  end;
  moyen := somme div j;
  result := moyen
end;
procedure niveauAdv(var adv : dresseur ; perso : joueur);  //Modifie le niveau des adversaire en fonction du niveau moyen
var
 niv,nb : integer;
begin
 niv := niveauMoyen(perso);
 nb := adv.nbGkmn;
 case nb of
   2:
   begin
   if niv > 1 then
   begin
    adv.equipe[1].niveau := niv -1;
    adv.equipe[2].niveau := niv +1;
   end
   else
   begin
    adv.equipe[1].niveau := niv;
    adv.equipe[2].niveau := niv + 1;
   end;
   end;
   3:
      begin
   if niv > 1 then
   begin
    adv.equipe[1].niveau := niv -1;
    adv.equipe[2].niveau := niv;
    adv.equipe[3].niveau := niv +1;
   end
   else
   begin
    adv.equipe[1].niveau := niv;
    adv.equipe[2].niveau := niv;
    adv.equipe[3].niveau := niv +1;
   end;
   end;
   4:
         begin
   if niv > 2 then
   begin
    adv.equipe[1].niveau := niv -2;
    adv.equipe[2].niveau := niv -1;
    adv.equipe[3].niveau := niv +1;
    adv.equipe[4].niveau := niv +2;
   end
   else
   begin
    adv.equipe[1].niveau := niv;
    adv.equipe[2].niveau := niv;
    adv.equipe[3].niveau := niv +1;
    adv.equipe[4].niveau := niv +2;
   end;
   end;
 end;
 statsdresseur(adv);
end;
procedure statsdresseur (var adversaire : dresseur);    //Détermine les caracteristique des adversaire en fonction du niveau qu'ils ont
var
  i : integer;
begin
  for i :=1 to 4 do
  begin
    case adversaire.equipe[i].carac of
    force :
    begin
      adversaire.equipe[i].strength := 15+5*adversaire.equipe[i].niveau;
      adversaire.equipe[i].endu := 8+2*adversaire.equipe[i].niveau;
      adversaire.equipe[i].agi := 8+2*adversaire.equipe[i].niveau;                  //Cas d'un adversaire de type force
      adversaire.equipe[i].pvmax := adversaire.equipe[i].endu*10;
      adversaire.equipe[i].pv := adversaire.equipe[i].pvmax;
    end;
    agilite :
    begin
      adversaire.equipe[i].agi := 15+5*adversaire.equipe[i].niveau;
      adversaire.equipe[i].endu := 8+2*adversaire.equipe[i].niveau;
      adversaire.equipe[i].strength := 8+2*adversaire.equipe[i].niveau;
      adversaire.equipe[i].pvmax := adversaire.equipe[i].endu*10;                   //Cas d'un adversiare de type agilite
      adversaire.equipe[i].pv := adversaire.equipe[i].pvmax;
    end;
    endurance :
    begin
      adversaire.equipe[i].endu := 15+5*adversaire.equipe[i].niveau;
      adversaire.equipe[i].strength := 8+2*adversaire.equipe[i].niveau;
      adversaire.equipe[i].agi := 8+2*adversaire.equipe[i].niveau;               //Cas d'un adversaire de type endurance
      adversaire.equipe[i].pvmax := adversaire.equipe[i].endu*10;
      adversaire.equipe[i].pv := adversaire.equipe[i].pvmax;
    end;
    end;
  end;
end;
procedure bossFinal(var adversaire : dresseur);
begin
  adversaire.equipe[1].niveau := 28;
  adversaire.equipe[2].niveau := 29;        //Initialise les niveau des geekemons du boss final
  adversaire.equipe[3].niveau := 31;
  adversaire.equipe[4].niveau := 35;
end;

end.
