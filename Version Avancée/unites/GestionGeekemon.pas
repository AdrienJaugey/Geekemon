unit GestionGeekemon;

interface
uses
  TypePerso,SysUtils,GestionEcran;

procedure SoignerEquipe(var perso : joueur;geekedex : pokedex);
function GkmnEnVie(gkmn : geekemon):boolean;
function EquipeEnVie(var equipe : EquipeGeekemon):boolean;
procedure CheckEtatJoueur(var perso : joueur);
procedure Capturer(var perso : joueur; gkmnSauvage : geekemon);
procedure Echange(var gkmn1 : geekemon;var gkmn2 : geekemon);
function ChangementGkmnCombat(var perso : joueur;droitAnnuler : boolean):boolean; 
procedure AfficherGkmn(perso:joueur;gkmn : geekemon); 
procedure AfficherEquipe(perso : joueur); 
procedure experienceMax(var perso : joueur); 
procedure gainExperience( var perso : joueur; gkmn : geekemon);
procedure Amelioration (var perso : joueur);
function experienceMaxsauvage(niveau : integer): integer;
function affichageElement(element: integer):string;
procedure OrganisationTabGkmn(var perso : joueur);
procedure gestionPC(var perso : joueur; var adversaire : pnj;var geekedex : pokedex);

implementation
uses
  Geekemon_sous_programme,localisation;
procedure SoignerEquipe(var perso : joueur;geekedex : pokedex);
//Permet de soigner les geekemons du joueur
var
  i,j : integer;
Begin
  for i := 1 to 4 do
  begin
    if perso.equipe[i].id <> 0 then //Pour les geekemons non vides, on met leur vie au max et on les réautorise au combat
    begin
      perso.equipe[i].pv := perso.equipe[i].pvmax;
      perso.equipe[i].ko := false;
    end
    else
    begin //Cas d'un geekemon vide, on le met à 0 pv et on l'interdit au combat. Sorte de sécurité pour empécher l'accès à ce geekemon
      perso.equipe[i].pv := 0;
      perso.equipe[i].ko := true;
    end;
  end;
End;

function GkmnEnVie(gkmn : geekemon):boolean;
//Fonction qui renvoit True si le geekemon passé en paramètre n'est pas KO et false dans le cas contraire
Begin
  if gkmn.pv <= 0 then Result := false //Cas où le geekemon n'est pas KO, on retourne False
                  else Result := true; //Cas où le geekemon est KO, on retourne True
End;

function EquipeEnVie(var equipe : EquipeGeekemon):boolean;
//Fonction qui renvoit True si au moins un geekemon d'une équipe n'est pas KO
var
  i,nbGkmnKo : integer;
Begin
  nbGkmnKo := 0;
  for i:=1 to 4 do //On test chaque geekemon
  begin
    if not(GkmnEnVie(equipe[i])) then //On test s'il est ko
    begin
    nbGkmnKo := nbGkmnKo + 1;  //Si oui, on incrémente un compteur
    equipe[i].pv := 0.0;
    end;
  end;
  if nbGkmnKo = 4 then Result := false //Après avoir testé toute l'équipe, on retourne False si celle ci ne peut plus être jouée
                  else Result := true; //et True dans le cas contraire
End;

procedure CheckEtatJoueur(var perso : joueur);
//Procédure qui permet de changer la capacité de combattre du joueur
Begin
  if not(EquipeEnVie(perso.equipe)) then perso.combat := false //Si son équipe n'est pas jouable, on passe sa variable combat à False
  else perso.combat := true; //Sinon on passe sa variale à True
End;

procedure Capturer(var perso : joueur; gkmnSauvage : geekemon);
//Procédure qui capture un geekemon sauvage et le stock dans l'équipe, le pc ou le relâche le cas échéant
var
  i : integer;
Begin
  if (perso.nbGkmn <= 3) then //Test si le joueur a encore de la place dans son équipe
  begin //Si oui, on y stock le geekemon et on incrémente son nombre de geekemons possédés
    perso.equipe[perso.nbGkmn + 1] := gkmnSauvage;
    perso.nbGkmn := perso.nbGkmn + 1;
    writeln(gkmnSauvage.nom,' a rejoint votre equipe.');
  end
  else
  begin //S'il n'a plus de place dans son équipe mais dans son pc
    if (perso.pc.gkmnEnStock <= 79) then
    begin //on la même chose mais cette fois-ci on incrémente le nombre de geekemons sockés
      perso.pc.boite[perso.pc.gkmnEnStock + 1] := gkmnSauvage;
      perso.pc.gkmnEnStock := perso.pc.gkmnEnStock + 1;
      writeln(gkmnSauvage.nom,' est envoyé dans le PC.');
    end
    else
    begin  //Cas où le joueur n'a plus du tou de place, ni dans son équipe, ni dans son pc
      writeln('Tu n''as plus de place ni dans ton sac, ni dans ton pc...Tu relâches donc ',gkmnSauvage.nom,'.');
    end;
  end;
End;

procedure Echange(var gkmn1 : geekemon;var gkmn2 : geekemon);
//Procédure permettant d'échanger de place 2 geekemons passés en paramètres
var
  gkmnTemp : geekemon;
Begin
  gkmnTemp := gkmn1;
  gkmn1 := gkmn2;
  gkmn2 := gkmnTemp;
End;

function ChangementGkmnCombat(var perso : joueur;droitAnnuler : boolean):boolean;
//Fonction permettant au joueur de changer de geekemon en combat avec possibilité de l'interdir d'annuler
var
  rep : integer;
  sortie,action,possible : boolean;
Begin
  possible := false;
  action := false;
  repeat
  bandeauLoc(perso); //Demande à l'utilisateur du geekemon a envoyé
  writeln('Par qui veux-tu remplacer ',perso.equipe[1].nom,' ?');
  writeln('1 - ',perso.equipe[2].nom);
  writeln('2 - ',perso.equipe[3].nom);
  writeln('3 - ',perso.equipe[4].nom);
  if droitAnnuler then writeln('4 - Annuler'); //Si il a le droit d'annuler, on affiche l'option
  readln(rep);
  case rep of
    1,2,3 : begin //Dans le cas des réponses 1,2 ou 3
              possible := GkmnEnVie(perso.equipe[rep+1]); //On teste si le geekemon demandé est bien vivant
              sortie := GkmnEnVie(perso.equipe[rep+1]);
              if not(sortie) then writeln('Impossible'); //Dans le cas où le geekemon
            end;
    else if (droitAnnuler) and (rep = 4)then sortie := true;
  end;
  until sortie;
  if possible then Echange(perso.equipe[1],perso.equipe[rep+1]); //Appelle la procédure echange si celui-ci est possible
  Result := possible;
End;

procedure AfficherGkmn(perso:joueur;gkmn : geekemon);
//Permet un affichage propre d'un geekemon
Begin
  bandeauLoc(perso);
  writeln('Nom : ',gkmn.nom);
  writeln('Résumé : ',gkmn.resume);
  writeln('Race : ',gkmn.race);
  writeln('Vie : ',gkmn.pv:0:2,'/',gkmn.pvmax);
  writeln('Exp : ',gkmn.exp,'/',gkmn.expmax);

End;

procedure AfficherEquipe(perso : joueur);
//Permet un affichage propre d'une équipe avec détails avancés
var
  i : integer;
  rep : integer;
  caract : string;
Begin
  BandeauLoc(perso);
  for i:= 1 to 4 do //On répète 4 fois pour afficher les 4 geekemons de l'équipe
  begin
    if perso.equipe[i].id <> 0 then  //On affiche seulement si ce n'est pas un geekemon vide
    begin
    case perso.equipe[i].carac of
      force      : caract := 'Force';
      agilite    : caract := 'Agilite';
      endurance  : caract := 'Endurance';
    end;
    writeln('Geekemon n°',i,' :');
    Writeln('Nom : ',perso.equipe[i].nom,' (Niv. ',perso.equipe[i].niveau,')');
    writeln('Element: ',affichageElement(perso.equipe[i].element));
    write('Vie : ',perso.equipe[i].pv:0:2,'/',perso.equipe[i].pvmax:0:2);
    writeln(' Exp : ',perso.equipe[i].exp,'/',perso.equipe[i].expmax);
    writeln;
    end;
  end;
  writeln('1 - Stats avancé');
  writeln('2 - Sortir');
  readln(rep);
  BandeauLoc(perso);
  if rep = 1 then //Demande de l'affichage avancé des stats
  begin
    for i:= 1 to 4 do
    begin
      if perso.equipe[i].id <> 0 then
      begin
      case perso.equipe[i].carac of
        force      : caract := 'Force' ;
        agilite    : caract := 'Agilite';
        endurance  : caract := 'Endurance';
      end;
      writeln('Type : ', caract);
      writeln('Agilite : ',perso.equipe[i].agi);
      writeln('Force : ',perso.equipe[i].strength);
      writeln('Endurance : ',perso.equipe[i].endu);
      writeln;
      end;
    end;
  writeln('Appuyer sur Entrée pour continuer');
  readln;;
  end;


End;
procedure experienceMax(var perso : joueur);   //Procedure permettant de calculer l'experience mal des geekemons dans l'equipe du joueur en fonction de leurs lvl
var
i : integer;
j : integer;
begin

  for i :=1 to 4 do
  begin
  perso.equipe[i].expmax := 50;
  for j :=2 to perso.equipe[i].niveau do
  begin
  perso.equipe[i].expmax := perso.equipe[i].expmax + j*50;
  end;
  end;
end;
procedure gainExperience( var perso : joueur; gkmn : geekemon);     //Procedure de gain d'expérience en fonction du niveau après la mort d'un geekemon
var
  expgagne : integer ;
begin
  expgagne := perso.equipe[1].niveau*40+((gkmn.niveau-perso.equipe[1].niveau)*35);
  if expgagne <0 then
  begin
    perso.equipe[1].exp := perso.equipe[1].exp + 0;
  end
  else
  begin
    perso.equipe[1].exp := perso.equipe[1].exp + expgagne;
  end;
  if perso.equipe[1].niveau < 30 then
  begin
  if perso.quete then
  expgagne := expgagne*2;
  writeln(perso.equipe[1].nom, ' a gagné ', expgagne,' point d''expérience');

  if perso.equipe[1].exp > perso.equipe[1].expmax then
    Amelioration(perso);
  end
  else
  begin
    writeln('Votre geekemon est au niveau max et ne peut plus gagner de points d''expériences');
    perso.equipe[1].exp := 0;
    perso.equipe[1].expmax := 0;
  end;
end;
procedure Amelioration (var perso : joueur);    //Procedure permettant de d'augmenter de niveau et les caractéristique de nos geekemons s'ils ont gagné un niveau
var
  expsup : integer ;
begin
  begin
    perso.equipe[1].niveau := perso.equipe[1].niveau + 1;
    writeln(perso.equipe[1].nom, ' monte au niveau ' , perso.equipe[1].niveau);
    expsup := perso.equipe[1].exp - perso.equipe[1].expmax;
    perso.equipe[1].exp := expsup;
    experienceMax(perso);
  case perso.equipe[1].carac of
  force :
  begin
    perso.equipe[1].strength :=  perso.equipe[1].strength + 5;
    perso.equipe[1].agi := perso.equipe[1].agi + 2;                 //Cas d'un geekemon de type force
    perso.equipe[1].endu := perso.equipe[1].endu + 2;
  end;
  agilite :
  begin
    perso.equipe[1].strength := perso.equipe[1].strength + 2;
    perso.equipe[1].agi := perso.equipe[1].agi + 5;                 //Cas d'un geekemon de type agilité
    perso.equipe[1].endu := perso.equipe[1].endu + 2;
  end;
  endurance :
  begin
    perso.equipe[1].strength := perso.equipe[1].strength + +2;
    perso.equipe[1].agi := perso.equipe[1].agi + 2;
    perso.equipe[1].endu := perso.equipe[1].endu + 5;             //Cas d'un geekemon de type endurance
  end;
end;
  perso.equipe[1].pvmax :=  perso.equipe[1].endu*10;
end;
end;
function experienceMaxsauvage(niveau : integer): integer;
//function calculant l'expréience d'un geekemon que l'on vien de capturer
var
j : integer;
exp : integer;
  begin
  exp := 50;
  for j :=2 to niveau do
  begin
  exp := exp + j*50;
  end;
  result:=exp;
  end;
function affichageElement(element: integer):string;
// Procedure permettant d'afficher les 3 élement du jeu sous format chaine de caractère car ceux ci sont des chiffre
var
  afficher : string;
  begin
    case element of
    2 : afficher :='Feu';
    4 : afficher :='Eau';
    8 : afficher :='Plante';
    end;
  result := afficher;
  end;

procedure OrganisationTabGkmn(var perso : joueur);
//Procedure qui permet de ramener au début de l'équipe ou du pc tous les geekemons non vides pour assurer une sauvegarde optimisée
var
  i,slotVide, slotRempli : integer;
  action : boolean;

const
  DEBUG = true;
Begin
  //Réorganisation de l'équipe du joueur
  slotVide := 1;
  repeat
    while ((perso.equipe[slotVide].id <> 0) and (slotVide <= 4)) do  //On cherche la position du premier slot vide
    begin
      slotVide := slotVide + 1;
    end;
    slotRempli := slotVide + 1;
    while ((perso.equipe[slotRempli].id = 0) and (slotRempli <= 4)) do //On cherche la position du premier geekemon après le slot vide
    begin
      slotRempli := slotRempli + 1;
    end;
    action := ((slotVide <= 4) and (slotRempli <= 4)); //Si on a trouvé un slot vide suivi d'un geekemon, on lance l'échange
    if action then
    begin
      if debug then writeln(perso.equipe[slotVide].id,':',perso.equipe[slotVide].nom,' <=> ',perso.equipe[slotRempli].id,':',perso.equipe[slotRempli].nom);
      Echange(perso.equipe[slotVide],perso.equipe[slotRempli]); //On échange de contenu les deux slots précédents
    end;
    slotVide := slotVide + 1; //On se ramène au slot après celui que l'on vient de remplir
  until not(action); //On recommence tant qu'il y a un changement <=> on s'arrête après avoir parcouru l'équipe sans avoir eu de changement


  //Réorganisation du PC
  slotVide := 1; //On se replace sur le premier slot et on éxécute les mêmes commandes mais au niveau du PC cette fois-ci
  repeat
    while ((perso.pc.boite[slotVide].id <> 0) and (slotVide <= 80)) do
    begin
      slotVide := slotVide + 1;
    end;
    slotRempli := slotVide + 1;
    while ((perso.pc.boite[slotRempli].id = 0) and (slotRempli <= 80)) do
    begin
      slotRempli := slotRempli + 1;
    end;
    action := ((slotVide <= 80) and (slotRempli <= 80));
    if action then
    begin
      if debug then writeln(perso.pc.boite[slotVide].id,':',perso.pc.boite[slotVide].nom,' <=> ',perso.pc.boite[slotRempli].id,':',perso.pc.boite[slotRempli].nom);
      Echange(perso.pc.boite[slotVide],perso.pc.boite[slotRempli]);
    end;
    slotVide := slotVide + 1;
  until not(action);
End;

procedure gestionPC(var perso : joueur; var adversaire : pnj;var geekedex : pokedex);
{ Procédure qui affiche le contenu du PC et permet à l'utilisateur d'échanger de place
  ses geekemons avec sécurité pour empécher les échanges dans des cas impossibles
  }
var
  i,j,slotPc,slotEquipe : integer;
  sortie,changement : boolean;
  rep : string;
begin
  for i := 1 to 3 do
  begin
    BandeauLoc(perso);
    writeln('Vous vous connectez au PC');
    for j := 1 to 3 do
    begin
      write('.');
      attendre(500);
    end;
  end;
  BandeauLoc(perso);
  writeln('Vous vous connectez au PC');
  writeln('Connecté au système de gestion de boite geekemon');
  writeln;
  writeln('Il semblerait que la connexion se fasse à l''aide d''un modem 56k. C''était vraiment long...'); //Faut pas croire mais on a connu ça un tout petit peu, enfin dans mon cas en tout cas
  writeln;
  writeln('Appuyer sur une touche pour continuer...');
  readln;
  repeat
    repeat
      BandeauLoc(perso);
      writeln('Geekemon(s) en stock : ',perso.pc.gkmnEnStock);
      for i := 0 to 19 do  //Affichage des geekemons stockés, on affiche que les slots où il n'y a pas de geekemon vide
      begin
        if perso.pc.boite[i*4 + 1].id <> 0 then write(i*4 + 1,' - ',perso.pc.boite[i*4 + 1].nom,' (Niv. ',perso.pc.boite[i*4 + 1].niveau,') | ');
        if perso.pc.boite[i*4 + 2].id <> 0 then write(i*4 + 2,' - ',perso.pc.boite[i*4 + 2].nom,' (Niv. ',perso.pc.boite[i*4 + 2].niveau,') | ');
        if perso.pc.boite[i*4 + 3].id <> 0 then write(i*4 + 3,' - ',perso.pc.boite[i*4 + 3].nom,' (Niv. ',perso.pc.boite[i*4 + 3].niveau,') | ');
        if perso.pc.boite[i*4 + 4].id <> 0 then writeln(i*4 + 4,' - ',perso.pc.boite[i*4 + 4].nom,' (Niv. ',perso.pc.boite[i*4 + 4].niveau,') | ');
      end;
      writeln; //Affichage des options à sélectionnner et attente d'un choix du joueur
      writeln('Que voulez vous faire :  1) Effectuer un transfert     2) Annuler');
      readln(rep);
      changement := false;
      if rep = '1' then
      begin
        write('Quel slot du PC le transfert concerne-t-il ? (De 1 à 80) ');readln(slotPC); //Saisit du slot du PC à échanger
        write('Quel slot de votre équipe le transfert concerne-t-il ? (De 1 à 4) ');readln(slotEquipe); //Saisit de l'équipe à échanger
        //On vérifie que l'échange est autorisé, on ne veut pas que le joueur envoie son dernier geekemon dans le pc
        changement := ((perso.pc.boite[slotPC].id <> 0) and (perso.nbGkmn = 1)) or ((perso.nbGkmn > 1)and((perso.equipe[slotEquipe].id <> 0) or (perso.pc.boite[slotPC].id <> 0)));
        sortie := (((slotEquipe >= 1) and (slotEquipe <= 4)) and ((slotPC >= 1) and (slotPc <= 100))); //Vérification de la validité des valeurs saisies
      end
      else if rep = '2' then sortie := true;
    until sortie;
    if changement then //Si le changement est possible, on le réalise
    begin
      if perso.equipe[slotEquipe].id = 0 then //Calcul des nouveaux comptes de geekemons possédés et stockés
      begin
        perso.pc.gkmnEnStock := perso.pc.gkmnEnStock - 1;
        perso.nbGkmn := perso.nbGkmn + 1;
      end
      else if perso.pc.boite[slotPC].id = 0 then  //Même chose dans le cas d'un échange inverse
      begin
        perso.nbGkmn := perso.nbGkmn - 1;
        perso.pc.gkmnEnStock := perso.pc.gkmnEnStock + 1;
      end;
      Echange(perso.equipe[slotEquipe],perso.pc.boite[slotPC]); //On appelle la procédure qui réalise l'échange
      writeln('Transfert Effectué');
      OrganisationTabGkmn(perso);   //On réorganise l'équipe et le PC pour n'avoir que des geekemons non vides à la suite
      readln;
      repeat
        BandeauLoc(perso); //On demande au joueur s'il veut continuer les transferts ou non
        writeln('Continuer les transferts ?');
        writeln('1 - Oui');
        writeln('2 - Non');
        readln(rep);
      until (rep = '1') or (rep = '2');
    end;
  until rep = '2';
  salleetddgchoix(perso,adversaire,geekedex);
end;
end.
