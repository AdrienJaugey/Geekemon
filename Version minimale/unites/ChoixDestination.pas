unit ChoixDestination;

interface
uses SysUtils, Windows,TypePerso, Combat, GestionEcran, GestionGeekemon;


procedure choisirSalle(var perso : joueur; var adversaire : pnj; geekedex : pokedex);
procedure salleetddg(var perso : joueur;var  adversaire : pnj ; var geekedex : pokedex);
procedure salleetddgchoix(var perso : joueur;var adversaire : pnj ; var geekedex : pokedex);
procedure cafeteria(var perso : joueur;var adversaire : pnj; var geekedex : pokedex);
implementation

procedure allerSalle(var perso : joueur; var adversaire : pnj ; var geekedex : pokedex);
begin
  if ((perso.equipe[1].pv>0) or (perso.equipe[2].pv>0) or (perso.equipe[3].pv>0) or (perso.equipe[4].pv>0))  then MatchSauvage(perso,adversaire,geekedex)
  else
  begin
  writeln('Votre Geekemon n''a pas de pv et ne peut pas aller au combat, vous devez vous reposez dans l''ETDDG');
  readln;
  choisirSalle(perso,adversaire,geekedex);
  end;
end;

procedure choisirSalle(var perso : joueur; var adversaire : pnj; geekedex : pokedex);
var
  choix1,choix2:integer;
  sortie : boolean;
begin
  effacerEcran;
  Writeln('Où voulez-vous aller ?');
  Writeln('1 - Salle de l''ETDDG');
  Writeln('2 - La cafétéria');
  writeln('3 - A quelles autres salles ai-je accès ?');
  readln(choix1);
if choix1=1 then
begin
  salleetddg(perso,adversaire,geekedex);
end;
if choix1=2 then
begin
effacerEcran();
cafeteria(perso,adversaire,geekedex);
end
else if choix1=3 then
  repeat
  Begin
    effacerEcran;
    Writeln('Choisissez la salle où vous vouler aller :');
    writeln('    1 - Salle R24     2 - Salle R29   3 - Salle R30    4 - Salle R31');
    writeln('    5 - Salle 147     6 - Salle 148   7 - Salle 149    8 - Salle 150');
    writeln('    9 - Salle 201    10 - Salle 202  11 - Salle 203   12 - Salle 206');
    writeln('   13 - Amphithéatre');
    readln(choix2);
    sortie := true;
    case choix2 of
      1   : perso.emplacement := R24;
      2   : perso.emplacement := R29;
      3   : perso.emplacement := R30;
      4   : perso.emplacement := R31;
      5   : perso.emplacement := S147;
      6   : perso.emplacement := S148;
      7   : perso.emplacement := S149;
      8   : perso.emplacement := S150;
      9   : perso.emplacement := S201;
      10  : perso.emplacement := S202;
      11  : perso.emplacement := S203;
      12  : perso.emplacement := S206;
      13  : perso.emplacement := Amphi;
      else sortie := false
    end;
    effacerEcran;
    writeln('Vous prenez alors vos affaires et vous déplacez jusqu''à cette salle.');
    attendre(1000);
    writeln;
    writeln('Appuyez sur Entrée pour continuer...');
    readln;
    allerSalle(perso,adversaire,geekedex);
  End;
  until sortie=true;
end;
procedure salleetddg(var perso : joueur;var  adversaire : pnj ; var geekedex : pokedex);
begin
    perso.emplacement := ETDDG;
    effacerEcran;
    Write('Vous rentrez dans une salle ou de nombreux étudiants sont présents.');
    writeln(' Certains sont assis autour d''une table et discutent, d''autre sont assis dans un canapé et joue à un jeu vidéo.');
    write('L''un d''entre eux, visiblement un deuxième année s''avance vers vous.');
    write('Bonjour, je suis David G., président de l''ETDDG, association des étudiants du département DDG.');
    writeln(' Bienvenue à toi.');
    writeln('Dans cette salle, tu peux te reposer un peu et soigner tes geekemons ou encore nous acheter des consomma...potions.');
    salleetddgchoix(perso,adversaire,geekedex);
end;
procedure salleetddgchoix(var perso : joueur;var adversaire : pnj ; var geekedex : pokedex);
var
  i, choix1:integer;
  sortie:boolean;
  nbPotion:integer;
begin
  writeln('Que voulez-vous faire ?');
  writeln('1 - Se reposer');
  writeln('2 - Acheter des potions (40 centimes)');
  writeln('3 - Sortir');
  readln(choix1);
if choix1=1 then
begin
  effacerEcran;
  SoignerEquipe(perso,geekedex);
  writeln('Après avoir bien pioncé dans le canapé toi et tes geekemons êtes au taquet');
  writeln;
  writeln('Appuyer sur Entrée pour continuer');
  readln;
  salleetddgchoix(perso,adversaire,geekedex);
end
else if choix1=2 then
begin
  repeat
  begin
    effacerEcran;
    nbPotion := 0;
    writeln('Vous avez actuellement ',(perso.argent div 100) ,' euro(s) et ',(perso.argent mod 100),' centimes. Vous possédez ',perso.nbPotion,' potion(s).');
    writeln('Vous pouvez acheter au maximum ',(perso.argent div 40), ' potion(s).');
    writeln('Combien de potions veux-tu ?');
    readln(nbpotion);
    sortie:=true;
    if (nbPotion <= (perso.argent div 40)) then
    begin
      perso.nbPotion := perso.nbPotion + nbPotion;
      perso.argent := perso.argent - (nbPotion*40);
      effacerEcran;
      writeln('Vous avez acheté ',nbPotion,' potion(s), vous venez de perdre ' ,((nbPotion * 40)div 100),' euro(s) et ',((nbPotion * 40)mod 100) ,' centimes');
      salleetddgchoix(perso,adversaire,geekedex);
    end
    else sortie := false;
  end;
  until sortie = true;
end
 else
 begin
  effacerEcran;
  choisirSalle(perso,adversaire,geekedex);
 end;
end;
procedure cafeteria(var perso : joueur;var adversaire : pnj; var geekedex : pokedex);
  var
  rep,id : integer;
begin
    Write('Vous rentrez dans une salle ou de nombreux étudiants sont présents.');
    write(' Certains sont assis autour d''une table, discutent et boient un café quand tout d''un coup l''un d''entre eux arrive');
    writeln(' il s''agit d''un dresseur, souhaitez vous le combattre ?');
    writeln('1 - Oui');
    writeln('2 - Non');
    readln(rep);
    if rep = 1 then
    begin
       randomize;
       id := random(9)+1;
       matchDresseur(perso,adversaire,geekedex,id);
    end
    else
    begin
      writeln('Comme vous ne souhaitez pas le combattre vous êtes chasser de la cafétéria');
      readln;
      choisirSalle(perso,adversaire,geekedex);
    end;
    readln;
    effacerEcran();
end ;
end.
