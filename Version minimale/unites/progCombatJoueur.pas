unit progCombatJoueur;

interface
uses
  ProgCombatAdversaire;

function attaque (nom : string ; pv : real; defense : integer) : real;
function capture(pv : real) : boolean ;
function potion(pv : real): real;
implementation
function attaque (nom : string ; pv : real; defense : integer) : real;
var
  degats : real;
begin
  randomize;
  degats := random(6)+25 ;
  if defense = 1 then
  begin
    degats := degats *0.65;
    pv := pv - degats ;
  end
  else
  begin
  pv := pv - degats ;
  end;
  writeln(nom,' a subit ',degats:0:2,' dégats');
  result := pv
end;

function capture(pv : real) : boolean ;
var
  chance : real;
  reussi : integer;
begin
  randomize;
  reussi := random(100)+1;
  if pv> 50 then
  begin
      chance := 15*(1+((100-pv)/100));
  end
  else
    chance := 40*(1+((100-pv)/100));
  if chance > reussi then
  begin
    writeln('vous avez capturer le Geekemon. Bravo !');
    result := true;
  end
  else
  begin
    writeln('La capture du Geekemon à échoué...') ;
    result := false
  end;
  end;
function potion(pv : real): real;
const
  potion = 40;
begin
    if pv < 110 then
    begin
    result :=  potion  ;
    end
    else
    begin
    result := (150 - pv) ;
    end;
end;
end.

