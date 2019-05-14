unit GestionFichierTexte;

interface
uses
  System.SysUtils,
  TypePerso;

type
  modeOuvertureTxt = (lecture,ecriture,ajout);

procedure ouvrirFichierTxt(var Fichier : TextFile; adresse : string; mode : modeOuvertureTxt);
procedure fermerFichierTxt(var Fichier : TextFile);
function RecupDonnee(ligne : string):string;
procedure sauvegarder(adresse : string;perso : joueur);

implementation

procedure ouvrirFichierTxt(var Fichier : TextFile; adresse : string; mode: modeOuvertureTxt);
{ Proc�dure qui permet d'ouvrir un fichier en une seule ligne de commande avec le
  mode d'ouverture pr�cis� (lecture,ecriture ou ajout)}
begin
  if FileExists(adresse) then
  begin  //Cas o� le fichier existe
    Assign(Fichier, adresse);
    case mode of //Ouverture dans le mode demand�
      lecture: Reset(Fichier);
      ecriture: ReWrite(Fichier);
      ajout: Append(Fichier);
    end;
  end
  else writeln('Fichier non trouv�');  //Cas o� le fichier n'existe pas, on affiche qu'on ne l'a pas trouv�
end;

procedure fermerFichierTxt(var Fichier : TextFile);
//Proc�dure servant � fermer un fichier texte
begin
  CloseFile(Fichier);
end;

function RecupDonnee(ligne : string):string;
{ Fonction qui permet de retourner la valeur seule d'une ligne d'un fichier texte avec ent�te
      ex : '[pseudo] Dresseur' donnera 'Dresseur' }
var
  i,j : integer;
  res : string;
const
  debug = FALSE; //Mise � TRUE, permet d'afficher la ligne lue et la valeur que la fonction renvoit
Begin
  i := 1;  //Initialisation des variables
  res:='';
  if debug then writeln(ligne);
  while (ligne[i] <> ' ') do  //On recherche la position de l'espace (caractere succedant l'ent�te)
  begin
    i := i + 1;
  end;
  for j := 1 to (ligne.Length - i) do //On r�cup�re la partie suivante et on l'affecte � res
  begin
    res := res + ligne[i+j];
  end;
  if debug then
  begin
    writeln(res);
    readln;
  end;
  Result := res;  //On retourne res
End;

procedure sauvegarder(adresse : string;perso : joueur);
// Procedure permettant de cr�er une sauvagarde de la partie en cours
var
  i,j : integer;
  save : TextFile;
  ligne : string;
begin
  Assign(save,adresse);  //On ouvre le fichier texte en mode �criture, s'il n'�xiste pas, il est alors cr�e
  ReWrite(save);
  writeln(save,'[JOUEUR]'); //Cr�ation de la ligne de s�paration ici, on stocke des donn�es relatives au joueur
  writeln(save,'');
  ligne := '[pseudo] ' + perso.pseudo; //Cr�ation de la ligne par l'ajout de la donn�e � l'ent�te
  writeln(save,ligne);  //On �crit la ligne pr�cedemment cr�e
  ligne := '[argent] ' + IntToStr(perso.argent);  //On recommence avec l'argent poss�d� par le joueur
  writeln(save,ligne);
  ligne := '[nbGkmn] ' + IntToStr(perso.nbGkmn); //Idem avec le nombre de geekemon qu'il poss�de
  writeln(save,ligne);
  if perso.combat then ligne := '[combat] TRUE'     //Ecriture de l'�tat de combattre
                  else ligne := '[combat] FALSE';
  writeln(save, ligne);
  if perso.quete then ligne := '[quete] TRUE'       //Ecriture de l'�tat de la qu�te
                  else ligne := '[quete] FALSE';
  writeln(save, ligne);
  ligne := '[nbPotion] ' + IntToStr(perso.nbpotion); //Ecriture du nombre de potion d�tenue
  writeln(save,ligne);
  ligne := '[gkmnEnStock] ' + IntToStr(perso.pc.gkmnEnStock); //Idem avec le nombre de geekemons dans le PC
  writeln(save,ligne);

  writeln(save,'');
  writeln(save,'[EQUIPE]'); //On sauvegarde ici les geekemons de l'�quipe du joueur (de 1 jusqu'� 4)
  for i := 1 to perso.nbGkmn do  //On �crit dans la sauvegarde autant de geekemon que le joueur poss�de pour optimiser l'espace
  begin
    writeln(save,'');
    ligne := '[id] ' + IntToStr(perso.equipe[i].id);  //Cr�ation de la ligne, ent�te et valeur de l'id du geekemon
    writeln(save,ligne); //Ecriture de la ligne
    ligne := '[nom] ' + perso.equipe[i].nom; //Idem avec le nom du geekemon
    writeln(save,ligne);
    ligne := '[pv] ' + FloatToStr(perso.equipe[i].pv);  //Idem avec les pv du geekemon
    writeln(save,ligne);
    if perso.equipe[i].ko then ligne := '[ko] TRUE'   //Idem avec l'etat du geekemon
                          else ligne := '[ko] FALSE';
    writeln(save,ligne);
    ligne := '[exp] ' + IntToStr(perso.equipe[i].exp); //Idem avec l'experience du geekemon
    writeln(save,ligne);
    ligne := '[expmax] ' + IntToStr(perso.equipe[i].expmax); //Idem avec l'experience max du geekemon
    writeln(save,ligne);
    ligne := '[niveau] ' + IntToStr(perso.equipe[i].niveau);    //Idem avec le niveau du geekemon
    writeln(save,ligne);
  end;

  writeln(save,'');
  writeln(save,'[PC]');  //M�me chose avec le PC
  for i := 1 to perso.pc.gkmnEnStock do
  begin
    writeln(save,'');
    ligne := '[id] ' + IntToStr(perso.pc.boite[i].id);
    writeln(save,ligne);
    ligne := '[nom] ' + perso.pc.boite[i].nom;
    writeln(save,ligne);
    ligne := '[pv] ' + FloatToStr(perso.pc.boite[i].pv);
    writeln(save,ligne);
    if perso.pc.boite[i].ko then ligne := '[ko] TRUE'
                          else ligne := '[ko] FALSE';
    writeln(save,ligne);
    ligne := '[exp] ' + IntToStr(perso.pc.boite[i].exp);
    writeln(save,ligne);
    ligne := '[expmax] ' + IntToStr(perso.pc.boite[i].expmax);
    writeln(save,ligne);
    ligne := '[niveau] ' + IntToStr(perso.pc.boite[i].niveau);
    writeln(save,ligne);
  end;

  fermerFichierTxt(save);  //On ferme le fichier pour gagner en m�moire
end;
end.

