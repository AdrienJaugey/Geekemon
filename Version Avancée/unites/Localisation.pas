unit Localisation;

interface
uses SysUtils, Windows,TypePerso, Combat,GestionFichierTexte, GestionEcran,GestionGeekemon,ProgCombatAdversaire;

procedure bandeauLoc(perso : joueur);
procedure choisirSalle(var perso : joueur; var adversaire : pnj; var geekedex : pokedex);
procedure salleetddg(var perso : joueur; var adversaire : pnj;var geekedex : pokedex);
procedure salleetddgchoix(var perso : joueur; var adversaire : pnj;var geekedex : pokedex);
procedure cafeteria(var perso : joueur;var adversaire : pnj; var geekedex : pokedex);
procedure niveausalle (min : integer;var geekedex: pokedex);
procedure salleBoss(var perso : joueur ; var adversaire :  pnj ; var geekedex : pokedex);

implementation

procedure allerSalle(var perso : joueur;  var adversaire : pnj; var geekedex : pokedex);
//Proc�dure qui envoie le joueur dans une salle et lance un combat s'il est en �tat de combattre
begin
  CheckEtatJoueur(perso);
  if perso.combat then MatchSauvage(perso,adversaire,geekedex)
  else
  begin //Cas o� le joueur ne peut plus combattre
  writeln('Vous ne pouvez jouez sans Geekemon valide, vous devez vous reposez dans l''ETDDG');
  readln;
  choisirSalle(perso,adversaire,geekedex);
  end;
end;

procedure bandeauLoc(perso : joueur);
//Proc�dure permettant d'afficher la localisation, l'argent poss�d� et l'�quipe du joueur
var
  affichageSalle : string;
begin
  case perso.emplacement of
    Secretariat : affichageSalle := 'Secr�tariat';
    Bureau      : affichageSalle := 'Bureau du Professeur Ramp';
    ETDDG       : affichageSalle := 'Salle de l''ETDDG';
    Amphi       : affichageSalle := 'Amphith�atre';
    Training    : affichageSalle := 'Salle d''entra�nement';
    cafet       : affichageSalle := 'Caf�t�ria';
    R24         : affichageSalle := 'Salle R24';
    R29         : affichageSalle := 'Salle R29';
    R30         : affichageSalle := 'Salle R30';
    R31         : affichageSalle := 'Salle R31';
    S147        : affichageSalle := 'Salle 147';
    S148        : affichageSalle := 'Salle 148';
    S149        : affichageSalle := 'Salle 149';
    S150        : affichageSalle := 'Salle 150';
    S201        : affichageSalle := 'Salle 201';
    S202        : affichageSalle := 'Salle 202';
    S203        : affichageSalle := 'Salle 203';
    S206        : affichageSalle := 'Salle 206';
  end;
  effacerEcran;
  writeln('    Pseudo : ',perso.pseudo);
  writeln('    Lieu   : ',affichageSalle);
  writeln('    Argent : ',perso.argent div 100,',',perso.argent mod 100,' euro(s)');
  write('    Equipe : ');
  if perso.equipe[1].id <> 0 then write(perso.equipe[1].nom,' (Niv. ',perso.equipe[1].niveau,')');
  if perso.equipe[2].id <> 0 then write(' | ',perso.equipe[2].nom,' (Niv. ',perso.equipe[2].niveau,')');
  if perso.equipe[3].id <> 0 then write(' | ',perso.equipe[3].nom,' (Niv. ',perso.equipe[3].niveau,')');
  if perso.equipe[4].id <> 0 then write(' | ',perso.equipe[4].nom,' (Niv. ',perso.equipe[4].niveau,')');
  writeln;
  writeln('-----------------------------------------------------------------------------------------------------------------------');
  writeln;
end;
procedure choisirSalle(var perso : joueur; var adversaire : pnj;  var geekedex : pokedex);
//Proc�dure qui demande au joueur o� il veut se rendre et appelle les proc�dures correspondantes
var
  choix1,choix2:integer;
  sortie,annulation : boolean;
  niveaumin : integer;
begin
  bandeauLoc(perso);
  Writeln('O� voulez-vous aller ?');
  Writeln('1 - Salle de l''ETDDG');
  Writeln('2 - La caf�t�ria');
  writeln('3 - A quelles autres salles ai-je acc�s ?');
  readln(choix1);
if choix1=1 then
begin
  perso.emplacement := ETDDG;
  salleetddg(perso,adversaire,geekedex);
end;
if choix1=2 then
begin
bandeauLoc(perso);
perso.emplacement := cafet;
cafeteria(perso,adversaire,geekedex);
end;
if choix1=3 then
  repeat
  Begin
    annulation := false;
    bandeauLoc(perso); //Affichage des salles o� le joueur peut se rendre
    Writeln('Choisissez la salle o� vous vouler aller :');
    writeln('    1  - Salle R24(Nv.1-2)     2  - Salle R29(Nv.3-4)    3  - Salle R30(Nv.5-6)');
    writeln('    4  - Salle R31(Nv.7-8)     5  - Salle 147(Nv.9-10)   6  - Salle 148(Nv.11-12)');
    writeln('    7  - Salle 149(Nv.13-14)   8  - Salle 150(Nv.15-16)  9  - Salle 201(Nv.17-18)');
    writeln('    10 - Salle 202(Nv.19-20)   11 - Salle 203(Nv.21-22)  12 - Salle 206(Nv.23-24)');
    writeln('    13 - Amphith�atre(Nv.???)                            0  - Annuler');
    readln(choix2);
    sortie := true;
    case choix2 of //Le niveau des geekemons sauvages rencontr�s est d�finit suivant la salle
      0   : annulation := true;
      1   : begin
              perso.emplacement := R24;
              niveaumin :=1;
            end;
      2   : begin
              perso.emplacement := R29;
              niveaumin :=3;
            end;
      3   : begin
              perso.emplacement := R30;
              niveaumin :=5;
            end;
      4   :  begin
              perso.emplacement := R31;
              niveaumin :=7;
            end;
      5   :  begin
              perso.emplacement := S147;
              niveaumin :=9;
            end;
      6   :  begin
              perso.emplacement := S148;
              niveaumin :=11;
            end;
      7   :  begin
              perso.emplacement := S149;
              niveaumin :=13;
            end;
      8   :  begin
              perso.emplacement := S150;
              niveaumin :=15;
            end;
      9   :  begin
              perso.emplacement := S201;
              niveaumin :=17;
            end;
      10  :  begin
              perso.emplacement := S202;
              niveaumin :=19;
            end;
      11  :  begin
              perso.emplacement := S203;
              niveaumin :=21;
            end;
      12  :  begin
              perso.emplacement := S206;
              niveaumin :=23;
            end;
      13  : begin
              perso.emplacement := Amphi;
              salleBoss(perso,adversaire,geekedex);
              choisirSalle(perso,adversaire,geekedex);
            end
      else sortie := false;
    end;
   End;
  until sortie or annulation;
    if not(annulation) then
    begin
      niveausalle(niveaumin,geekedex);
      bandeauLoc(perso); //On affiche au joueur qu'il se d�place
      writeln('Vous prenez alors vos affaires et vous d�placez jusqu''� cette salle.');
      attendre(1000);
      writeln;
      writeln('Appuyez sur Entr�e pour continuer...');
      readln;
      allerSalle(perso,adversaire,geekedex);
    end
    else choisirSalle(perso,adversaire,geekedex);
end;
procedure salleetddg(var perso : joueur; var adversaire : pnj;var geekedex : pokedex);
//Proc�dure qui g�re l'arriv�e � l'ETDDG
begin
    perso.emplacement := ETDDG;
    bandeauLoc(perso);

    write('Bonjour, je suis David G., pr�sident de l''ETDDG, association des �tudiants du d�partement DDG.');
    writeln(' Bienvenue � toi.');
    writeln('Dans cette salle, tu peux te reposer un peu et soigner tes geekemons ou encore nous acheter des consomma...potions.');
    salleetddgchoix(perso,adversaire,geekedex);
end;

procedure salleetddgchoix(var perso : joueur; var adversaire : pnj;var geekedex : pokedex);
//Proc�dure qui g�re les options disponibles � l'ETDDG et appelle les proc�dures correspondantes
var
  i, choix1:integer;
  sortie:boolean;
  nbPotion:integer;
begin
  bandeauLoc(perso);
  writeln('Que voulez-vous faire ?');
  writeln('1 - Se reposer');
  writeln('2 - Acheter des potions (40 centimes)');
  writeln('3 - Voir l''�quipe');
  if perso.quete then writeln('4 - Acc�der au PC du Chimiste Adrien') //Si le joueur a battu le 'boss', Chimiste Adrien, il a acc�s au nom complet
                 else writeln('4 - Acc�der au PC de ???'); //Sinon affichage du nom non d�couvert
  writeln('5 - Sauvegarder');
  writeln('6 - Qu�te Principale');
  writeln('7 - Sortir');
  readln(choix1);
if choix1=1 then
begin
  bandeauLoc(perso);
  SoignerEquipe(perso,geekedex); //On soigne les geekemons du joueur
  writeln('Apr�s avoir bien pionc� dans le canap� toi et tes geekemons �tes au taquet');
  writeln;
  writeln('Appuyer sur Entr�e pour continuer');
  readln;
  salleetddgchoix(perso,adversaire,geekedex);
end
else if choix1=2 then
begin
  repeat
  begin
    bandeauLoc(perso);
    nbPotion := 0;    //on calcule le nombre de potions que peut acheter le joueur et on lui demande de saisir le nombre qu'il veut
    writeln('Vous avez actuellement ',(perso.argent div 100) ,' euro(s) et ',(perso.argent mod 100),' centimes. Vous poss�dez ',perso.nbPotion,' potion(s).');
    writeln('Vous pouvez acheter au maximum ',(perso.argent div 40), ' potion(s).');
    writeln('Combien de potions veux-tu ?');
    readln(nbpotion);
    sortie:=true;
    if (nbPotion <= (perso.argent div 40)) then
    begin //Cas o� le joueur n'a demand� trop de potions, on affiche le montant total et le nombre de potions qu'il a achet�
      perso.nbPotion := perso.nbPotion + nbPotion;
      perso.argent := perso.argent - (nbPotion*40);
      bandeauLoc(perso);
      writeln('Vous avez achet� ',nbPotion,' potion(s), vous venez de perdre ' ,((nbPotion * 40)div 100),' euro(s) et ',((nbPotion * 40)mod 100) ,' centimes');
      writeln;
      writeln('Appuyer sur Entr�e pour continuer');
      readln;
      salleetddgchoix(perso,adversaire,geekedex);
    end
    else sortie := false;
  end;
  until sortie = true;
end
 else if choix1 = 3 then
 begin  //Appelle de la proc�dure permettant d'afficher l'�quipe
  AfficherEquipe(perso);
  salleetddgchoix(perso,adversaire,geekedex);
 end
 else if choix1 = 4 then
 begin  //Appelle de la proc�dure permettant la gestion du PC
  gestionPC(perso,adversaire,geekedex);
 end
 else if choix1 = 5 then
 begin //Appelle de la proc�dure permettant la sauvegarde
  sauvegarder('../../data/save.txt',perso);
  writeln('Partie sauvegard�e');
  attendre(1000);
  salleetddgchoix(perso,adversaire,geekedex);
 end
 else if choix1 = 6 then
 begin
   queteprinc(perso);
   salleetddgchoix(perso,adversaire,geekedex);
 end;
 begin
  bandeauLoc(perso);
  choisirSalle(perso,adversaire,geekedex);
 end;
end;

procedure cafeteria(var perso : joueur;var adversaire : pnj; var geekedex : pokedex);    //Procedure permettant de lancer un d�fi contre des dresseurs dans la caf�t�ria
  var
  rep,rep2,id : integer;
begin
      BandeauLoc(perso);
      Write('Vous rentrez dans une salle ou de nombreux �tudiants sont pr�sents.');
      write(' Certains sont assis autour d''une table, discutent et boient un caf� quand tout d''un coup l''un d''entre eux arrive');
      writeln(' il s''agit d''un dresseur, souhaitez vous le combattre ?');
      writeln('1 - Oui');
      writeln('2 - Non');         //demande au joueur s'il veux vraiment faire un combat contre un dresseur ou pas
      readln(rep);
  CheckEtatJoueur(perso);
  if perso.combat then
  begin
  if rep = 1 then
    begin
      repeat
      BandeauLoc(perso);
      writeln('Tr�s bien, combien de geekemons souhaites-tu que le dresseur poss�de ? (2,3 ou 4)');
      readln(rep2);
      randomize;
      case rep2 of                   //Demande au joueur combien de geekemon il souhaite que le dresseur poss�de
      2 : id := random(3)+1;
      3 : id := random(3)+4;
      4 : id := random(3)+7;
      end;
      until ((rep2 >= 2) and (rep2 <= 4)); ;
      matchDresseur(perso,adversaire,geekedex,id);
    end
    else
    begin
      writeln('Comme vous ne souhaitez pas le combattre vous �tes chass� de la caf�t�ria');
      readln;
      choisirSalle(perso,adversaire,geekedex);
    end;
  end
  else
  begin //Cas o� le joueur ne peut plus combattre
  writeln('Vous ne pouvez jouez sans Geekemon valide, vous devez vous reposez dans l''ETDDG');
  readln;
  choisirSalle(perso,adversaire,geekedex);
  end;
    readln;
    bandeauLoc(perso);
end ;
procedure niveausalle (min : integer;var geekedex: pokedex);  //Procedure calculant le niveau des geekemons sauvages dans les salles
var
  i : integer;
  lvl : integer;
begin
  randomize;
  lvl := min + random(2);
  for i :=1 to 20 do
  begin
    case geekedex[i].carac of
    force :
    begin
      geekedex[i].strength := 15+5*lvl;
      geekedex[i].endu := 8+2*lvl;
      geekedex[i].agi := 8+2*lvl;                     //Evolution des caract�ristique d'un geekemons de type force apr�s augmentation de son niveau
      geekedex[i].pvmax := geekedex[i].endu*10;
      geekedex[i].pv := geekedex[i].pvmax;
      geekedex[i].niveau := lvl;
      geekedex[i].expmax :=experienceMaxsauvage(lvl);
    end;
    agilite :
    begin
      geekedex[i].agi := 15+5*lvl;
      geekedex[i].endu := 8+2*lvl;
      geekedex[i].strength := 8+2*lvl;
      geekedex[i].pvmax := geekedex[i].endu*10;        //Evolution des caract�ristique d'un geekemons de type agilit� apr�s augmentation de son niveau
      geekedex[i].pv := geekedex[i].pvmax;
      geekedex[i].niveau := lvl;
      geekedex[i].expmax :=experienceMaxsauvage(lvl);
    end;
    endurance :
    begin
      geekedex[i].endu := 15+5*lvl;
      geekedex[i].strength := 8+2*lvl;
      geekedex[i].agi := 8+2*lvl;
      geekedex[i].pvmax := geekedex[i].endu*10;        //Evolution des caract�ristique d'un geekemons de type endurance apr�s augmentation de son niveau
      geekedex[i].pv := geekedex[i].pvmax;
      geekedex[i].niveau := lvl;
      geekedex[i].expmax :=experienceMaxsauvage(lvl);
    end;
    end;
  end;
end;

procedure salleBoss(var perso : joueur ; var adversaire : pnj ; var geekedex : pokedex);  //Salle de boss final
const
id = 10;
var
  nivmoy : integer;
begin
  nivmoy := niveauMoyen(perso);          //V�rifie que le niveau moyen de l'�quipe du joueur est inf�rieur a 28 si oui empeche le combat contre le boss�
  if nivmoy < 28 then
  begin
    writeln('Il semblerait que tes geekemons soit trop faible pour affronter le Chimiste, tu devrais continuer � entrainer tes geekemons afin d''�tre de taille pour ce final duel !');
    readln;
    choisirSalle(perso,adversaire,geekedex);
  end
  else
  begin
    writeln('Attention le combat final va commencer, bien que tu n''ai surement aucune chance !!!!!');
    MatchDresseur(perso,adversaire,geekedex,id)
  end;
end;

end.

