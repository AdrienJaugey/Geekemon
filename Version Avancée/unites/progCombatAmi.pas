unit progCombatAmi;

interface
uses
  ProgCombatEnnemi ;

function attaque (pv : real) : real;
function capture(pv : real) : boolean ;
function potion(pv : real): real;
implementation
function attaque (pv : real) : real;
var
  degats : real;
  defense : integer ;
begin
  defense := action();
  randomize;
  degats := random(16)+15 ;
  if defense = 0 then
  begin
    degats := degats *0.65;
    pv := pv - degats ;
    result:= pv
  end
  else
  begin
  pv := pv - degats ;
  result :=  pv
  end;
end;
 function défense (pv : real ;nomsauvage : string) : integer;
 var
 degatssubi : integer;
 begin
   attaque:= action();
   if attaque = 1 then
   degatssubi:= attaqueadversaire() *0.65;
   writeln(nomsauvage,' à subit ' ,degatssubi,'dégats');
   pv := pv - degatssubi ;
   result:= pv

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
    write('vous avez capturer le Geekemon. Bravo !');
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
  potion = 25;
begin
    if pv < 75 then
    begin
    result :=  potion  ;
    end
    else
    begin
    result := (100 - pv) ;
    end;
end;
end.

