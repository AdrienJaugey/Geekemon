unit TypePerso;

interface
uses
  SysUtils;

type
  caracteristique = (force,agilite,endurance);

  geekemon = record  //Définition d'un geekemon
    id : integer;
    nom : string;
    pv : real;
    pvmax : real;
    resume : string;
    race : string;
    element : integer; //2 : feu | 4 : eau | 8 : plante
    carac : caracteristique;
    strength : integer;
    agi : integer;
    endu : integer;
    ko : boolean; //Capacité à combattre du geekemon
    exp : integer;
    expmax : integer;
    niveau : integer; //niveau du geekemon
  end;

  pokedex = array[0..22] of geekemon;

  equipeGeekemon = array[1..4] of geekemon;

  pcStock = array[1..80] of geekemon;

  stock = record
    gkmnEnStock : integer;
    boite : pcStock;
  end;

  salle = (Secretariat,Bureau,ETDDG,Amphi,Training,Cafet,R24,R29,R30,R31,S147,S148,S149,S150,S201,S202,S203,S206);

  joueur = record
    pseudo : string;
    quete : boolean;
    equipe : equipeGeekemon;
    argent : integer;
    nbGkmn : integer;
    combat : boolean;
    nbPotion : integer;
    emplacement : salle;
    pc : stock;
  end;

  dresseur = record
    id : integer;
    nom : string;
    equipe : equipeGeekemon;
    nbGkmn : integer;
    texte : string;
    recompense : integer;
  end;

  pnj = array[1..10] of dresseur;

//Procédures utilisées dans le cadre de test, affichage simple de nombreuses données respectivement sur le perso, un dresseur et un geekemon
procedure debugPerso(perso : joueur);
procedure debugDresseur(adv : dresseur);
procedure debugGeekemon(gkmn : geekemon);
procedure queteprinc(var perso : joueur);

implementation
uses
  Localisation;
procedure debugPerso(perso : joueur);
begin
  writeln('pseudo : ',perso.pseudo);
  writeln('id gkmn 1 : ',perso.equipe[1].id);
  writeln('argent : ',perso.argent);
  writeln('nbGkmn : ',perso.nbGkmn);
  writeln('combat : ',perso.combat);
  writeln('nbPotion : ',perso.nbPotion);
  readln;
end;
procedure debugDresseur(adv : dresseur);
begin
  writeln(adv.id);
  writeln(adv.nom);
  writeln(adv.equipe[1].id);
  writeln(adv.equipe[2].id);
  writeln(adv.nbGkmn);
  writeln(adv.texte);
  writeln(adv.recompense);
  readln;
end;

procedure debugGeekemon(gkmn : geekemon);
begin
  writeln('id :',gkmn.id);
  writeln('nom : ',gkmn.nom);
  writeln('pv : ',gkmn.pv:0:2);
  writeln('pv max :',gkmn.pvmax:0:2);
  writeln('resume : ',gkmn.resume);
  writeln('race : ',gkmn.race);
  writeln('element : ',gkmn.element);
  if gkmn.carac = force then writeln('carac : force')
  else if gkmn.carac = agilite then writeln('carac : agilite')
  else if gkmn.carac = endurance then writeln('carac : endurance')
  else writeln('carac : ERREUR');
  writeln('strenght : ',gkmn.strength);
  writeln('agilite : ',gkmn.agi);
  writeln('endurance : ',gkmn.endu);
  if gkmn.ko then writeln('ko : true')
             else writeln('ko : false');
  writeln('exp : ',gkmn.exp);
  writeln('exp max : ',gkmn.expmax);
  writeln('niveau : ',gkmn.niveau);
  readln;
end;
procedure queteprinc(var perso : joueur); //Procedure affichant la quete principale et sa réalisation
var
  quest : string;
begin
bandeauLoc(perso);
  if perso.quete   then quest := 'Terminée'
  else quest :='En cours';

  writeln('Quete Principale : ',quest);
  writeln;
  Writeln('Fais progresser ton équipe afin d''arreter les plan du Chimiste fou.');
  writeln('Tu peut trouver le Chimiste fou dans l''amphitheatre, mais son accès te sera');
  writeln('limité si ton équipe n''a pas un niveau moyen d''au moins 28');
  writeln;
  writeln('Récompense :');
  writeln;
  writeln('   Expériences des geekemons multipliées par 2');
  writeln('   Titre "Maitre IUT"');
  readln;
end;
end.
