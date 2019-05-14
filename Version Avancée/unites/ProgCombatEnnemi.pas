unit ProgCombatEnnemi;

interface
function action () : integer ;
function attaqueadversaire (pv : real) : real;
implementation
function action () : integer ;
var
action1 : integer;
begin
  randomize;
  action :=random(1);
  result := action
end;



function attaqueadversaire (choix : integer ;pv : real) : real;
var
  degats : real;
begin

  randomize;
  degats := random(16)+15 ;
  if  choix = 2 then
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
end.
