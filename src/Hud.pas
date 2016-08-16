UNIT Hud;

INTERFACE
USES
BMP,
OpenGl,
Caractere,
Repere,
nbrarme,
SysUtils,
Windows;


Procedure glBindTexture(target: GLenum; texture: GLuint); stdcall; external opengl32;
Procedure HudPerdu();
Procedure HudVie(vie , VieMax : integer; invincible : boolean);
Procedure HudEssence(essence : real);
Procedure HudArme(armeselec : T_PNbrArme; arme_1, arme_2, arme_3,
                  arme_4 ,arme_5, arme_6 : T_NbrArme);
Procedure HudMort(mort : Boolean);
Procedure ChargementHUD;
Procedure HudEtat(nbMort, nbAmis, nbNeutre, nbEnnemis : integer);
Procedure AfficheHud;

VAR
TextureHudArme : GLuint;
TextureHudDrapeau : GLuint;
TextureHudMunition : GLuint;
TextureHudVie : GLuint;



IMPLEMENTATION

//----------------------------------------------------------------------------//

Function IntToStr(Num : Integer) : String;
VAR
 tmp : string;
begin
 Str(Num, tmp);
 if num < 10 then tmp := ' '+tmp;
 result := tmp;
end;
//----------------------------------------------------------------------------//

Procedure HudVie(vie , VieMax : Integer; invincible : boolean);
begin
  glPushMatrix;
  glTexte(940,32,1.0,1.0,1.0,IntToStr(vie));
  glPopMatrix;
end;
//----------------------------------------------------------------------------//

Procedure HudEssence(essence : real);
begin
glPushMatrix;
glTexte(940,84,1.0,1.0,1.0,IntToStr(round(essence)));
glPopMatrix;
end;
//----------------------------------------------------------------------------//

Procedure HudArme(armeselec : T_PNbrArme; arme_1, arme_2, arme_3,
                  arme_4 ,arme_5, arme_6 : T_NbrArme);
begin

glTexte(960,750,1.0,0.0,1.0,IntToStr(armeselec.NbrArme));

glTexte(455,740,1.0,0.0,0.0,'1');
glTexte(535,740,1.0,0.0,0.0,'2');
glTexte(615,740,1.0,0.0,0.0,'3');
glTexte(695,740,1.0,0.0,0.0,'4');
glTexte(775,740,1.0,0.0,0.0,'5');
glTexte(855,740,1.0,0.0,0.0,'6');

glEnable(GL_BLEND);
glDepthMask(GL_FALSE);
glpushmatrix;
  OrthoMode(0,0,1024,768);
  glColor3f(0.65,0.65,0.0);
  glBegin(GL_QUADS);
    glTexCoord2f(0.0,1.0);             glVertex2f(370 + armeselec.Id * 80, 718);
    glTexCoord2f(1.0,1.0);             glVertex2f(450 + armeselec.Id * 80, 718);
    glTexCoord2f(1.0,0.0);             glVertex2f(450 + armeselec.Id * 80, 768);
    glTexCoord2f(0.0,0.0);             glVertex2f(370 + armeselec.Id * 80, 768);
  glEnd;
  PerspectiveMode;
glpopmatrix;
glDepthMask(GL_TRUE);
glDisable(GL_BLEND);

glColor3f(0.0,1.0,0.0);
glpushmatrix;
  OrthoMode(0,0,1024,768);
  glBegin(GL_QUADS);
    glVertex2f(455, 760);
    glVertex2f(455, 750);
    glVertex2f(455 + 65*(arme_1.NbrArme/ arme_1.NbrArme_max), 750);
    glVertex2f(455 + 65*(arme_1.NbrArme/ arme_1.NbrArme_max), 760);

    glVertex2f(535, 760);
    glVertex2f(535, 750);
    glVertex2f(535 + 65*(arme_2.NbrArme/ arme_2.NbrArme_max), 750);
    glVertex2f(535 + 65*(arme_2.NbrArme/ arme_2.NbrArme_max), 760);

    glVertex2f(615, 760);
    glVertex2f(615, 750);
    glVertex2f(615 + 65*(arme_3.NbrArme/ arme_3.NbrArme_max), 750);
    glVertex2f(615 + 65*(arme_3.NbrArme/ arme_3.NbrArme_max), 760);

    glVertex2f(695, 760);
    glVertex2f(695, 750);
    glVertex2f(695 + 65*(arme_4.NbrArme/ arme_4.NbrArme_max), 750);
    glVertex2f(695 + 65*(arme_4.NbrArme/ arme_4.NbrArme_max), 760);

    glVertex2f(775, 760);
    glVertex2f(775, 750);
    glVertex2f(775 + 65*(arme_5.NbrArme/ arme_5.NbrArme_max), 750);
    glVertex2f(775 + 65*(arme_5.NbrArme/ arme_5.NbrArme_max), 760);

    glVertex2f(855, 760);
    glVertex2f(855, 750);
    glVertex2f(855 + 65*(arme_6.NbrArme/ arme_6.NbrArme_max), 750);
    glVertex2f(855 + 65*(arme_6.NbrArme/ arme_6.NbrArme_max), 760);

  glEnd;
  PerspectiveMode;
glpopmatrix;
end;
//----------------------------------------------------------------------------//
Procedure HudPerdu();
begin
   glTexte(320,350,1.0,0.0,0.0,'Vous vous etes fait convertir');
end;


Procedure HudMort(mort : Boolean);
begin
if mort then
   begin
   glTexte(320,350,1.0,0.0,0.0,'Vous etes Mort');
   end;
end;
//----------------------------------------------------------------------------//

Procedure chargementHUD;
begin
  LoadTexture(GetCurrentDir + '\data\textures\hudArme.bmp', TextureHudArme);
  LoadTexture(GetCurrentDir + '\data\textures\hudDrapeau.bmp', TextureHudDrapeau);
  LoadTexture(GetCurrentDir + '\data\textures\hudMunition.bmp', TextureHudMunition);
  LoadTexture(GetCurrentDir + '\data\textures\hudVie.bmp', TextureHudVie);
end;

//----------------------------------------------------------------------------//

Procedure AfficheHud;
VAR
i : integer;
x,y : GLfloat;

begin
x := 450.0;
y := 718.0;
glEnable(GL_BLEND);
glDepthMask(GL_FALSE);
glEnable(GL_TEXTURE_2D);
glBindTexture(GL_TEXTURE_2D, TextureHudArme);

for i := 0 to 5 do
begin
  glpushmatrix;
    OrthoMode(0,0,1024,768);
    glBegin(GL_QUADS);
      glTexCoord2f(0.0,1.0);             glVertex2f(x + (i * 80), y );
      glTexCoord2f(1.0,1.0);             glVertex2f(x + 80*(i+1), y );
      glTexCoord2f(1.0,0.0);             glVertex2f(x + 80*(i+1), y + 50);
      glTexCoord2f(0.0,0.0);             glVertex2f(x + (i * 80), y + 50);
    glEnd;
    PerspectiveMode;
  glpopmatrix;
end;

glBindTexture(GL_TEXTURE_2D, TextureHudMunition);
glPushMatrix;
OrthoMode(0,0,1024,768);
glBegin(GL_QUADS);
    glTexCoord2f(0.0,1.0);             glVertex2f(934, y);
    glTexCoord2f(1.0,1.0);             glVertex2f(1024,y);
    glTexCoord2f(1.0,0.0);             glVertex2f(1024,y + 50);
    glTexCoord2f(0.0,0.0);             glVertex2f(934,y + 50);
glEnd;
PerspectiveMode;
glPopMatrix;

glBindTexture(GL_TEXTURE_2D,TextureHudDrapeau);
glPushMatrix;
OrthoMode(0,0,1024,768);
glBegin(GL_QUADS);
    glTexCoord2f(0.0,1.0);             glVertex2f(0.0,568);
    glTexCoord2f(1.0,1.0);             glVertex2f(90,568);
    glTexCoord2f(1.0,0.0);             glVertex2f(90,768);
    glTexCoord2f(0.0,0.0);             glVertex2f(0.0,768);
glEnd;
PerspectiveMode;
glPopMatrix;

glBindTexture(GL_TEXTURE_2D,TextureHudVie);
glPushMatrix;
OrthoMode(0,0,1024,768);
glBegin(GL_QUADS);
    glTexCoord2f(0.0,1.0);             glVertex2f(934,0.0);
    glTexCoord2f(1.0,1.0);             glVertex2f(1024,0.0);
    glTexCoord2f(1.0,0.0);             glVertex2f(1024,100);
    glTexCoord2f(0.0,0.0);             glVertex2f(934,100);
glEnd;
PerspectiveMode;
glPopMatrix;
glDepthMask(GL_TRUE);
glDisable(GL_BLEND);
glDisable(GL_TEXTURE_2D);
end;
//----------------------------------------------------------------------------//

Procedure HudEtat(nbMort, nbAmis, nbNeutre, nbEnnemis : integer);
VAR
x : integer;
begin
x := 54;
if nbMort > 99 then x := 38;
glTexte(x,605,1.0,1.0,1.0,IntToStr(nbMort));
if nbAmis < 100 then x := 54;
if nbAmis > 99 then x := 38;
glTexte(x,655,1.0,1.0,1.0,IntToStr(nbAmis));
if nbNeutre < 100 then x := 54;
if nbNeutre > 99 then x := 38;
glTexte(x,705,1.0,1.0,1.0,IntToStr(nbNeutre));
if nbEnnemis < 100 then x := 54;
if nbEnnemis > 99 then x := 38;
glTexte(x,755,1.0,1.0,1.0,IntToStr(nbEnnemis));
end;

//----------------------------------------------------------------------------//
end.
