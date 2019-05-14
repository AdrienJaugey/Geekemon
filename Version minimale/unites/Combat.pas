unit Combat;

interface
uses
  System.SysUtils,
  GestionEcran,
  GestionGeekemon,
  TypePerso,
  ProgCombatAdversaire,
  progCombatJoueur;

procedure MatchSauvage(var perso : joueur; var adversaire : pnj ; var geekedex : pokedex);
  procedure MatchDresseur(var perso : joueur;var adversaire : pnj;var geekedex : pokedex; id : integer);

implementation
uses
 ChoixDestination;
procedure MatchSauvage(var perso : joueur; var adversaire : pnj ; var geekedex : pokedex);
var
  choix,actionadversaire : integer;
  sortie,obtenir : boolean;
  pvrecuperer : real;
  sauvage : geekemon;

begin
  randomize();
  sauvage := geekedex[random(18)+1];
  sortie := false;
  obtenir := false ;
  while sortie = false do
  begin
  effacerEcran;
  writeln('Alors que vous entrez dans la salle, vous apercevez une petit silhouette se faufiler entre les ordinateurs. Pas de doute, un Geekemon sauvage se trouve dans cette salle. D''un geste rapide vous attraper la geekeball de ',perso.equipe[1].nom,' et la lancez en direction du Geekemon.');

  writeln('-----------------------------------');
  writeln('- Combat avec un Geekemon sauvage -');
  writeln('-----------------------------------');

  writeln('Le geekemon sauvage : ',sauvage.nom,' se prépare au combat.');
  writeln('Votre geekemon : ',perso.equipe[1].nom,' se prépare au combat. ');
  writeln(sauvage.nom,' : ', sauvage.pv:0:2 ,' PV');
  writeln(perso.equipe[1].nom, ' : ',perso.equipe[1].pv:0:2, ' PV');
  writeln('C''est à ',perso.equipe[1].nom,' d''agir, que souhaitez vous faire ? ');
  writeln('1 - Attaquer');
  writeln('2 - Defendre');
  writeln('3 - Lancer une geekeball');
  writeln('4 - Utiliser une potion (',perso.nbPotion,')');
  writeln('5 - Fuir le combat');

  readln(choix);
  actionadversaire := action();
  if choix = 1  then
  begin
    sauvage.pv := attaque(sauvage.nom,sauvage.pv,actionadversaire) ;
    if sauvage.pv <1 then
    begin
     writeln(sauvage.nom,' est mort !');
     writeln('Le combat est terminé');
     readln;
     sortie := true
    end;
  end;
  if choix = 2 then
  begin
    writeln(perso.equipe[1].nom, ' se défend.');
  end;
  if choix = 3 then
  begin
    writeln('Vous lancez une geekeball');
    obtenir := capture(sauvage.pv);
    if obtenir = true then
    begin
      Capturer(perso,sauvage);
      readln;
      sortie := true;
      writeln('Le combat est terminé');
    end;
  end;
  if choix = 4 then
  begin
    if perso.nbPotion>0 then
    begin
      perso.nbPotion := perso.nbPotion - 1;
      writeln('Il vous reste ',perso.nbPotion,' potion(s).');
      pvrecuperer := potion(perso.equipe[1].pv);
      writeln(perso.pseudo,' utilise une potion');
      writeln(perso.equipe[1].nom,' à récupérer ', pvrecuperer:0:2,'PV' );
      perso.equipe[1].pv := perso.equipe[1].pv+pvrecuperer ;
    end
    else writeln('Vous n''avez plus de potion !');
  end;
  if choix = 5 then
  begin
   writeln('Vous prennez la fuite.');
   readln;
   sortie := true ;
  end;
  if (choix <5) and (sauvage.pv>0) then
  begin
    if obtenir = false then
    begin
      if actionadversaire = 0  then
      begin
        writeln( sauvage.nom ,' attaque !' );
        perso.equipe[1].pv := attaqueadversaire(perso.equipe[1].nom,choix,perso.equipe[1].pv);

        if not(GkmnEnVie(perso.equipe[1]))then
        begin
         writeln(perso.equipe[1].nom,' est mort !');
          readln;
        if EquipeEnVie(perso.equipe) then ChangementGkmnCombat(perso,false)
        else
        begin
		   	  writeln('Le combat est terminé');
			    readln;
			    sortie := true;
        end;
        end;
      end
      else
      begin
        writeln( sauvage.nom ,' se défend.');
      end;
    end;
  end;
  readln;
end;
  choisirSalle(perso,adversaire,geekedex);
end;

procedure MatchDresseur(var perso : joueur;var adversaire : pnj;var geekedex : pokedex; id : integer);
var
  choix,actionadversaireTemp, restant : integer;
  sortie,obtenir,autorisation : boolean;
  pvrecuperer : real;
  sauvage : geekemon;
  adversaireTemp : dresseur;
begin
  adversaireTemp := adversaire[id];
  sortie := false;
  autorisation := true;
  writeln('Vous défiez en duel ',adversaireTemp.nom,'.');
  writeln('       - ',adversaireTemp.texte);
  restant := adversaireTemp.nbGkmn;
  readln;
  while sortie = false do
  begin
  effacerEcran;


  writeln('-----------------------------------');
  writeln('- Combat avec ',adversaireTemp.nom);
  writeln('-----------------------------------');

  writeln('Le geekemon sauvage : ',adversaireTemp.equipe[1].nom,' se prépare au combat.');
  writeln('Votre geekemon : ',perso.equipe[1].nom,' se prépare au combat. ');
  writeln(adversaireTemp.equipe[1].nom,' : ', adversaireTemp.equipe[1].pv:0:2 ,' PV');
  writeln(perso.equipe[1].nom, ' : ',perso.equipe[1].pv:0:2, ' PV');
  writeln('C''est à ',perso.equipe[1].nom,' d''agir, que souhaitez vous faire ? ');
  writeln('1 - Attaquer');
  writeln('2 - Defendre');
  writeln('3 - Utiliser une potion (',perso.nbPotion,')');

  readln(choix);
  actionadversaireTemp := action();
  if choix = 1  then
  begin
    adversaireTemp.equipe[1].pv := attaque(adversaireTemp.equipe[1].nom,adversaireTemp.equipe[1].pv,actionadversaireTemp) ;
    if adversaireTemp.equipe[1].pv <1 then
    begin
      writeln(adversaireTemp.equipe[1].nom,' est mort !');
      restant:= restant - 1;
      if restant = 0 then
      begin
      writeln('Le combat est terminé');
      writeln('Vous avez gagné ',adversaireTemp.recompense div 100,' euro(s)');
      perso.argent:= perso.argent + adversaireTemp.recompense;
      readln;
      sortie := true;
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
    writeln(perso.equipe[1].nom, ' se défend.');
  end;
  if choix = 3 then
  begin
    if perso.nbPotion>0 then
    begin
      perso.nbPotion := perso.nbPotion - 1;
      writeln('Il vous reste ',perso.nbPotion,' potion(s).');
      pvrecuperer := potion(perso.equipe[1].pv);
      writeln(perso.pseudo,' utilise une potion');
      writeln(perso.equipe[1].nom,' à récupérer ', pvrecuperer:0:2,'PV' );
      perso.equipe[1].pv := perso.equipe[1].pv+pvrecuperer ;
    end
    else writeln('Vous n''avez plus de potion !');
  end;
   if(adversaireTemp.equipe[1].pv>0) then
  begin
    if autorisation = true then
    begin
      if actionadversaireTemp = 0  then
      begin
        writeln( adversaireTemp.equipe[1].nom ,' attaque !' );
        perso.equipe[1].pv := attaqueadversaire(perso.equipe[1].nom,choix,perso.equipe[1].pv);

        if not(GkmnEnVie(perso.equipe[1]))then
        begin
         writeln(perso.equipe[1].nom,' est mort !');
         readln;
        if EquipeEnVie(perso.equipe) then ChangementGkmnCombat(perso,false)
        else
        begin
		   	  writeln('Le combat est terminé');
			    readln;
			    sortie := true;
        end;
        end;
      end
      else
      begin
        writeln( adversaireTemp.equipe[1].nom ,' se défend.');
      end;
    end;
  end;
  readln;
  autorisation := true;
end;
  choisirSalle(perso,adversaire,geekedex);
end;
end.
