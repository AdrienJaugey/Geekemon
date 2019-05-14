unit ProgCombarAdversaire;

interface
function action () : integer ;
function attaqueadversaire (nom : string;choix : integer ;pv : real) : real;
implementation
function action () : integer ;

begin
  randomize;
 result := random(2)
end;



function attaqueadversaire (nom : string;choix : integer ;pv : real) : real;
var
  degats : real;
begin

  randomize;
  degats := random(16)+15 ;
  if  choix = 2 then
  begin
    degats := degats *0.65;
    pv := pv - degats ;
  end
  else
  begin
  pv := pv - degats ;
  end;
   writeln(nom,' a subit ', degats:0:2,' dégats');
   result:= pv
end;
end.
