program Geekemon;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  GestionEcran in 'unites\GestionEcran.pas',
  TypePerso in 'unites\TypePerso.pas',
  Geekemon_sous_programme in 'unites\Geekemon_sous_programme.pas',
  ChoixDestination in 'unites\ChoixDestination.pas',
  ProgCombatAdversaire in 'unites\ProgCombatAdversaire.pas',
  progCombatJoueur in 'unites\progCombatJoueur.pas',
  GestionFichierTexte in 'unites\GestionFichierTexte.pas',
  Combat in 'unites\Combat.pas',
  GestionGeekemon in 'unites\GestionGeekemon.pas';

begin
  nouvellePartie();
end.
