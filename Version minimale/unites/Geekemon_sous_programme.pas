unit Geekemon_sous_programme;
  
interface
uses
  System.SysUtils,
  TypePerso,
  GestionFichierTexte,
  ChoixDestination,
  GestionEcran;

procedure nouvellePartie;

implementation




procedure creationGeekedex(var geekedex : pokedex);
var
 i : integer;
 ligne : string;
 geekedexTxt : TextFile;

const
  ADR_GEEKEDEX = '../../data/geekedex.txt';

 Begin
  geekedex[0].id := 0;
  geekedex[0].nom := '';
  geekedex[0].pv := 0.0;
  geekedex[0].resume := '';
  geekedex[0].race := '';
  geekedex[0].ko := true;
  ouvrirFichierTxt(geekedexTxt,ADR_GEEKEDEX,lecture);
  for i:= 1 to 22 do
  begin
    readln(geekedexTxt,ligne);
    geekedex[i].id := StrToInt(RecupDonnee(ligne));
    readln(geekedexTxt,ligne);
    geekedex[i].nom := RecupDonnee(ligne);
    readln(geekedexTxt,ligne);
    geekedex[i].resume := RecupDonnee(ligne);
    readln(geekedexTxt,ligne);
    geekedex[i].race := RecupDonnee(ligne);
    geekedex[i].ko := false;
    readln(geekedexTxt,ligne);;
    readln(geekedexTxt,ligne);
    readln(geekedexTxt,ligne);
    readln(geekedexTxt,ligne);
    readln(geekedexTxt,ligne);
    readln(geekedexTxt,ligne);
    geekedex[i].pv := 150;
  end;
  fermerFichierTxt(geekedexTxt);
End;

procedure creationPnj(var t : pnj;geekedex : pokedex);
var
  i,j : integer;
  chaine : string;
  dresseurTxt : textFile;

const
  ADR_DRESSEUR : string = '../../data/dresseur.txt';

Begin
  ouvrirFichierTxt(dresseurTxt,ADR_DRESSEUR,lecture);
  for i:= 1 to 10 do
  begin
    readln(dresseurTxt,chaine);
    t[i].id := StrToInt(RecupDonnee(chaine));
    readln(dresseurTxt,chaine);
    t[i].nom := RecupDonnee(chaine);
    for j := 1 to 4 do
    begin
    readln(dresseurTxt,chaine);
    t[i].equipe[j] := geekedex[StrToInt(RecupDonnee(chaine))];
    end;
    readln(dresseurTxt,chaine);
    t[i].nbGkmn := StrToInt(RecupDonnee(chaine));
    readln(dresseurTxt,chaine);
    t[i].texte := RecupDonnee(chaine);
    readln(dresseurTxt,chaine);
    t[i].recompense := StrToInt(RecupDonnee(chaine));
    readln(dresseurTxt,chaine);
  end;
  fermerFichierTxt(dresseurTxt);
End;

procedure creationPerso(var perso : joueur;geekedex : pokedex);
var
  rep,rep2,i : integer;
  sortie,sortie2 : boolean;
  nom : string;
Begin
 //Introduction
 repeat
  //effacerEcran();
  perso.emplacement := Secretariat;
  effacerEcran;
  writeln('Timidement, sac-à-dos à l''épaule, vous rentrez dans le secrétariat. Derrière un grand bureau blanc, une femme est penchée sur son ordinateur. En vous entendant rentrer, elle se tourne vers vous.');
  writeln;
  writeln('"Oui bonjour, c''est pour quoi ?"');
  writeln;
  writeln('       1 - "Bonjour, je suis bien au département DDG ?"');
  sortie := false;
  readln(rep);
  if rep=1 then sortie := true;
 until sortie = true ;

 //Choix du pseudo
 sortie:=false;
 while not(sortie) do
 begin
  //effacerEcran();
  effacerEcran;
  writeln('La secrétaire vous souris et repond :');
  write('"Oui. Ah ! Vous devez être le nouvel étudiant. Thérèse, je suis la secrétaire du département. Vos parents nous ont appelé pour nous dire que vous ne pourriez pas être présent à la journée de rentrée. J''ai besoin que vous remplissiez quelques papiers pour');
  writeln('finir votre inscription. Vous pouvez me rappeler votre nom ? "');
  writeln('Quel est ton nom ?');
  readln(nom);
  writeln('Es-tu sûr de t''appeler ',nom,' ? On sait jamais, une erreur est si vite arrivée...');
  writeln('1 - Oui');
  writeln('2 - Non');
  readln(rep);
  if rep = 1 then
  begin
      sortie := true;
      perso.pseudo := nom;
  end;
  perso.argent := 400;
  perso.nbPotion := 5;
 end;

 //Choix du premier Geekemon
 sortie := false;
 while not(sortie) do
 begin
   repeat
   begin
   //effacerEcran();
   perso.emplacement := Bureau;
   effacerEcran;
   writeln('"Bienvenue dans le département DDG : Dressage De Geekemon. Ici, tu apprendras à devenir un dresseur de geekemons. Mais attention, un grand nombre de ces créatures vivent à l''état sauvage dans ce bâtiment. Si tu veux pouvoir te promener en toute sécurité,','il te faut un premier geekemon. Tu as de la chance, il m''en reste trois. Je te laisse choisir. "');
   writeln('Le professeur Ramp place trois geekeballs sur son bureau');
   writeln('Geekeball 1 : ',geekedex[1].nom,', ',geekedex[1].race);
   writeln('Geekeball 2 : ',geekedex[2].nom,', ',geekedex[2].race);
   writeln('Geekeball 3 : ',geekedex[3].nom,', ',geekedex[3].race);
   writeln('Lequel de ces geekemons voulez-vous ?');
   readln(rep2);
   sortie2:=True;
   case rep2 of
      1 : rep2 := 1;
      2 : rep2 := 2;
      3 : rep2 := 3;
      else sortie2 := false;
   end;
   end;
   until sortie2=True;
   writeln('Es-tu sûr de ton choix ? Il ne sera pas réversible');
   writeln('1 - Oui');
   writeln('2 - Non');
   readln(rep);
   if rep = 1 then
  begin
      sortie := true;
      perso.equipe[1] := geekedex[rep2];
      for i := 2 to 4 do perso.equipe[i] := geekedex[0];
      perso.nbGkmn := 1

  end;
 end;
  //Surnom du geekemon ?
  //effacerEcran();
  effacerEcran;
  writeln('Veux-tu donner un surnon à ton nouveau geekemon ?');
  writeln('1 - Oui');
  writeln('2 - Non');
  readln(rep);
  if rep = 1 then
  begin
      writeln('Quel sera son surnom ?');
      readln(nom);
      perso.equipe[1].nom := nom;
      attendre(1000);
      writeln('Ton ', geekedex[perso.equipe[1].id].nom,' s''appelle désormais ', perso.equipe[1].nom,'.');
      readln;
  end;

 //Debut de l'aventure
 //effacerEcran();
 effacerEcran;
 writeln('Il est maintenant temps pour toi, ', perso.pseudo,' de partir à l''aventure, aidé de tes geekemons pour combler ta curiosité !',' Comme chaque débutant, tu disposes de 5 potions et 4 euros pour bien commencer, tu peux acheter plus de potion dans la salle de l''ETDDG');
 attendre(1500);
 writeln('Appuyer sur Entrée pour continuer...');
 readln;
end;

procedure nouvellePartie;
var
  perso : joueur;
  geekedex : pokedex;
  adversaire : pnj;
Begin
  creationGeekedex(geekedex);
  creationPnj(adversaire,geekedex);
  creationPerso(perso,geekedex);
  choisirSalle(perso,adversaire,geekedex);
  readln;
end;
end.
