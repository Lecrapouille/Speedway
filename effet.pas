unit effet;

interface
USES
Windows,
OpenGl,
bmp,
Sysutils,

Repere,
maths;


CONST
MAX_PARTICLES = 150;
SparkCount = 20;  //elec
     Steps = 30;  // elec

TYPE
T_Particule = record		// Create A Structure For Particle
       	life : GLfloat;		// Particle Life
	fade : GLfloat;		// Fade Speed
        r : GLfloat;		// Red Value
	g : GLfloat;		// Green Value
	b : GLfloat;		// Blue Value
	pos : position;
	dir : position;		// Direction
        active : bool;
end;

T_pSysteme_de_particules = ^T_Syteme_de_particules;

T_Syteme_de_Particules = object
  particules : Array [1..MAX_PARTICLES] of T_Particule;
  pos : Position;
  suivant : T_pSysteme_de_particules;
  //quantite : integer;
  constructor Init (i : position);
  function actif : boolean;
  procedure Actualise;
  procedure Draw;
end;


Type TOP_Explosion = ^TO_Explosion;
TO_Explosion = object
  Suivant : TOP_Explosion;
  CurrentTexture : Integer;
  Posix,Posiy,Posiz : glfloat;
  forme : integer;
  procedure Explose(x,y,z : glfloat; fo : integer);
end;

VAR
  yo : Array[0..STEPS] of real;  // elec
  TextureArray : Array[1..41] of glUint;   //explo
  TheViseur1,TheGrille : gluint;
  ListeExplosion : TOP_Explosion = NIL;
  particule : GLUint;
  texture : GLuint;
  eblouit : integer = 0;
  tutu : boolean = FALSE;
  NbEclair : integer;
  //MAX_PARTICLES : integer = 400;
  AffCur : integer = 0;

procedure Viseur();
procedure Drapeau(camp : integer);
procedure InitTextExplos();
procedure ParcoursListeExplosion(var ListeExplosion : TOP_Explosion);
procedure BuildListeExplosion(xx,yy,zz : glfloat; fforme : integer; var ListeExplosion : TOP_Explosion);
procedure Eblouissement(duree : integer);
procedure glBindTexture(target: GLenum; texture: GLuint); stdcall; external opengl32;
procedure Chargementparticule(TAB_CHEMIN_BITMAP : String);
procedure Laser(nb,angle : integer);
procedure Ajouter_Systeme_de_Particule(i : position; var liste : T_pSysteme_de_Particules);
procedure Actualise_Systeme_de_Particule(var liste : T_pSysteme_de_Particules);
procedure Draw_Systeme_de_Particule(liste : T_pSysteme_de_Particules);
procedure Supprimer_Systeme_de_Particule(var systeme, liste :T_pSysteme_de_Particules);
procedure Electricite(pX,pY,pZ : real; Angle : integer);
procedure Electricite2(pX,pY,pZ : real);
procedure InitElec();
function Orage(coordx,coordy : real; Frequence,Duree : integer) : boolean;
procedure Pluie();

implementation
//----------------------------------------------------------------------------//
procedure InitElec();
begin
  yo[0] :=0.0;
  yo[STEPS-1] :=0.0;
end;

procedure InitTextExplos();
{explosion de type 1 :
     1 -> 10
   explosion de type 2 :
     10 -> 19
   explosion de type 3 :
     20 -> 28}
var i : integer;
begin
   for i := 1 to 40 do
   begin
     LoadTexture('data/Explose/texture'+IntToStr(i)+'.bmp', TextureArray[i]);
   end;
   LoadTexture('data/textures/VoleurRouge.bmp',TextureArray[41]);
   LoadTexture('data/Explose/viseur1.bmp',TheViseur1);
   LoadTexture('data/textures/Grate3.bmp',TheGrille);
end;

procedure ParcoursListeExplosion(var ListeExplosion : TOP_Explosion);
begin
  if ListeExplosion <> NIL then
  begin
    ListeExplosion^.Explose(ListeExplosion^.Posix,ListeExplosion^.Posiy,ListeExplosion^.Posiz,ListeExplosion^.forme);
    ParcoursListeExplosion(ListeExplosion^.Suivant);
  end;
end;

procedure BuildListeExplosion(xx,yy,zz : glfloat; fforme : integer; var ListeExplosion : TOP_Explosion);
var TEMP : TOP_Explosion;
begin
  new(TEMP);
  TEMP^.CurrentTexture := 1;

  TEMP^.Posix := xx;
  TEMP^.Posiy := yy;
  TEMP^.Posiz := zz;
  TEMP^.forme := fforme;

  TEMP^.suivant := ListeExplosion;
  ListeExplosion := TEMP;
end;


procedure TO_Explosion.Explose(x,y,z : glfloat; fo : integer);
begin
case fo of
  1 :
  begin
    Inc(CurrentTexture);
    if CurrentTexture = 11 then
       CurrentTexture :=1;
  end;
  2 :
  begin
    Inc(CurrentTexture);
    if CurrentTexture = 20 then
       CurrentTexture :=11;
  end;
  3 :
  begin
    Inc(CurrentTexture);
    if CurrentTexture = 29 then
       CurrentTexture :=21;
  end;
  4 :
  begin
    Inc(CurrentTexture);
    if CurrentTexture = 30 then
       CurrentTexture :=41;
  end;
end;

    glDepthMask(GL_FALSE);

    glEnable(GL_TEXTURE_2D);
    //glDisable(GL_DEPTH_TEST);
    glDepthMask(GL_FALSE);
    glBindTexture(GL_TEXTURE_2D, TextureArray[CurrentTexture]);

    glPushMatrix();
        glTranslatef(x,y,z);
        glscalef(15,15,15);
        glColor3f(1.0, 1.0, 1.0);
        glBegin(GL_QUADS);
           glTexCoord2f(0, 0);  glVertex3f(-1,-1, 0);
           glTexCoord2f(1, 0);  glVertex3f( 1,-1, 0);
           glTexCoord2f(1, 1);  glVertex3f( 1, 1, 0);
           glTexCoord2f(0, 1);  glVertex3f(-1, 1, 0);


           glTexCoord2f(1.0,1.0); glVertex3f( 0.0, 1.0, 1.0 );
           glTexCoord2f(0.0,1.0); glVertex3f( 0.0, 1.0,-1.0 );
           glTexCoord2f(0.0,0.0); glVertex3f( 0.0,-1.0,-1.0 );
           glTexCoord2f(1.0,0.0); glVertex3f( 0.0,-1.0, 1.0 );

        glEnd();
    glPopMatrix ();

    {glPushMatrix();
        glTranslatef(x,y,z);
        glscalef(15,15,15);
        glrotatef(90,0,1,0);
        glColor3f(1.0, 1.0, 1.0);
        glBegin(GL_QUADS);
           glTexCoord2f(0, 0);  glVertex3f(-1,-1, 0);
           glTexCoord2f(1, 0);  glVertex3f( 1,-1, 0);
           glTexCoord2f(1, 1);  glVertex3f( 1, 1, 0);
           glTexCoord2f(0, 1);  glVertex3f(-1, 1, 0);
        glEnd();
    glPopMatrix ();}

    glDepthMask(GL_TRUE);
    glDisable(GL_BLEND);

    glDepthMask(GL_TRUE);
    //glEnable(GL_DEPTH_TEST);
    glDisable(GL_TEXTURE_2D);
end;


constructor T_Syteme_de_Particules.Init (i : position);
var
loop : integer;
begin
  pos := i;
  //MAX_PARTICLES := quantite;
  for loop := 1 to MAX_PARTICLES do
  begin
    particules[loop].life:=0.1;
    particules[loop].fade:=(random(10))/1000.0+0.002;
    particules[loop].r := 1.0;
    particules[loop].g := 0.0;
    particules[loop].b := 0.0;
    particules[loop].pos := i;
    particules[loop].dir.coordx:=(random(50)-26.0)*10.0;
    particules[loop].dir.coordy:=(random(50)-25.0)*10.0;
    particules[loop].dir.coordz:=(random(50)-25.0)*10.0;
    particules[loop].active := true;
  end;
end;
//----------------------------------------------------------------------------//
function T_Syteme_de_Particules.actif : boolean;
var i : integer;
    retour : boolean;
begin
  i := 1;
  retour := false;
  while (i<=MAX_PARTICLES)and not(retour) do
  begin
    if particules[i].active then retour := true;
    inc(i);
  end;
  result := retour;
end;
//----------------------------------------------------------------------------//
procedure T_Syteme_de_Particules.actualise;
var
loop : integer;
begin
  for loop := 1 to MAX_PARTICLES do
  begin
    if particules[loop].active then
    begin
      particules[loop].pos.coordx := particules[loop].pos.coordx + particules[loop].dir.coordx/1000;                 // Move On The X Axis By X Speed
      particules[loop].pos.coordy := particules[loop].pos.coordy + particules[loop].dir.coordy/1000;                 // Move On The Y Axis By Y Speed
      particules[loop].pos.coordz := particules[loop].pos.coordz + particules[loop].dir.coordz/1000;                 // Move On The Z Axis By Z Speed
      particules[loop].life := particules[loop].life - particules[loop].fade;                                        // Reduce Particles Life By 'Fade'
      if particules[loop].g < 1 then particules[loop].g := particules[loop].g + 0.03;
      if (particules[loop].life < 0.0) then particules[loop].active := FALSE;			                     // If Particle Is Burned Out
    end;
  end;
end;

//----------------------------------------------------------------------------//

procedure T_Syteme_de_Particules.draw;
var loop : integer;
begin
  for loop := 1 to MAX_PARTICLES do
  begin
    glEnable(GL_BLEND);
    glDepthMask(GL_FALSE);
    glEnable(GL_TEXTURE_2D);
    glBindTexture(GL_TEXTURE_2D, texture);
    glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE );

    if particules[loop].active then
    begin
      glPushMatrix;
      // Position Each Particle On The Screen, Use Zoom To Move Into The Screen
      glTranslatef(particules[loop].pos.coordx,
                   particules[loop].pos.coordy,
                   particules[loop].pos.coordz);
      // Draw The Particle Using Our RGB Values, Fade The Particle Based On It's Life
      glColor4f(particules[loop].r,
                particules[loop].g,
                particules[loop].b,
                particules[loop].life*10);
      glCallList(particule);
      glPopMatrix;
      particules[loop].active := particules[loop].pos.coordy >= 0;
    end;
  end;
  glColor4f(0.0,0.0,0.0,1.0);
  glTexEnvi( GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_REPLACE );
  glDisable(GL_TEXTURE_2D);
  glDepthMask(GL_TRUE);
  glDisable(GL_BLEND);
end;
//----------------------------------------------------------------------------//

procedure Ajouter_Systeme_de_Particule(i : position; var liste : T_pSysteme_de_Particules);
var
  courant : T_pSysteme_de_Particules;
begin
  new(courant);
  courant.init(i);
  courant^.suivant := liste;
  liste := courant;
end;
//----------------------------------------------------------------------------//
procedure Actualise_Systeme_de_Particule(var liste : T_pSysteme_de_Particules);
var courant : T_pSysteme_de_Particules;
begin
  courant := liste;
  while courant<>nil do
  begin
    if courant.actif then
    begin
      courant.Actualise;
      courant := courant.suivant;
    end
    else Supprimer_Systeme_de_Particule(courant, liste);
  end;
end;
//----------------------------------------------------------------------------//
procedure Draw_Systeme_de_Particule(liste : T_pSysteme_de_Particules);
begin
  while liste<>nil do
  begin
    liste.draw;
    liste := liste.suivant;
  end;
end;
//----------------------------------------------------------------------------//
procedure Supprimer_Systeme_de_Particule(var systeme, liste :T_pSysteme_de_Particules);
VAR
courant , prec : T_pSysteme_de_Particules;
begin
  if (liste <> NIL) and (systeme <> NIl) then
  begin
    if systeme = liste then
    begin
      liste := liste^.suivant;
      freemem(systeme);
      systeme := liste;
    end
    else
    begin
      courant := liste;
      prec := liste;
      while courant <> systeme  do
      begin
        prec := courant;
        courant := courant^.suivant;
      end;
      prec^.suivant := courant^.suivant;
      freemem(systeme);
      systeme := prec;
    end;
  end;
end;


//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//
procedure Chargementparticule(TAB_CHEMIN_BITMAP : String);
begin
  LoadTexture(TAB_CHEMIN_BITMAP, texture);
  particule := glGenLists(1);
  glNewList(particule,GL_COMPILE);
  glpushmatrix;
  glBegin(GL_QUADS);   					// Build A Quad
    glTexCoord2f(1.0,1.0);             glVertex3f( 0.5, 0.5, 0.0 );
    glTexCoord2f(0.0,1.0);             glVertex3f(-0.5, 0.5, 0.0 );
    glTexCoord2f(0.0,0.0);             glVertex3f(-0.5,-0.5, 0.0 );
    glTexCoord2f(1.0,0.0);             glVertex3f( 0.5,-0.5, 0.0 );

    glTexCoord2f(1.0,1.0);             glVertex3f( 0.0, 0.5, 0.5 );
    glTexCoord2f(0.0,1.0);             glVertex3f( 0.0, 0.5,-0.5 );
    glTexCoord2f(0.0,0.0);             glVertex3f( 0.0,-0.5,-0.5 );
    glTexCoord2f(1.0,0.0);             glVertex3f( 0.0,-0.5, 0.5 );
  glend;
  glpopmatrix;
  glEndList;
end;

//----------------------------------------------------------------------------//
procedure Laser(nb,angle : integer);
var rot,i : integer;
begin
    glEnable(GL_BLEND);
    glDepthMask(GL_FALSE);
    glEnable(GL_TEXTURE_2D);
    glBindTexture(GL_TEXTURE_2D, texture);

    for i := 1 to nb do
    begin
        rot := (i*5) mod 360;

        glPushMatrix();
        glrotatef(rot + angle,1,0,0);
        glTranslatef(i/10,0.25,0.25);
        glColor3f(1.0, 1.0, 1.0);
        glBegin(GL_QUADS);
           glTexCoord2f(0, 0);  glVertex3f(-0.5,-0.5, 0);
           glTexCoord2f(1, 0);  glVertex3f( 0.5,-0.5, 0);
           glTexCoord2f(1, 1);  glVertex3f( 0.5, 0.5, 0);
           glTexCoord2f(0, 1);  glVertex3f(-0.5, 0.5, 0);
        glEnd();
        glPopMatrix ();

        glPushMatrix();
        glrotatef(-rot + angle,1,0,0);
        glTranslatef(i/10+0.5,0.15,0.15);
        glColor3f(1.0, 1.0, 1.0);
        glBegin(GL_QUADS);
           glTexCoord2f(0, 0);  glVertex3f(-0.5,-0.5, 0);
           glTexCoord2f(1, 0);  glVertex3f( 0.5,-0.5, 0);
           glTexCoord2f(1, 1);  glVertex3f( 0.5, 0.5, 0);
           glTexCoord2f(0, 1);  glVertex3f(-0.5, 0.5, 0);
        glEnd();
        glPopMatrix ();
    end;
    glDepthMask(GL_TRUE);
    glDisable(GL_BLEND);
    glDisable(GL_TEXTURE_2D);
end;


procedure Electricite(pX,pY,pZ : real; Angle : integer);
var i,j : integer; rnd : real;
begin
randomize;

{mouvement aleatoire de l'arc
Note : si on commente cette boucle -> arc droit}
for I :=1 to STEPS-2 do
  begin
    yo[I] :=yo[I] + 0.1*(random-0.5);
    if yo[I] > yo[I-1] + 0.075 then yo[I] :=yo[I-1]+0.075;
    if yo[I] < yo[I-1] - 0.075 then yo[I] :=yo[I-1]-0.075;
    if yo[I] > yo[I+1] + 0.075 then yo[I] :=yo[I+1]+0.075;
    if yo[I] < yo[I+1] - 0.075 then yo[I] :=yo[I+1]-0.075;
    if yo[I] >  0.5 then yo[I] :=0.5;
    if yo[I] < -0.5 then yo[I] :=-0.5;
  end;


  {Dessinne l'arc electrique}
//  glDisable(GL_TEXTURE_2D);
  glEnable(GL_BLEND);
  glColor3f(0.4, 0.3, 0.8);
  glpushMatrix;


  glTranslatef(pX,pZ,pY);
  glscalef(50,50,50);
  for I :=1 to SparkCount do
  begin
    glBegin(GL_TRIANGLE_STRIP);
    for J :=0 to STEPS-1 do
    begin
      rnd :=0.04*(random-0.5);
      glVertex3f(-1 + 2*J/STEPS + rnd, -0.01 + yo[J] + rnd, rnd);
      glVertex3f(-1 + 2*J/STEPS + rnd, +0.01 + yo[J] + rnd, rnd);

    //  glVertex3f(-1 + 2*J/STEPS + rnd, -0.1 + yo[J] + rnd, rnd);
    //  glVertex3f(-1 + 2*J/STEPS + rnd, +0.1 + yo[J] + rnd, rnd);

    end;
    glEnd();
  end;
  glpopMatrix;
  glDisable(GL_BLEND);
//  glEnable(GL_TEXTURE_2D);
end;


procedure Electricite2(pX,pY,pZ : real);
var i,j : integer; rnd : real;
begin
randomize;

{mouvement aleatoire de l'arc
Note : si on commente cette boucle -> arc droit}
for I :=1 to STEPS-2 do
  begin
    yo[I] :=yo[I] + 0.1*(random-0.5);
    if yo[I] > yo[I-1] + 0.075 then yo[I] :=yo[I-1]+0.075;
    if yo[I] < yo[I-1] - 0.075 then yo[I] :=yo[I-1]-0.075;
    if yo[I] > yo[I+1] + 0.075 then yo[I] :=yo[I+1]+0.075;
    if yo[I] < yo[I+1] - 0.075 then yo[I] :=yo[I+1]-0.075;
    if yo[I] >  0.5 then yo[I] :=0.5;
    if yo[I] < -0.5 then yo[I] :=-0.5;
  end;


  {Dessinne l'arc electrique}
  glEnable(GL_BLEND);
  glColor3f(0.4, 0.3, 0.8);
  glpushMatrix;


  glTranslatef(pX,pZ,pY);
  glrotatef(90,0,0,1);
  glscalef(50,50,50);
  for I :=1 to SparkCount do
  begin
    glBegin(GL_TRIANGLE_STRIP);
    for J :=0 to STEPS-1 do
    begin
      rnd :=0.04*(random-0.5);
      glVertex3f(-1 + 2*J/STEPS + rnd, -0.01 + yo[J] + rnd, rnd);
      glVertex3f(-1 + 2*J/STEPS + rnd, +0.01 + yo[J] + rnd, rnd);
    end;
    glEnd();
  end;
  glpopMatrix;
  glDisable(GL_BLEND);
end;


procedure Eblouissement(duree : integer);
begin
  eblouit := eblouit + 5;
  if eblouit <= duree then
  begin
    tutu := TRUE;
    glDisable(GL_DEPTH_TEST);
    glEnable(GL_BLEND);
    glPushMatrix;
       OrthoMode(0,0,1024,768);
       glColor3f(1-eblouit/duree,1-eblouit/duree,1-eblouit/duree);
          glBegin(GL_QUADS);
             glTexCoord2f(0, 0); glVertex2f(0,0);
             glTexCoord2f(1, 0); glVertex2f(1024,0);
             glTexCoord2f(1, 1); glVertex2f(1024,768);
             glTexCoord2f(0, 1); glVertex2f(0,768);
          glEnd;
       PerspectiveMode;
    glPopMatrix;
    glDisable(GL_BLEND);
    glEnable(GL_DEPTH_TEST);
  end;
  if eblouit > 100 then begin eblouit := 0; tutu := FALSE; end;
end;


function Orage(coordx,coordy : real; Frequence, Duree : integer) : boolean;
var EclairX,EclairY,Signe1,Signe2 : integer; Etat : boolean;
begin
    EclairX := random(10);
    EclairY := random(10);
    signe1 := random(2);
    Signe2 := random(2);
    Etat := FALSE;


    if Signe1 = 0 then Signe1 := -1;
    if Signe2 = 0 then Signe2 := -1;
    nbEclair := (nbEclair+1) mod Frequence;
    if nbEclair = 0 then
    begin
      tutu := TRUE;
      Electricite2(coordx+Signe1*EclairX,0.35,coordy+Signe2*EclairY);
      Etat := TRUE;
    end;

    if tutu then
    begin
      Eblouissement(Duree);
    end;
    result := Etat;
end;

procedure Drapeau(camp : integer);
begin

 { glPushMatrix;
  glTranslatef(-1087,2,440);
    glCallList(DrapeauBleu.list);
  glPopMatrix;

  glPushMatrix;
  glTranslatef(1009,2,-414);
    glCallList(DrapeauRouge.list);
  glPopMatrix;  }
 { glPushMatrix;
  glTranslatef(-1087,2,440);
  glBegin(GL_QUADS);
      glVertex3f( 0.5, 0.5, 0.5 );
      glVertex3f( 0.5, 0.5,-0.5 );
      glVertex3f( 0.5,-0.5,-0.5 );
      glVertex3f( 0.5,-0.5, 0.5 );

      glVertex3f( 0.5, 0.5,-0.5 );
      glVertex3f(-0.5, 0.5,-0.5 );
      glVertex3f(-0.5,-0.5,-0.5 );
      glVertex3f( 0.5,-0.5,-0.5 );

      glVertex3f( 0.5, 0.5, 0.5 );
      glVertex3f( 0.5, 0.5,-0.5 );
      glVertex3f(-0.5, 0.5,-0.5 );
      glVertex3f(-0.5, 0.5, 0.5 );

      glVertex3f( 0.5,-0.5, 0.5 );
      glVertex3f( 0.5,-0.5,-0.5 );
      glVertex3f(-0.5,-0.5,-0.5 );
      glVertex3f(-0.5,-0.5, 0.5 );

      glVertex3f(-0.5, 0.5, 0.5 );
      glVertex3f(-0.5,-0.5, 0.5 );
      glVertex3f(-0.5,-0.5,-0.5 );
      glVertex3f(-0.5, 0.5,-0.5 );
    glEnd;
  glPopMatrix;

  glPushMatrix;
  glTranslatef(1009,2,-414);
  glBegin(GL_QUADS);
      glVertex3f( 0.5, 0.5, 0.5 );
      glVertex3f( 0.5, 0.5,-0.5 );
      glVertex3f( 0.5,-0.5,-0.5 );
      glVertex3f( 0.5,-0.5, 0.5 );

      glVertex3f( 0.5, 0.5,-0.5 );
      glVertex3f(-0.5, 0.5,-0.5 );
      glVertex3f(-0.5,-0.5,-0.5 );
      glVertex3f( 0.5,-0.5,-0.5 );

      glVertex3f( 0.5, 0.5, 0.5 );
      glVertex3f( 0.5, 0.5,-0.5 );
      glVertex3f(-0.5, 0.5,-0.5 );
      glVertex3f(-0.5, 0.5, 0.5 );

      glVertex3f( 0.5,-0.5, 0.5 );
      glVertex3f( 0.5,-0.5,-0.5 );
      glVertex3f(-0.5,-0.5,-0.5 );
      glVertex3f(-0.5,-0.5, 0.5 );

      glVertex3f(-0.5, 0.5, 0.5 );
      glVertex3f(-0.5,-0.5, 0.5 );
      glVertex3f(-0.5,-0.5,-0.5 );
      glVertex3f(-0.5, 0.5,-0.5 );
    glEnd;
  glPopMatrix; }
end;

procedure Viseur();
begin
  //if AffCur = 2 then
  begin
    glEnable(GL_BLEND);
      glEnable(GL_TEXTURE_2D);
      glDisable(GL_DEPTH_TEST);
      glBindTexture(GL_TEXTURE_2D, TheViseur1);

      glPushMatrix;
         OrthoMode(0,0,1027,768);
         gltranslated(1024/2-100,768/2-120,0);

            glBegin(GL_QUADS);
               glTexCoord2f(0, 0); glVertex2f(0,0);
               glTexCoord2f(1, 0); glVertex2f(200,0);
               glTexCoord2f(1, 1); glVertex2f(200,200);
               glTexCoord2f(0, 1); glVertex2f(0,200);
            glEnd;
         PerspectiveMode;
      glPopMatrix;


      glEnable(GL_DEPTH_TEST);
      glDisable(GL_BLEND);
      glDisable(GL_TEXTURE_2D);
  end;
end;


procedure Pluie();
var i,j,xx,yy,PosiX,PosiY : integer;
begin
  for i := -10 to 10 do
    for j := -10 to 10 do
      begin
        xx := i * 100;
        yy := j * 100;

        PosiX := xx+random(100);
        PosiY := yy+random(100);

        glPushMatrix();
          glColor3f(0.2, 0.3, 0.5);
          glLineWidth(0);
          glBegin(GL_LINES);
             glVertex3f(PosiX,100,PosiY);
             glVertex3f(PosiX+random(10),-10,Posiy+random(10));
          glEnd();
        glPopMatrix ();
      end;
end;

//----------------------------------------------------------------------------//
end.
