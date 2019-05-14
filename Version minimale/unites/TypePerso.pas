unit TypePerso;

interface
type
  geekemon = record
    id : integer;
    nom : string;
    pv : real;
    ko : boolean;
    resume : string;
    race : string;

  end;

  pokedex = array[0..22] of geekemon;

  equipeGeekemon = array[1..4] of geekemon;

  salle = (Secretariat,Bureau,ETDDG,Amphi,R24,R29,R30,R31,S147,S148,S149,S150,S201,S202,S203,S206);

  joueur = record
    pseudo : string;
    equipe : equipeGeekemon;
    argent : integer;
    nbGkmn : integer;
    combat : boolean;
    nbPotion : integer;
    emplacement : salle;
  end;

  dresseur = record
    id : integer;
    nom : string;
    equipe : equipeGeekemon;
    nbGkmn : integer;
    texte : string;
    recompense : integer;
  end;

  pnj = array[1..10] of dresseur;
implementation

end.
