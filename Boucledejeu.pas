unit Boucledejeu;

interface
USES
  Windows,
  SysUtils,
  Messages,
  Opengl,
  typege,
  Joueur,
  Voiture,
  bonus,
  hud,
  qq,
  effet,
  boucleiacol,
  UControle,
  Armes,
  UCamera,
  U_Chargement,
  lancement,
  DDirectSound,
  BoucleBot,
  libre,
  sound;


function WinMain(hInstance : HINST; hPrevInstance : HINST;
                 lpCmdLine : PChar; nCmdShow : Integer;
                 param : T_param) : Integer; stdcall;


var PlusDrapeauBleu : integer = 0;
  PlusDrapeauRouge : integer = 0;

implementation
{--------------------------------------------------------------------}
{  Main message loop for the application                             }
{--------------------------------------------------------------------}
function WinMain(hInstance : HINST; hPrevInstance : HINST;
                 lpCmdLine : PChar; nCmdShow : Integer;
                 param : T_param) : Integer; stdcall;
var
  msg : TMsg;
  finished,finito : Boolean;
  listejoueur : T_pJoueur;
  listebonus : T_pBonus;
  listeparticule : T_pSysteme_de_particules;
  Cam1 : T_Camera;
  i,ii,j : integer;
  DSB: array [0..72] of  TDirectSoundBuffer;
  Map,PlanMap : Tobjet;
begin
  randomize;
  // Perform application initialization:
  if not glCreateWnd(param) then
  begin
    Result := 0;
    Exit;
  end;
  //initialise le son
  if param.SonON then initsound(dsb, param) else
  InitSilence(dsb, param);

  for i:=0 to 255 do
    Keys[i] := false;

  //initialisation du nombre d'eclair
  NbEclair := 0;

  //Pour quitter le jeu
  finished := False;
  finito := FALSE;
  
  //Initialisation de la boucle de jeu
  listejoueur  := nil;
  listebonus  := nil;
  listeparticule := nil;

  //Initialisation des effets spéciaux
  InitElec();
  InitTextExplos();

  //Ambiance du jeu = sons de l'environnement

  // Play(1) = en boucle et Play(0) = 1 seule fois
  case param.config.carte of
    0 : begin
          dsb[68].play(1);
          dsb[59].play(1);
        end;
    1 : begin
          dsb[68].play(1);
          //dsb[9].play(1);
        end;

    2 : begin
          BuildListeExplosion(-17,15,245,1,ListeExplosion);
          BuildListeExplosion(195,15,62,1,ListeExplosion);
          BuildListeExplosion(-244,15,31,1,ListeExplosion);
          BuildListeExplosion(237,15,48,2,ListeExplosion);

          dsb[59].play(1);
          dsb[62].play(1);
         // dsb[9].play(1);
        end;
    3 : dsb[71].play(1);
    4 : dsb[70].play(1);
    5 : dsb[68].play(1);
    6 : dsb[68].play(1);
   // 7 : dsb[62].play(1);
  end;

  //chargement de la carte
   case param.config.carte of
      0 : begin chargement('NouvelleVille.ASE', @Map);
                chargement('PlanVille.ASE', @PlanMap);
                //chargement('routeVille.ASE', @PlanRoute);
                loadBonus(listebonus, 'Quick arena b.pos');
          end;
      1 : begin chargement('Chaud.ASE', @Map);
                chargement('PlanVille.ASE', @PlanMap);
                loadBonus(listebonus, 'Quick arena b.pos');
          end;
      2 : begin chargement('Hell.ASE', @Map);
                chargement('PlanHell.ASE', @PlanMap);
                loadBonus(listebonus, 'Quick arena b.pos');
          end;
      3 : begin chargement('BlackMesa.ASE', @Map);
                chargement('PlanBlackMesa.ASE', @PlanMap);
                loadBonus(listebonus, 'BM.pos');
          end;
      4 : begin chargement('CarteMere.ASE', @Map);
                chargement('PlanCarte.ASE', @PlanMap);
                loadBonus(listebonus, 'Quick arena b.pos');
          end;
      5 : begin chargement('Foret.ASE', @Map);
                chargement('PlanForet.ASE', @PlanMap);
                loadBonus(listebonus, 'Quick arena b.pos');
          end;
      6 : begin chargement('Labyrinte.ASE', @Map);
                chargement('Labyrinte.ASE', @PlanMap);
                loadBonus(listebonus, 'Quick arena b.pos');
          end;
      7 : begin chargement('QuickArena.ASE', @Map);
                loadBonus(listebonus, 'Quick arena b.pos');
          end;

   end;

  //Creation des joueurs
  j := 0;
  for i:=1 to param.config.BotsAmis do
     ajouterjoueur(param.config.carte,'quentin',param.config.goodies,artificielle,bleu,listejoueur, j);
  for i:=1 to param.config.BotsNeutre do
     ajouterjoueur(param.config.carte,'quentin',param.config.neutres,artificielle,neutre,listejoueur, j);
  for i:=1 to param.config.BotsEnnemis do
     ajouterjoueur(param.config.carte,'quentin',param.config.badies,artificielle,rouge,listejoueur, j);
  ajouterjoueur(param.config.carte,'joel',param.config.voiture,humain,bleu,listejoueur, j);

  //if (param.config.ia=1) then ChoisitLeader(listejoueur);
  InitArm(listejoueur);
  cam1.init(listejoueur);

  // Main message loop:
  while (not(finished)) do
  begin
    if (PeekMessage(msg, 0, 0, 0, PM_REMOVE)) then // Check if there is a message for this window
    begin
      if (msg.message = WM_QUIT) then     // If WM_QUIT message received then we are done
        finished := True
      else
      begin                               // Else translate and dispatch the message to this window
  	TranslateMessage(msg);
        DispatchMessage(msg);
      end;
    end
    else
    begin
      Inc(FPSCount);                      // Increment FPS Counter

     {Ambiance}
     //AmbianceSonore(dsb,listejoueur,param);
     {Traitement des collisions et de l'IA}
     if (param.config.ia=1) then {Boucle d'animation des bots dans le mode de partie 'derniere equipe en vie'}
        Boubou(listejoueur, listebonus, listeparticule, dsb, @map, param.Frottement, param.VitesseJeu, param.FrequenceTirs, param.config.carte)
     else {Boucle d'animation des bots dans le mode de partie 'Capture The Flag'}
       BoucleCaptureFlag(listejoueur, listebonus, listeparticule, dsb, @map,PlusDrapeauBleu,PlusDrapeauRouge, param.Frottement, param.VitesseJeu, param.FrequenceTirs);

     cam1.collision(listejoueur, @map);
     if listeparticule<>nil then Actualise_Systeme_de_Particule(listeparticule);

//affichage
     {Vidage du contenu situé à l'écran}
     glClear(GL_COLOR_BUFFER_BIT Or GL_DEPTH_BUFFER_BIT);
     glClearColor(0.0, 0.0, 0.0, 1.0);
     {On réénitialise la matrice modélisation-visualisation}
     glMatrixMode(GL_MODELVIEW);
     glLoadIdentity;

//On place la camera dans la scene
     cam1.Positionne;

     //Activation du fog
     if param.video.fog then glEnable(GL_FOG);
     // On place la Map
     glCallList(map.list);


     {Capture The Flag}
     if PlusDrapeauRouge = 1 then dsb[6].Play(0) else ;
     if PlusDrapeauRouge = 0 then
     begin
       glPushMatrix;
       glTranslatef(-1087,2,440);
       glCallList(DrapeauRouge.list);
       glPopMatrix;
     end;

     if PlusDrapeauBleu = 0 then
     begin
       glPushMatrix;
       glTranslatef(1009,2,-414);
       glCallList(DrapeauBleu.list);
       glPopMatrix;
     end;

     // On place les joueurs et les armes dans la scene
     cam1.actualise(listejoueur);

     //création du radar
      if param.radar then
      begin
        case param.config.carte of
         0,1 : begin
               radar(listejoueur, @PlanMap,105,150,17,8);
             end;
         2 : radar(listejoueur, @PlanMap,95,100,5,5);
         3 : radar(listejoueur, @PlanMap,75,140,5,5);
         4 : radar(listejoueur, @PlanMap,55,100,10,10);
         5,6 : radar(listejoueur, @PlanMap,90,150,15,10);
        end;
      end;

     //explosions
     ParcoursListeExplosion(ListeExplosion);

     //creation d'un orage
     if (param.AmbiancePluie) then Pluie();
     if (param.orage) AND (Orage(listejoueur.Voiture.emplacement.coordx,
                                 listejoueur.Voiture.emplacement.coordy,
                                 param.FrequenceEclair,param.DureeEblouit))
     then dsb[63].play(0);

     //Drapeau(0);
     //Viseur();

     AfficherJoueur(listejoueur);
     if param.video.fog then glDisable(GL_FOG);
     DrawBonus(listeBonus);
     if listeparticule<>nil then Draw_Systeme_de_Particule(listeparticule);
// On affiche la scene
     SwapBuffers(h_DC);
//definition des actions
      Touche(Keys, listejoueur, cam1, dsb);

      finished := ousontlesbleus(listejoueur);
      //finished := ousontlesrouges(listejoueur);

// Si [escape] est pressee alors on sort
      if (keys[VK_ESCAPE]) then
      begin
        finished := True;
      end;

    end;
  end; // fin du while

  finished := False;

  for ii := 1 to 72 do dsb[ii].stop;
  DetruireListeJoueur(listejoueur);
  DetruireListeBonus(listebonus);

  libererobjet(map);
  libererobjet(PlanMap);

  libererobjet(joel_m);
  libererobjet(priscillien_m);
  libererobjet(quentin_m);
  libererobjet(roman_m);
  libererobjet(pelleteuse_m);

  libererobjet(VR);
  libererobjet(VB);
  libererobjet(TR);
  libererobjet(TB);
  libererobjet(DR);
  libererobjet(DB);
  libererobjet(DrapeauBleu);
  libererobjet(DrapeauRouge);

   HudPerdu();
  sleep(500);
 // PostQuitMessage(0);
  glKillWnd(param.video.Width, param.video.Height, param.video.FullScreen);
  Result := msg.wParam;
end;






end.
 