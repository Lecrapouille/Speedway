unit boucleIAcol;

interface
uses
  joueur,
  maths,
  Armes,
  IA,
  effet,
  collision,
  bonus,
  DDirectSound,
  typege;

procedure bouclage( jtete : T_pJoueur; lbonus : T_pBonus;var listep : T_pSysteme_de_particules;
                    map : Pobjet; dsb : array of  TDirectSoundBuffer; param : T_param);

implementation


procedure bouclage( jtete : T_pJoueur; lbonus : T_pBonus;var listep : T_pSysteme_de_particules;
                    map : Pobjet; dsb : array of  TDirectSoundBuffer; param : T_param);
var j1, jpoursuit : T_pJoueur;
    jbonus : T_pBonus;
begin
//parcour les differents joueur
  j1 := jtete;
  while j1<>NIL do
  begin
    if not j1.Mort then
    begin
     { if (j1.Categorie=artificielle) and not(j1.Mort)and(param.config.ia=0) then
      begin
        // renvoie la voiture a poursuivre
        jpoursuit := nil;
        jbonus := nil;
        jpoursuit := voitvoiture(j1, jtete, map);
        jbonus := voitbonus(j1, lbonus, map);
        if (jpoursuit<>nil)and(j1.Equipe<>jpoursuit.Equipe)and(j1.Equipe<>neutre) then
            ChampVV(j1, jpoursuit)
        else if jbonus<>nil then
               ChampVB(j1, jbonus)
             else if j1.Voiture.vitesse.norme< 1.0 then j1.Voiture.Avance;
        ChampVM(j1, map);
        if j1.timer>30 then j1.timer := 0
        else inc(j1.timer);
      end; }


      if (j1.Armeselectionne.NbrArme<1)and
          ((j1.Arme_1.NbrArme>0) or
          (j1.Arme_2.NbrArme>0) or
          (j1.Arme_3.NbrArme>0) or
          (j1.Arme_4.NbrArme>0) or
          (j1.Arme_5.NbrArme>0) or
          (j1.Arme_6.NbrArme>0)) then j1.ArmeSuivante;
      // collision voiture-Bonus
      //colliVB(j1, lbonus, dsb);


     // j1.collision(jtete,listep,map,dsb);

     // j1.convertion(jtete,dsb);
     // if (j1.Categorie=humain) and (j1.Equipe=rouge) then changerjoueur(jtete)
    end;
    j1 := j1^.next;
   end
end;

end.
