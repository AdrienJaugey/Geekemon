unit Geekemon_sous_programme;
  
interface
uses
  System.SysUtils,
  TypePerso,
  Localisation,
  GestionFichierTexte,
  Tutoriel,
  GestionGeekemon,
  GestionEcran;

procedure ecranTitre();

implementation

procedure creationGeekedex(var geekedex : pokedex;adresse : string );
{ Crée le geekedex (sorte de base de données regroupant tous les geekemons existants
  avec leurs différentes statistiques (id, nom de base, element...) }
var
 i : integer;
 ligne : string;
 geekedexTxt : TextFile;

const
  DEBUG = false; //Si mise à TRUE, affichage des geekemons créés
 Begin
 //Création du geekemon "vide", il sert à combler les parties vides des tableaux de geekemons
  geekedex[0].id := 0;
  geekedex[0].nom := '';
  geekedex[0].pv := 0.0;
  geekedex[0].pvmax := 0.0;
  geekedex[0].resume := '';
  geekedex[0].race := '';
  geekedex[0].carac := endurance;
  geekedex[0].agi := 0;
  geekedex[0].endu := 0;
  geekedex[0].strength := 0;
  geekedex[0].element := 0;
  geekedex[0].exp := 0;
  geekedex[0].expmax := 0;
  geekedex[0].ko := true;
  geekedex[0].niveau := 0;
  if DEBUG then debugGeekemon(geekedex[0]);

  //Récupération des caractéristiques des geekemons depuis le fichier texte data/geekedex.txt
  ouvrirFichierTxt(geekedexTxt,adresse,lecture);
  for i:= 1 to 22 do //On répète l'import des données 22 fois (nombre de geekemons différents)
  begin
    readln(geekedexTxt,ligne); //Récupération de la ligne où est stocké l'id du geekemon
    geekedex[i].id := StrToInt(RecupDonnee(ligne)); //On affecte cet id au geekemon n°1 du geekedex
    readln(geekedexTxt,ligne); //Idem avec le nom
    geekedex[i].nom := RecupDonnee(ligne);
    readln(geekedexTxt,ligne); //Idem avec le résumé du geekemon (description longue)
    geekedex[i].resume := RecupDonnee(ligne);
    readln(geekedexTxt,ligne); //Idem avec la race
    geekedex[i].race := RecupDonnee(ligne);
    geekedex[i].ko := false;  //Chaque geekemon (hors id 0) est définit comme vivant
    geekedex[i].exp := 0;     //Initialisation de l'experience possédée par le geekemon
    geekedex[i].expmax := 50; //Initialisation de l'experience à obtenir pour monter de niveau
    geekedex[i].niveau := 1;  //Initialisation du niveau à 1
    readln(geekedexTxt,ligne);  //Récupération de la ligne où est stocké l'element du geekemon sous forme d'entier (2/4/8)
    geekedex[i].element:= StrToInt(RecupDonnee(ligne)); //Affectation de l'element
    readln(geekedexTxt,ligne);  //Récupération de la ligne où est stocké la caractéristique du geekemon
    if RecupDonnee(ligne) = 'force' then geekedex[i].carac := force //Etant stockée sous forme de texte, on teste la ligne lue pour définir la caractéristique
    else if RecupDonnee(ligne) = 'agilite' then geekedex[i].carac := agilite
    else if RecupDonnee(ligne) = 'endurance' then geekedex[i].carac := endurance;
    readln(geekedexTxt,ligne); //Récupération de la ligne où est stockée la stats d'agilité du geekemon
    geekedex[i].agi:= StrToInt(RecupDonnee(ligne)); //Affectation de cette dernière
    readln(geekedexTxt,ligne); //Idem avec la force
    geekedex[i].strength := StrToInt(RecupDonnee(ligne));
    readln(geekedexTxt,ligne); //Idem avec l'endurance
    geekedex[i].endu := StrToInt(RecupDonnee(ligne));
    readln(geekedexTxt,ligne); //On passe le saut de ligne servant de séparation avec le prochain geekemon
    geekedex[i].pvmax := geekedex[i].endu*10; //Calcul et affectation de la valeur maximale des points de vie
    geekedex[i].pv := geekedex[i].pvmax; //On définit le geekemon comme ayant sa vie au maximum
    if DEBUG then debugGeekemon(geekedex[i]);
  end;
  fermerFichierTxt(geekedexTxt); //On ferme le fichier ayant servit à l'import des données pour libérer de la place
End;

procedure CreationPc(var perso : joueur;var geekedex : pokedex);
//Procédure appellée lors d'une nouvelle partie, elle remplit le pc avec le geekemon vide
var
  i : integer;
Begin
  for i := 1 to 80 do perso.pc.boite[i] := geekedex[0];
  perso.pc.gkmnEnStock :=  0; //On initialise le nombre de geekemon en stock à 0, le geekemon vide n'en étant pas vraiment un
End;

procedure creationPerso(var perso : joueur;var geekedex : pokedex);
{ Procédure appellée lors d'une nouvelle partie, elle permet de mettre en place l'histoire, récupérer les informations
  et de laisser choisir son geekemon à l'utilisateur }
var
  rep,rep2,i : integer;
  sortie,sortie2 : boolean;
  nom : string;
Begin
 //Introduction
 repeat
  //Initialisation des variables affichées telles que l'emplacement, l'argent et le nombre de geekemons sur soi et l'équipe
  perso.emplacement := Secretariat;
  perso.argent := 0;
  perso.nbGkmn := 0;
  for i := 1 to 4 do perso.equipe[i] := geekedex[0];
  perso.quete := false;

  //Mise en place de l'histoire
  bandeauLoc(perso);
  writeln('Timidement, sac-à-dos à l''épaule, vous rentrez dans le secrétariat. Derrière un grand bureau blanc, une femme est penchée sur son ordinateur. En vous entendant rentrer, elle se tourne vers vous.');
  writeln;
  writeln('"Oui bonjour, c''est pour quoi ?"');
  writeln;
  writeln('       1 - "Bonjour, je suis bien au département DDG ?"');
  sortie := false;
  readln(rep);
  if rep=1 then sortie := true; //L'utilisateur ne peut rentrer uniquement la valeur 1 pour continuer
 until sortie = true ;

 //Choix du pseudo
 sortie:=false;
 while not(sortie) do
 begin
  bandeauLoc(perso);
  writeln('La secrétaire vous souris et repond :');
  write('"Oui. Ah ! Vous devez être le nouvel étudiant. Thérèse, je suis la secrétaire du département. Vos parents nous ont appelé pour nous dire que vous ne pourriez pas être présent à la journée de rentrée. J''ai besoin que vous remplissiez quelques papiers pour');
  writeln('finir votre inscription. Vous pouvez me rappeler votre nom ? "');
  writeln;
  writeln('Quel est ton nom ?');
  readln(nom); //Demande de saisie du pseudo à l'utilisateur
  BandeauLoc(perso);
  if nom = '' then nom := 'Jean-Kévin';
  //Demande de confirmation, le pseudo ne peut être changé par la suite
  writeln('Es-tu sûr de t''appeler ',nom,' ? On sait jamais, une erreur est si vite arrivée...');
  writeln('1 - Oui');
  writeln('2 - Non');
  readln(rep);
  if rep = 1 then
  begin
      sortie := true;
      perso.pseudo := nom;  //L'utilisateur a confirmé, on affecte son pseudo et on continue
  end;
 end;

 //Choix du premier Geekemon
 sortie := false;
 while not(sortie) do
 begin
   repeat
   begin
    perso.emplacement := Bureau;
    bandeauLoc(perso); //Affichage des 3 geekemons "starters" et demande de choix à l'utilisateur
    writeln('"Bienvenue dans le département DDG : Dressage De Geekemon. Ici, tu apprendras à devenir un dresseur de geekemons. Mais attention, un grand nombre de ces créatures vivent à l''état sauvage dans ce bâtiment. Si tu veux pouvoir te promener en toute sécurité,','il te faut un premier geekemon. Tu as de la chance, il m''en reste trois. Je te laisse choisir. "');
    writeln('Le professeur Ramp place trois geekeballs sur son bureau');
    writeln('Geekeball 1 : ',geekedex[1].nom,', ',geekedex[1].race,', ',affichageElement(geekedex[1].element));
    writeln('Geekeball 2 : ',geekedex[2].nom,', ',geekedex[2].race,', ',affichageElement(geekedex[2].element));
    writeln('Geekeball 3 : ',geekedex[3].nom,', ',geekedex[3].race,', ',affichageElement(geekedex[3].element));
    writeln('Lequel de ces geekemons voulez-vous ?');
    readln(rep2);
    sortie2:=True;
    case rep2 of
        1 : rep2 := 1;
        2 : rep2 := 2;    //On vérifie la réponse de l'utilisateur
        3 : rep2 := 3;
        else sortie2 := false;
    end;
   end;
   until sortie2=True;

   //Demande de confirmation
   writeln('Es-tu sûr de ton choix ? Il ne sera pas réversible');
   writeln('1 - Oui');
   writeln('2 - Non');
   readln(rep);
   if rep = 1 then
  begin
      sortie := true;
      perso.equipe[1] := geekedex[rep2];
      perso.nbGkmn := 1;
      perso.combat := true;
  end;
 end;
 //Demande à l'utilisateur pour un surnom de son geekemon
 bandeauLoc(perso);
 writeln('Veux-tu donner un surnom à ton nouveau geekemon ?');
 writeln('1 - Oui');
 writeln('2 - Non');
 readln(rep);
 if rep = 1 then
 begin
  sortie := false;
  repeat //Demande de saisie du surnom à l'utilisateur
    writeln('Quel sera son surnom ?');
    readln(nom);
    BandeauLoc(Perso);
    //Demande de confirmation
    writeln('Es-tu sûr de ton choix ?');
    writeln('1 - Oui');
    writeln('2 - Non');
    readln(rep);
    if rep = 1 then
    begin
      sortie := true;
      perso.equipe[1].nom := nom; //Affectation du geekemon à l'équipe du joueur
      attendre(1000);
      //Affichage du nouveau surnom du geekemon
      writeln('Ton ', geekedex[perso.equipe[1].id].nom,' s''appelle désormais ', perso.equipe[1].nom,'.');
    end;
  until sortie;
  writeln;
  writeln('Appuyer sur Entrée pour continuer...');
  readln;
  end;

 //Le joueur reçoit l'argent et les potions de départ. Appel du tutoriel
 perso.argent := 400;
 perso.nbPotion := 5;
 bandeauLoc(perso);
 tuto(perso);
end;

procedure creationPnj(var t : pnj;addresse : string;var geekedex : pokedex);
{ Procedure appellée à chaque lancement du jeu, permet d'importer les différents
  dresseurs depuis le fichier texte}
var
  i,j : integer;
  chaine : string;
  dresseurTxt : textFile;
Begin
  //Ouverture du fichier en mode lecture
  ouvrirFichierTxt(dresseurTxt,addresse,lecture);
  for i:= 1 to 10 do //On répète 10 fois pour importer les différents dresseurs
  begin
    readln(dresseurTxt,chaine);   //On lit la ligne
    t[i].id := StrToInt(RecupDonnee(chaine)); //On affecte l'id lu à l'adversaire du tableau à l'indice i
    readln(dresseurTxt,chaine);  //Lecture de la ligne suivante
    t[i].nom := RecupDonnee(chaine);  //Affectation du nom au dresseur
    for j := 1 to 4 do
    begin
    readln(dresseurTxt,chaine);  //Lecture de la ligne suivante
    t[i].equipe[j] := geekedex[StrToInt(RecupDonnee(chaine))];  //Affectation des geekemons au dresseur
    end;
    readln(dresseurTxt,chaine);  //Lecture de la ligne suivante
    t[i].nbGkmn := StrToInt(RecupDonnee(chaine));  //Affectation du nombre de geekemon possédé par le dresseur
    readln(dresseurTxt,chaine);   //Lecture de la ligne suivante
    t[i].texte := RecupDonnee(chaine);  //Affectation de la phrase d'amorce du dresseur
    readln(dresseurTxt,chaine);  //Lecture de la ligne suivante
    t[i].recompense := StrToInt(RecupDonnee(chaine));  //Affectation de la récompense au dresseur
    readln(dresseurTxt,chaine);  //Passage du saut de ligne servant de séparation entre les dresseurs
  end;
  fermerFichierTxt(dresseurTxt); //Fermeture du fichier texte pour gagner de la mémoire
End;

procedure nouvellePartie;
{ Procédure appellée si l'utilisateur choisit de commencer une nouvelle partie,
  elle permet de lancer la création des variables importantes au jeu}
var
  perso : joueur;
  geekedex : pokedex;
  pc : stock;
  adversaire : pnj;

const
  ADDR_GEEKEDEX : string = '../../data/geekedex.txt';  //Addresse du fichier texte contenant les données du geekedex
  ADDR_DRESSEUR : string = '../../data/dresseur.txt';  //Idem avec les données des dresseurs

Begin
  creationGeekedex(geekedex,ADDR_GEEKEDEX); //Appel des différentes procédures précedemment décrites
  creationPc(perso,geekedex);
  creationPnj(adversaire,ADDR_DRESSEUR,geekedex);
  creationPerso(perso,geekedex);
  choisirSalle(perso,adversaire,geekedex); //Après la création du personnage, le joueur choisit sa destination
  readln;
End;

procedure recupSauvegarde(adresse : string;var perso : joueur;var geekedex : pokedex);
{ Procédure appellée lors de la continuation d'une partie, elle permet de réobtenir les
  informations concernant le personnage, son équipe et son pc}
var
  fichier : textFile;
  ligne : string;
  i,f,e,a : integer;

const
  DEBUG = false; //Mise à TRUE, affiche le perso et les geekemons importés
Begin
  perso.emplacement := ETDDG; //On place le joueur à l'ETDDG
  ouvrirFichierTxt(fichier,adresse,lecture); //On ouvre le fichier
  readln(fichier,ligne);
  readln(fichier,ligne);  //On passe les quelques lignes inutiles (hors lecture manuelle des données)
  readln(fichier,ligne);  //Récupération de la ligne contenant le pseudo
  perso.pseudo := RecupDonnee(ligne); //Affectation de ce dernier
  readln(fichier,ligne);   //Idem avec l'argent qu'il possède
  perso.argent := StrToInt(RecupDonnee(ligne));
  readln(fichier,ligne);  //Idem avec le nombre de geekemons qu'il a
  perso.nbGkmn := StrToInt(RecupDonnee(ligne));
  readln(fichier,ligne); //Idem avec son etat de combattre (TRUE = peut aller au combat)
  if recupDonnee(ligne) = 'TRUE' then perso.combat := true
                                 else perso.combat := false;
  readln(fichier,ligne); //Idem avec la variable contenant la validation ou non de la quête
  if recupDonnee(ligne) = 'TRUE' then perso.quete := true
                                 else perso.quete := false;
  readln(fichier,ligne); //Idem avec les potions possédées par le joueur
  perso.nbPotion := StrToInt(RecupDonnee(ligne));
  readln(fichier,ligne); //Idem avec le nombre de geekemons dans le PC
  perso.pc.gkmnEnStock := StrToInt(RecupDonnee(ligne));
  readln(fichier,ligne);
  readln(fichier,ligne);
  if DEBUG then debugPerso(perso);
  for i := 1 to perso.nbGkmn do  //On répète autant de fois que le joueur a de geekemon
  begin
    readln(fichier,ligne);  //Tout comme pour la création du geekedex, ici on ne récupère que l'id, le nom, le niveau, l'etat de combattre, l'exp et l'expmax
    readln(fichier,ligne);
    perso.equipe[i].id := StrToInt(RecupDonnee(ligne));
    readln(fichier,ligne);
    perso.equipe[i].nom := RecupDonnee(ligne);
    readln(fichier,ligne);
    perso.equipe[i].pv := StrToFloat(RecupDonnee(ligne));
    readln(fichier,ligne);
    if recupDonnee(ligne) = 'TRUE' then perso.equipe[i].ko := true
                                 else perso.equipe[i].ko := false;
    readln(fichier,ligne);
    perso.equipe[i].exp := StrToInt(RecupDonnee(ligne));
    readln(fichier,ligne);
    perso.equipe[i].expmax := StrToInt(RecupDonnee(ligne));
    readln(fichier,ligne);
    perso.equipe[i].niveau := StrToInt(RecupDonnee(ligne));
    perso.equipe[i].carac := geekedex[perso.equipe[i].id].carac;
    f := 2;
    a := 2;
    e := 2;
    case perso.equipe[i].carac of   //Suivant la caractéristique du geekemon, une des stats augmente plus avec les niveaux
      force : f := 5;
      agilite : a := 5;
      endurance : e := 5;
    end;
    //Calcul et affectation des différentes stats, on récupère également les données qui ne sont pas modifiables dans le geekedex (gain de place dans le fichier de sauvegarde)
    perso.equipe[i].strength := geekedex[perso.equipe[i].id].strength + (perso.equipe[i].niveau - 1)*f;
    perso.equipe[i].agi := geekedex[perso.equipe[i].id].agi + (perso.equipe[i].niveau - 1)*a;
    perso.equipe[i].endu := geekedex[perso.equipe[i].id].endu + (perso.equipe[i].niveau - 1)*e;
    perso.equipe[i].resume := geekedex[perso.equipe[i].id].resume;
    perso.equipe[i].race := geekedex[perso.equipe[i].id].race;
    perso.equipe[i].element := geekedex[perso.equipe[i].id].element;
    perso.equipe[i].pvmax := perso.equipe[i].endu * 10;
    if debug then debugGeekemon(perso.equipe[i]);
  end;
  for i := perso.nbGkmn+1 to 4 do //Pour les places libres dans l'équipe, on affecte le geekemon vide
  begin
    perso.equipe[i] := geekedex[0];
    if DEBUG then debugGeekemon(perso.equipe[i]);
  end;
  readln(fichier,ligne);
  readln(fichier,ligne);
  for i := 1 to perso.pc.gkmnEnStock do  //On recommence l'import des geekemons mais cette foi-ci pour le Pc
  begin
    readln(fichier,ligne);
    readln(fichier,ligne);
    perso.pc.boite[i].id := StrToInt(RecupDonnee(ligne));
    readln(fichier,ligne);
    perso.pc.boite[i].nom := RecupDonnee(ligne);
    readln(fichier,ligne);
    perso.pc.boite[i].pv := StrToFloat(RecupDonnee(ligne));
    readln(fichier,ligne);
    if recupDonnee(ligne) = 'TRUE' then perso.pc.boite[i].ko := true
                                 else perso.pc.boite[i].ko := false;
    readln(fichier,ligne);
    perso.pc.boite[i].exp := StrToInt(RecupDonnee(ligne));
    readln(fichier,ligne);
    perso.pc.boite[i].expmax := StrToInt(RecupDonnee(ligne));
    readln(fichier,ligne);
    perso.pc.boite[i].niveau := StrToInt(RecupDonnee(ligne));
    perso.pc.boite[i].carac := geekedex[perso.pc.boite[i].id].carac;
    f := 2;
    a := 2;
    e := 2;
    case perso.pc.boite[i].carac of
      force : f := 5;
      agilite : a := 5;
      endurance : e := 5;
    end;
    perso.pc.boite[i].strength := geekedex[perso.pc.boite[i].id].strength + (perso.pc.boite[i].niveau - 1)*f;
    perso.pc.boite[i].agi := geekedex[perso.pc.boite[i].id].agi + (perso.pc.boite[i].niveau - 1)*a;
    perso.pc.boite[i].endu := geekedex[perso.pc.boite[i].id].endu + (perso.pc.boite[i].niveau - 1)*e;
    perso.pc.boite[i].resume := geekedex[perso.pc.boite[i].id].resume;
    perso.pc.boite[i].race := geekedex[perso.pc.boite[i].id].race;
    perso.pc.boite[i].element := geekedex[perso.pc.boite[i].id].element;
    perso.pc.boite[i].pvmax := perso.pc.boite[i].endu * 10;
    if DEBUG then debugGeekemon(perso.pc.boite[i]);
  end;
  for i := perso.pc.gkmnEnStock+1 to 80 do perso.pc.boite[i] := geekedex[0]; //Idem ave le PC, on occupe les places libres
  fermerFichierTxt(fichier); //On ferme le fichier pour gagner en mémoire
End;

procedure continuerPartie;
{ Procédure appellée si un fichier de sauvegarde existe, elle permet de créer les
  variables importantes et de récupérer les informations de la partie sauvegardée}
var
  perso : joueur;
  geekedex : pokedex;
  pc : stock;
  adversaire : pnj;
const
  ADDR_GEEKEDEX : string = '../../data/geekedex.txt';
  ADDR_DRESSEUR : string = '../../data/dresseur.txt';
  ADDR_SAVE : string = '../../data/save.txt';
Begin
  creationGeekedex(geekedex,ADDR_GEEKEDEX);
  creationPnj(adversaire,ADDR_DRESSEUR,geekedex);
  recupSauvegarde(ADDR_SAVE,perso,geekedex);
  choisirSalle(perso,adversaire,geekedex);
End;

procedure ecranTitre();
//Procédure permettant de choisir entre commencer ou continuer une partie et quitter
var
  choix : integer;
  sortie : boolean;

const
  ADDR_SAVE : string = '../../data/save.txt';
Begin
  repeat
  begin
    effacerEcran();
    writeln;
    writeln;
    writeln('        ___            ___            ___            ___            ___           ___           ___           ___     ');
    writeln('       /\__\          /\__\          /\__\          /|  |          /\__\         /\  \         /\  \         /\  \    ');
    writeln('      /:/ _/_        /:/ _/_        /:/ _/_        |:|  |         /:/ _/_       |::\  \       /::\  \        \:\  \   ');
    writeln('     /:/ /\  \      /:/ /\__\      /:/ /\__\       |:|  |        /:/ /\__\      |:|:\  \     /:/\:\  \        \:\  \  ');
    writeln('    /:/ /::\  \    /:/ /:/ _/_    /:/ /:/ _/_    __|:|  |       /:/ /:/ _/_   __|:|\:\  \   /:/  \:\  \   _____\:\  \ ');
    writeln('   /:/__\/\:\__\  /:/_/:/ /\__\  /:/_/:/ /\__\  /\ |:|__|____  /:/_/:/ /\__\ /::::|_\:\__\ /:/__/ \:\__\ /::::::::\__\');
    writeln('   \:\  \ /:/  /  \:\/:/ /:/  /  \:\/:/ /:/  /  \:\/:::::/__/  \:\/:/ /:/  / \:\~~\  \/__/ \:\  \ /:/  / \:\~~\~~~/__/');
    writeln('    \:\  /:/  /    \::/ /:/  /    \::/ /:/  /    \::/~~/~       \::/ /:/  /   \:\  \        \:\  /:/  /   \:\  \      ');
    writeln('     \:\/:/  /      \:\/:/  /      \:\/:/  /      \:\~~\         \:\/:/  /     \:\  \        \:\/:/  /     \:\  \     ');
    writeln('      \::/  /        \::/  /        \::/  /        \:\__\         \::/  /       \:\__\        \::/  /       \:\__\    ');
    writeln('       \/__/          \/__/          \/__/          \/__/          \/__/         \/__/         \/__/         \/__/    ');
    writeln;
    writeln;
    writeln;
    writeln;
    writeln('           Bienvenue dans Geekemon - soumettez les tous !');
    writeln('             1 - Nouvelle Partie');

    if fileExists(ADDR_SAVE) then //Si un fichier de sauvegarde existe, on ajoute l'option pour continuer
    begin
      writeln('             2 - Continuer Partie');
      writeln('             3 - Quitter');
      readln(choix);
      sortie := true;
      case choix of  //Le choix fait par l'utilsateur définit la procédure qui va être lancée
      1 : nouvellePartie();
      2 : continuerPartie();
      3 : sleep(0);
      else sortie := false;
      end
    end
    else
    begin //Cas où il n'y a pas de fichier de sauvegarde
      writeln('             2 - Quitter');
      readln(choix);
      sortie := true;
      case choix of
      1 : nouvellePartie();
      2 : sleep(0);
      else sortie := false;
    end;
    end;

  end;
  until sortie = true;
End;

end.
