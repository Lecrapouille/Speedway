unit U_chargement;

interface
USES
  HUD,
  SysUtils,
  Opengl,
  Caractere,
  Loader,
  effet,
  Voiture,
  Armes,
  typege;
  
procedure Chargement(nom_map : string; Map : Pobjet);

implementation

procedure chargementdelamap(nom : string; Map : Pobjet);
begin
  loaderAse(GetCurrentDir + '\data\map\' + nom, Map);
end;

//----------------------------------------------------------------------------//

procedure chargementdesvoitures;
begin
loaderAse(GetCurrentDir + '\data\voiture\jeep.ase', @joel_m);
loaderAse(GetCurrentDir + '\data\voiture\Camion.ase', @priscillien_m);
loaderAse(GetCurrentDir + '\data\voiture\tank5.ase', @quentin_m);
loaderAse(GetCurrentDir + '\data\voiture\blinde.ase', @roman_m);
loaderAse(GetCurrentDir + '\data\voiture\Pelleteuse.ase', @pelleteuse_m);
//loaderAse(GetCurrentDir + '\data\voiture\tankdestroy.ASE', @tankdestroy);
loaderAse(GetCurrentDir + '\data\voiture\DrapeauBleu.ASE', @DrapeauBleu);
loaderAse(GetCurrentDir + '\data\voiture\DrapeauRouge.ASE', @DrapeauRouge);
end;

//----------------------------------------------------------------------------//
procedure chargementdesarmes;
begin
loaderAse(GetCurrentDir + '\data\Arme\arme_2.ase', @arme_2_m);
loaderAse(GetCurrentDir + '\data\Arme\arme_3.ase', @arme_3_m);
loaderAse(GetCurrentDir + '\data\Arme\arme_1.ase', @arme_4_m);
loaderAse(GetCurrentDir + '\data\Arme\arme_5.ase', @arme_5_m);
end;
//----------------------------------------------------------------------------//
procedure chargementdesgrades;
begin
loaderAse(GetCurrentDir + '\data\Grade\VoleurRouge.ASE', @VR);
loaderAse(GetCurrentDir + '\data\Grade\VoleurBleu.ASE', @VB);
loaderAse(GetCurrentDir + '\data\Grade\TireurRouge.ASE', @TR);
loaderAse(GetCurrentDir + '\data\Grade\TireurBleu.ASE', @TB);
loaderAse(GetCurrentDir + '\data\Grade\DefenseurRouge.ASE', @DR);
loaderAse(GetCurrentDir + '\data\Grade\DefenseurBleu.ASE', @DB);
end;
//----------------------------------------------------------------------------//

procedure Chargement(nom_map : string; Map : Pobjet );
begin
chargementdelamap(nom_map,Map);
chargementdesvoitures;
chargementdesarmes;
chargementdesgrades;
chargementparticule(GetCurrentDir + '\data\textures\particle.bmp');
chargementHUD;
end;
//----------------------------------------------------------------------------//

end.
