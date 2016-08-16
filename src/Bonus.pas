unit Bonus;

interface
USES
Windows,
Typege,
Maths,
bmp,
Opengl,
SysUtils,
nbrarme,
DDirectSound,
Joueur;

TYPE

// Type pour une liste Chaine
T_pBonus = ^T_Bonus;
//----------------------------------------------------------------------------//
// Type General                                                               //
//----------------------------------------------------------------------------//
T_Bonus = class
  emplacement : position;
  next : t_pBonus;
  bsphere : T_BSphere;
  texture : GLUint;
  genlist : GLUint;
  TypeBonus : integer;
  rota : integer;

  constructor Init(x,y,z : GLFloat; TAB_CHEMIN_BITMAP : String);
  procedure changerbonus;
  procedure Affiche;
  procedure Action(joueur : T_pJoueur); virtual; abstract;
end;
//----------------------------------------------------------------------------//
T_Bonus_Vie50 = class(T_Bonus)
procedure Action(Joueur : T_pJoueur);override;
end;
//----------------------------------------------------------------------------//
T_Bonus_Arme_1_20 = class(T_Bonus)
procedure Action(Joueur : T_pJoueur);override;
end;
//----------------------------------------------------------------------------//
T_Bonus_Arme_2_20 = class(T_Bonus)
procedure Action(Joueur : T_pJoueur);override;
end;
//----------------------------------------------------------------------------//
T_Bonus_Arme_3_20 = class(T_Bonus)
procedure Action(Joueur : T_pJoueur);override;
end;
//----------------------------------------------------------------------------//
T_Bonus_Arme_4_20 = class(T_Bonus)
procedure Action(Joueur : T_pJoueur);override;
end;
//----------------------------------------------------------------------------//
T_Bonus_Arme_5_20 = class(T_Bonus)
procedure Action(Joueur : T_pJoueur);override;
end;
//----------------------------------------------------------------------------//
T_Bonus_Arme_6_20 = class(T_Bonus)
procedure Action(Joueur : T_pJoueur);override;
end;
//----------------------------------------------------------------------------//
T_Bonus_Plein = class(T_Bonus)
procedure Action(Joueur : T_pJoueur); override;
end;
//----------------------------------------------------------------------------//

//----------------------------------------------------------------------------//
procedure glBindTexture(target: GLenum; texture: GLuint); stdcall; external opengl32;
//----------------------------------------------------------------------------//
procedure SupprimerBonus(element : T_pBonus; var tete : T_pBonus);
procedure DetruireListeBonus(var liste : T_pBonus);
procedure Drawbonus(liste : T_pBonus);
procedure loadbonus(var liste : T_pBonus; TAB_CHEMIN : String);
procedure colliVB(j1 : T_pJoueur; lbonus : T_pBonus; dsb : array of  TDirectSoundBuffer);


var ch : array [1..20] of T_chaine;
    pointeur : integer;

implementation
//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//
procedure T_Bonus.Affiche;
begin
  glBindTexture(GL_TEXTURE_2D, texture);
  glPushMatrix;
    glTranslatef(emplacement.coordx,
                 emplacement.coordy,
                 emplacement.coordz);
    rota := (rota + 10) mod 360;
    glrotatef(rota,0,1,0);
    glCallList(GenList);
  glPopMatrix;
end;
//----------------------------------------------------------------------------//
constructor T_Bonus.Init(x,y,z : GLFloat; TAB_CHEMIN_BITMAP : String);
var epaisseur : real; kk : integer;
begin
emplacement.Init(x,y,z);
bsphere.rayon := 2;
   LoadTexture(GetCurrentDir + '\data\Explose\bonus2.bmp', texture);
   {case TypeBonus of
     1..3 : LoadTexture(GetCurrentDir + '\data\textures\' + TAB_CHEMIN_BITMAP, texture);
     4..7 : LoadTexture(GetCurrentDir + '\data\Explose\bonus1.bmp', texture);
     8..10 : LoadTexture(GetCurrentDir + '\data\Explose\bonus2.bmp', texture);
     11..12 : LoadTexture(GetCurrentDir + '\data\Explose\bonus3.bmp', texture);
   end;}
  {if TypeBonus = 1 then
  LoadTexture(GetCurrentDir + '\data\textures\' + TAB_CHEMIN_BITMAP, texture)
  else
  LoadTexture(GetCurrentDir + '\data\Explose\bonus1.bmp', texture); }

  GenList := glGenLists(1);
  glNewList(GenList,GL_COMPILE);

  {case TypeBonus of
     1..3 : LoadTexture(GetCurrentDir + '\data\textures\' + TAB_CHEMIN_BITMAP, texture);
     4..7 : LoadTexture(GetCurrentDir + '\data\Explose\bonus1.bmp', texture);
     8..10 : LoadTexture(GetCurrentDir + '\data\Explose\bonus2.bmp', texture);
     11..12 : LoadTexture(GetCurrentDir + '\data\Explose\bonus3.bmp', texture);
   end; }

  glpushmatrix;
  glBegin(GL_QUADS);

    for kk := 1 to 4 do
    begin
      epaisseur := kk * 0.01;

      glTexCoord2f(1.0,1.0);             glVertex3f( 1.0, 1.0, epaisseur );
      glTexCoord2f(0.0,1.0);             glVertex3f(-1.0, 1.0, epaisseur );
      glTexCoord2f(0.0,0.0);             glVertex3f(-1.0,-1.0, epaisseur );
      glTexCoord2f(1.0,0.0);             glVertex3f( 1.0,-1.0, epaisseur );
    end;

   { glTexCoord2f(1.0,1.0);             glVertex3f( 1.0, 1.0, 0.05 );
    glTexCoord2f(0.0,1.0);             glVertex3f(-1.0, 1.0, 0.05 );
    glTexCoord2f(0.0,0.0);             glVertex3f(-1.0,-1.0, 0.05 );
    glTexCoord2f(1.0,0.0);             glVertex3f( 1.0,-1.0, 0.05 );

    glTexCoord2f(1.0,1.0);             glVertex3f( 1.0, 1.0, 0. );
    glTexCoord2f(0.0,1.0);             glVertex3f(-1.0, 1.0, 0.2 );
    glTexCoord2f(0.0,0.0);             glVertex3f(-1.0,-1.0, 0.2 );
    glTexCoord2f(1.0,0.0);             glVertex3f( 1.0,-1.0, 0.2 );

    glTexCoord2f(1.0,1.0);             glVertex3f( 1.0, 1.0, 0.3 );
    glTexCoord2f(0.0,1.0);             glVertex3f(-1.0, 1.0, 0.3 );
    glTexCoord2f(0.0,0.0);             glVertex3f(-1.0,-1.0, 0.3 );
    glTexCoord2f(1.0,0.0);             glVertex3f( 1.0,-1.0, 0.3 );

    glTexCoord2f(1.0,1.0);             glVertex3f( 1.0, 1.0, 0.4 );
    glTexCoord2f(0.0,1.0);             glVertex3f(-1.0, 1.0, 0.4 );
    glTexCoord2f(0.0,0.0);             glVertex3f(-1.0,-1.0, 0.4 );
    glTexCoord2f(1.0,0.0);             glVertex3f( 1.0,-1.0, 0.4 ); }

  {  glTexCoord2f(1.0,1.0);             glVertex3f( 0.0, 1.0, 1.0 );
    glTexCoord2f(0.0,1.0);             glVertex3f( 0.0, 1.0,-1.0 );
    glTexCoord2f(0.0,0.0);             glVertex3f( 0.0,-1.0,-1.0 );
    glTexCoord2f(1.0,0.0);             glVertex3f( 0.0,-1.0, 1.0 );   }
  glend;
  glpopmatrix;
  glEndList;
end;
//----------------------------------------------------------------------------//
procedure T_Bonus.changerbonus;
begin
  emplacement.coordx := ch[pointeur].x;
  emplacement.coordz := ch[pointeur].z;
  if pointeur=20 then pointeur := 1
  else inc(pointeur);
end;
//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//
procedure T_Bonus_Vie50.Action(joueur : T_pJoueur);
begin
joueur.vie := joueur.vie + 50;
if joueur.vie > joueur.VieMax then joueur.vie := joueur.VieMax;
// afficher a l'ecran + 50 pts de vie si joueur humain
end;
//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//
procedure T_Bonus_Arme_1_20.Action(Joueur : T_pJoueur);
begin
joueur^.arme_1.NbrArme := joueur.arme_1.NbrArme + 20;
if joueur^.arme_1.NbrArme > joueur^.arme_1.NbrArme_max then
     joueur^.arme_1.NbrArme := joueur^.arme_1.NbrArme_max;
// afficher a l'ecran + 20 balles si joueur humain
end;

//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//
procedure T_Bonus_Arme_2_20.Action(Joueur : T_pJoueur);
begin
joueur^.arme_2.NbrArme := joueur^.arme_2.NbrArme + 20;
if joueur^.arme_2.NbrArme > joueur^.arme_2.NbrArme_max then
     joueur^.arme_2.NbrArme := joueur^.arme_2.NbrArme_max;
// afficher a l'ecran + 20 missiles si joueur humain
end;

//----------------------------------------------------------------------------//
procedure T_Bonus_Arme_3_20.Action(Joueur : T_pJoueur);
begin
joueur^.arme_3.NbrArme := joueur^.arme_3.NbrArme + 20;
if joueur^.arme_3.NbrArme > joueur^.arme_3.NbrArme_max then
       joueur^.arme_3.NbrArme := joueur^.arme_3.NbrArme_max;
// afficher a l'ecran + 20 mines si joueur humain
end;

//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//
procedure T_Bonus_Arme_4_20.Action(Joueur : T_pJoueur);
begin
joueur^.arme_4.NbrArme := joueur^.arme_4.NbrArme + 20;
if joueur^.arme_4.NbrArme > joueur^.arme_4.NbrArme_max then
         joueur^.arme_4.NbrArme := joueur^.arme_4.NbrArme_max;
// afficher a l'ecran + 20 missiles dirigeables si joueur humain
end;

//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//
procedure T_Bonus_Arme_5_20.Action(Joueur : T_pJoueur);
begin
joueur^.arme_5.NbrArme := joueur^.arme_5.NbrArme + 20;
if joueur^.arme_5.NbrArme > joueur^.arme_5.NbrArme_max then
         joueur^.arme_5.NbrArme := joueur^.arme_5.NbrArme_max;
// afficher a l'ecran + 20 missiles dirigeables si joueur humain
end;

//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//
procedure T_Bonus_Arme_6_20.Action(Joueur : T_pJoueur);
begin
joueur^.arme_6.NbrArme := joueur^.arme_6.NbrArme + 20;
if joueur^.arme_6.NbrArme > joueur^.arme_6.NbrArme_max then
         joueur^.arme_6.NbrArme := joueur^.arme_6.NbrArme_max;
// afficher a l'ecran + 20 missiles dirigeables si joueur humain
end;

//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//
procedure T_Bonus_Plein.Action(Joueur : T_pJoueur);
begin
joueur^.Voiture.essence := joueur^.Voiture.EssenceMax;
end;

//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//

procedure SupprimerBonus(element : T_pBonus; var tete : T_pBonus);
var
courant , prec : T_pBonus;
begin
if (tete <> NIL) and (element <> NIl) then
  begin
  if element = tete then tete := tete^.next
     else
           begin
           courant := tete;
           prec := tete;
                while courant <> element do
                begin
                prec := courant;
                courant := courant^.next;
                end;
           prec^.next := courant^.next;
           end;
   freemem(element);
   end;
end;
//----------------------------------------------------------------------------//
procedure AjouterBonus(nom : integer;x,y,z : GLFloat; var liste : T_pBonus);
var
nouveau : T_pBonus;
begin
  new(nouveau);
     case nom of
          1 : nouveau^ := T_Bonus_Vie50.Init(x,y,z,'bonus1.bmp');
          2 : nouveau^ := T_Bonus_Arme_1_20.Init(x,y,z,'bonus1.bmp');
          3 : nouveau^ := T_Bonus_Arme_2_20.Init(x,y,z,'bonus1.bmp');
          4 : nouveau^ := T_Bonus_Arme_3_20.Init(x,y,z,'bonus1.bmp');
          5 : nouveau^ := T_Bonus_Arme_4_20.Init(x,y,z,'bonus1.bmp');
          6 : nouveau^ := T_Bonus_Arme_5_20.Init(x,y,z,'bonus1.bmp');
          7 : nouveau^ := T_Bonus_Arme_6_20.Init(x,y,z,'bonus1.bmp');
          8 : nouveau^ := T_Bonus_Plein.Init(x,y,z,'bonus1.bmp');
          9 : nouveau^ := T_Bonus_Vie50.Init(x,y,z,'bonus1.bmp');
          10 : nouveau^ := T_Bonus_Arme_1_20.Init(x,y,z,'bonus1.bmp');
          11 : nouveau^ := T_Bonus_Arme_2_20.Init(x,y,z,'bonus1.bmp');
          12 : nouveau^ := T_Bonus_Arme_3_20.Init(x,y,z,'bonus1.bmp');
          13 : nouveau^ := T_Bonus_Arme_4_20.Init(x,y,z,'bonus1.bmp');
          14 : nouveau^ := T_Bonus_Arme_5_20.Init(x,y,z,'bonus1.bmp');
          15 : nouveau^ := T_Bonus_Arme_6_20.Init(x,y,z,'bonus1.bmp');
          16 : nouveau^ := T_Bonus_Arme_1_20.Init(x,y,z,'bonus1.bmp');
          17 : nouveau^ := T_Bonus_Plein.Init(x,y,z,'bonus1.bmp');
     end;
  nouveau^.TypeBonus := nom;
  nouveau^.rota := 0;
  nouveau^.next := liste;
  liste := nouveau;
end;

//----------------------------------------------------------------------------//
procedure DrawBonus(liste : T_pBonus);
begin
  glEnable(GL_BLEND);
  glDepthMask(GL_FALSE);
  glEnable(GL_TEXTURE_2D);
  glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE );

  while liste<>nil do
  begin
    liste.Affiche;
    liste := liste.next;
  end;

  //glColor4f(0.0,0.0,0.0,1.0);
  glTexEnvi( GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_REPLACE );
  glDisable(GL_TEXTURE_2D);
  glDepthMask(GL_TRUE);
  glDisable(GL_BLEND);

end;
//----------------------------------------------------------------------------//
procedure DetruireListeBonus(var liste : T_pBonus);
var
courant : T_pBonus;
begin
  while liste <> NIL do
  begin
    courant := liste;
    liste := liste^.next;
    freemem(courant);
  end;
end;
//----------------------------------------------------------------------------//
procedure loadbonus(var liste : T_pBonus; TAB_CHEMIN : String);
var i : integer;
    inFile : file;
begin
  AssignFile(inFile, GetCurrentDir + '\data\map\' + TAB_CHEMIN);
  Reset(inFile, SizeOf(ch));
  blockread(inFile, ch, 1);
  CloseFile(inFile);

  for i:=1 to 11 do
  begin
    AjouterBonus(i, ch[i].x, 3, ch[i].z, liste);
  end;
  pointeur := 12
end;
//----------------------------------------------------------------------------//
// collision voiture Bonus
procedure colliVB(j1 : T_pJoueur; lbonus : T_pBonus; dsb : array of  TDirectSoundBuffer);
var d : GLFloat;
    b : T_pBonus;
begin
   b := lbonus;
   while b<>NIL do
   begin
      d := sqrt(sqr(j1.voiture.emplacement.coordx-b^.emplacement.coordx)+
                sqr(j1.voiture.emplacement.coordz-b^.emplacement.coordz));
      if d<j1.voiture.bsphere.rayon+b^.bsphere.rayon then
      begin
         //fdfgdf
         b.changerbonus;
         b.Action(j1);
         if j1.Categorie=humain then dsb[1].Play(0);
      end;
      b := b.next;
   end;
end;

//----------------------------------------------------------------------------//



end.
