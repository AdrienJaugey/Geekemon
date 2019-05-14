program Geekemon;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  GestionEcran in 'unites\GestionEcran.pas',
  TypePerso in 'unites\TypePerso.pas',
  Geekemon_sous_programme in 'unites\Geekemon_sous_programme.pas',
  Localisation in 'unites\Localisation.pas',
  ProgCombatAdversaire in 'unites\ProgCombatAdversaire.pas',
  progCombatJoueur in 'unites\progCombatJoueur.pas',
  Combat in 'unites\Combat.pas',
  GestionGeekemon in 'unites\GestionGeekemon.pas',
  GestionFichierTexte in 'unites\GestionFichierTexte.pas',
  Tutoriel in 'unites\Tutoriel.pas';

begin
  ecranTitre(); //Lancement de l'écran titre
end.
