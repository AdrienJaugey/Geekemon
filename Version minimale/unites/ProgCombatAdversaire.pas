unit ProgCombatAdversaire;

interface
uses typePerso ;
function action () : integer ;
function attaqueadversaire (nom : string;choix : integer ;pv : real) : real;
procedure changeGeekemonAdv(var gkmn1 : geekemon;var gkmn2 : geekemon;var gkmn3 : geekemon;var gkmn4 : geekemon);
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
  degats := random(6)+25 ;
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
procedure changeGeekemonAdv(var gkmn1 : geekemon;var gkmn2 : geekemon;var gkmn3 : geekemon;var gkmn4 : geekemon);
var
  gkmntemp : geekemon ;
begin
  gkmntemp := gkmn1 ;
  gkmn1 := gkmn2;
  gkmn2:=gkmn3;
  gkmn3:=gkmn4;
  gkmn4:=gkmn1;
end;
end.
