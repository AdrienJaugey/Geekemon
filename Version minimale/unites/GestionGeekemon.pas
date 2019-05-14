unit GestionGeekemon;

interface
uses
  TypePerso,GestionEcran;
procedure SoignerEquipe(var perso : joueur;geekedex : pokedex);
function GkmnEnVie(gkmn : geekemon):boolean; //Renvoie true si le geekemon n'est pas K.O.
function EquipeEnVie(var equipe : EquipeGeekemon):boolean; //Renvoie true si l'équipe peut aller au combat
procedure CheckEtatJoueur(var perso : joueur); //Définit si un joueur peut combattre ou non
procedure Capturer(var perso : joueur; gkmnSauvage : geekemon); //Permet de capturer un geekemon
procedure Echange(var gkmn1 : geekemon;var gkmn2 : geekemon); //Echange de place 2 geekemons
function ChangementGkmnCombat(var perso : joueur;droitAnnuler : boolean):boolean; //Remplace le geekemon au combat par un autre de l'équipe


implementation
uses
  Geekemon_sous_programme,choixDestination;
procedure SoignerEquipe(var perso : joueur;geekedex : pokedex);
var
  i,j : integer;
Begin
  for i := 1 to 4 do
  begin
    if perso.equipe[i].id <> 0 then
    begin
      perso.equipe[i].pv := 150;
      perso.equipe[i].ko := false;
    end
    else
    begin
      perso.equipe[i].pv := 0;
      perso.equipe[i].ko := true;
    end;
  end;
End;

function GkmnEnVie(gkmn : geekemon):boolean;
Begin
  if gkmn.pv <= 0 then Result := false
                  else Result := true;
End;

function EquipeEnVie(var equipe : EquipeGeekemon):boolean;
var
  i,nbGkmnKo : integer;
Begin
  nbGkmnKo := 0;
  for i:=1 to 4 do
  begin
    if not(GkmnEnVie(equipe[i])) then
    begin
    nbGkmnKo := nbGkmnKo + 1;
    //writeln('Geekemon n°',i,' est mort');
    //readln;
    equipe[i].pv := 0.0;
    end;
  end;
  if nbGkmnKo = 4 then Result := false
                  else Result := true;
End;

procedure CheckEtatJoueur(var perso : joueur);
Begin
  if not(EquipeEnVie(perso.equipe)) then perso.combat := false
  else perso.combat := true;;
End;

procedure Capturer(var perso : joueur; gkmnSauvage : geekemon);
var
  i : integer;
Begin
  if (perso.nbGkmn <= 3) then
  begin
    perso.equipe[perso.nbGkmn + 1] := gkmnSauvage;
    perso.nbGkmn := perso.nbGkmn + 1;
  end
  else
  begin
    writeln('Le Geekemon est stocker dans le PC');
  end;
End;

procedure Echange(var gkmn1 : geekemon;var gkmn2 : geekemon);
var
  gkmnTemp : geekemon;
Begin
  gkmnTemp := gkmn1;
  gkmn1 := gkmn2;
  gkmn2 := gkmnTemp;
End;

function ChangementGkmnCombat(var perso : joueur;droitAnnuler : boolean):boolean;
var
  rep : integer;
  sortie,action,possible : boolean;
Begin
  possible := false;
  action := false;
  repeat
  effacerEcran;
  writeln('Par qui veux-tu remplacer ',perso.equipe[1].nom,' ?');
  writeln('1 - ',perso.equipe[2].nom);
  writeln('2 - ',perso.equipe[3].nom);
  writeln('3 - ',perso.equipe[4].nom);
  if droitAnnuler then writeln('4 - Annuler');
  readln(rep);
  case rep of
    1,2,3 : begin
              possible := GkmnEnVie(perso.equipe[rep+1]);
              sortie := GkmnEnVie(perso.equipe[rep+1]);
              if not(sortie) then writeln('Impossible');
            end;
    else if (droitAnnuler) and (rep = 4)then sortie := true;
  end;
  until sortie;
  if possible then Echange(perso.equipe[1],perso.equipe[rep+1]);
  Result := possible;
End;
end.
