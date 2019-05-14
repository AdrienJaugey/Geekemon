unit Tutoriel;

interface
uses
 System.SysUtils,
 TypePerso,
 Localisation,
 GestionEcran;


procedure tuto(perso : joueur);
procedure lieututo(perso : joueur);
procedure cmbtuto(perso : joueur);
procedure astuce(perso : joueur);

implementation
procedure tuto(perso:joueur);// C'est la procedure qui s'occupe du choix de joueur si il veut ou non suivre le tutoriel de capture
var
choix:integer;
begin
  writeln((perso.pseudo),', veux-tu que je te montre comment on capture un geekemon ?');
  Writeln('1 - Oui je veux bien');
  writeln('2 - T''inquiète Catherine j''assure');
  readln(choix);
if choix=2 then
begin
  astuce(perso); // S'il ne veut pas suivre le tuto on le renvoit directement aux explications des méchanismes du jeu
end
else if choix=1 then
begin
  writeln;
  perso.emplacement := Training;
  Writeln('Dans ce cas tous en voiture......euh oui c''est vrai on a pas besoin de voiture.'); // Dans le cas où il accepte on lance la procedure combat tuto
  Writeln('Allons dans la salle d''entraînement.');
  readln;
  cmbtuto(perso);
end;
end;
procedure lieututo(perso : joueur); //Cette procedure permet d'effacer l'écran et d'afficher le lieu du tutoriel en haut de l'écran
begin
  effacerEcran;
  writeln;
  writeln('    Lieu : Salle d''entraînement   ');
  writeln;
  writeln;
  writeln('----------------------------------------------------------------------------------------------------------------------');
  writeln;
end;

procedure cmbtuto(perso:joueur); // Cette procedure gère le combat scripté pour que le Prof montre au joueur comment on procède à la capture
  var
  pdvBender:integer; // comme nous somme dans un combat scripté on n'utilise pas les vrais donnée de la liste de tout les geekemons 
  pdvPikachu:integer;
begin
  pdvPikachu:=250;
  pdvBender:=150;
  BandeauLoc(perso);
  writeln('Vous apercevez une petite silhouette se faufiler entre les ordinateurs.'); //
  writeln('-----------------------------------');									 //	
  writeln('- Combat avec un Geekemon sauvage -');                                   //
  writeln('-----------------------------------');                                  //
  writeln('Le geekemon sauvage : Bender se prépare au combat.');				  // Ici on retrouvre l'interface de combat
  writeln('Le Prof lance son Pikachu, il est prêt à se battre.');				 //
  writeln('Bender : ',(pdvBender),' PV');										//
  writeln('Pikachu : ',(pdvPikachu),' PV');									   //
  readln;
  writeln((perso.pseudo),' voilà une petite astuce, plus le geekemon est faible en points de vie, plus tes chances de le capturer sont hautes');
  readln;
  writeln('Allez attaque Pikachu');
  writeln('Pikachu attaque !');
  attendre(1500);
  writeln('Bender subit 45 points de dégats.');
  writeln('Bender risposte.');
  attendre(1500);
  writeln('Pikachu subit  12 points de dégats.');
  readln;
  BandeauLoc(perso);
  writeln('-----------------------------------');
  writeln('- Combat avec un Geekemon sauvage -');
  writeln('-----------------------------------');
  writeln('Le geekemon sauvage : Bender commence à lancer des insultes.');
  writeln('Pikachu ne semble pas comprendre son langage.');
  writeln('Bender : ',(((pdvBender))-45),' PV');
  writeln('Pikachu : ',((pdvPikachu)-12),' PV');
  readln;
  writeln('Bon maintenant ',(perso.pseudo),' tu lance une geekeball et c''est parti mon kiki!!!');  //
  attendre(1000);																				   //		
  writeln('Le Prof lance une geekeball en direction du geekemon.');								  //
  attendre(1000);																				 // Ici on similule le mouvement de la geekeball par un affichage de petits points avec un interval de 1 seconde
  write('......');																				//
  attendre(1000);																			   //
  write('......');																			  //
  attendre(1000);																			 //
  write('......');																			//
  attendre(1000);																		   //
  writeln('......');																	  //
  attendre(1000);																		 //
  Writeln('Et hop le geekemon a été capturé.');											//	
  attendre(1000);																	   //
  writeln('Appuyez sur Entrée......');												  //
  readln;																			 //
  astuce(perso);                                                         // A la fin on appelle la procedure astuce  pour expliquer au joueur les méchanismes du jeu
end;

  procedure astuce(perso : joueur); // Ici il n'y a que une gestion de l'affichage qui explique les lieux importants au joueur et aussi sur les différent types élémentaires et les différentes stastistiques
  begin
    BandeauLoc(perso);
    writeln('Avant que tu partes, il faut que je t''explique certaines choses qui te seront utiles');
    readln;
    writeln('Commençons par l''ETDDG, c''est une salle où tu pourras acheter des potions pour soigner tes geekemons en combat. Tu pourras aussi te reposer toi et ton équipe pour faire le plein d''énergie');
    readln;
    writeln('Tu auras la possibilité de te balader dans les diverses salles de l''IUT afin de faire progresser la puissance de ton équipe');
    readln;
    writeln('Et si jamais tu te sens d''attaque tu peux aller à la La cafétéria pour te mesurer à d''autres dresseurs et gagner de l''argent');
    readln;
    BandeauLoc(perso);
    writeln('Bon maintenant passons aux geekemons');
    readln;
    writeln('Alors premièrement parlons des types élémentaires : Il existe 3 type feu,eau,plante dont les faiblesses/avantages sont ceux-ci feu > plante > eau > feu');
    readln;
    writeln('Donc il vaut mieux faire une attaque élémentaire contre un élément plus faible, dans le cas contraire une attaque normale conviendra mieux mais je te recommande de changer de geekemon sinon il pourrait vite tomber K.O');
    readln;
    writeln('Chaque geekemon dispose de 3 stats : agilité qui augmente des chance de faire des coups critique, la force qui augmente les dégâts des attaques et enfin l''endurance qui augmente le nombre de PV maximum');
    readln;
    writeln('Si un geekemon est expert agilité,force ou endurance alors à chaque niveau il gagnera plus de points de statistiques suivant là où il excelle mais moins dans les autres stats');
    readln;
    BandeauLoc(perso);
    writeln('Ah au fait comme chaque nouveau dresseur je dois de donner la carte du défi ultime');
    attendre(1000);
    writeln('Vous recevez une "carte défi ultime"');
    readln;
    writeln('Il y a une inscription derrière "Devient le plus puissant des dresseurs et viens m''affronter à l''Amphithéatre pour tenter de me prendre le titre de Maître de l''IUT');
    readln;
    writeln('Je pense que tout a été dit');
    attendre(1000);
    writeln;
    writeln('Il est maintenant temps pour toi, ',(perso.pseudo),' de partir à l''aventure, aidé de tes geekemons pour combler ta curiosité !',' Comme chaque débutant, tu disposes de 5 potions et 4 euros pour bien commencer, tu peux acheter plus de potion dans la salle de l''ETDDG');
    attendre(1500);
    writeln;
    writeln('Appuyez sur Entrée pour continuer...');
    readln;
end;

end.
