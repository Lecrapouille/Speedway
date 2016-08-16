unit BoucleBot;

interface

USES
  QQ,
  Windows,
  SysUtils,
  Messages,
  Opengl,
  typege,
  Joueur,
  Voiture,
  collision,
  UControle,
  Armes,
  U_Chargement,
  lancement,
  math,
  maths,
  effet,
  Bonus,
  Repere,
  DDirectSound,
  caractere;


function Boubou(ll : T_pJoueur; bonus : t_pBonus; var listep : T_pSysteme_de_particules;
                 var dsb : array of  TDirectSoundBuffer; map : PObjet; Frot,MyTime : real; FreqTir : integer; NbCarte : integer) : boolean;
procedure BoucleCaptureFlag(ll : T_pJoueur; bonus : t_pBonus; var listep : T_pSysteme_de_particules;
                 var dsb : array of  TDirectSoundBuffer; map : PObjet; PlusDrapeauBleu,PlusDrapeauRouge : integer; Frot,MyTime : real; FreqTir : integer);

implementation

//VAR
  //MyTime : real = 1;
  //Frot : real = 0.5;//0.8;
  //FreqTir : integer = 7;





//**********************************************************************************************************************//
//
//                                     Boubou
//
//**********************************************************************************************************************//

function Boubou(ll : T_pJoueur; bonus : t_pBonus; var listep : T_pSysteme_de_particules;
                 var dsb : array of  TDirectSoundBuffer; map : PObjet; Frot,MyTime : real; FreqTir : integer; NbCarte : integer) : boolean;
var tete,toto,LeJoueur,liste : t_pJoueur; JoueurEstRouge : boolean;
begin
  //MyTime := parametres.VitesseJeu;
  //Frot := parametres.frottement;
//  toto := NIL;
  tete := ll;
//  liste := ll;

  AmbianceSonore(dsb,ll,NbCarte);

  LeJoueur := ChoisitLeader(tete);
  if LeJoueur.Equipe = Rouge then AutreJoueur(LeJoueur,ll);
  //result := JoueurEstRouge;
  
 // if not(JoueurEstRouge) then //arret immediat de la boucle si le Joueur est rouge <=> Fin du jeu
 // begin
        //******************** 1er cas : Le Joueue **********************************//
        LeJoueur.collision(ll,listep,map,dsb);
        colliVB(LeJoueur, bonus, dsb);
        LeJoueur.convertion(ll,dsb);


        while (tete <> NIL) do
        begin
           {Armes}
           if (tete.Armeselectionne.NbrArme<1)and
                ((tete.Arme_1.NbrArme>0) or
                (tete.Arme_2.NbrArme>0) or
                (tete.Arme_3.NbrArme>0) or
                (tete.Arme_4.NbrArme>0) or
                (tete.Arme_5.NbrArme>0) or
                (tete.Arme_6.NbrArme>0))
           then tete.ArmeSuivante;


           //******************** 2eme cas : NEUTRE **********************************//
              if (tete.Equipe = neutre) AND (tete.vie > 0) then
              begin
                 TrouveBonus(tete,bonus,50); // Voitures neutres vont trouver les bonus
                 //colliVB(tete, bonus, dsb);   // collision voiture-bonus
                 ChampVM(tete,map,-80);       // evite les murs
                 EviteVoiture(tete,ll,-30);   //evite les autres voitures

                 //frottement
                 tete.Voiture.vex := frot * tete.Voiture.vex;
                 tete.Voiture.vey := frot * tete.Voiture.vey;

                 //norme
                 tete.Voiture.orientation.norme := sqrt(sqr(tete.Voiture.Vex)+sqr(tete.Voiture.Vey));
                 if tete.Voiture.orientation.norme > 1 then // filtre les mouvements parasites
                      begin
                         tete.Voiture.orientation.teta := 0*(tete.Voiture.orientation.teta)+1*(3.14+ArcTan2(tete.Voiture.vex,tete.Voiture.vey));
                         tete.Voiture.emplacement.coordx := tete.Voiture.emplacement.coordx + Mytime * tete.Voiture.Vex;
                         tete.Voiture.emplacement.coordz := tete.Voiture.emplacement.coordz + Mytime * tete.Voiture.Vey;
                      end;

              end;

              //******************** 3eme cas : NON NEUTRE **********************************//
              if (tete.Equipe <> neutre) AND (tete.Categorie <> humain) AND (tete.vie > 0) then
              begin
                     // TrouveBonus(tete,bonus,10);
                      colliVB(tete, bonus, dsb);
                      //ChampVM(tete,map,-50);
                      tete.collision(ll,listep,map,dsb);

                      liste := ll;
                      while liste <> NIL do
                      begin
                        TrouveBonus(liste,bonus,10);
                        ChampVM(liste,map,-10);

                        //evite toutes les voitures
                        if (liste <> tete) AND (liste.vie >0) then Champrepulsif(tete,liste,-10);
                        EviteMine(tete,liste.arme);
                        TrouveUnMort(tete,liste);

                        {A decommenter}
                        toto := PlusPresVoit(tete,liste); //toto premiere voiture plus proche
                        if toto <> NIL then ChampAttractif(tete,toto,2/40);

                        //******** Enlever ou commenter le 'else' suivant selon votre choix ********//
                        //else
                        //**************************************************************************//

                          begin  // si pas de toto alors les deux leaders s'attirent et les autres suivent le leader
                            SuivreLeader(tete,liste);
                            LeaderVsleader(tete,liste);
                          end;

                        liste.convertion(ll,dsb);
                        OPSFlinge(tete,liste,FreqTir);
                        liste := liste.next;
                      end;

                      tete.Voiture.vex := frot * tete.Voiture.vex;
                      tete.Voiture.vey := frot * tete.Voiture.vey;
                      tete.Voiture.orientation.norme := sqrt(sqr(tete.Voiture.Vex)+sqr(tete.Voiture.Vey));

                      if tete.Voiture.orientation.norme > 1 then
                      begin
                         tete.Voiture.orientation.teta := 0*(tete.Voiture.orientation.teta)+1*(3.14+ArcTan2(tete.Voiture.vex,tete.Voiture.vey));
                         tete.Voiture.emplacement.coordx := tete.Voiture.emplacement.coordx + Mytime * tete.Voiture.Vex;
                         tete.Voiture.emplacement.coordz := tete.Voiture.emplacement.coordz + Mytime * tete.Voiture.Vey;
                      end;

              end; //**
         tete := tete.next;
        end;
  //end else result := JoueurEstRouge;
end;

//**********************************************************************************************************************//
//
//                                     BoucleCaptureFlag
//
//**********************************************************************************************************************//

procedure BoucleCaptureFlag(ll : T_pJoueur; bonus : t_pBonus; var listep : T_pSysteme_de_particules;
                 var dsb : array of  TDirectSoundBuffer; map : PObjet; PlusDrapeauBleu,PlusDrapeauRouge : integer; Frot,MyTime : real; FreqTir : integer);
var liste,lll, liste2, leaderBotRouge, leaderBotBleu : t_pJoueur; PremB,PremR : boolean;
repartition : integer; Occupe : boolean; lbonus : t_pBonus;
begin
  leaderBotRouge := NIL;
  leaderBotBleu := NIL;
  lbonus := bonus;
  liste := ll;
  liste2 := liste;
//  YaLeader := FALSE; // si une voiture a recupere le drapeau (=> YaLeader = TRUE) alors toutes les autres vont la proteger
  PremB := TRUE;
  PremR := TRUE;
  repartition := 0;
  Occupe := FALSE;
  // grade = 1 <=> voiture a drapeau
  // grade = 0 <=> voiture pas drapeau

  while liste <> NIL do
  begin

       //Repartion des roles
        while liste2 <> NIl do
        begin
         if liste2.Mort then begin liste2 := liste2.next; inc(repartition) end
         else
         begin
            case (repartition mod 3) of
              0 : liste2.rang := defenseur;
              1 : liste2.rang := tireur;
              2 : liste2.rang := voleur;
            end;

            if (liste2.Equipe = bleu) AND (liste2.grade = 1) AND (premB) then
            begin
              leaderBotBleu := liste2;
              premB := FALSE;
            end else
            if (liste2.Equipe = rouge) AND (liste2.grade = 1) AND (premR) then
            begin
              leaderBotRouge := liste2;
              PremR := FALSE;
            end;
            //else liste.grade := 0;
            liste2 := liste2.next;
            inc(repartition);
         end;
        end;

        //les voitures 'tireurs' qui n'ont pas de drapeau vont chercher le drapeau adverse s'il n'y a
        //pas de leader a proteger
        if (liste.vie <> 0) AND (liste.Categorie <> humain) AND (liste.grade = 0) AND (liste.rang = tireur) then
        begin
          case liste.Equipe of
              Bleu : if (LeaderBotBleu = NIL) then TrouveDrapeau(liste,-1087,440,PlusDrapeauBleu,PlusDrapeauRouge) else ChampAttractif(liste,LeaderBotBleu,2/40);
              Rouge : if (LeaderBotRouge = NIL) then TrouveDrapeau(liste,1009,-414,PlusDrapeauBleu,PlusDrapeauRouge) else ChampAttractif(liste,LeaderBotRouge,2/40);
          end;
        end;

        //les voitures 'voleurs' qui n'ont pas de drapeau vont chercher le drapeau adverse quoiqu'il arrive
        if (liste.vie <> 0) AND (liste.Categorie <> humain) AND (liste.grade = 0) AND (liste.rang = voleur) then
        begin
          case liste.Equipe of
              Bleu : TrouveDrapeau(liste,-1087,440,PlusDrapeauBleu,PlusDrapeauRouge);
              Rouge : TrouveDrapeau(liste,1009,-414,PlusDrapeauBleu,PlusDrapeauRouge);
          end;
        end;

        //les voitures 'defenseurs' restent pres du drapeau
        if (liste.vie <> 0) AND (liste.Categorie <> humain) AND (liste.grade = 0) AND (liste.rang = defenseur) then
        begin

          lll := ll;
          while lll <> NIL do
          begin  // defense du drapeau par les voitures 'defenseurs', si elle attaque on enleve le champ de force du drapeau
                if (lll.vie <> 0) AND (lll.Equipe <> liste.Equipe) AND (DistanceVoiture(lll,liste) < 500)
                then
                  {if (
                     (liste.Equipe = Bleu) AND
                     (sqrt(sqr(liste.Voiture.emplacement.coordx-1009)+sqr(liste.Voiture.emplacement.coordz+414)) < 500)
                     ) OR (
                     (liste.Equipe = Rouge) AND
                     (sqrt(sqr(liste.Voiture.emplacement.coordx+1087)+sqr(liste.Voiture.emplacement.coordz-440)) < 500)
                     )
                  then }
                    begin
                      ChampAttractif(liste,lll,2/40);
                      Occupe := TRUE;
                    end;



                //***********************************************
                 if Not(occupe) then
                 begin
                      case liste.Equipe of
                        Bleu : begin
                                 TrouveDrapeau2(liste,1009,-414);
                                 PeurDrapeau(liste,1009,-414);
                               end;
                        Rouge : begin
                                  TrouveDrapeau2(liste,-1087,440);
                                  PeurDrapeau(liste,-1087,440);
                                end;
                      end;
                end;
               //***********************************************
                lll := lll.next;
          end;
        end;

        //la voiture qui a un drapeau rentre au camp (= cherche son propre drapeau)
        if (liste.vie <> 0) AND (liste.Categorie <> humain) AND (liste.grade = 1) then
        begin
          case liste.Equipe of
              Bleu : TrouveDrapeau(liste,1009,-414,PlusDrapeauBleu,PlusDrapeauRouge);
              Rouge : TrouveDrapeau(liste,-1087,440,PlusDrapeauBleu,PlusDrapeauRouge);
          end;
        end;

        // Voitures neutres vont trouver les bonus
        while lbonus <> NIL do
        begin
         if sqrt(sqr(liste.Voiture.emplacement.coordx - lbonus.emplacement.coordx)+sqr(liste.Voiture.emplacement.coordz - lbonus.emplacement.coordz)) < 200 then
           TrouveBonus(liste,lbonus,50);
         lbonus := lbonus.next;
        end;

        if liste.vie <> 0 then
        begin
            liste.convertion(ll,dsb);
            SuivreLeader(liste,ll);
            OPSFlinge(liste,ll,FreqTir);
            EviteVoiture(liste,ll,-30);
            EviteMine(liste,ll.arme);
            colliVB(liste, bonus, dsb);
            ChampVM(liste,map,-10);


            {li := ll;
            while li <> NIL do
            begin
             EviteMine(liste,li.arme);
             li := li.next;
            end; }

            liste.Voiture.vex := frot * liste.Voiture.vex;
            liste.Voiture.vey := frot * liste.Voiture.vey;
            liste.Voiture.orientation.norme := sqrt(sqr(liste.Voiture.Vex)+sqr(liste.Voiture.Vey));

            //on filtre les mouvements parasites lors les voitures s'arretent
            if (liste.Categorie <> humain ) AND (liste.Voiture.orientation.norme > 1) then
            //if liste.Categorie <> humain then
            begin
              liste.Voiture.orientation.teta := 3.14+ArcTan2(liste.Voiture.vex,liste.Voiture.vey);
              liste.Voiture.emplacement.coordx := liste.Voiture.emplacement.coordx + Mytime * liste.Voiture.Vex;
              liste.Voiture.emplacement.coordz := liste.Voiture.emplacement.coordz + Mytime * liste.Voiture.Vey;
            end;
        end;
  liste := liste.next;
  end;
end;

end.
