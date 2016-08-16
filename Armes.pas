unit Armes;

interface
USES
Effet,
Maths,
typege,
Opengl;

//----------------------------------------------------------------------------//
//type pour une liste
//****************************************************************************//
TYPE
T_pArme = ^T_Arme;

T_Arme = class
  id : integer;
  proprietaire : string;
  emplacement : position;
  orientation : VecteurPol;
  degats : integer;
  bsphere : T_BSphere;
  next : T_pArme;
 constructor Init(Vemplacement : position; Vorientation : VecteurPol); virtual; abstract;
 procedure Actualise; virtual;abstract;
 procedure Affiche; virtual;abstract;
end;


//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//

T_arme_1 = class(T_Arme)
  constructor Init(Vemplacement : position; Vorientation : VecteurPol);override;
  procedure Affiche; override;
end;

//****************************************************************************//
//****************************************************************************//

T_arme_2 = class(T_Arme)
  constructor Init(Vemplacement : position; Vorientation : VecteurPol);override;
  procedure Actualise; override;
  procedure Affiche; override;
end;

//****************************************************************************//
//****************************************************************************//
T_arme_3 = class(T_Arme)
  constructor Init(Vemplacement : position; Vorientation : VecteurPol);override;
  procedure Actualise; override;
  procedure Affiche; override;
end;
//****************************************************************************//
//****************************************************************************//
T_arme_4 = class(T_Arme)
  constructor Init(Vemplacement : position; Vorientation : VecteurPol); override;
  procedure Actualise; override;
  procedure Affiche; override;
end;
//****************************************************************************//
//****************************************************************************//

T_arme_5 = class(T_Arme)
  constructor Init(Vemplacement : position; Vorientation : VecteurPol); override;
  procedure Actualise; override;
  procedure Affiche; override;
end;
//****************************************************************************//
//****************************************************************************//
T_arme_6 = class(T_Arme)
  depart : position;
  debut : position;
  nb : integer;
  rot : integer;
  constructor Init(Vemplacement : position; Vorientation : VecteurPol);override;
  procedure Actualise; override;
  procedure Affiche; override;
end;
//****************************************************************************//
//****************************************************************************//




procedure Supprimerarme(var arme, tete: T_pArme);
procedure AfficheArme(debut : T_pArme);
procedure DetruireListeArme(var liste : T_pArme);
//----------------------------------------------------------------------------//




VAR
  Arme_1_m,Arme_2_m,Arme_3_m,Arme_4_m,Arme_5_m : TObjet;

implementation

//----------------------------------------------------------------------------//
// Arme numero 1  des balles                                                  //
//----------------------------------------------------------------------------//

constructor T_arme_1.Init(Vemplacement : position; Vorientation : VecteurPol);
begin
  id := 1;
  emplacement := Vemplacement;
  emplacement.Translate(0.0,2.0,0.0); // a modifier suivant le type de voiture
  orientation := vorientation;
  orientation.norme := 20.0;
  bsphere.rayon := 2;
  degats := 10;
end;

//----------------------------------------------------------------------------//

procedure T_Arme_1.Affiche;
begin
    glPushMatrix;
      glTranslated(emplacement.coordx,emplacement.coordy,emplacement.coordz);
      glRotated( orientation.teta*180/pi,0.0,1.0,0.0 );
      glCallList(Arme_1_m.list);
    glPopMatrix;
end;

//****************************************************************************//
//****************************************************************************//

//----------------------------------------------------------------------------//
// arme numero 2  un missile                                                  //
//----------------------------------------------------------------------------//

constructor T_Arme_2.Init(Vemplacement : position; Vorientation : VecteurPol);
begin
  id := 2;
  emplacement := Vemplacement;
  emplacement.Translate(0.0,5.0,0.0); // a modifier suivant le type de voiture
  orientation := Vorientation;
  orientation.norme := 25;
  bsphere.rayon := 2;
  degats := 50;
end;

//----------------------------------------------------------------------------//


procedure T_Arme_2.Affiche;
begin
  glPushMatrix;
    glTranslated(emplacement.coordx,emplacement.coordy,emplacement.coordz);
    glRotated( orientation.teta*180/pi,0.0,1.0,0.0 );
    glCallList(Arme_2_m.list);
  glPopMatrix;
end;

//----------------------------------------------------------------------------//
procedure T_Arme_2.Actualise;
begin
  emplacement.deplace(orientation);
end;

//****************************************************************************//
//****************************************************************************//

//----------------------------------------------------------------------------//
// Arme numero 3 une mine                                                     //
//----------------------------------------------------------------------------//

constructor T_arme_3.Init(Vemplacement : position; Vorientation : VecteurPol);
begin
  id := 3;
  emplacement := Vemplacement;
  emplacement.Translate(0.0,0.0,0.0); // a modifier suivant le type de voiture
  orientation := Vorientation;
  orientation.norme := 0.0;
  bsphere.rayon := 2;
  degats := 100;
end;

//----------------------------------------------------------------------------//

procedure T_Arme_3.Actualise;
begin
  emplacement.deplace(orientation);
end;

//----------------------------------------------------------------------------//

procedure T_Arme_3.Affiche;
begin
    glPushMatrix;
      glTranslated(emplacement.coordx,emplacement.coordy,emplacement.coordz);
      glRotated( orientation.teta*180/pi,0.0,1.0,0.0 );
      glCallList(Arme_3_m.list);
    glPopMatrix;
end;

//****************************************************************************//
//****************************************************************************//

//----------------------------------------------------------------------------//
// Arme numero 4 un missile dirigeable                                        //
//----------------------------------------------------------------------------//

constructor T_arme_4.Init(Vemplacement : position; vorientation : VecteurPol);
begin
  id := 4;
  emplacement := Vemplacement;
  emplacement.Translate(0.0,5.0,0.0);// a modifier suivant le type de voiture
  orientation := Vorientation;
  orientation.norme := 22;
  bsphere.rayon := 2;
  degats := 25;
end;

//----------------------------------------------------------------------------//

procedure T_Arme_4.Actualise;
begin
// a modifier pour prendre en compte les mouvements du joueur
  emplacement.deplace(orientation);
end;

//----------------------------------------------------------------------------//

procedure T_Arme_4.Affiche;
begin
// modifier la camera
  glPushMatrix;
    glTranslated(emplacement.coordx,emplacement.coordy,emplacement.coordz);
    glRotated( orientation.teta*180/pi,0.0,1.0,0.0 );
    glCallList(Arme_4_m.list);
  glPopMatrix;
end;

//****************************************************************************//
//****************************************************************************//
//----------------------------------------------------------------------------//
// Arme numero 5 Un snifer d'essence                                          //
//----------------------------------------------------------------------------//

constructor T_arme_5.Init(Vemplacement : position; vorientation : VecteurPol);
begin
  id := 5;
  emplacement := Vemplacement;
  emplacement.Translate(0.0,5.0,0.0);// a modifier suivant le type de voiture
  orientation := Vorientation;
  orientation.norme := 25;
  bsphere.rayon := 2;
  degats := 50;
end;

//----------------------------------------------------------------------------//

procedure T_Arme_5.Actualise;
begin
// a modifier pour prendre en compte les mouvements du joueur
  emplacement.deplace(orientation);
end;

//----------------------------------------------------------------------------//

procedure T_Arme_5.Affiche;
begin
// modifier la camera
  glPushMatrix;
    glTranslated(emplacement.coordx,emplacement.coordy,emplacement.coordz);
    glRotated( orientation.teta*180/pi,0.0,1.0,0.0 );
    glCallList(Arme_5_m.list);
  glPopMatrix;
end;

//****************************************************************************//
//****************************************************************************//
//----------------------------------------------------------------------------//
// Arme numero 6 Un LASER                                                     //
//----------------------------------------------------------------------------//


constructor T_arme_6.Init(Vemplacement : position; Vorientation : VecteurPol);
begin
  id := 6;
  nb := 0;
  rot := 0;
  
  emplacement := Vemplacement;
  emplacement.Translate(0.0,5.0,0.0); // a modifier suivant le type de voiture
  depart := emplacement;
  debut := emplacement;
  orientation := vorientation;
  //orientation.norme := 3.5;
  orientation.norme := 13.5;
  bsphere.rayon := 2;
  degats := 50;
end;

//----------------------------------------------------------------------------//

procedure T_Arme_6.Actualise;
begin
  emplacement.deplace(orientation);
  if distance(depart, emplacement) > 10 then debut.deplace(orientation);
  nb := nb + 9 ;
  if nb > 200 then nb := nb - 200;
  rot  := rot + 7;
  if rot > 359 then rot := rot - 359;
end;

//----------------------------------------------------------------------------//

procedure T_Arme_6.Affiche;
begin
    glPushMatrix;
      glTranslated(debut.coordx,debut.coordy,debut.coordz);
      glRotated(90 + orientation.teta*180/pi,0.0,1.0,0.0 );
      Laser(nb,rot);
    glPopMatrix;
end;

//----------------------------------------------------------------------------//

procedure Supprimerarme(var arme, tete: T_pArme);
var
  courant , prec : T_pArme;
begin
  if (tete <> NIL) and (arme <> NIl) then
    begin
     if arme = tete then
       begin
       tete := tete^.next;
       freemem(arme);
       arme := tete;
       end
     else
       begin
       courant := tete;
       prec := tete;
       while courant <> arme  do
         begin
         prec := courant;
         courant := courant^.next;
         end;
       prec^.next := courant^.next;
       freemem(arme);
       arme := prec;
       end;
    end;
end;

//----------------------------------------------------------------------------//
procedure AfficheArme(debut : T_pArme);
var
  courant : T_pArme;
begin
  courant := debut;
  while courant <> NIL do
    begin
    courant^.Affiche;
    courant^.Actualise;
    courant := courant^.next;
    end;
end;

//----------------------------------------------------------------------------//

procedure DetruireListeArme(var liste : T_pArme);
var
  courant : T_pArme;
begin
   // liberer les armes
   while liste <> NIL do
     begin
     courant := liste;
     liste := liste^.next;
     freemem(courant);
     end;
end;

//----------------------------------------------------------------------------//











end.
