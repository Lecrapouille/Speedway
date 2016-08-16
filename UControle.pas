unit UControle;

interface
USES
Sysutils,
Joueur,
Ucamera,
effet,
DDirectSound,
Windows;

var
  keysold   : Array[0..255] of Boolean;   // olds keystrokes

procedure Touche(Keys : array of BOOLEAN; listejoueur : T_pJoueur; cam : T_Camera; var dsb : array of  TDirectSoundBuffer);

implementation

procedure Touche(Keys : array of BOOLEAN; listejoueur : T_pJoueur; cam : T_Camera; var dsb : array of  TDirectSoundBuffer);
var  pjoueur : T_Pjoueur;
     i : integer;

     F : textfile;
begin
  pjoueur := listejoueur;
  while pjoueur^.categorie<>humain do
   pjoueur := pjoueur.next;
  if pjoueur^.pointdevue<3 then
  begin
   if not pjoueur^.Mort then
   begin
     if (Keys[VK_UP])     then pjoueur^.voiture.Avance;
     if (Keys[VK_DOWN])   then pjoueur^.voiture.Recule;
     if (Keys[VK_LEFT])   then begin
                               pjoueur^.voiture.Gauche;
                               Cam.actualise(pjoueur);
                               end;
     if (Keys[VK_RIGHT])  then begin
                               pjoueur^.voiture.Droite;
                               Cam.actualise(pjoueur);
                               end;
     if (Keys[VK_HOME])and not(Keysold[VK_HOME]) then begin pJoueur^.Armesuivante; dsb[pJoueur^.Armeselectionne.Id+25].play(0); end;
     if (Keys[$31]) then begin pJoueur^.Armeselectionne := @pjoueur.Arme_1; dsb[26].play(0); end;
     if (Keys[$32]) then begin pJoueur^.Armeselectionne := @pjoueur.Arme_2; dsb[27].play(0); end;
     if (Keys[$33]) then begin pJoueur^.Armeselectionne := @pjoueur.Arme_3; dsb[28].play(0); end;
     if (Keys[$34]) then begin pJoueur^.Armeselectionne := @pjoueur.Arme_4; dsb[29].play(0); end;
     if (Keys[$35]) then begin pJoueur^.Armeselectionne := @pjoueur.Arme_5; dsb[30].play(0); end;
     if (Keys[$36]) then begin pJoueur^.Armeselectionne := @pjoueur.Arme_6; dsb[31].play(0); end;
     if (Keys[VK_SPACE]) then
       if pJoueur^.Armeselectionne.Id=1 then begin //pJoueur^.Tire;
                                             end
       else
       if not(Keysold[VK_SPACE]) then
       begin
         pJoueur^.Tire;
         case pJoueur.Armeselectionne.Id of
           2 : dsb[57].Play(0);
           3 : dsb[10].Play(0);
           4 : dsb[56].Play(0);
           5 : dsb[52].Play(0);
           6 : dsb[55].Play(0);
         end;
       end;


     if (Keys[$41])and not(Keysold[$41]) then begin
                               AffCur := (AffCur+1) mod 3;
                               Cam.pointdevuesuivant(pjoueur);
                               Cam.actualise(pjoueur);
                               end;
   end;
   if (Keys[VK_TAB])and not(Keysold[VK_TAB]) then changerjoueur(pjoueur,listejoueur);
  end
  else begin
    if (Keys[VK_LEFT]) then pjoueur^.arme.orientation.Inc(0.0, 0.05, 0.0);
    if (Keys[VK_RIGHT]) then pjoueur^.arme.orientation.Inc(0.0,-0.05,0.0);
  end;

  if (Keys[VK_F1])and not(Keysold[VK_F1]) then
  begin
    AssignFile(F,'c:\BLAIREAU.txt');
    Rewrite(F);
    writeln(F,floattostr(listejoueur.Voiture.emplacement.coordx));
    writeln(F,floattostr(listejoueur.Voiture.emplacement.coordz));
    writeln(F,floattostr(listejoueur.Voiture.emplacement.coordy));
    closeFile(F);
  end;


  for i:=0 to 255 do
   Keysold[i]:=Keys[i];

end;


end.
