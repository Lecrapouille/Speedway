unit UCamera;

interface
USES
Opengl,
typege,
joueur,
effet,
collision,
Maths;

TYPE
T_Camera = object
eye, center : position;
public
constructor init(j1 : T_Pjoueur);
procedure changepointdevue(numero : integer; j1 : T_Pjoueur);
procedure pointdevuesuivant(j1 : T_Pjoueur);
procedure collision(j1 : T_Pjoueur; map : Pobjet);
procedure actu(emplacement : position; orientation : vecteurPol; pointdevue : integer);
procedure actualise(j1 : T_pjoueur);
procedure Positionne;
end;


implementation
//-----------------------------------------------------------------------------//

constructor T_Camera.init(j1 : T_Pjoueur);
begin
  while j1.categorie=artificielle do
    j1 := j1.next;
eye.coordx := j1.Voiture.emplacement.coordx + 70*sin(j1.Voiture.orientation.teta);
eye.coordy := j1.Voiture.emplacement.coordy + 20;
eye.coordz := j1.Voiture.emplacement.coordz + 70*cos(j1.Voiture.orientation.teta);

center := j1.voiture.emplacement;

j1.pointdevue := 0;
end;

//----------------------------------------------------------------------------//

procedure T_Camera.changepointdevue(numero : integer; j1 : T_Pjoueur);
begin
j1.pointdevue := numero;
end;

//----------------------------------------------------------------------------//

procedure T_Camera.pointdevuesuivant(j1 : T_Pjoueur);
begin
inc (j1.pointdevue);
if j1.pointdevue > 2 then
   j1.pointdevue := 0;
end;

//----------------------------------------------------------------------------//

procedure T_Camera.collision(j1 : T_Pjoueur; map : Pobjet);
var i, ivrai, emplacement : position;
    d, dvrai : real;
begin
  dvrai := 1000;
  ivrai.Init(0.0,0.0,0.0);
  while j1.Categorie=artificielle do
    j1 := j1.next;
  if (j1.arme=nil)or(j1.arme.id<>5) then
    emplacement := j1.Voiture.emplacement
  else emplacement := j1.Arme.emplacement;
  map^.MeshQueue := @map^.MeshHead;
  while map^.MeshQueue<>NIL do
  begin
    map^.MeshQueue^.FaceQueue := @map^.MeshQueue^.FaceHead;
    while (map^.MeshQueue^.FaceQueue^.next<>NIL)  do
    begin
      i := interPlanDroite(emplacement, eye, map^.MeshQueue^.FaceQueue);
      if ((i.coordx<>0) or
         (i.coordy<>0) or
         (i.coordx<>0)) and
         interieur(emplacement, i, eye)and
         (abs(map^.MeshQueue^.FaceQueue.U.y)<0.2) then
         if vraicolli(i, map^.MeshQueue^.FaceQueue) then
         begin
           d := sqrt(sqr(emplacement.coordx-i.coordx)+
                     sqr(emplacement.coordz-i.coordz));
           if d<dvrai then
           begin
             dvrai := d;
             ivrai := i;
           end;
         end;
         map^.MeshQueue^.FaceQueue := map^.MeshQueue^.FaceQueue^.Next;
    end;
    map^.MeshQueue := map^.MeshQueue^.Next;
  end;
  if (ivrai.coordx<>0) or
     (ivrai.coordy<>0) or
     (ivrai.coordx<>0) then
  begin
    eye.coordx := ivrai.coordx;
    eye.coordz := ivrai.coordz;
  end;
end;
//----------------------------------------------------------------------------//

procedure T_Camera.actu(emplacement : position; orientation : vecteurPol; pointdevue : integer);
begin
  center := emplacement;
  case pointdevue of
       0 : begin
           eye.coordx := emplacement.coordx + 70*sin(orientation.teta);
           eye.coordy := emplacement.coordy + 10;
           eye.coordz := emplacement.coordz + 70*cos(orientation.teta);
           end;
       1 : begin
           Viseur();
           eye.coordx := emplacement.coordx + sin(orientation.teta);
           eye.coordy := emplacement.coordy + 3;
           eye.coordz := emplacement.coordz + cos(orientation.teta);
           center.Translate(0.0,3.0,0.0);
           end;
       2 : begin
           eye.coordx := emplacement.coordx + 20*sin(orientation.teta);
           eye.coordy := emplacement.coordy + 5;
           eye.coordz := emplacement.coordz + 20*cos(orientation.teta);
           end;
       3 : begin
           eye.coordx := emplacement.coordx + 50*sin(orientation.teta);
           eye.coordy := emplacement.coordy + 10;
           eye.coordz := emplacement.coordz + 50*cos(orientation.teta);
           //Viseur();
           end;
  end;
end;
//----------------------------------------------------------------------------//

procedure T_Camera.actualise(j1 : T_pjoueur);
begin
  while j1^.categorie<>humain do
       j1 := j1.next;
  if (j1.arme=nil)or(j1.arme.id<>5) then
     actu(j1.voiture.emplacement, j1.voiture.orientation, j1.pointdevue)
  else
     actu(j1.arme^.emplacement,j1.arme^.orientation, j1.pointdevue);
  if j1.pointdevue <> 1 then j1.voiture.Affiche;
end;

//----------------------------------------------------------------------------//
procedure T_Camera.positionne;
begin
  gluLookAt(eye.coordx,
            eye.coordy,
            eye.coordz,
            center.coordx,
            center.coordy,
            center.coordz,
            0.0,1.0,0.0);
end;
//----------------------------------------------------------------------------//
end.
