unit Combat;

interface
uses
  System.SysUtils,
  GestionEcran,
  TypePerso,
  ProgCombatAdversaire,
  GestionGeekemon,
  progCombatJoueur;

  procedure MatchSauvage(var perso : joueur; var adversaire : pnj;var geekedex : pokedex);
  procedure MatchDresseur(var perso : joueur;adversaire : pnj; var geekedex : pokedex; id : integer);

implementation
uses
  Localisation;
procedure MatchSauvage(var perso : joueur; var adversaire : pnj;var geekedex : pokedex);
// procedure qui enclenche le combat contre un geekemon sauvage
var
  choix,actionadversaire : integer;
  sortie,obtenir,changement : boolean;
  pvrecuperer : real;
  sauvage : geekemon;
  elementJ,elementS : string;

begin
  randomize();
  sauvage := geekedex[random(18)+1];             // recup�ration du geekemon dans le geekedex
  sortie := false;
  obtenir := false;
  elementS := affichageElement(sauvage.element);
  while sortie = false do
  begin
  elementJ := affichageElement(perso.equipe[1].element);
  bandeauLoc(perso);
  changement := false;
  writeln('Alors que vous entrez dans la salle, vous apercevez une petit silhouette se faufiler entre les ordinateurs. Pas de doute, un Geekemon sauvage se trouve dans cette salle. D''un geste rapide vous attraper la geekeball de ',perso.equipe[1].nom,' et la lancez en direction du Geekemon.');

  writeln('-----------------------------------');
  writeln('- Combat avec un Geekemon sauvage -');
  writeln('-----------------------------------');

  writeln('Le geekemon sauvage : ',sauvage.nom,' se pr�pare au combat.');
  writeln('Votre geekemon : ',perso.equipe[1].nom,' se pr�pare au combat. ');
  writeln(sauvage.nom,' Niv.',sauvage.niveau,' : ', sauvage.pv:0:2 ,' PV', ' Element : ',elementS);    // Interface d'affichage pendant le combat
  writeln(perso.equipe[1].nom,' Niv.',perso.equipe[1].niveau, ' : ',perso.equipe[1].pv:0:2, ' PV',' Element : ',elementJ);
  writeln('C''est � ',perso.equipe[1].nom,' d''agir, que souhaitez vous faire ? ');
  writeln('1 - Attaquer');
  writeln('2 - Attaque Elementaire');
  writeln('3 - Lancer une geekeball');
  writeln('4 - Utiliser une potion (',perso.nbPotion,')');
  writeln('5 - Changer de geekemon');
  writeln('6 - Fuir le combat');
  readln(choix);

  actionadversaire := action();
  if choix = 1  then
  begin
    writeln(perso.equipe[1].nom,' attaque !');
    sauvage.pv := attaque(perso.equipe[1].nom,sauvage.nom,sauvage.pv,perso.equipe[1].strength,perso.equipe[1].agi,perso.equipe[1].carac) ;
    if not(GkmnEnVie(sauvage)) then  //verification afin de savoir si l'adversaire est toujours en vie
    begin
     writeln(sauvage.nom,' est mort !');
     gainExperience(perso,sauvage);
     writeln('Le combat est termin�');
     readln;
     sortie := true
    end;
  end;
  if choix = 2 then
  begin
    writeln(perso.equipe[1].nom,' utilise sont attaque elementaire !');
    sauvage.pv := attaqueElementaire(perso.equipe[1].nom,sauvage.nom,sauvage.pv,perso.equipe[1].strength,perso.equipe[1].agi,perso.equipe[1].carac,perso.equipe[1].element,sauvage.element);
    if not(GkmnEnVie(sauvage)) then   //verification afin de savoir si l'adversaire est toujours en vie
    begin
     writeln(sauvage.nom,' est mort !');
     gainExperience(perso,sauvage);
     writeln('Le combat est termin�');
     readln;
     sortie := true
    end;
  end;
  if choix = 3 then
  begin
    writeln('Vous lancez une geekeball');
    obtenir := capture(sauvage.pv,sauvage.pvmax);
    if obtenir = true then  //Si la capture r�ussi, stock dans le pc
    begin
      Capturer(perso,sauvage);
      readln;
      sortie := true;
      writeln('Le combat est termin�');
    end;
  end;
  if choix = 4 then
  begin
    if perso.nbPotion>0 then
    begin
      perso.nbPotion := perso.nbPotion - 1;
      writeln('Il vous reste ',perso.nbPotion,' potion(s).');
      pvrecuperer := potion(perso.equipe[1].pv,perso.equipe[1].pvmax,perso.equipe[1].niveau);
      writeln(perso.pseudo,' utilise une potion');                                   // Utilisation de potion en fonction du nombre poss�d�
      writeln(perso.equipe[1].nom,' � r�cup�rer ', pvrecuperer:0:2,'PV' );
      perso.equipe[1].pv := perso.equipe[1].pv+pvrecuperer ;
    end
    else writeln('Vous n''avez plus de potion !');
  end;
  if choix = 5 then
  begin
  changement := ChangementGkmnCombat(perso,true);   //Echange le geekemon actuelle avec un autre selectionner dans l'�quipe
  end;

  if choix = 6 then
  begin
   writeln('Vous prennez la fuite.');
   readln;
   sortie := true ;
  end;
  if ((choix <5)or changement) and (GkmnEnVie(sauvage)) then
  begin
    if obtenir = false then
    begin
      if actionadversaire = 0  then
      begin                           // Block d'action de l'adversaire dans le cas ou il est vivant et n'est pas capture
        writeln(sauvage.nom,' attaque !');
        perso.equipe[1].pv := attaque(sauvage.nom,perso.equipe[1].nom,perso.equipe[1].pv,sauvage.strength,sauvage.agi,sauvage.carac);
      end
      else
      begin
        writeln(sauvage.nom,' utilise sont attaque �l�mentaire');
        perso.equipe[1].pv := attaqueElementaire(sauvage.nom,perso.equipe[1].nom,perso.equipe[1].pv,sauvage.strength,sauvage.agi,sauvage.carac,sauvage.element,perso.equipe[1].element);
      end;
      if not(GkmnEnVie(perso.equipe[1]))then
      begin
        writeln(perso.equipe[1].nom,' est mort !');
        readln;
        if EquipeEnVie(perso.equipe) then ChangementGkmnCombat(perso,false)
        else
        begin
        writeln('Le combat est termin�');
        readln;
        sortie := true;
        end;
      end;
    end;
  end;

  readln;
end;
  choisirSalle(perso,adversaire,geekedex);  //Fin du combat retour � la selection de la salle
end;

procedure MatchDresseur(var perso : joueur;adversaire : pnj;var geekedex:pokedex;id :integer);  //procedure qui engage un combat contre un dresseur
var
  choix,actionadversaire, restant: integer;
  sortie,obtenir,changement,autorisation : boolean;
  pvrecuperer : real;
  elementJ,elementA : string;
  adversaireTemp : dresseur;

begin
  if id < 10 then niveauAdv(adversaire[id],perso)       //Comme l'id 10 correspond au boss on v�rifie d'abord si on se bat contre le boss ou pas
  else bossFinal(adversaire[id]);
  adversaireTemp := adversaire[id];   //On cr�e une copie de l'adversaire
  sortie := false;
  obtenir := false ;
  autorisation := true;
  changement := false;
  writeln('Vous d�fiez en duel ',adversaireTemp.nom,'.');
  writeln('       - ',adversaireTemp.texte);
  restant := adversaireTemp.nbGkmn;
  readln;
  bandeauLoc(perso);
  while sortie = false do
  begin
  elementJ := affichageElement(perso.equipe[1].element);
  elementA := affichageElement(adversaireTemp.equipe[1].element);
  bandeauLoc(perso);


  writeln('-----------------------------------');
  writeln('- Combat avec ',adversaireTemp.nom);
  writeln('-----------------------------------');
                                                                 //Block d'affichage pendant le combat
  writeln('Le geekemon sauvage : ',adversaireTemp.equipe[1].nom,' se pr�pare au combat.');
  writeln('Votre geekemon : ',perso.equipe[1].nom,' se pr�pare au combat. ');
  writeln(adversaireTemp.equipe[1].nom,' Niv.',adversaireTemp.equipe[1].niveau,' : ', adversaireTemp.equipe[1].pv:0:2 ,' PV',' Element : ',elementA);
  writeln(perso.equipe[1].nom,' Niv.',perso.equipe[1].niveau ,' : ',perso.equipe[1].pv:0:2, ' PV',' Element : ',elementJ);
  writeln('C''est � ',perso.equipe[1].nom,' d''agir, que souhaitez vous faire ? ');
  writeln('1 - Attaquer');
  writeln('2 - Attaque Elementaire');
  writeln('3 - Utiliser une potion (',perso.nbPotion,')');
  writeln('4 - Changer de geekemon');

  readln(choix);
  actionadversaire := action();
  if choix = 1  then
  begin
    writeln(perso.equipe[1].nom,' attaque !');
    adversaireTemp.equipe[1].pv := attaque(perso.equipe[1].nom,adversaireTemp.equipe[1].nom,adversaireTemp.equipe[1].pv,perso.equipe[1].strength,perso.equipe[1].agi,perso.equipe[1].carac) ;
    if adversaireTemp.equipe[1].pv <1 then    //Verification si le geekemons de l'adversaire est toujours en vie
    begin
    writeln(adversaireTemp.equipe[1].nom,' est mort !');
    gainExperience(perso,adversaireTemp.equipe[1]);
    restant:= restant - 1;   // On v�rifie si l'adversaire poss�de toujours des geekemons vivant
     if restant = 0 then
     begin
     writeln('Le combat est termin�');
     writeln('Vous avez gagn� ',adversaireTemp.recompense div 100,' euro(s)');
     perso.argent:= perso.argent + adversaireTemp.recompense;
     readln;
     sortie := true;
     if  perso.emplacement = Amphi then
     begin
      bandeauLoc(perso);
      Fin(perso,adversaire,geekedex);
     end
     end
     else
     begin
     changeGeekemonAdv(adversaireTemp.equipe[1],adversaireTemp.equipe[2],adversaireTemp.equipe[3],adversaireTemp.equipe[4]);
     autorisation := false
     end;
    end;
  end;
  if choix = 2 then
  begin
  writeln(perso.equipe[1].nom,' utilise sont attaque elementaire !');
  adversaireTemp.equipe[1].pv := attaqueElementaire(perso.equipe[1].nom,adversaireTemp.equipe[1].nom,adversaireTemp.equipe[1].pv,perso.equipe[1].strength,perso.equipe[1].agi,perso.equipe[1].carac,perso.equipe[1].element,adversaireTemp.equipe[1].element) ;
  if adversaireTemp.equipe[1].pv <1 then     //Verification si le geekemons de l'adversaire est toujours en vie
    begin
     writeln(adversaireTemp.equipe[1].nom,' est mort !');
     gainExperience(perso,adversaireTemp.equipe[1]);
     restant := restant - 1;    // On v�rifie si l'adversaire poss�de toujours des geekemons vivant
     if restant = 0 then
     begin
     writeln('Le combat est termin�');
     writeln('Vous avez gagn� ',adversaireTemp.recompense div 100,' euro(s)');
     perso.argent:= perso.argent + adversaireTemp.recompense;
     readln;
     sortie := true;
     if  perso.emplacement = Amphi then
     begin
      bandeauLoc(perso);
      Fin(perso,adversaire,geekedex);
     end
     end
     else
     begin
     changeGeekemonAdv(adversaireTemp.equipe[1],adversaireTemp.equipe[2],adversaireTemp.equipe[3],adversaireTemp.equipe[4]);
     autorisation := false
     end;
  end;
  end;
  if choix = 3 then
  begin
    if perso.nbPotion>0 then
    begin
      perso.nbPotion := perso.nbPotion - 1;
      writeln('Il vous reste ',perso.nbPotion,' potion(s).');
      pvrecuperer := potion(perso.equipe[1].pv,perso.equipe[1].pvmax,perso.equipe[1].niveau);
      writeln(perso.pseudo,' utilise une potion');
      writeln(perso.equipe[1].nom,' � r�cup�rer ', pvrecuperer:0:2,'PV' );
      perso.equipe[1].pv := perso.equipe[1].pv+pvrecuperer ;
    end
    else writeln('Vous n''avez plus de potion !');
  end;
  if choix = 4 then
  begin
  changement := ChangementGkmnCombat(perso,true);      //changement de geekemon manuel pendant le combat
  end;

  if (adversaireTemp.equipe[1].pv>0) then
  begin
  if autorisation = true then
  begin
    if obtenir = false then
    begin
      if actionadversaire = 0  then
      begin
        writeln( adversaireTemp.equipe[1].nom ,' attaque !' );
        perso.equipe[1].pv := attaque(adversaireTemp.equipe[1].nom,perso.equipe[1].nom,perso.equipe[1].pv,adversaireTemp.equipe[1].strength,adversaireTemp.equipe[1].agi,adversaireTemp.equipe[1].carac);
      end
      else
      begin
      writeln( adversaireTemp.equipe[1].nom ,' utilise son attaque elementaire');
      perso.equipe[1].pv := attaqueElementaire(adversaireTemp.equipe[1].nom,perso.equipe[1].nom,perso.equipe[1].pv,adversaireTemp.equipe[1].strength,adversaireTemp.equipe[1].agi,adversaireTemp.equipe[1].carac,adversaireTemp.equipe[1].element,perso.equipe[1].element);
      end;
      if not(GkmnEnVie(perso.equipe[1]))then     //Verification si le geekemons est toujours vivant
      begin
        writeln(perso.equipe[1].nom,' est mort !');
        readln;
        if EquipeEnVie(perso.equipe) then ChangementGkmnCombat(perso,false)  //V�rification si le joueur poss�de des geekemons vivant
        else
        begin
		   	writeln('Le combat est termin�');       //Fin de combat si �quipe morte
			  readln;
			  sortie := true;
        end;
      end;
    end;
  end;
  end;
autorisation := true;
readln;

end;
choisirSalle(perso,adversaire,geekedex);
end;
end.
