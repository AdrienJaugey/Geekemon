unit GestionFichierTexte;

interface
uses
  System.SysUtils,
  TypePerso;

type
  modeOuvertureTxt = (lecture,ecriture,ajout);

procedure ouvrirFichierTxt(var Fichier : TextFile; adresse : string; mode : modeOuvertureTxt);
procedure fermerFichierTxt(var Fichier : TextFile);
function lireFichierTxt(var Fichier : TextFile; numLigne : integer):string;
function nbLigne(var Fichier : TextFile;adresse:string;mode : modeOuvertureTxt):integer;
function RecupDonnee(ligne : string):string;

implementation

procedure ouvrirFichierTxt(var Fichier : TextFile; adresse : string; mode: modeOuvertureTxt);
begin
  if FileExists(adresse) then
  begin
    Assign(Fichier, adresse);
    case mode of
      lecture: Reset(Fichier);
      ecriture: ReWrite(Fichier);
      ajout: Append(Fichier);
    end;
  end
  else writeln('Fichier non trouvé');
end;

procedure fermerFichierTxt(var Fichier : TextFile);
begin
  CloseFile(Fichier);
end;

function lireFichierTxt(var Fichier : TextFile; numLigne : integer):string;
var
  i : integer;
  ligne : string;
begin
  for i := 1 to (numLigne - 1) do
  begin
  readln(Fichier, ligne);
  end;
  readln(Fichier, ligne);
  Result := ligne;
end;

function nbLigne(var Fichier : TextFile;adresse:string;mode : modeOuvertureTxt):integer;
var
  res : integer;
  ligne : string;
Begin
  res := 0;
  while not(EOF(Fichier)) do
  begin
    readln(Fichier,ligne);
    res := res + 1;
  end;
  fermerFichierTxt(Fichier);
  OuvrirFichierTxt(Fichier,adresse,mode);
  Result := res;
End;

function RecupDonnee(ligne : string):string;
var
  i,j : integer;
  res : string;
const
  debug = FALSE;
Begin
  i := 1;
  res:='';
  if debug then writeln(ligne);
  while (ligne[i] <> ' ') do
  begin
    i := i + 1;
  end;
  for j := 1 to (ligne.Length - i) do
  begin
    res := res + ligne[i+j];
  end;
  if debug then
  begin
    writeln(res);
    readln;
  end;
  Result := res;
End;

end.

